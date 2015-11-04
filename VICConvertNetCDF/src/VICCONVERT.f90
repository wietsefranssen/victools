! Author : Wietse Franssen (Wageningen University)
! E-mail : wietse.franssen@wur.nl
! Created: march 2012
! Purpose: Convert meteorological gridded NetCDF data into ASCII or Binary Format that can be used for de VIC-Model.
! Usage  : ./VICCONVERT netcdf2VIC <StartTimeStep> <EndTimeStep> <TimeStepPerPart> <BinaryOutput(0=no/1=yes)>
!                                  <Outpath+prefix> <NetCDFMaskFilename> <VarnameOfMask>
!                                  <NetCDFFilenamOfVar1> <VariableNameOfVar1> <MultiplicationFactOfVar1>
!                                  <NetCDFFilenamOfVar2> <VariableNameOfVar2> <MultiplicationFactOfVar2>
!                                  <NetCDFFilenamOfVarN> <VariableNameOfVarN> <MultiplicationFactOfVarN>
! Example: ./VICCONVERT netcdf2VIC 1 3000 1000 1 ./VICMet/fluxes_ ./cru.nc cell ./Precip.nc prec 100
!                                  ./Tmin.nc tmin 100 ./Tmax.nc tmax 100 ./Wind.nc wind 100
! Notes  : --> If in doubt, read the disclaimer.
!          --> In case you will get a memory issue: lower the <TimeStepPerPart> value.
!              Lowering this number will slow down the conversion but on the other hand it uses less memory.
!          --> If using ASCII output. <VariableNameOfVarN> and <MultiplicationFactOfVarN>
!              must still contain a number in although it will not be used during conversion.
! Disclaimer: Feel free to use or adapt any part of this program for your own
!             convenience.  However, this only applies with the understanding
!             that YOU ARE RESPONSIBLE TO ENSURE THAT THE PROGRAM DOES WHAT YOU
!             THINK IT SHOULD DO.  The author of this program does not in any
!             way, shape or form accept responsibility for problems caused by
!             the use of this code.  At any time, please feel free to discard
!             this code and WRITE YOUR OWN, it's what I would do.
!
program VICCONVERT

    use netcdf
    use definitionsAndTypes

    !   implicit none
    TYPE(type_NETCDF2VIC) Set_N2V
    TYPE(type_VIC2NETCDF) Set_V2N
    TYPE(type_VIC2BIGNETCDF) Set_V2BIGN

    !! Commandline arguments
    integer                 :: numarg,n
    character(len = 512)    :: cargs(0:200)
    character(len = 8192)  :: cargx
    integer                 :: nVar
    character(len = 512)    :: cConfigFile,cConfigType
    character(len = 512)    :: cLon,cLat
    character(len = 10)     :: cVar

    ! Check commandline arguments
    numarg=iargc()
    do n=0,numarg
        call getarg(n,cargx)
        cargs(n)=trim(cargx) !//char(0)
    enddo

    READ(cargs(1),*)  cConfigType


    if (TRIM(cConfigType) == 'netcdf2VIC'     ) then
        !READ(cargs(1),*)  cConfigFile
        nVar=(numArg-8)/3

        print *,'Number arguments given: ', numArg
        print *,'Number of VIC-Variables:', nVar
        print *,'**********************************************************'
        print *,'netcdf2VIC:                 ', trim(cargs(1))
        print *,'Start Time:                 ', trim(cargs(2))
        print *,'End Time:                   ', trim(cargs(3))
        print *,'TimeStepSplit:              ', trim(cargs(4)),'    (Lower this number if memory issues occur)'
        print *,'Options:                    ', trim(cargs(5))
        print *,'  (0=ascii/1=binary/3=routing,skip3,.day) '
        print *,'Outpath+prefix:             ', trim(cargs(6))
        print *,'Mask filename:              ', trim(cargs(7))
        print *,'Variablename of maskfile:   ', trim(cargs(8))
        do iVar=1,nVar
            WRITE (cVar,10) iVar
            print *,'(VAR ',trim(adjustl(cVar)),') Filename:           ', trim(cargs((iVar*3)+6))
            print *,'(VAR ',trim(adjustl(cVar)),') Variablename:       ', trim(cargs((iVar*3)+7))
            print *,'(VAR ',trim(adjustl(cVar)),') Multiplication:     ', trim(cargs((iVar*3)+8))
            READ (cargs((iVar*3)+6),12)       Set_N2V%dataVICInFile(iVar)
            READ (cargs((iVar*3)+7),12)       Set_N2V%varName(iVar)
            READ (cargs((iVar*3)+8),10)       Set_N2V%varBinMultipl(iVar)
        enddo
        print *,'**********************************************************'
        READ (cargs(2),10)       Set_N2V%timeStart
        READ (cargs(3),10)       Set_N2V%timeEnd
        READ (cargs(4),10)       Set_N2V%numMaxTimeSteps
        READ (cargs(5),10)       Set_N2V%binary
        READ (cargs(6),12)       Set_N2V%outPath
        READ (cargs(7),12)       Set_N2V%gridVICInFile
        READ (cargs(8),12)       Set_N2V%varNameMask

        if (numArg < 11) then

            print *,'Some commandline arguments are missing!'
            print *,''
            print *,'Usage  : ./VICCONVERT netcdf2VIC <StartTimeStep> <EndTimeStep> <TimeStepPerPart> <BinaryOutput(0=no/1=yes)>'
            print *,'                                  <Outpath+prefix> <NetCDFMaskFilename> <VarnameOfMask>'
            print *,'                                  <NetCDFFilenamOfVar1> <VariableNameOfVar1> <MultiplicationFactOfVar1>'
            print *,'                                  <NetCDFFilenamOfVar2> <VariableNameOfVar2> <MultiplicationFactOfVar2>'
            print *,'                                  <NetCDFFilenamOfVarN> <VariableNameOfVarN> <MultiplicationFactOfVarN>'
            print *,' '
            print *,'Example: ./VICCONVERT netcdf2VIC 1 3000 1000 1 ./VICMet/fluxes_ ./cru.nc cell ./Precip.nc prec 100'
            print *,'                                  ./Tmin.nc tmin 100 ./Tmax.nc tmax 100 ./Wind.nc wind 100'
            print *,' '
            print *,'Notes  : --> In case you will get a memory issue: lower the <TimeStepPerPart> value.'
            print *,'             Lowering this number will slow down the conversion but on the other hand it uses less memory.'
            print *,'         --> If using ASCII output. <VariableNameOfVarN> and <MultiplicationFactOfVarN>'
            print *,'             must still contain a number in although it will not be used during conversion.'
            print *,' '
            stop
        endif
        CALL netcdf2VIC(Set_N2V, cConfigFile, nVar)



    elseif (TRIM(cConfigType) == 'VIC2netcdf'     ) then
        !READ(cargs(1),*)  cConfigFile
        nVar=(numArg-7)/7

        print *,'Number arguments given: ', numArg
        print *,'Number of VIC-Variables:', nVar
        print *,'**********************************************************'
        print *,'VIC2netcdf:                 ', trim(cargs(1))
        print *,'Start Time:                 ', trim(cargs(2))
        print *,'End Time:                   ', trim(cargs(3))
        print *,'TimeStepSplit:              ', trim(cargs(4)),'    (Lower this number if memory issues occur)'
        print *,'Start year:                 ', trim(cargs(5))
        print *,'Binary input (0=no/1=yes):  ', trim(cargs(6))
        print *,'Monthly input (0=no/1=yes): ', trim(cargs(7))
        print *,'VICDataPath+prefix:         ', trim(cargs(8))
        print *,'NetCDF prefix:              ', trim(cargs(9))
        do iVar=1,nVar
            WRITE (cVar,10) iVar
            print *,'(VAR ',trim(adjustl(cVar)),') Variablename:       ', trim(cargs((iVar*7)+3))
            print *,'(VAR ',trim(adjustl(cVar)),') Long name:          ', trim(cargs((iVar*7)+4))
            print *,'(VAR ',trim(adjustl(cVar)),') Unit:               ', trim(cargs((iVar*7)+5))
            print *,'(VAR ',trim(adjustl(cVar)),') Comment 1:          ', trim(cargs((iVar*7)+6))
            print *,'(VAR ',trim(adjustl(cVar)),') Comment 2:          ', trim(cargs((iVar*7)+7))
            print *,'(VAR ',trim(adjustl(cVar)),') DataType (f/i/u):   ', trim(cargs((iVar*7)+8))
            print *,'(VAR ',trim(adjustl(cVar)),') Multiplication:     ', trim(cargs((iVar*7)+9))
            READ (cargs((iVar*7)+3),12)      Set_V2N%varName(iVar)
            READ (cargs((iVar*7)+4),12)      Set_V2N%varNameLong(iVar)
            READ (cargs((iVar*7)+5),12)      Set_V2N%varUnit(iVar)
            READ (cargs((iVar*7)+6),12)      Set_V2N%varComment1(iVar)
            READ (cargs((iVar*7)+7),12)      Set_V2N%varComment2(iVar)
            READ (cargs((iVar*7)+8),12)      Set_V2N%varBinType(iVar)
            READ (cargs((iVar*7)+9),10)      Set_V2N%varBinMultipl(iVar)
        enddo
        print *,'**********************************************************'
        READ (cargs(2),10)       Set_V2N%timeStart
        READ (cargs(3),10)       Set_V2N%timeEnd
        READ (cargs(4),10)       Set_V2N%numMaxTimeSteps
        READ (cargs(5),12)       Set_V2N%yearStart
        READ (cargs(6),10)       Set_V2N%binary
        READ (cargs(7),10)       Set_V2N%monthly
        READ (cargs(8),12)       Set_V2N%outPath
        READ (cargs(9),12)       Set_V2N%NetCDFPrefix

        if (numArg < 12) then

            print *,'Some commandline arguments are missing!'
            print *,''
            print *,'Usage  : ./VICCONVERT NETCDF2VIC <StartTimeStep> <EndTimeStep> <TimeStepPerPart> <BinaryInput(0=no/1=yes)>'
            print *,'                                  <VICDataPath+prefix> <PrefixOfNetCDFFilename>'
            print *,'                                  <VariableNameOfVar1> <MultiplicationFactOfVar1>'
            print *,'                                  <VariableNameOfVar2> <MultiplicationFactOfVar2>'
            print *,'                                  <VariableNameOfVarN> <MultiplicationFactOfVarN>'
            print *,'Example: ./VICCONVERT NETCDF2VIC 1 3000 1000 0 ./VICMet/fluxes_ ./netcdf/ncData_ prec 100'
            print *,'                                  tmin 100 tmax 100 wind 100'
            print *,' '
            print *,'Notes  : --> In case you will get a memory issue: lower the <TimeStepPerPart> value.'
            print *,'             Lowering this number will slow down the conversion but on the other hand it uses less memory.'
            print *,'         --> If using ASCII output. <VariableNameOfVarN> and <MultiplicationFactOfVarN>'
            print *,'             must still contain a number in although it will not be used during conversion.'
            print *,' '
            stop
        endif
        CALL VIC2netcdf(Set_V2N, cConfigFile, nVar)
    elseif (TRIM(cConfigType) == 'VIC2bignetcdf'     ) then
        !READ(cargs(1),*)  cConfigFile
        nVar=(numArg-7)/7
        print *,'Number arguments given: ', numArg
        print *,'Number of VIC-Variables:', nVar
        print *,'**********************************************************'
        print *,'VIC2netcdf:                 ', trim(cargs(1))
        print *,'Configfile:                 ', trim(cargs(2))

        READ (cargs(2),12)      cConfigFile

        CALL VIC2bignetcdf(Set_V2BIGN, cConfigFile)

    else
        Print *,'The first argument must be: '
        print *,'"netcdf2VIC"'
        print *,'or'
        print *,'"VIC2netcdf"'
        print *,'or'
        print *,'"VIC2bignetcdf"'
        print *,'or'
        print *,'...'
    endif

10  FORMAT (i8)
11  FORMAT (f12.8)
12  FORMAT (A)

end program VICCONVERT