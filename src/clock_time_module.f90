module clock_time_module

    use, intrinsic :: iso_fortran_env, only : ik=>int32, rk=>real64

    implicit none

    ! Module Constants
    character(80), parameter :: dash80='--------------------' // &
                                       '--------------------' // &
                                       '--------------------' // &
                                       '--------------------'

    ! Module Formats
    character( 4), parameter :: f0 = "(/A)"
    character(16), parameter :: f1 = "(/A, ':', 2X, A)"
    character(48), parameter :: f2 = "(/'ELAPSED CLOCK TIME:', 2X, A, ' milliseconds')"
    character(47), parameter :: f3 = "(/'ELAPSED CLOCK TIME:', 2X, F10.3, ' seconds')"
    character(47), parameter :: f4 = "(/'ELAPSED CLOCK TIME:', 2X, F10.3, ' minutes')"
    character(45), parameter :: f5 = "(/'ELAPSED CLOCK TIME:', 2X, F10.3, ' hours')"

    ! Module Variables
    type ClockType
        character(12) :: time=''
        real(rk)      :: msec=0.0_rk
        real(rk)      :: sec=0.0_rk
        real(rk)      :: min=0.0_rk
        real(rk)      :: hour=0.0_rk
    end type
    type(ClockType)   :: clock_time_start, clock_time_end
    real(rk)          :: elapsed_clock_time=0.0_rk

    save clock_time_start

    ! Scope
    private
    public print_start_time, print_end_time


contains


!---------------------------------------------------------------------------------------
function int2text(i) result(res)
    character(:), allocatable :: res
    integer(ik),  intent(in)  :: i
    character(range(i)+2)     :: temp
    write(temp,'(I0)') i
    res = trim(temp)
end function int2text

!---------------------------------------------------------------------------------------
subroutine print_start_time

    clock_time_start = get_clock_time()

    write(*,f0) dash80
    write(*,f1) 'CLOCK START TIME', clock_time_start%time

end subroutine print_start_time

!---------------------------------------------------------------------------------------
subroutine print_end_time

    character(:), allocatable :: text

    clock_time_end = get_clock_time()
    elapsed_clock_time = clock_time_end%sec - clock_time_start%sec

    write(*,f0) dash80
    write(*,f1) 'CLOCK START END', clock_time_end%time

    if (elapsed_clock_time < 1.0_rk) then
        text = int2text( int(1000.0_rk * elapsed_clock_time) )
        write(*,f2) text
    elseif (elapsed_clock_time < 60.0_rk) then
        write(*,f3) elapsed_clock_time
    elseif (elapsed_clock_time < 3600.0_rk) then
        write(*,f4) elapsed_clock_time / 60.0_rk
    else
        write(*,f5) elapsed_clock_time / 3600.0_rk
    end if

    write(*,f0) dash80

end subroutine print_end_time

!---------------------------------------------------------------------------------------
function get_clock_time() result(current_time)
    ! Function Variables
    type(ClockType) :: current_time
    integer(ik), dimension(8) :: clock_vals
    character(2) :: time_h, time_m, time_s
    character(3) :: time_ms

    ! Get clock time
    call date_and_time(values=clock_vals)

    ! Compute time in seconds
    current_time%sec = real(clock_vals(5), rk) * 3600.0_rk + &
                       real(clock_vals(6), rk) *   60.0_rk + &
                       real(clock_vals(7), rk)             + &
                       real(clock_vals(8), rk) * 0.0010_rk

    ! Compute time in milliseconds
    current_time%msec = current_time%sec * 1000.0_rk

    ! Compute time in minutes
    current_time%min = current_time%sec / 60.0_rk

    ! Compute time in hours
    current_time%hour = current_time%min / 24.0_rk

    ! Store clock time in HH:MM:SS:mmm format
    write(time_h,  '(I2.2)') clock_vals(5)
    write(time_m,  '(I2.2)') clock_vals(6)
    write(time_s,  '(I2.2)') clock_vals(7)
    write(time_ms, '(I3.3)') clock_vals(8)
    current_time%time = time_h //':'// time_m //':'// time_s //':'// time_ms

end function get_clock_time

!---------------------------------------------------------------------------------------
end module clock_time_module
