!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----Utility subroutines
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
		subroutine assert(condition, message)
      logical DEBUG
      parameter (DEBUG=.true.) !set this to false to turn assert off
  		logical, intent(in) :: condition
  		character(*), intent(in) :: message
      if (.not. DEBUG) then
         return
  		else if (.not. condition) then
    		write(*,*) "Assertion failed: ", message
    		stop
		endif
  		return
		end subroutine assert