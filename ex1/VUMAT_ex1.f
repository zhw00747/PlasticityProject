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
!-----------------------------------------------------------------------
! Uncomment this to turn asserts off
#define DEBUG
!----------------------------------------------------------------------- 
#ifdef DEBUG
#define assert(cond, msg) call assertFunction(cond, msg)
#else
#define assert(cond, msg)
#endif
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
		real*8 E0, nu, lame1, lame2, dEpsilonV !lame1 = lambda, and lame2 = mu
!-----------------------------------------------------------------------
!-----Declare other variables
		integer i
      real*8 s1, s2, s3, s4, s5, s6 !Stress components 
		real*8 t1, t2, t3, t4, t5, t6 !Trial stress components
!
!-----------------------------------------------------------------------
!-----Initialization step (elastic)
!-----Since the initial values of strain components are zero,  
!-----strainInc and strain will be equal for this step
!-----------------------------------------------------------------------
		assert((nshr.eq.3),"nshr==3 (plates will be handled later)")
      if ((totalTime.eq.zero).and.(stepTime.eq.zero)) then
			E0 = props(1)
			nu = props(2)
			lame1 = nu * E0 / ((1 + nu)*(1 - 2*nu))
			lame2 = E0 / (2 * (1 + nu)) 

			do i = 1,nblock
				dEpsilonV = strainInc(i,1) + strainInc(i,2) + strainInc(i,3)
				stressNew(i,1) = lame1*dEpsilonV + 2.* lame2*strainInc(i,1)
				stressNew(i,2) = lame1*dEpsilonV + 2.* lame2*strainInc(i,2) 
				stressNew(i,3) = lame1*dEpsilonV + 2.* lame2*strainInc(i,3)  
				stressNew(i,4) = 2.* lame2*strainInc(i, 4)
				stressNew(i,5) = 2.* lame2*strainInc(i, 5)
				stressNew(i,6) = 2.* lame2*strainInc(i, 6)		
			enddo
!
!-----------------------------------------------------------------------
!-----Ordinary increment
!-----------------------------------------------------------------------
		else
         E0 = props(1)
         nu = props(2)
         lame1 = nu * E0 / ((1 + nu)*(1 - 2*nu))
         lame2 = E0 / (2 * (1 + nu)) 
         ! print *, "E0 ",E0,", nu ",nu,", lame1 ",lame1,", lame2 ",lame2
				
			do i = 1,nblock
!-----------------------------------------------------------------------
!-----Gather old stress components (only to decrease variable name size
!-----at this stage)
!-----------------------------------------------------------------------
            s1 = stressOld(i,1)
            s2 = stressOld(i,2)
            s3 = stressOld(i,3)
            s4 = stressOld(i,4)
            s5 = stressOld(i,5)
            s6 = stressOld(i,6)
!-----------------------------------------------------------------------
!-----Trial stress
!-----------------------------------------------------------------------
            dEpsilonV = strainInc(i,1) + strainInc(i,2) + strainInc(i,3)
				t1 = s1 + lame1 * dEpsilonV + 2. * lame2 * strainInc(i,1)
				t2 = s2 + lame1 * dEpsilonV + 2. * lame2 * strainInc(i,2)
				t3 = s3 + lame1 * dEpsilonV + 2. * lame2 * strainInc(i,3)
				t4 = s4 + 2. * lame2 *strainInc(i,4)
				t5 = s5 + 2. * lame2 *strainInc(i,5)
				t6 = s6 + 2. * lame2 *strainInc(i,6)
!
!-----------------------------------------------------------------------
!-----Unpack stresses (since it's only elastic for now, the trial
!-----stress is accepted as the new stress)
!-----------------------------------------------------------------------
				stressNew(i,1) = t1
				stressNew(i,2) = t2
				stressNew(i,3) = t3
				stressNew(i,4) = t4
				stressNew(i,5) = t5
				stressNew(i,6) = t6
            !if (i.eq.1.and)
               !print *, "stressOld ",stressNew
            print *,"i ",i, "stressNew ",stressNew
!
!-----------------------------------------------------------------------
!-----Update specific internal energy [J/kg]. 
!-----U_new = U_old + 
!-----0.5 * (sigma_old_ij + sigma_new_ij) * d_epsilon_ij / rho
!-----------------------------------------------------------------------			

            enerInternNew(i) = enerInternOld(i) + (
     +          (stressOld(i,1) + stressNew(i,1)) * strainInc(i,1) +
     +          (stressOld(i,2) + stressNew(i,2)) * strainInc(i,2) +
     +          (stressOld(i,3) + stressNew(i,3)) * strainInc(i,3) +
     +     2. * (stressOld(i,4) + stressNew(i,4)) * strainInc(i,4) +
     +     2. * (stressOld(i,5) + stressNew(i,5)) * strainInc(i,5) +
     +     2. * (stressOld(i,6) + stressNew(i,6)) * strainInc(i,6)
     +          ) * 0.5 / density(i)

	  		enddo
!
		endif
!
!-----------------------------------------------------------------------
!-----End of subroutine
!-----------------------------------------------------------------------
		return
      end


