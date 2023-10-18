!-----------------------------------------------------------------------
!-----VUMAT model implementation
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
      subroutine vumat_model(sigma, deps, zeta, props, ntens, nzeta, nprops)
      implicit none
!-----------------------------------------------------------------------
!-----Declaration variables
!-----------------------------------------------------------------------
      real*8 sigma(ntens), deps(ntens), zeta(nzeta), props(nprops)
      integer ntens, nzeta, nprops
!-----------------------------------------------------------------------
!-----Declaration internal variables
!-----------------------------------------------------------------------
      integer i,j,iter_max
      parameter(iter_max=1000)
!-----Elasticity constants
      real*8 E, nu
!-----Lamè parameters (lame1 = lambda, lame2 = mu = G)
      real*8 lame1, lame2
!-----Elasticiy matrix
      real*8 C(6,6)
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
!-----Power law constants
      real*8 B, n
!-----Power law change rate and gradient of f with respect to R
      real*8 hR, dfdR
!-----Old stress and old strain
      real*8 sold(6), de(6)
!-----Trial stress, stress and internal variables
      real*8 t(6), s(6)
!-----Plastic multiplier increment used in update scheme
      real*8 ddlambda 
!-----tolerance for update scheme
      real*8 tol
      parameter(tol=1e-8)
!-----gradient of f with respect to sigma
      real*8 dfds(6)
!-----Product of df_ds, C and df_ds
      real*8 dfds_C_dfds
!-----Product of C and df_ds
      real*8 C_dfds(6)
!-----Product of dfdzeta and h (h is the gradient internal variables)
      real*8 dfdzeta_h
!-----------------------------------------------------------------------
!-----Read parameters and define constants
!-----------------------------------------------------------------------
      call assert((nprops.eq.5),"nprops==5")
      call assert((nzeta.eq.1), "nzeta==1")
      E = props(1)
      nu = props(2)
      sigma0 = props(3)
      B = props(4)
      n = props(5)
      pold = zeta(1)
      lame1 = nu*E/((1+nu)*(1-2*nu))
      lame2 = E/(2*(1+nu))
      C = 0.0
      C(1,1) = lame1 + 2*lame2
      C(1,2) = lame1
      C(1,3) = lame1
      C(2,1) = lame1
      C(2,2) = lame1 + 2*lame2
      C(2,3) = lame1
      C(3,1) = lame1
      C(3,2) = lame1
      C(3,3) = lame1 + 2*lame2
      C(4,4) = 2*lame2
      C(5,5) = 2*lame2
      C(6,6) = 2*lame2

      print*
      print*,"E",E
      print*,"nu",nu
      print*,"sigma0",sigma0
      print*,"B",B
      print*,"n",n
      print*,"pold",pold
      print*,"sigma",sigma
      print*
      ! do i=1,6
      ! write(*,*) (C(i,j), j=1,6)
      ! end do

!-----------------------------------------------------------------------
!-----Unpack old stresses
!-----------------------------------------------------------------------
      de = deps
      if (ntens.lt.6) then
         call assert((ntens.eq.4),"ntens should be equal to 4 if shells are modelled")
         sigma(5) = 0.0
         sigma(6) = 0.0
         de(5) = 0.0
         de(6) = 0.0
      endif
      sold = sigma
!-----------------------------------------------------------------------
!-----Trial stress
!-----------------------------------------------------------------------
         t(1) = sold(1) + C(1,1)*de(1) + C(1,2)*de(2) + C(1,3)*de(3)
         t(2) = sold(2) + C(2,1)*de(1) + C(2,2)*de(2) + C(2,3)*de(3)
         t(3) = sold(3) + C(3,1)*de(1) + C(3,2)*de(2) + C(3,3)*de(3)
         t(4) = sold(4) + C(4,4)*de(4)
         t(5) = sold(5) + C(5,5)*de(5)
         t(6) = sold(6) + C(6,6)*de(6)
      
!-----------------------------------------------------------------------
!-----Computing yield function f
!-----------------------------------------------------------------------
!-----Equivalent stress, phi = sqrt(3*J2)
      phi = t(1)**2 + t(2)**2 + t(3)**2 -
     +      t(1)*t(2) - t(2)*t(3) - t(3)*t(1) + 
     +      3.0*(t(4)**2 + t(5)**2 + t(6)**2)
      call assert((phi.ge.0.0),"J2 should always be >= 0")
      phi = sqrt(phi)
!-----Power law hardening
      R = B*pold**n
!-----Yield function
      f = phi - (sigma0 + R)
      print*, "sigma eq = ",phi
      print*,"f = ",f
      if (f.le.0) then
!-----------------------------------------------------------------------
!-----f<=0: Elastic increment
!-----------------------------------------------------------------------
         print*, "Elastic increment"
         sigma = t
         p = pold
      else
!-----------------------------------------------------------------------
!-----f>0: Return mapping using cutting plane method
!-----------------------------------------------------------------------
         print*,"Plastic increment"
         s = t
         p = pold
         do i=1,iter_max 
!-----------------------------------------------------------------------
!-----Computing dfds:C:dfds
!-----------------------------------------------------------------------
!-----Gradient of f with respect to sigma
            dfds(1) = 1/(2*phi)*(2*s(1) - s(2) - s(3))
            dfds(2) = 1/(2*phi)*(2*s(2) - s(1) - s(3))
            dfds(3) = 1/(2*phi)*(2*s(3) - s(1) - s(2))
            dfds(4) = 3/(2*phi)*s(4)
            dfds(5) = 3/(2*phi)*s(5)
            dfds(6) = 3/(2*phi)*s(6)
!-----Temporary product
            C_dfds(1) = C(1,1)*dfds(1) + C(1,2)*dfds(2) + C(1,3)*dfds(3)
            C_dfds(2) = C(2,1)*dfds(1) + C(2,2)*dfds(2) + C(2,3)*dfds(3)
            C_dfds(3) = C(3,1)*dfds(1) + C(3,2)*dfds(2) + C(3,3)*dfds(3)
            C_dfds(4) = C(4,4)*dfds(4)
            C_dfds(5) = C(5,5)*dfds(5)
            C_dfds(6) = C(6,6)*dfds(6)
!-----dfds:(C:dfds)
            dfds_C_dfds = dfds(1)*C_dfds(1) + dfds(2)*C_dfds(2) + 
     +                    dfds(3)*C_dfds(3) + dfds(4)*C_dfds(4) +
     +                    dfds(5)*C_dfds(5) + dfds(6)*C_dfds(6)
!-----------------------------------------------------------------------
!-----Cumputing dfdzeta:h
!-----------------------------------------------------------------------
            !extend to more general vectors when nzeta becomes larger
            call assert((nzeta.eq.1),"nzeta==1")
            if (p.le.1e-5)then
               hR = B*n*(1e-5)**(n-1.0)
            else
               hR = B*n*p**(n-1.0)
            endif
            dfdR = -1.0
            print*,"hR",hR,"n",n,"B",B,"p",p
            dfdzeta_h = dfdR * hR
!-----------------------------------------------------------------------
!-----Computing dlambda increment
!-----------------------------------------------------------------------
            call assert(abs(dfds_C_dfds - dfdzeta_h).ge.(1e-6))

            print*, "f",f
            print*,"dfds_C_df_ds",dfds_C_dfds 
            print*, "dfdzeta_h",dfdzeta_h

            ddlambda = f/(dfds_C_dfds - dfdzeta_h)
            call assert(.not. isnan(ddlambda),"lambda is nan")
            print*,"inner iter = ",i
            print*,"ddlambda",ddlambda
!-----------------------------------------------------------------------
!-----Updating stresses and internal variables 
!-----------------------------------------------------------------------
            s = s - ddlambda * C_dfds 
            p = p + ddlambda
            print*,"p",p
!-----------------------------------------------------------------------
!-----Recompute yield function
!-----------------------------------------------------------------------
            phi = s(1)**2 + s(2)**2 + s(3)**2 -
     +            s(1)*s(2) - s(2)*s(3) - s(3)*s(1) + 
     +            3.0*(s(4)**2 + s(5)**2 + s(6)**2)
            call assert((phi.ge.0.0),"J2 should always be >= 0")
            phi = sqrt(phi)
            print*,"n",n,"B",B,"p",p
            if (p.ge.0) then
               R = B*p**n
            else
               R=0
            endif 
            call assert(.not. isnan(R),"R is nan")
            f = phi - (sigma0 + R)
            call assert(.not. isnan(f),"f is nan")
            
            print*,"f",f
!-----------------------------------------------------------------------
!-----Convergence check
!-----------------------------------------------------------------------
            if (abs(f).le.tol) then
               sigma = s
               exit
            else if (i.eq.iter_max) then
               print*, "No convergence"
               stop
            endif
         enddo
      endif
!-----------------------------------------------------------------------
!-----Pack internal variables
!-----------------------------------------------------------------------
      zeta(1) = p
      return 

      end