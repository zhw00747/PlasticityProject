!-----------------------------------------------------------------------
!
!
!
!
!-----------------------------------------------------------------------
      include "./utils.f"
!
!
!-----------------------------------------------------------------------
      include "./vumat_model.f"
!-----------------------------------------------------------------------
      subroutine vumat(
!----- Input variables
     <  nblock, ndir, nshr, nstatev, nfieldv, nprops, lanneal,
     <  stepTime, totalTime, dt, cmname, coordMp, charLength,
     <  props, density, strainInc, relSpinInc,
     <  tempOld, stretchOld, defgradOld, fieldOld,
     <  stressOld, stateOld, enerInternOld, enerInelasOld,
     <  tempNew, stretchNew, defgradNew, fieldNew,
!----- Output variables
     <  stressNew, stateNew, enerInternNew, enerInelasNew )
!
      include 'vaba_param.inc'
!-----------------------------------------------------------------------
!-----Declaration Abaqus variables
!-----------------------------------------------------------------------
		character*(*) cmname
      dimension props(nprops), density(nblock), coordMp(nblock,*),
     <  charLength(nblock), strainInc(nblock,ndir+nshr),
     <  relSpinInc(nblock,nshr), tempOld(nblock),
     <  stretchOld(nblock,ndir+nshr),
     <  defgradOld(nblock,ndir+nshr+nshr),
     <  fieldOld(nblock,nfieldv), stressOld(nblock,ndir+nshr),
     <  stateOld(nblock,nstatev), enerInternOld(nblock),
     <  enerInelasOld(nblock), tempNew(nblock),
     <  stretchNew(nblock,ndir+nshr),
     <  defgradNew(nblock,ndir+nshr+nshr),
     <  fieldNew(nblock,nfieldv),
     <  stressNew(nblock,ndir+nshr), stateNew(nblock,nstatev),
     <  enerInternNew(nblock), enerInelasNew(nblock)
!
!-----------------------------------------------------------------------
!-----Elastic parameters
!-----------------------------------------------------------------------
		real*8 E, nu, lame1, lame2, depsV !lame1 = lambda, and lame2 = mu
!-----Initial temperature
      real*8 T0
!-----------------------------------------------------------------------
!-----Declare other variables
		integer i,k
      real*8 sigma(ndir+nshr), deps(ndir+nshr), statev(nstatev)
      integer ntens
!
!-----------------------------------------------------------------------
!-----Initialization step (elastic)
!-----Since the initial values of strain components are zero,  
!-----strainInc and strain will be equal for this step
!-----------------------------------------------------------------------
		call assert((nshr.eq.3),"nshr==3 (plates will be handled later)")


      if ((totalTime.eq.zero).and.(stepTime.eq.zero)) then
			E = props(1)
			nu = props(2)
			lame1 = nu * E / ((1 + nu)*(1 - 2*nu))
			lame2 = E / (2 * (1 + nu)) 
         T0 = props(13)
			do i = 1,nblock
				depsV = strainInc(i,1) + strainInc(i,2) + strainInc(i,3)
				stressNew(i,1) = lame1*depsV + 2.* lame2*strainInc(i,1)
				stressNew(i,2) = lame1*depsV + 2.* lame2*strainInc(i,2) 
				stressNew(i,3) = lame1*depsV + 2.* lame2*strainInc(i,3)  
				stressNew(i,4) = 2.* lame2*strainInc(i, 4)
				stressNew(i,5) = 2.* lame2*strainInc(i, 5)
				stressNew(i,6) = 2.* lame2*strainInc(i, 6)		
!-----Initializing temperature
            stateOld(i,2) = T0
            stateNew(i,2) = T0
			enddo
!
!-----------------------------------------------------------------------
!-----Ordinary increment
!-----------------------------------------------------------------------
		else
         ntens = ndir + nshr
!-----------------------------------------------------------------------
			do i = 1,nblock
!-----------------------------------------------------------------------
!-----Grab old stresses, strain increment and old state variables
!-----------------------------------------------------------------------
            do k=1,ntens
               sigma(j) = stressOld(i,k)
               deps(k) = strainInc(i,k)
            enddo
            do k=1,nstatev
               statev(k) = stateOld(i,k)
            enddo
!-----------------------------------------------------------------------
!-----Call vumat model and obtain new stresses and state variables
!-----------------------------------------------------------------------
            call vumat_model(sigma, deps, statev, props, ntens, nstatev, 
     <           nprops, density(i), dt)
            !print*,"t=",totalTime," i=",i,", VUMAT MODEL COMPLETED"
!
!-----------------------------------------------------------------------
!-----Update stresses and state variables
!-----------------------------------------------------------------------
            do k=1,ntens
               stressNew(i,k) = sigma(k)
            enddo
            do k=1,nstatev
               stateNew(i,k) = statev(k)
            enddo
!-----------------------------------------------------------------------
!-----Update specific internal energy [J/kg]. 
!-----U_new = U_old + 
!-----0.5 * (sigma_old_ij + sigma_new_ij) * d_epsilon_ij / rho
!-----------------------------------------------------------------------			

            enerInternNew(i) = enerInternOld(i) + (
     <          (stressOld(i,1) + stressNew(i,1)) * strainInc(i,1) +
     <          (stressOld(i,2) + stressNew(i,2)) * strainInc(i,2) +
     <          (stressOld(i,3) + stressNew(i,3)) * strainInc(i,3) +
     <     2. * (stressOld(i,4) + stressNew(i,4)) * strainInc(i,4) +
     <     2. * (stressOld(i,5) + stressNew(i,5)) * strainInc(i,5) +
     <     2. * (stressOld(i,6) + stressNew(i,6)) * strainInc(i,6)
     <          ) * 0.5 / density(i)


	  		enddo
!        
		endif
!
!-----------------------------------------------------------------------
!-----End of subroutine
!-----------------------------------------------------------------------
		return
      end


