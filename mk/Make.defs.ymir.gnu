################################################################################
# Parallel SCHISM Makefile
#
# User makes environment settings for particular OS / PLATFORM / COMPILER / MPI
# below as well as setting flags having to do with included algorithms (e.g. sediment)
# and the compiler configuration (debug, timing). 
#
# The environment settings are based on the following options.
#
# Compiler name:
#   FCS: Serial compiler (for utilities)
#   FCP: Parallel compiler
#   FLD: Linker (in general same as parallel compiler)
#
# Compilation flags
#   FCSFLAGS: Flags for serial compilation
#   FCPFLAGS: Flags for parallel compilation (including all pre-processing flags)
#   FLDFLAGS: Flags for linker (e.g., -O2)
#
# Preprocessor flags:
#   DEBUG: Enable debugging code
#   ORDERED_SUM: Enable globally ordered sums & dot-products for bit reproducibility
#     of state quantities independent of number of processors (note: this can
#     significantly degrade performance);
#   INCLUDE_TIMING: Enable wallclock timing of code (note: this can have slight
#     effect on performance);
#   MPI_VERSION = 1 or 2: Version of MPI (try 2 first, if compile fails due to mpi
#     related errors then switch to version 1;
#
# Libraries (needed for parallel code)
#   MTSLIBS: Flags for linking ParMeTiS/MeTiS libaries
#   ALTLIBS: Flags for linking alternate solver libraries (LAPACK or ITPACK,
#            these are just for testing)
#
#
#
################################################################################


ENV = ymir.gnu


################################################################################
# Environment for Linux / 64 bit /  GNU Compiler / MPICH2 (Ymir cluster)
################################################################################

FCP = mpif90 -f90=gfortran -ffree-line-length-none
FLD = $(FCP)
# MPI vserion (1 or 2)
PPFLAGS := $(PPFLAGS) -DMPIVERSION=2
FCPFLAGS = $(PPFLAGS) -O2 -Bstatic #-g -fbacktrace #-finit-real=nan -fbounds-check
FLDFLAGS = -O2  #for final linking of object files
  #####Libraries
MTSLIBS = -L/Calcul/Apps/parmetis/distrib.ParMetis-3.1.1 -lparmetis -lmetis
CDFLIBS = -L/Calcul/Apps/intel/composerxe/lib/intel64 -lirc -limf -lintlc -lifcore -lsvml -lifport -L/Calcul/Apps/netcdf411/lib -lnetcdf -lnetcdff
CDFMOD = -I/Calcul/Apps/netcdf411/include # -I/Calcul/Apps/netcdf/4.2.1.1.ifort/include   # modules for netcdf
ifdef USE_GOTM
   GTMMOD =  -I/Utilisateurs/kli/opt/source/gotm-4.0.0/modules/IFORT/ #modules
   GTMLIBS = -L/Utilisateurs/kli/opt/source/gotm-4.0.0/lib/IFORT -lturbulence_prod  -lutil_prod
else
   GTMMOD =
   GTMLIBS =
endif




################################################################################
# Alternate executable name if you do not want the default. 
################################################################################

#EXEC   := othername.ex


################################################################################
# Algorithm preference flags.
# Comment out unwanted modules and flags.
################################################################################

# -DSCHISM is always on and is defined elsewhere
include ../mk/include_modules

# Don't comment out the follow ifdef
# Note: currently GOTM4 may give reasonable results only with k-omega
ifdef USE_GOTM
  #Following for GOTM4
  #GTMMOD =  -I/sciclone/home04/yinglong/SELFE/svn/trunk/src/GOTM4.0/modules/PGF90/ #modules
  #GTMLIBS = -L/sciclone/home04/yinglong/SELFE/svn/trunk/src/GOTM4.0/lib/PGF90/ -lturbulence_prod -lutil_prod

  #Following for GOTM3
  GTMMOD =  -I/sciclone/home04/yinglong/gotm-3.2.5/modules/PGF90/ #modules
  GTMLIBS = -L/sciclone/home04/yinglong/gotm-3.2.5/lib/PGF90/ -lturbulence_prod -lutil_prod
else
  GTMMOD =
  GTMLIBS =
endif

######### Specialty compiler flags and workarounds
# Add -DNO_TR_15581 like below for allocatable array problem in sflux_subs.F90
# PPFLAGS := $(PPFLAGS) -DNO_TR_15581

# Obsolete flags: use USE_WRAP flag to avoid problems in ParMetis lib (calling C from FORTRAN)
# PPFLAGS := $(PPFLAGS) -DUSE_WRAP 



#############################################################################################

