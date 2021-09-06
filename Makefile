BRANCH=v5.8.0

MAKEFILE_PATH:=$(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_PARENT:=$(dir $(MAKEFILE_PATH))

default:
	@set -e;\
	NETCDF_C_PREFIX=$$(nc-config --prefix);\
	NETCDF_F_PREFIX=$$(nf-config --prefix);\
	opts+=("-DNetCDF_Fortran_LIBRARY=$${NETCDF_F_PREFIX}/lib/libnetcdff.so");\
	opts+=("-DNetCDF_C_LIBRARY=$${NETCDF_C_PREFIX}/lib/libnetcdf.so");\
	opts+=("-DNetCDF_INCLUDE_DIR=$${NETCDF_C_PREFIX}/include/");\
	mkdir build;\
	pushd build;\
	if [ $$(expr `gcc -dumpversion | cut -f1 -d.` \>= 10) = 1 ];\
	then \
		opts+=' -DCMAKE_Fortran_FLAGS_RELEASE="-O2 -ffree-line-length-none -fallow-argument-mismatch"';\
	fi;\
	printf -v opts " %s" "$${opts[@]}";\
	eval "cmake ../schism_${BRANCH}/src $${opts}";\
	make -j $$(nproc) --no-print-directory;\
	mv bin ..;\
	popd;\
	if command -v module &> /dev/null; \
	then \
		make modulefiles --no-print-directory;\
	fi

modulefiles:
	@set -e;\
	PREFIX=$${HOME}/.local/Modules/modulefiles/schism;\
	mkdir -p $${PREFIX};\
	echo '#%Module1.0' > $${PREFIX}/${BRANCH};\
	echo '#' >> $${PREFIX}/${BRANCH};\
	echo '# SCHISM ${BRANCH} tag' >> $${PREFIX}/${BRANCH};\
	echo '#' >> $${PREFIX}/${BRANCH};\
	echo '' >> $${PREFIX}/${BRANCH};\
	echo 'proc ModulesHelp { } {' >> $${PREFIX}/${BRANCH};\
	echo "puts stderr \"SCHISM loading from master branch from a local compile @ $${INSTALL_PATH}.\"" >> $${PREFIX}/${BRANCH};\
	echo '}' >> $${PREFIX}/${BRANCH};\
	echo "prepend-path PATH {${MAKEFILE_PARENT}/bin}" >> $${PREFIX}/${BRANCH}


sciclone:
	@set -e;\
	source /usr/local/Modules/default/init/sh;\
	module load intel/2018 intel/2018-mpi netcdf/4.4.1.1/intel-2018 netcdf-fortran/4.4.4/intel-2018 cmake;\
	make --no-print-directory;\
	mkdir -p sciclone/modulefiles/schism;\
	mv build/ sciclone/
	echo '#%Module1.0' > sciclone/modulefiles/schism/${BRANCH};\
	echo '#' >> sciclone/modulefiles/schism/${BRANCH};\
	echo '# SCHISM ${BRANCH} tag' >> sciclone/modulefiles/schism/${BRANCH};\
	echo '#' >> sciclone/modulefiles/schism/${BRANCH};\
	echo '' >> sciclone/modulefiles/schism/${BRANCH};\
	echo 'proc ModulesHelp { } {' >> sciclone/modulefiles/schism/${BRANCH};\
	INSTALL_PATH=$$(realpath sciclone/bin);\
	echo "puts stderr \"SCHISM loading from master branch from a local compile @ $${INSTALL_PATH}.\"" >> sciclone/modulefiles/schism/${BRANCH};\
	echo '}' >> sciclone/modulefiles/schism/${BRANCH};\
	echo 'if { [module-info mode load] && ![is-loaded intel/2018] } { module load intel/2018 }' >> sciclone/modulefiles/schism/${BRANCH};\
	echo 'if { [module-info mode load] && ![is-loaded intel/2018-mpi] } { module load intel/2018-mpi }' >> sciclone/modulefiles/schism/${BRANCH};\
	echo 'if { [module-info mode load] && ![is-loaded netcdf/4.4.1.1/intel-2018] } { module load netcdf/4.4.1.1/intel-2018 }' >> sciclone/modulefiles/schism/${BRANCH};\
	echo 'if { [module-info mode load] && ![is-loaded netcdf-fortran/4.4.4/intel-2018] } { module load netcdf-fortran/4.4.4/intel-2018 }' >> sciclone/modulefiles/schism/${BRANCH};\
	echo "prepend-path PATH {$${INSTALL_PATH}}" >> sciclone/modulefiles/schism/${BRANCH};\
	mv build sciclone;\
	mkdir -p $${HOME}/.local/Modules/modulefiles/schism;\
	cp sciclone/modulefiles/schism/${BRANCH} $${HOME}/.local/Modules/modulefiles/schism/


clean:
	rm -rf build/
	rm -rf bin/
	rm -rf modulefiles/