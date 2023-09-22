!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
		subroutine assert(condition, message)
  		logical, intent(in) :: condition
  		character(*), intent(in) :: message

  		if (.not. condition) then
    		write(*,*) "Assertion failed: ", message
    		stop
		endif

  		return
		end subroutine assert
!-----------------------------------------------------------------------
!
!
!
      subroutine vumat(
!----- Input variables
     +  nblock, ndir, nshr, nstatev, nfieldv, nprops, lanneal,
     +  stepTime, totalTime, dt, cmname, coordMp, charLength,
     +  props, density, strainInc, relSpinInc,
     +  tempOld, stretchOld, defgradOld, fieldOld,
     +  stressOld, stateOld, enerInternOld, enerInelasOld,
     +  tempNew, stretchNew, defgradNew, fieldNew,
!----- Output variables
     +  stressNew, stateNew, enerInternNew, enerInelasNew )
!
      include 'vaba_param.inc'
!-----------------------------------------------------------------------
!-----Declaration Abaqus variables
!-----------------------------------------------------------------------
		character*(*) cmname
      dimension props(nprops), density(nblock), coordMp(nblock,*),
     +  charLength(nblock), strainInc(nblock,ndir+nshr),
     +  relSpinInc(nblock,nshr), tempOld(nblock),
     +  stretchOld(nblock,ndir+nshr),
     +  defgradOld(nblock,ndir+nshr+nshr),
     +  fieldOld(nblock,nfieldv), stressOld(nblock,ndir+nshr),
     +  stateOld(nblock,nstatev), enerInternOld(nblock),
     +  enerInelasOld(nblock), tempNew(nblock),
     +  stretchNew(nblock,ndir+nshr),
     +  defgradNew(nblock,ndir+nshr+nshr),
     +  fieldNew(nblock,nfieldv),
     +  stressNew(nblock,ndir+nshr), stateNew(nblock,nstatev),
     +  enerInternNew(nblock), enerInelasNew(nblock)
!
!-----------------------------------------------------------------------
!-----Declaration elastic parameters
!-----------------------------------------------------------------------
		real*8 E0, nu, lame1, lame2, volStrain !lame1 = mu, and lame2 = lambda
!-----------------------------------------------------------------------
!-----Declare other variables
		integer n,j, ii, ij
!-----------------------------------------------------------------------
!-----Initialization step (elastic)
!-----------------------------------------------------------------------
		call assert((nshr.eq.3),"nshr==3 (plates will be handled later)") 
      if ((stepTime.eq.totalTime.and.stepTime.eq.zero)) then
			E0 = props(1)
			nu = props(2)
			!print *, "E0 ",E0, "nu", nu
			do n=1,nblock
				strain_v = strainInc(n,1) + strainInc(n,2) + strainInc(n,3)
				stressNew(n,1) = lame1 * volStrain + 2. * lame2 * strainInc(n,1)
				stressNew(n,2) = lame1 * volStrain + 2. * lame2 * strainInc(n,2) 
				stressNew(n,3) = lame1 * volStrain + 2. * lame2 * strainInc(n,3)  
				stressNew(n,4) = 2*lame2 *strainInc(n, 4)
				stressNew(n,5) = 2*lame2 *strainInc(n, 5)
				stressNew(n,6) = 2*lame2 *strainInc(n, 6)		
			enddo


!-----------------------------------------------------------------------
!-----Ordinary increment
!-----------------------------------------------------------------------
         else

         endif

!-----------------------------------------------------------------------
!-----End of subroutine
!-----------------------------------------------------------------------
         return
      end


