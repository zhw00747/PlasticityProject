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
      props(4) = 236.4    ! Material Parameter Q1 (Q1)
      props(5) = 39.3     ! Material Parameter C1 (C1)
      props(6) = 408.1    ! Material Parameter Q2 (Q2)
      props(7) = 4.5      ! Material Parameter C2 (C2)
      props(8) = 0.0    ! Material Parameter Q3 (Q3)
      props(9) = 0.0      ! Material Parameter C3 (C3)
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


      !sigma = (/350., 0.0, 0.0, 0.0, 0.0, 0.0/)
      !deps = (/0.0001, 0.0, 0.0, 0.0, 0.0, 0.0/)
      sigma(1) = -3.142876803773045E-002  
      sigma(2) = 441.604359277701 
      sigma(3) = -3.142876803773081E-002
      sigma(4) = -9.657592299344892E-017 
      sigma(4) = 9.195864922075129E-017  
      sigma(5) = 0.000000000000000E+000
      deps(1) = -8.997370093618229E-007 
      deps(2) = 2.726323263584914E-006 
      deps(3) = -8.997370093618239E-007
      deps(4) = -3.630586278502658E-023 
      deps(5) = 8.029974878255568E-023 
      deps(6) = -4.764438330989222E-024

      call vumat_model(sigma, deps, statev, props, ntens, nstatev, 
     <                       nprops, rho, dt, time)
 
      end program abq_debug
