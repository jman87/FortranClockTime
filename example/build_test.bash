cd ..
./build.bash

cd example/
cp ../bin/clock_time_module.o .
cp ../bin/clock_time_module.mod .

gfortran clock_time_module.o test_clock_time.f90 -std=f2018 -Wall -pedantic -O3 -o TEST.exe

exit
