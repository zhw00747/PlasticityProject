!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----Utility subroutines
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
#ifdef UTILS_INCLUDED
c header guard
#else
#define UTILS_INCLUDED
!
!
		subroutine assertFunction(condition, message)
  		logical, intent(in) :: condition
  		character(*), intent(in) :: message
  		if (.not. condition) then
    		write(*,*) "Assertion failed: ", message
    		stop
		endif
  		return
		end subroutine assertFunction
! Uncomment next line to turn asserts off
#define DEBUG
!----------------------------------------------------------------------- 
#ifdef DEBUG
#define assert(cond, msg) call assertFunction(cond, msg)
#else
#define assert(cond, msg)
!
#endif

#endif