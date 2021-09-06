
default:
	@set -e;\
	NETCDF_C_PREFIX=$$(nc-config --prefix);\
	NETCDF_F_PREFIX=$$(nf-config --prefix);\
	opts+=("-DNetCDF_Fortran_LIBRARY=$${NETCDF_F_PREFIX}/lib/libnetcdff.so");\
	opts+=("-DNetCDF_C_LIBRARY=$${NETCDF_C_PREFIX}/lib/libnetcdf.so");\
	opts+=("-DNetCDF_INCLUDE_DIR=$${NETCDF_C_PREFIX}/include/");\
	mkdir build;\
	cd build;\
	if [ $$(expr `gcc -dumpversion | cut -f1 -d.` \>= 10) = 1 ];\
	then \
		opts+=' -DCMAKE_Fortran_FLAGS_RELEASE="-O2 -ffree-line-length-none -fallow-argument-mismatch"';\
	fi;\
	printf -v opts " %s" "$${opts[@]}";\
	eval "cmake ../schism_v5.8.0/src $${opts}";\
	make -j $$(nproc) --no-print-directory

sciclone:
	@set -e;\
	source /usr/local/Modules/default/init/sh;\
	module load intel/2018 intel/2018-mpi netcdf/4.4.1.1/intel-2018 netcdf-fortran/4.4.4/intel-2018 cmake;\
	make --no-print-directory;\
	mkdir -p sciclone/modulefiles/schism;\
	mv build/bin sciclone/bin;\
	echo '#%Module1.0' > sciclone/modulefiles/schism/v5.8.0;\
	echo '#' >> sciclone/modulefiles/schism/v5.8.0;\
	echo '# SCHISM v5.8.0 tag' >> sciclone/modulefiles/schism/v5.8.0;\
	echo '#' >> sciclone/modulefiles/schism/v5.8.0;\
	echo '' >> sciclone/modulefiles/schism/v5.8.0;\
	echo 'proc ModulesHelp { } {' >> sciclone/modulefiles/schism/v5.8.0;\
	INSTALL_PATH=$$(realpath sciclone/bin);\
	echo "puts stderr \"SCHISM loading from master branch from a local compile @ $${INSTALL_PATH}.\"" >> sciclone/modulefiles/schism/v5.8.0;\
	echo '}' >> sciclone/modulefiles/schism/v5.8.0;\
	echo 'if { [module-info mode load] && ![is-loaded intel/2018] } { module load intel/2018 }' >> sciclone/modulefiles/schism/v5.8.0;\
	echo 'if { [module-info mode load] && ![is-loaded intel/2018-mpi] } { module load intel/2018-mpi }' >> sciclone/modulefiles/schism/v5.8.0;\
	echo 'if { [module-info mode load] && ![is-loaded netcdf/4.4.1.1/intel-2018] } { module load netcdf/4.4.1.1/intel-2018 }' >> sciclone/modulefiles/schism/v5.8.0;\
	echo 'if { [module-info mode load] && ![is-loaded netcdf-fortran/4.4.4/intel-2018] } { module load netcdf-fortran/4.4.4/intel-2018 }' >> sciclone/modulefiles/schism/v5.8.0;\
	echo "prepend-path PATH {$${INSTALL_PATH}}" >> sciclone/modulefiles/schism/v5.8.0;\
	mv build sciclone;\
	mkdir -p $${HOME}/.local/Modules/modulefiles/schism;\
	cp sciclone/modulefiles/schism/v5.8.0 $${HOME}/.local/Modules/modulefiles/schism/


clean:
	@rm -rf build/