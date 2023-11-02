!
!
      include "./vumat_model.f"
      include "./utils.f"
!
      program abq_debug
      implicit none
      integer nstatev, nprops, ntens
      real*8 time, dt
      real*8 :: props(17)
      real*8 :: sigma(6)
      real*8 ::  deps(6)
      real*8 :: statev(2)
      real*8 :: rho
      props(1) = 210000.0 ! Youngs Modulus (E)
      props(2) = 0.33      ! Poissons Ratio (nu)
      props(3) = 370.0    ! Initial Stress (sigma0)
      props(4) = 236.4    ! Material 
      props(5) = 39.3     ! Material 
      props(6) = 408.1    ! Material 
      props(7) = 4.5      ! Material 
      props(8) = 0.0    ! Material Parameter 
      props(9) = 0.0      ! Material 
      props(10) = 10      ! Integer Property (n)
      props(11) = 452e6     ! Specific Heat (cp)
      props(12) = 0.9   ! Coefficient (betaTQ)
      props(13) = 293.0   ! Initial Temperature (T0)
      props(14) = 1800.0   ! Melting Temperature (Tm)
      props(15) = 1.0     ! Material Parameter m (m)
      props(16) = 5e-5    ! Material Parameter pdot0 (pdot0)
      props(17) = 0.01    ! Viscosity Parameter (c_visc)
      
      ntens = 6
      nprops = 17
      nstatev = 2
      time = 0.
      dt = 2.304708807389752E-007
      rho = 6.994994544954491E-009

      statev(1) = 0.0      ! Initial Pressure (pold)
      statev(2) = 293.0    ! Initial Temperature (T)

      sigma(1) = -2.833093563662269E-002 
      sigma(2)=  369.819665019179
      sigma(3)=      -2.833093563662276E-002
      sigma(4)=1.359336507980214E-018  
      sigma(5)=9.379106771702361E-017  
      sigma(6)=0.000000000000000E+000
  
      deps(1)= -8.145571943181830E-007 
      deps(2)= 2.468200698446931E-006
      deps(3)= -8.145571943181818E-007
      deps(4)=-2.829481682011195E-029 
      deps(5)= 1.503252892125976E-022
      deps(6)= -5.109490227698063E-023



      call vumat_model(sigma, deps, statev, props, ntens, nstatev, 
     <                       nprops, rho, dt, time)
 
      end program abq_debug
