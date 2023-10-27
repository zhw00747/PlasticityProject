!-----------------------------------------------------------------------
!-----VUMAT model implementation
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
      subroutine vumat_model(sigma, deps, zeta, props, ntens, nzeta, 
     +                       nprops)
      implicit none
!-----------------------------------------------------------------------
!-----Declaration variables
!-----------------------------------------------------------------------
      real*8 sigma(ntens), deps(ntens), zeta(nzeta), props(nprops)
      integer ntens, nzeta, nprops
!-----------------------------------------------------------------------
!-----Declaration internal variables
!-----------------------------------------------------------------------
      integer i,j
!-----Max number of iterations when plasticity occurs
      integer iter_max
      parameter(iter_max=1000)
!-----Used for special case when finding dfds
      real*8 singular_tol
      parameter(singular_tol=1e-5)
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
!-----Voce hardening constants
      real*8 Q1, C1, Q2, C2, Q3, C3 
!-----Hershey exponent
      real*8 n
!-----Power law change rate and gradient of f with respect to R
      real*8 hR, dfdR
!-----Old stress and old strain
      real*8 sold(6), de(6)
!-----Trial stress, deviatoric stress and stress components 
      real*8 t(6), sdev(6), s11, s22, s33, s12, s21, s31
!-----hydrostatic stress
      real*8 sH
!-----Plastic multiplier increment used in update scheme
      real*8 ddlambda 
!-----tolerance for update scheme
      real*8 tol
      parameter(tol=1e-8)
!-----gradient of yield function with respect to stresses
      real*8 dfds(6)
!-----Product of df_ds, C and df_ds
      real*8 dfds_C_dfds
!-----Product of C and dfds
      real*8 C_dfds(6)
!-----Product of dfdzeta and h (h is the gradient internal variables)
      real*8 dfdzeta_h
!-----Lode angle
      real*8 Lode
!-----Invariants
      real*8 J2, J3
!-----Invariant gradients with respect to stress components
      real*8 dJ2ds, dJ3ds
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
!-----Hershey exponent 
      real*8 n
!-----temporary real
      real*8 tmp1, tmp2
!-----------------------------------------------------------------------
!-----Read parameters and define constants
!-----------------------------------------------------------------------
      call assert((nprops.eq.9),"nprops==9")
      call assert((nzeta.eq.1), "nzeta==1")
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
      call assert((n.ge.1).and.(n.le.10), "1 <= n Hershey <= 10")
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
      print*,"Q1",Q1
      print*,"C1",C1
      print*,"Q2",Q2
      print*,"C2",C2
      print*,"Q3",Q3
      print*,"C3",C3
      print*,"n (Hershey)",n
      print*,"pold",pold
      print*,"sigma",sigma
      print*
      stop
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
      !Gather stress components
      s11 = t(1) 
      s22 = t(2) 
      s33 = t(3) 
      s12 = t(4)
      s21 = t(5)
      s31 = t(6)
      do i=1,iter_max 
         sH = (s11 + s22 + s33)/3
!-----J2 
         J2 = 0.5 * (s11**2 + s22**2 + s33**2 + 
     +        2 * (s12**2 + s23**2 + s31**2)) -
     +        1.0 / 6 * (s11 + s22 + s33) ** 2
!-----J3  
         call invariantJ3(s11,s22,s33,s12,s23,s31,J3)
!-----------------------------------------------------------------------
!-----Calulating Lode angle: (This includes a fix in case the argument 
!-----is slightly out of the allowed range for arccos (-1 to 1) 
!-----------------------------------------------------------------------
         tmp1 = 3*sqrt(3)/2*J3/J2**1.5
         call assert((tmp1.ge.(-1.-1e-6)).and.(le(),tmp1.le(1.+1e-6)),
              "arccos must take args from -1 to 1")
         if tmp1.le.(-1.) then
            tmp1 = -1.
         elseif tmp1.qe.(1.) 
            tmp1 = 1.
         endif
         Lode = 1.0/3*acos(tmp1)
         call assert((Lode.ge.0.0).and.(Lode.le.(PI/3)), 
     +        "0 <= Lode <= pi/3") 
!-----Principal stresses
         s1 = sH + 2/sqrt(3)*sqrt(J2)*cos(Lode)
         s2 = sH + 2/sqrt(3)*sqrt(J2)*cos(2*PI/3 - Lode)
         s3 = sH + 2/sqrt(3)*sqrt(J2)*cos(2*PI/3 + Lode)
         A = s1 - s2
         B = s2 - s3
         C = s1 - s3
         call assert((abs(A).ge.0.).and.(abs(B).ge.0.).
     +                and.(abs(C).ge.0.),
     +       "principal stresses must be ordered as s1>=s2>=s3") 
!-----------------------------------------------------------------------
!-----Computing yield function f
!-----------------------------------------------------------------------
!-----Equivalent stress, Hershey
         phi = (0.5*(A**n + B**n + C**n))**(1/n)
         call assert((phi.ge.0.0),
     +        "sigma equivalent should always be >= 0")
!-----Power law hardening
         R = Q1*(1 - exp(-C1*pold)) + 
     +       Q2*(1 - exp(-C2*pold)) +
     +       Q3*(1 - exp(-Q3*pold)) 
!-----Yield function
         f = phi - (sigma0 + R)
         print*, "sigma eq = ",phi
         print*,"f = ",f
!-----------------------------------------------------------------------
!-----CHECK IF YIELDING OCCURS
!-----------------------------------------------------------------------
         if i.eq.1 then
            p = pold
            if (f.le.0) then
!-----------------------------------------------------------------------
!-----f<=0: Elastic increment
!-----------------------------------------------------------------------
               print*, "Elastic increment"
               sigma = t
               exit
            else
!-----------------------------------------------------------------------
!-----f>0: Plastic increment
!-----------------------------------------------------------------------
               print*,"Plastic increment"
            endif
         else 
!-----------------------------------------------------------------------
!-----Convergence check
!-----------------------------------------------------------------------
            if (abs(f).le.tol) then
               sigma(1) = s11
               sigma(2) = s22
               sigma(3) = s33
               sigma(4) = s12
               sigma(5) = s21
               sigma(6) = s31
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
         sdev(5) = s21
         sdev(6) = s31
!-----Gradient of J3 with respect to stress components
         call dInvariantJ3_dSigma(s11, s22, s33, s12, s21, s31, dJ3ds)
!-----------------------------------------------------------------------
         if (Lode.ge.singular_tol).and.(Lode.le.(PI/3-singular_tol)) 
         then
            print*,"ORDINARY CASE (no singularity)"
!-----------------------------------------------------------------------
            tmp1 = 0.5 * (A**n + B**n + C**n)
            dfds1 = 0.5*tmp1 **(1./n-1.) * (A**(n-1) + C**(n-1))
            dfds2 = 0.5*tmp1 ** (1./n-1.) * (-(A**(n-1)) + B**(n-1))
            dfds3 = 0.5*tmp1 ** (1./n-1.) * (-(B**(n-1)) - C**(n-1))
!-----------------------------------------------------------------------
            dLodeds = sqrt(3)/(2*sin(3*Lode))*(3./2*J3*J2**(-5./2)*sdev 
     +                - dJ3ds*J2**(-3./2))
            ds1ds = kronecker/3. + 
     +              sdev/sqrt(3 * J2)*np.cos(Lode) -
     +              2*sqrt(J2)/sqrt(3)*sin(Lode)*dLodeds
            ds2ds = kronecker/3. + 
     +              sdev/sqrt(3 * J2)*np.cos(2.*PI/3-Lode) +
     +              2*sqrt(J2)/sqrt(3)*sin(2.*PI/3 - Lode)*dLodeds
            ds3ds = kronecker/3. + 
     +              sdev/sqrt(3 * J2)*np.cos(2.*PI/3 + Lode) -
     +              2*sqrt(J2)/sqrt(3)*sin(2.*PI/3 + Lode)*dLodeds
            dfds = dfds1*ds1ds + dfds2*ds2ds + dfds3*ds3ds
         else
            print*,"SINGULARITY"
            !I might very well not need the last terms here.
            tmp1 = 3.0 / 2 * sdev / sqrt(3 * J2)
            tmp2 = 3.0 / 2 * J3 * J2 ** (-2.) * sdev - dJ3ds / J2
            if Lode.le.singular_tol then
               dfds = tmp1 - 1.0 / 3 * tmp2
            elseif Lode.qe.(PI/3 - singular_tol)
               dfds = tmp1 - tmp2
            else  
               call assert(0,"Illegal state reached")
            endif
         endif
!-----------------------------------------------------------------------
!-----Computing dfds:C:dfds
!-----------------------------------------------------------------------
!
!-----Temporary product
         C_dfds(1) = C(1,1)*dfds(1) + C(1,2)*dfds(2) + C(1,3)*dfds(3)
         C_dfds(2) = C(2,1)*dfds(1) + C(2,2)*dfds(2) + C(2,3)*dfds(3)
         C_dfds(3) = C(3,1)*dfds(1) + C(3,2)*dfds(2) + C(3,3)*dfds(3)
         C_dfds(4) = C(4,4)*dfds(4)
         C_dfds(5) = C(5,5)*dfds(5)
         C_dfds(6) = C(6,6)*dfds(6)
!-----dfds:(C:dfds)
         dfds_C_dfds = dfds(1)*C_dfds(1) + dfds(2)*C_dfds(2) + 
     +                 dfds(3)*C_dfds(3) + dfds(4)*C_dfds(4) +
     +                 dfds(5)*C_dfds(5) + dfds(6)*C_dfds(6)

!-----------------------------------------------------------------------
!-----Cumputing dfdzeta:h
!-----------------------------------------------------------------------
         !extend to more general vectors when nzeta becomes larger
         call assert((nzeta.eq.1),"nzeta==1")
         hR = Q1*C1*exp(-C1*p) + Q2*C2*exp(-C2*p) + C3*Q3*exp(-C3*p)
         dfdR = -1.0
         dfdzeta_h = dfdR * hR
!-----------------------------------------------------------------------
!-----Computing dlambda increment
!-----------------------------------------------------------------------
         call assert(abs(dfds_C_dfds - dfdzeta_h).ge.(1e-2), 
   +      "not allowing the denominator in cutting plane to be small")

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
         s11 = s11 - ddlambda * C_dfds(1)
         s22 = s22 - ddlambda * C_dfds(2)
         s33 = s33 - ddlambda * C_dfds(3)
         s12 = s12 - ddlambda * C_dfds(4)
         s23 = s23 - ddlambda * C_dfds(5)
         s31 = s31 - ddlambda * C_dfds(6) 
         p = p + ddlambda
         call assert(p.ge.(1e-5), "p should not be negative")
         print*,"p",p

      enddo
      
!-----------------------------------------------------------------------
!-----Pack internal variables
!-----------------------------------------------------------------------
      zeta(1) = p
      return 

      end