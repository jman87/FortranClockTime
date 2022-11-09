cd bin
rm -f clock_time_module.o
rm -f clock_time_module.mod

cd ../src
gfortran -c clock_time_module.f90 -std=f2018 -Wall -pedantic -O3

mv clock_time_module.mod ../bin/.
mv clock_time_module.o   ../bin/.

cd ..
exit
