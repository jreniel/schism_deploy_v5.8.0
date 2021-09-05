#message(STATUS "Using SCHISM Project default file for various architectures/flags")


if("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Intel")
    message(STATUS "DEBUG IS ${DEBUG}, SED IS ${USE_SED}, TVD_LIM IS ${TVD_LIM}")
    if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
         set ( CMAKE_Fortran_FLAGS_RELEASE_INIT "-O2 /names:lowercase ${WIN_FORTRAN_OPTIONS}")
         set ( CMAKE_Fortran_FLAGS_DEBUG_INIT "/names:lowercase ${WIN_FORTRAN_OPTIONS}")
         set ( CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT "-O2 -debug inline_debug_info ${WIN_FORTRAN_OPTIONS}")
         set (CMAKE_EXE_LINKER_FLAGS "/INCREMENTAL:NO /NODEFAULTLIB:LIBCMT.lib;libifcoremt.lib ${WIN_LINKER_OPTIONS}")
         set( C_PREPROCESS_FLAG /cpp CACHE STRING "C Preprocessor Flag")
    else()
         set (SCHISM_INTEL_OPTIONS "-assume byterecl")
         set( CMAKE_Fortran_FLAGS_RELEASE_INIT "-O2 ${SCHISM_INTEL_OPTIONS}")
         set( CMAKE_Fortran_FLAGS_DEBUG_INIT "-g ${SCHISM_INTEL_OPTIONS}")
         set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT "-O2 -g -debug inline_debug_info ${SCHISM_INTEL_OPTIONS}")
         set( C_PREPROCESS_FLAG -cpp CACHE STRING "C Preprocessor Flag")
    endif()
    
endif()

if("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "PGI")
    #message(STATUS "Overriding default cmake Portland Group compiler flags")
    set (SCHISM_PG_OPTIONS "-mcmodel=medium")
    set( CMAKE_Fortran_FLAGS_RELEASE_INIT "-O2 ${SCHISM_PG_OPTIONS}")
    set( CMAKE_Fortran_FLAGS_DEBUG_INIT "-g ${SCHISM_PG_OPTIONS}")
    set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT "-O2 -g ${SCHISM_PG_OPTIONS}")
    set( C_PREPROCESS_FLAG "-Mpreprocess" CACHE STRING "C Preprocessor Flag")
endif()

if("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "GNU")
    #message(STATUS "Overriding default cmake GNU compiler flags")
    set (SCHISM_GFORTRAN_OPTIONS " -ffree-line-length-none")
    set( CMAKE_Fortran_FLAGS_RELEASE_INIT "-O2 ${SCHISM_GFORTRAN_OPTIONS}")
    set( CMAKE_Fortran_FLAGS_DEBUG_INIT "-g ${SCHISM_GFORTRAN_OPTIONS}")
    set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT "-O2 -g ${SCHISM_GFORTRAN_OPTIONS}")
    set( C_PREPROCESS_FLAG "-cpp" CACHE STRING "C Preprocessor Flag")
endif()
