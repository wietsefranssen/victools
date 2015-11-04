MODULE definitionsAndTypes

    TYPE :: type_NETCDF2VIC
        CHARACTER(len = 256)       :: inPath
        CHARACTER(len = 256)       :: outPath
        CHARACTER(len = 256)       :: landmaskFile
        CHARACTER(len = 256)       :: gridVICInFile
        CHARACTER(len = 256)       :: dataVICInFile(50)
        INTEGER             :: varBinMultipl(50)
        INTEGER             :: timeStart
        INTEGER             :: timeEnd
        INTEGER             :: numMaxTimeSteps
        REAL                :: lonMin
        REAL                :: lonMax
        REAL                :: latMin
        REAL                :: latMax
        REAL                :: resolution
        INTEGER             :: binary
        CHARACTER(len = 256)       :: ncFile(50)
        CHARACTER(len = 256)       :: binFile(50)
        CHARACTER(len = 256)       :: varName(50)
        CHARACTER(len = 256)       :: varNameMask
        CHARACTER(len = 256)       :: headerName(50)
        INTEGER             :: startYear(50)
        INTEGER             :: nYears(50)
        CHARACTER(len = 256)       :: endian(50)
        INTEGER             :: headerSize(50)
        CHARACTER(len = 256)       :: dataType(50)
        REAL                :: correction(50)
        INTEGER             :: nVar
    END TYPE type_NETCDF2VIC

    TYPE :: type_VIC2NETCDF
        CHARACTER(len = 256)       :: inPath
        CHARACTER(len = 256)       :: outPath
        CHARACTER(len = 256)       :: landmaskFile
        CHARACTER(len = 256)       :: NetCDFPrefix
        CHARACTER(len = 256)       :: dataVICInFile(50)
        INTEGER             :: varBinMultipl(50)
        CHARACTER(len = 1)             :: varBinType(50)
        CHARACTER(len = 256)       :: varNameLong(50)
        CHARACTER(len = 256)       :: varUnit(50)
        CHARACTER(len = 256)       :: varComment1(50)
        CHARACTER(len = 256)       :: varComment2(50)
        INTEGER             :: timeStart
        INTEGER             :: timeEnd
        CHARACTER(len = 4)             :: yearStart
        INTEGER             :: numMaxTimeSteps
        REAL                :: lonMin
        REAL                :: lonMax
        REAL                :: latMin
        REAL                :: latMax
        REAL                :: resolution
        INTEGER             :: binary
        INTEGER             :: monthly
        CHARACTER(len = 256)       :: ncFile(50)
        CHARACTER(len = 256)       :: binFile(50)
        CHARACTER(len = 256)       :: varName(50)
        CHARACTER(len = 256)       :: varNameMask
        CHARACTER(len = 256)       :: headerName(50)
        INTEGER             :: startYear(50)
        INTEGER             :: nYears(50)
        CHARACTER(len = 256)       :: endian(50)
        INTEGER             :: headerSize(50)
        CHARACTER(len = 256)       :: dataType(50)
        REAL                :: correction(50)
        INTEGER             :: nVar
    END TYPE type_VIC2NETCDF

    TYPE :: type_VIC2BIGNETCDF
        REAL                :: lonMin
        REAL                :: lonMax
        REAL                :: latMin
        REAL                :: latMax
        REAL                :: resolution
        CHARACTER(len = 256)       :: NetCDFPrefix
        CHARACTER(len = 4)             :: yearStart
        END TYPE type_VIC2BIGNETCDF
    
END MODULE definitionsAndTypes