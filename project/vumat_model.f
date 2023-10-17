!-----------------------------------------------------------------------
!-----VUMAT model implementation
!-----------------------------------------------------------------------
! Uncomment next line to turn asserts off
#define DEBUG
!----------------------------------------------------------------------- 
#ifdef DEBUG
#define assert(cond, msg) call assertFunction(cond, msg)
#else
#define assert(cond, msg)
#endif
!-----------------------------------------------------------------------
      subroutine vumat_model(sigma, zeta, props, ntens, nzeta, nprops)
      implicit none
!-----------------------------------------------------------------------
!-----Declaration variables
!-----------------------------------------------------------------------
      real*8 sigma(ntens), zeta(nzeta), props(nprops)
      integer ntens, nzeta, nprops
!-----------------------------------------------------------------------
!-----Declaration internal variables
!-----------------------------------------------------------------------
      integer i,j
!-----Elasticity constants
      real*8 E, nu
!-----Lamè parameters (lame1 = lambda, lame2 = mu = G)
      lame1, lame2
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
!-----Old stress and old strain
      real*8 sold(6), de(6)
!-----Trial stress
      real*8 t(6)
!-----------------------------------------------------------------------
!-----Read parameters and define constants
!-----------------------------------------------------------------------
      assert((nprops.eq.5),"nprops==5")
      assert((nzeta.eq.1), "nzeta==1")
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
!-----------------------------------------------------------------------
!-----Unpack old stresses
!-----------------------------------------------------------------------
      sold = sigma
      de = deps
      if (ntens.le.6)
         assert((ntens.eq.4),"ntens should be equal to 4 if shells are modelled")
         sold(5) = 0.0
         sold(6) = 0.0
         de(5) = 0.0
         de(6) = 0.0
      enddo
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
      assert((phi.ge.0.0),"J2 should always be >= 0")
      phi = sqrt(phi)
!-----Power law hardening
      R = B*pold**n
!-----Yield function
      f = phi - (sigma0 + R)
      
      if (f.le.0)
!-----------------------------------------------------------------------
!-----f<=0: Elastic increment
!-----------------------------------------------------------------------
         sigma = t
         p = pold
      else
!-----------------------------------------------------------------------
!-----f>0: Return mapping
!-----------------------------------------------------------------------

         
      endif

      zeta(1) = p
   

      return 
      end