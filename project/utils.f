!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----Utility subroutines
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
		subroutine assertFunction(condition, message)
  		logical, intent(in) :: condition
  		character(*), intent(in) :: message
  		if (.not. condition) then
    		write(*,*) "Assertion failed: ", message
    		stop
		endif
  		return
		end subroutine assertFunction
