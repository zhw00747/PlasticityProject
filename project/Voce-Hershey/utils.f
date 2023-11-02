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

!-----------------------------------------------------------------------
      subroutine invariantJ3(s11, s22, s33, s12, s23, s31, J3)
      implicit none
      real*8 s11, s22, s33, s12, s23, s31, J3
      J3 = 2 * s11**3 / 27
     +   - s11**2 * s22 / 9
     +   - s11**2 * s33 / 9
     +   + s11 * s12**2 / 3
     +   - s11 * s22**2 / 9
     +   + 4 * s11 * s22 * s33 / 9
     +   - 2 * s11 * s23**2 / 3
     +   + s11 * s31**2 / 3
     +   - s11 * s33**2 / 9
     +   + s12**2 * s22 / 3
     +   - 2 * s12**2 * s33 / 3
     +   + 2 * s12 * s23 * s31
     +   + 2 * s22**3 / 27
     +   - s22**2 * s33 / 9
     +   + s22 * s23**2 / 3
     +   - 2 * s22 * s31**2 / 3
     +   - s22 * s33**2 / 9
     +   + s23**2 * s33 / 3
     +   + s31**2 * s33 / 3
     +   + 2 * s33**3 / 27
      return
      end subroutine invariantJ3

!-----------------------------------------------------------------------
      subroutine dInvariantJ3_dSigma(s11, s22, s33, s12, s23, s31, 
     +                               dJ3ds)
      implicit none
      real*8 s11, s22, s33, s12, s23, s31, dJ3ds(6)
      dJ3ds(1) = 2 * s11**2 / 9
     +         - 2 * s11 * s22 / 9
     +         - 2 * s11 * s33 / 9
     +         + s12**2 / 3
     +         - s22**2 / 9
     +         + 4 * s22 * s33 / 9
     +         - 2 * s23**2 / 3
     +         + s31**2 / 3
     +         - s33**2 / 9
    
      dJ3ds(2) = -(s11**2) / 9
     +         - 2 * s11 * s22 / 9
     +         + 4 * s11 * s33 / 9
     +         + s12**2 / 3
     +         + 2 * s22**2 / 9
     +         - 2 * s22 * s33 / 9
     +         + s23**2 / 3
     +         - 2 * s31**2 / 3
     +         - s33**2 / 9
    
      dJ3ds(3) = -(s11**2) / 9
     +         + 4 * s11 * s22 / 9
     +         - 2 * s11 * s33 / 9
     +         - 2 * s12**2 / 3
     +         - s22**2 / 9
     +         - 2 * s22 * s33 / 9
     +         + s23**2 / 3
     +         + s31**2 / 3
     +         + 2 * s33**2 / 9
!-----------------------------------------------------------------------
      dJ3ds(4) = s11*s12/3 + s12*s22/3 - 2*s12*s33/3 + s23*s31

      dJ3ds(5) = -2*s11*s23/3 + s12*s31 + s22*s23 / 3 + s23*s33/3

      dJ3ds(6) = s11*s31/3 + s12*s23 - 2*s31*s22/3 + s31*s33/3
      
      return
      end subroutine dInvariantJ3_dSigma
