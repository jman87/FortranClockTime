program test_clock_time

use, intrinsic :: iso_fortran_env, only : ik=>int32
use clock_time_module

implicit none

! Parameters
character(7), parameter :: dfile='dat.txt'

! Integers
integer(ik) :: iost=0_ik, u
integer(ik) :: i, i1,i2,i3,i4, i5,i6,i7,i8

! Print start time
call print_start_time

! Begin Main Program
print '(/A)', '----------------------------------------' //  &
             '----------------------------------------'
print '(/A)', 'RUN MAIN PROGRAM ...'

! Make dat.txt file
open(newunit=u, file=dfile, iostat=iost, status='replace', action='write')
  do i = 1, 9999
    write(u, '(8I10.9)') i*1, i*2, i*3, i*4, i*5, i*6, i*7, i*8
  end do
close(u)

! Read dat.txt file
open(newunit=u, file=dfile, iostat=iost, status='old', action='read')
  do i = 1, 9999
    read(u, '(8I10.9)') i1, i2, i3, i4, i5, i6, i7, i8
  end do
close(u, status='delete')

! Print end time
call print_end_time
print *

end program test_clock_time

