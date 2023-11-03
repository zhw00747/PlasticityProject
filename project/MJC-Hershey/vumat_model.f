!-----------------------------------------------------------------------
!-----VUMAT model implementation
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!

!-----------------------------------------------------------------------
      subroutine vumat_model(sigma, deps, statev, props, ntens, nstatev, 
     <                       nprops, rho, dt, time)
      implicit none
!-----------------------------------------------------------------------
!-----Declaration variables
!-----------------------------------------------------------------------
      real*8 sigma(ntens), deps(ntens), statev(nstatev), props(nprops)
      real*8 rho,dt,time
      integer ntens, nstatev, nprops
!-----------------------------------------------------------------------
!-----Declaration internal variables
!-----------------------------------------------------------------------
      integer i
!-----Max number of iterations when plasticity occurs
      integer, parameter :: iter_max = 1000
!-----tolerance for update scheme
      real*8, parameter :: err_tol = 1e-8
!-----Used for special case when finding dfds
      real*8, parameter :: sing_tol = 1e-5
!-----PI
      real*8, parameter :: PI = 3.14159265358979323846264338327
!-----Elasticity constants
      real*8 E, nu
!-----Lamè parameters (lame1 = lambda, lame2 = mu = G)
      real*8 lame1, lame2
!-----Elasticiy matrix
      real*8 Ce(6,6)
!-----Yield function
      real*8 f
!-----Sigma equivalent
      real*8 phi
!-----Initial yield stress
      real*8 sigma0
!-----Hardening
      real*8 R
!-----Equivalent plastic strain 
      real*8 p, pold
!-----Temperature
      real*8 T
!-----Voce hardening constants
      real*8 Q1, C1, Q2, C2, Q3, C3 
!-----Hershey exponent
      real*8 n
!-----Thermal parameters
      real*8 cp, betaTQ, T0, Tm, m
!-----Viscoplastic parameters
      real*8 pdot0, c_visc
!-----Old stress and old strain
      real*8 sold(6), de(6)
!-----Trial stress, deviatoric stress and stress components 
      real*8 tr(6), sdev(6), s11, s22, s33, s12, s23, s31
!-----hydrostatic stress
      real*8 sH
!-----Plastic multiplier increments
      real*8 ddlambda, dlambda
!-----gradient of yield function with respect to stresses
      real*8 dfds(6)
!-----Product of df_ds, C and df_ds
      real*8 dfds_Ce_dfds
!-----Product of C and dfds
      real*8 Ce_dfds(6)
!----- dzeta:h contribution from inner variables in cutting plane method
      real*8 dfdzeta_h
!-----Yield stress (sigma0 - R)
      real*8 sigmaY
!-----Gamma (temperature softening term)
      real*8 Gamma
!-----vp - Plastic strain rate term: (1+pdot)^c
      real*8 vp
!-----Hardening law change rate (dR/dp)
      real*8 hR
!-----Temperature softening rate (dGamma/dp)
      real*8 hGamma
!-----dvp/dp
      real*8 hv
!-----Lode angle
      real*8 Lode
!-----Invariants
      real*8 J2, J3
!-----Invariant gradients with respect to stress components
      real*8 dJ3ds(6)
!-----Principal stresses
      real*8 s1, s2, s3
!-----A = (s1-s2), B = (s2-s3), C=(s1-s3)
      real*8 A, B, C
!-----gradient of phi with respect to principal stresses
      real*8 dfds1, dfds2, dfds3
!-----Gradients of principal stresses with respect to stress components
      real*8 ds1ds(6), ds2ds(6), ds3ds(6)
!-----Gradient of Lode with respect to stress components
      real*8 dLodeds(6)
!-----Kronecker delta
      real*8 kronecker(6)
      data kronecker / 1., 1., 1., 0., 0., 0. /
!-----temporary real
      real*8 tmp

!-----------------------------------------------------------------------
!-----Read parameters and define constants
!-----------------------------------------------------------------------
      call assert((nprops.eq.17),"nprops==17")
      call assert((nstatev.eq.2), "statev==2")
      E = props(1)
      nu = props(2)
      sigma0 = props(3)
      Q1 = props(4)
      C1 = props(5)
      Q2 = props(6)
      C2 = props(7)
      Q3 = props(8)
      C3 = props(9)
      n = props(10)
      cp = props(11)
      betaTQ = props(12)
      T0 = props(13)
      Tm = props(14)
      m = props(15)
      pdot0 = props(16)
      c_visc = props(17)
      call assert((n.ge.1).and.(n.le.100), "1 <= n(Hershey) <= 100")
      pold = statev(1)
      T = statev(2)
      p = pold
      dlambda = 0.0
      lame1 = nu*E/((1+nu)*(1-2*nu))
      lame2 = E/(2*(1+nu))
      Ce = 0.0
      Ce(1,1) = lame1 + 2*lame2
      Ce(1,2) = lame1
      Ce(1,3) = lame1
      Ce(2,1) = lame1
      Ce(2,2) = lame1 + 2*lame2
      Ce(2,3) = lame1
      Ce(3,1) = lame1
      Ce(3,2) = lame1
      Ce(3,3) = lame1 + 2*lame2
      Ce(4,4) = 2*lame2
      Ce(5,5) = 2*lame2
      Ce(6,6) = 2*lame2

      !m = 1000.0
      !c_visc = 0.0
      !print*
      !print*,"E",E
      !print*,"nu",nu
      !print*,"sigma0",sigma0
      !print*,"Q1",Q1
      !print*,"C1",C1
      !print*,"Q2",Q2
      !print*,"C2",C2
      !print*,"Q3",Q3
      !print*,"C3",C3
      !print*,"n (Hershey)",n
      !print*,"cp",cp
      !print*,"betaTQ",betaTQ
      !print*,"T0",T0
      !print*,"Tm",Tm
      !print*,"m (thermal)",m
      !print*,"pdot0",pdot0
      !print*,"c",c_visc
      !print*,"------------"
      !print*,"pold",pold
      !print*,"T",T
      !print*,"Ce",Ce
      !print*
      
!-----------------------------------------------------------------------
!-----Unpack old stresses
!-----------------------------------------------------------------------
      de = deps
      if (ntens.lt.6) then
         call assert((ntens.eq.4),
     <   "ntens should be equal to 4 if shells are modelled")
         sigma(5) = 0.0
         sigma(6) = 0.0
         de(5) = 0.0
         de(6) = 0.0
      endif
      sold = sigma

      !print*,"sold",sold
      !print*,"de",de
!-----------------------------------------------------------------------
!-----Trial stress
!-----------------------------------------------------------------------
      tr(1) = sold(1) + Ce(1,1)*de(1) + Ce(1,2)*de(2) + Ce(1,3)*de(3)
      tr(2) = sold(2) + Ce(2,1)*de(1) + Ce(2,2)*de(2) + Ce(2,3)*de(3)
      tr(3) = sold(3) + Ce(3,1)*de(1) + Ce(3,2)*de(2) + Ce(3,3)*de(3)
      tr(4) = sold(4) + Ce(4,4)*de(4)
      tr(5) = sold(5) + Ce(5,5)*de(5)
      tr(6) = sold(6) + Ce(6,6)*de(6)

!-----------------------------------------------------------------------
      !Gather stress components
      s11 = tr(1) 
      s22 = tr(2) 
      s33 = tr(3) 
      s12 = tr(4)
      s23 = tr(5)
      s31 = tr(6)

!-----------------------------------------------------------------------
!-----Start inner loop (loop breaks at i=1 if the increment is elastic)
!-----------------------------------------------------------------------
      do i=0,iter_max 
!-----J2 
         J2 = 0.5 * (s11**2 + s22**2 + s33**2 + 
     <        2 * (s12**2 + s23**2 + s31**2)) -
     <        1.0 / 6 * (s11 + s22 + s33) ** 2
!-----J3  
         call invariantJ3(s11,s22,s33,s12,s23,s31,J3)
!-----------------------------------------------------------------------
!-----Calulating Lode angle: (This includes a fix in case the argument 
!-----is slightly out of the allowed range for arccos (-1 to 1) 
!-----------------------------------------------------------------------
         tmp = 3*sqrt(3.)/2*J3/J2**1.5
         call assert((tmp.ge.(-1.-1e-6)).and.(tmp.le.(1.+1e-6)),
     <        "arccos must take args from -1 to 1")
         if (tmp.le.(-1.)) then
            tmp = -1.
         elseif (tmp.ge.(1.)) then
            tmp = 1.
         endif
         Lode = 1.0/3*acos(tmp)
         call assert((Lode.ge.0.0).and.(Lode.le.(PI/3)), 
     <        "0 <= Lode <= pi/3") 
!-----Principal stresses
         sH = (s11 + s22 + s33)/3
         s1 = sH + 2/sqrt(3.)*sqrt(J2)*cos(Lode)
         s2 = sH + 2/sqrt(3.)*sqrt(J2)*cos(2*PI/3 - Lode)
         s3 = sH + 2/sqrt(3.)*sqrt(J2)*cos(2*PI/3 + Lode)
         A = s1 - s2
         B = s2 - s3
         C = s1 - s3
         call assert((abs(A).ge.0.).and.(abs(B).ge.0.).
     <                and.(abs(C).ge.0.),
     <       "principal stresses must be ordered as s1>=s2>=s3") 
!-----------------------------------------------------------------------
!-----Computing yield function f
!-----------------------------------------------------------------------
!-----Equivalent stress, Hershey

         !call phi_mises(s11,s22,s33,s12,s23,s31,phi)
         !print*, "phi mises",phi
         phi = (0.5*(A**n + B**n + C**n))**(1/n)
         !print*,"PHI",phi

         call assert((phi.ge.0.0),
     <        "sigma equivalent should always be >= 0")
         if (i.eq.0)then
!-----Power law hardening
            R = Q1*(1. - exp(-C1*p)) + 
     <          Q2*(1. - exp(-C2*p)) +
     <          Q3*(1. - exp(-Q3*p)) 
!-----Temperature softening
            Gamma = 1. - ((T - T0)/(Tm - T0))**m
         endif
!-----Yield stress
         sigmaY = sigma0 + R
!-----------------------------------------------------------------------
!-----CHECK IF YIELDING OCCURS
!-----------------------------------------------------------------------
         if (i.eq.0) then
!-----Yield function
            f = phi - sigmaY*Gamma
            if (f.le.0) then
!-----------------------------------------------------------------------
!-----f<=0: Elastic increment
!-----------------------------------------------------------------------
               !sigma = tr
               exit
!-----------------------------------------------------------------------
!-----ELSE: f>0 - Plastic increment
!-----------------------------------------------------------------------
            endif
            !print*, "phi",phi,"sigmay",sigmaY,"Gamma",Gamma
            !print*,"f",f
         else 
            
            !stop
!-----------------------------------------------------------------------
!-----Convergence check
!-----------------------------------------------------------------------
            
            if (abs(f/sigmaY).le.err_tol) then


               print*,"Rmap completed in",i,"iter, f=",f,"t=",time
               !stop
               exit
            else if (i.eq.iter_max) then
               print*, "No convergence"
               stop
            endif
         endif   
    
!-----------------------------------------------------------------------
!-----Gradient of f with respect to stress components
!-----------------------------------------------------------------------
!-----Deviatoric stresses
         sdev(1) = s11 - sH
         sdev(2) = s22 - sH
         sdev(3) = s33 - sH
         sdev(4) = s12
         sdev(5) = s23
         sdev(6) = s31
         
!-----Gradient of J3 with respect to stress components
         call dInvariantJ3_dSigma(s11, s22, s33, s12, s23, s31, dJ3ds)
         !print*,"dJ3ds",dJ3ds
!-----------------------------------------------------------------------
         if ((Lode.ge.1e-5).and.(Lode.le.(PI/3-1e-5))) then
!-----------------------------------------------------------------------
!-----Ordinary case (no singularity)
!-----------------------------------------------------------------------
            tmp = 0.5 * (A**n + B**n + C**n)
            dfds1 = 0.5*tmp **(1./n-1.) * (A**(n-1) + C**(n-1))
            dfds2 = 0.5*tmp ** (1./n-1.) * (-(A**(n-1)) + B**(n-1))
            dfds3 = 0.5*tmp ** (1./n-1.) * (-(B**(n-1)) - C**(n-1))
!-----------------------------------------------------------------------
            dLodeds = sqrt(3.)/(2*sin(3*Lode))*(
     <              3./2*J3*J2**(-5./2)*sdev - dJ3ds*J2**(-3./2))
            ds1ds = kronecker/3. + 
     <              sdev/sqrt(3 * J2)*cos(Lode) -
     <              2*sqrt(J2)/sqrt(3.)*sin(Lode)*dLodeds
            ds2ds = kronecker/3. + 
     <              sdev/sqrt(3 * J2)*cos(2.*PI/3-Lode) +
     <              2*sqrt(J2)/sqrt(3.)*sin(2.*PI/3 - Lode)*dLodeds
            ds3ds = kronecker/3. + 
     <              sdev/sqrt(3 * J2)*cos(2.*PI/3 + Lode) -
     <              2*sqrt(J2)/sqrt(3.)*sin(2.*PI/3 + Lode)*dLodeds
            dfds = dfds1*ds1ds + dfds2*ds2ds + dfds3*ds3ds
   !         dfds(1) = dfds1*ds1ds(1) + dfds2*ds2ds(1) + dfds3*ds3ds(1)
   !         dfds(2) = dfds1*ds1ds(2) + dfds2*ds2ds(2) + dfds3*ds3ds(2)
   !         dfds(3) = dfds1*ds1ds(3) + dfds2*ds2ds(3) + dfds3*ds3ds(3)
   !         dfds(4) = 2.*(dfds1*ds1ds(4) + 
   !  <                    dfds2*ds2ds(4) + 
   !  <                    dfds3*ds3ds(4))
   !         dfds(5) = 2.*(dfds1*ds1ds(5) + 
   !  <                    dfds2*ds2ds(5) + 
   !  <                    dfds3*ds3ds(5))
   !         dfds(6) = 2.*(dfds1*ds1ds(6) + 
   !  <                    dfds2*ds2ds(6) + 
   !  <                    dfds3*ds3ds(6))
         else
!-----------------------------------------------------------------------
!-----Special case: Singularity
!-----------------------------------------------------------------------
            !I might very well not need the last terms here.
            if (Lode.le.sing_tol) then
               dfds = 3.0/2*sdev/sqrt(3*J2) - 
     <                1./3* (3./2*J3*J2**(-2.)*sdev - dJ3ds/J2)
            elseif (Lode.ge.(PI/3 - sing_tol)) then
               dfds = 3.0/2*sdev/sqrt(3*J2) - 
     <                (3./2*J3*J2**(-2.)*sdev - dJ3ds/J2)
            else  
               call assert(.false.,"Illegal state reached")
            endif
         endif
         !print*,"DFDS",dfds
         !call dphi_mises_ds(s11,s22,s33,s12,s23,s31,dfds)
         !print*,"dfds mises",dfds
!-----------------------------------------------------------------------
!-----Computing dfds:C:dfds
!-----------------------------------------------------------------------
!
!-----Temporary product
         Ce_dfds(1) = Ce(1,1)*dfds(1)+ Ce(1,2)*dfds(2)+ Ce(1,3)*dfds(3)
         Ce_dfds(2) = Ce(2,1)*dfds(1)+ Ce(2,2)*dfds(2)+ Ce(2,3)*dfds(3)
         Ce_dfds(3) = Ce(3,1)*dfds(1)+ Ce(3,2)*dfds(2)+ Ce(3,3)*dfds(3)
         Ce_dfds(4) = Ce(4,4)*dfds(4)
         Ce_dfds(5) = Ce(5,5)*dfds(5)
         Ce_dfds(6) = Ce(6,6)*dfds(6)
!-----dfds:(C:dfds)
         dfds_Ce_dfds = dfds(1)*Ce_dfds(1)+ 
     <                  dfds(2)*Ce_dfds(2)+ 
     <                  dfds(3)*Ce_dfds(3)+ 
     <              2.*(dfds(4)*Ce_dfds(4)+
     <                  dfds(5)*Ce_dfds(5)+ 
     <                  dfds(6)*Ce_dfds(6))
!-----------------------------------------------------------------------
!-----Cumputing various contributions from inner variables
!-----------------------------------------------------------------------
         hR = Q1*C1*exp(-C1*p) + Q2*C2*exp(-C2*p) + C3*Q3*exp(-C3*p)
         vp = (1.0 + dlambda/(pdot0*dt))**c_visc
         !hGamma = -m*((T-T0)/(Tm-T0))**(m-1.0)*betaTQ*phi/(rho*cp)
         hv = c_visc/(pdot0*dt)*(1.0 + dlambda/(pdot0*dt))**(c_visc-1.0)
!-----Adding all inner variable contributions
         !print*,"hv",hv
         !tmp = ((phi/(sigmaY*Gamma))**(1./c_visc)-1.)
         
         !print*,"hv_alt", c_visc/(pdot0*dt)*(1. + tmp)**(c_visc-1.)
         !if (i.eq.10)then
         !stop
         !endif
         !dfdzeta_h = -hR*Gamma*vp - sigmaY*hGamma*vp - sigmaY*Gamma*hv
         dfdzeta_h = -hR*Gamma*vp - sigmaY*Gamma*hv
         
         !print*,"hR",hR
         !print*,"vp",vp
         !print*,"hGamma",hGamma
         !print*,"---"
         !print*,"phi",phi
         !print*,"m",m
         !print*,"T0",T0
         !print*,"Tm",Tm
         !print*,"betaTQ",betaTQ
         !print*,"rho",rho
         !print*,"cp",cp
         !print*,"---"
         !print*,"hv",hv
         !print*,"sigmaY",sigmaY
         !print*,"Gamma",Gamma
         !print*,"T",T
         !print*,"dfdzeta_h",dfdzeta_h
         !print*
         !print*,"i",i,"REMOVING THIS BREAKS THE PROGRAM!???"
         !dfdzeta_h = -hR*Gamma*vp - sigmaY*Gamma*hv
         !stop
!-----------------------------------------------------------------------
!-----Cumputing dfdzeta:h
!-----------------------------------------------------------------------
         !hR = Q1*C1*exp(-C1*p) + Q2*C2*exp(-C2*p) + C3*Q3*exp(-C3*p)
         !dfdzeta_h = -hR
!-----------------------------------------------------------------------
!-----Computing dlambda increment

!-----------------------------------------------------------------------
         !print*, "f",f
         !print*, "dfds", dfds
         !print*,"dfds_C_df_ds",dfds_Ce_dfds 
         !print*, "dfdzeta_h",dfdzeta_h

         call assert(abs(dfds_Ce_dfds - dfdzeta_h).ge.(1e-2), 
     <   "not allowing the denominator in cutting plane to be small")

         f = phi - sigmaY*Gamma*vp
         ddlambda = f/(dfds_Ce_dfds - dfdzeta_h)
         !print*,"f",f
         !print*,"dfds_Ce_dfds",dfds_Ce_dfds
         !print*,"dfds",dfds
         !print*,"hR",hR
         !print*,"ddlambda",ddlambda
         !stop
         call assert(.not. isnan(ddlambda),"lambda is nan")
         !print*,"inner iter = ",i
         !print*,"ddlambda",ddlambda

!-----------------------------------------------------------------------
!-----Updating stresses and internal variables 
!-----------------------------------------------------------------------
         s11 = s11 - ddlambda * Ce_dfds(1)
         s22 = s22 - ddlambda * Ce_dfds(2)
         s33 = s33 - ddlambda * Ce_dfds(3)
         s12 = s12 - ddlambda * Ce_dfds(4)
         s23 = s23 - ddlambda * Ce_dfds(5)
         s31 = s31 - ddlambda * Ce_dfds(6) 
         p = p + ddlambda
         !print*,"ddlambda",ddlambda
         !print*,"p",p
         !dlambda = p-pold
         dlambda = dlambda + ddlambda
         R = R + hR*ddlambda
         !T = T + (betaTQ*phi)/(rho*cp)*ddlambda
         !call assert(p.ge.(-1e-5), "p should be nonnegative")

         
         !print*,"ddlambda",ddlambda
         !print*,"dlambda",p-pold
         !print*,"pold",pold
         !print*,"p",p
         !print*, "phi",phi
         !print*,"R",R
         
      enddo
      
!-----------------------------------------------------------------------
!-----Pack internal variables
!-----------------------------------------------------------------------

      if (p.lt.pold) then
         print*,"negative plastic strain"
         print*, "aborting"
         stop
      endif
      sigma(1) = s11
      sigma(2) = s22
      sigma(3) = s33
      sigma(4) = s12
      sigma(5) = s23
      sigma(6) = s31
      T = T + (betaTQ*phi)/(rho*cp)*dlambda
      statev(1) = p
      statev(2) = T
      !print*,"T",T
      return 

      end