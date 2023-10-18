!-----------------------------------------------------------------------
!
!
!
!
!-----------------------------------------------------------------------
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
!
!
!-----------------------------------------------------------------------
      include "./vumat_model.f"
!-----------------------------------------------------------------------
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
		real*8 E0, nu, lame1, lame2, depsV !lame1 = lambda, and lame2 = mu
!-----------------------------------------------------------------------
!-----Declare other variables
		integer i,k
      real*8 sigma(ndir+nshr), deps(ndir+nshr), zeta(nstatev)
      integer ntens, nzeta
!
!-----------------------------------------------------------------------
!-----Initialization step (elastic)
!-----Since the initial values of strain components are zero,  
!-----strainInc and strain will be equal for this step
!-----------------------------------------------------------------------
		call assert((nshr.eq.3),"nshr==3 (plates will be handled later)")


      if ((totalTime.eq.zero).and.(stepTime.eq.zero)) then
			E0 = props(1)
			nu = props(2)
			lame1 = nu * E0 / ((1 + nu)*(1 - 2*nu))
			lame2 = E0 / (2 * (1 + nu)) 

			do i = 1,nblock
				depsV = strainInc(i,1) + strainInc(i,2) + strainInc(i,3)
				stressNew(i,1) = lame1*depsV + 2.* lame2*strainInc(i,1)
				stressNew(i,2) = lame1*depsV + 2.* lame2*strainInc(i,2) 
				stressNew(i,3) = lame1*depsV + 2.* lame2*strainInc(i,3)  
				stressNew(i,4) = 2.* lame2*strainInc(i, 4)
				stressNew(i,5) = 2.* lame2*strainInc(i, 5)
				stressNew(i,6) = 2.* lame2*strainInc(i, 6)		
			enddo
!
!-----------------------------------------------------------------------
!-----Ordinary increment
!-----------------------------------------------------------------------
		else
         ntens = ndir + nshr
         nzeta = nstatev
!-----------------------------------------------------------------------
			do i = 1,nblock
!-----------------------------------------------------------------------
!-----Grab old stresses, strain increment and old state variables
!-----------------------------------------------------------------------
            do k=1,ntens
               sigma(j) = stressOld(i,k)
               deps(k) = strainInc(i,k)
            enddo
            do k=1,nzeta
               zeta(k) = stateOld(i,k)
            enddo
!-----------------------------------------------------------------------
!-----Call vumat model and obtain new stresses and state variables
!-----------------------------------------------------------------------
            call vumat_model(sigma, deps, zeta, props, ntens, nzeta, nprops)
            print*,"t=",totalTime," i=",i,", VUMAT MODEL COMPLETED"

!
!-----------------------------------------------------------------------
!-----Update stresses and state variables
!-----------------------------------------------------------------------
            do k=1,ntens
               stressNew(i,k) = sigma(k)
            enddo
            do k=1,nzeta
               stateNew(i,k) = zeta(k)
            enddo
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


