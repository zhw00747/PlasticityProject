       SUBROUTINE VUMAT(
! READ ONLY - DO NOT MODIFY
     . NBLOCK, NDIR, NSHR, NSTATEV, NFIELDV, NPROPS, LANNEAL, STEPTIME,
     . TOTALTIME, DT, CMNAME, COORDMP, CHARLENGTH, PROPS, DENSITY,
     . STRAININC, RELSPININC, TEMPOLD, STRETCHOLD, DEFGRADOLD, FIELDOLD,
     . STRESSOLD, STATEOLD, ENERINTERNOLD, ENERINELASOLD, TEMPNEW,
     . STRETCHNEW, DEFGRADNEW, FIELDNEW,
! WRITE ONLY - DO NOT READ
     . STRESSNEW, STATENEW, ENERINTERNNEW, ENERINELASNEW)
!-----------------------------------------------------------------------
!     ABAQUS implicit variable declaration included in VABA_PARAM.INC
!     states the following:
!     a to h are real variables
!     o to z are real variables
!     i to n are integer variables
!-----------------------------------------------------------------------
      INCLUDE 'VABA_PARAM.INC'
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    !     ABAQUS variables 
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      DIMENSION PROPS(NPROPS), DENSITY(NBLOCK), COORDMP(NBLOCK,*),
     . CHARLENGTH(*), STRAININC(NBLOCK,NDIR+NSHR), RELSPININC(*),
     . TEMPOLD(*), STRETCHOLD(*), DEFGRADOLD(*), FIELDOLD(*),
     . STRESSOLD(NBLOCK,NDIR+NSHR), STATEOLD(NBLOCK,NSTATEV),
     . ENERINTERNOLD(NBLOCK),  ENERINELASOLD(NBLOCK), TEMPNEW(*),
     . STRETCHNEW(*), DEFGRADNEW(*), FIELDNEW(*),
     . STRESSNEW(NBLOCK,NDIR+NSHR), STATENEW(NBLOCK,NSTATEV),
     . ENERINTERNNEW(NBLOCK), ENERINELASNEW(NBLOCK)
    !
      CHARACTER*80 CMNAME
!-----------------------------------------------------------------------
    !     Internal UMAT variables 
!-----------------------------------------------------------------------
      REAL*8 STRESS(NDIR+NSHR)      ! Stress tensor inside UMAT
      REAL*8 HYDSTRESS              ! HYDROSTATIC STRESS INSIDE UMAT
      REAL*8 DEVSTRESS(NDIR+NSHR)   ! DEVIATORIC STRESS INSIDE UMAT
      REAL*8 DPSTRESS(NDIR)         ! DEVIATORIC PRINCIPAL STRESS
      REAL*8 PSTRESS(NDIR)          ! PRINCIPAL STRESS
!-----------------------------------------------------------------------
    !    VARIABLES TO CALCULATE DFDS 
!-----------------------------------------------------------------------      
      REAL*8 DFDS(NDIR+NSHR)        ! Derivative of the yield function
      REAL*8 DENOM                  ! DENOMINATOR USED TO AVOID NAN
      REAL*8 DLADS(NDIR+NSHR)       ! DERIVATIVE OF LODE ANGLE
      REAL*8 DJ3DS(NDIR+NSHR)       ! DERIVATIVE OF J3
      REAL*8 DPHIDSP(NDIR)          ! DERIVATIVE OF PHI WRT PSTRESS
      REAL*8 DPS1DS(NDIR+NSHR)      ! DERIVATIVE OF PRINCIPAL STRESS 1
      REAL*8 DPS2DS(NDIR+NSHR)      ! DERIVATIVE OF PRINCIPAL STRESS 2
      REAL*8 DPS3DS(NDIR+NSHR)      ! DERIVATIVE OF PRINCIPAL STRESS 3
      REAL*8 A, B, C                ! VARIABLES INTRODUCED INTO HERSHEY
!-----------------------------------------------------------------------
    !     MATERIAL PROPERTIES
!-----------------------------------------------------------------------
      REAL*8 YOUNGS           ! YOUNGS MODULUS
      REAL*8 POISS            ! POISSONS RATIO
      REAL*8 C11, C12, C44    ! COMPONENTS ELASTIC STIFFNESS MATRIX
      REAL*8 FACTOR            ! FACTOR TO CALCULATE THICKNESS STRAIN SHELL
!-----------------------------------------------------------------------
    !     YIELD FUNCTION
!-----------------------------------------------------------------------
      REAL*8 F                ! YIELD FUNCTION
      REAL*8 PHI              ! EQUIVALENT STRESS
      REAL*8 SIGMA0           ! INITIAL YIELD STRESS
      REAL*8 HR               ! PLASTIC HARDENING MODULUS
      REAL*8 SIGMAY           ! YIELD STRESS
      REAL*8 J2,J3,LA,TRIAX   ! J2, J3, LODE ANGLE AND TRIAX
      REAL*8 M                ! EXPONENT IN HERSHEY
!-----------------------------------------------------------------------
    !     VOCE HARDENING THREE TERMS
!-----------------------------------------------------------------------
      REAL*8 QR1,CR1,QR2,CR2,QR3,CR3      
!-----------------------------------------------------------------------
    !     PLASTIC VARIABLES
!-----------------------------------------------------------------------
      REAL*8 P                ! EQUIVALENT STRESS
      REAL*8 DLAMBDA          ! PLASTIC MULTIPLIER
      REAL*8 DDLAMBDA         ! INCREMENT PLASTIC MULTIPLIER
!-----------------------------------------------------------------------
    ! VARIABLES IN RETRUN MAPPING AND CONVERGENCE
!-----------------------------------------------------------------------
      REAL*8 TOL              ! TOLERANCE FOR CONVERGENCE CRITERION
      REAL*8 RESNOR           ! CONVERGENCE CRITERION
      INTEGER ITER            ! ITERATION COUNTER
      INTEGER MXITER          ! MAXIMUM NUMBER OF ITERATIONS IN RMAP
      REAL*8 DFDSCDFDS        ! VARIABLE IN CUTTING PLANE DENOMINATOR FOR DDLAMBDA
      REAL*8 PI               ! PI
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      ! IMPORTING PROPERTIES FROM .INP
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      YOUNGS = PROPS(1)
      POISS = PROPS(2)
      SIGMA0 = PROPS(3)
      M = PROPS(4)
      QR1 = PROPS(5)
      CR1 = PROPS(6)
      QR2 = PROPS(7)
      CR2 = PROPS(8)
      QR3 = PROPS(9)
      CR3 = PROPS(10)
      TOL = PROPS(11)
      MXITER = PROPS(12)
!-----------------------------------------------------------------------
      PI = 4.0*ATAN(1.0) ! PI
!-----------------------------------------------------------------------
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        ! SOLID FORMULATION
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      IF(NSHR.EQ.3.0)THEN
!-----------------------------------------------------------------------
      !ELASTIC COMPONENTS
!-----------------------------------------------------------------------
      C11 = YOUNGS*(1.0-POISS)/((1.0+POISS)*(1.0-2.0*POISS))
      C12 = C11*POISS/(1.0-POISS)
      C44 = YOUNGS/(2.0*(1.0+POISS))
      DO i=1,NBLOCK
!-----------------------------------------------------------------------
    ! ABAQUS EXPLICIT DATA CHECK: FICTITOUS STRAINS WHEN TOIAL STEP AND STEP TIME = 0.0.
    ! CHECKS YOUR CONSTITUTIVE REALTION AND CALCULATES THE INITIAL MATERIAL PROPERTIES.
    ! THUS, THE ELASTIC WAVE SPEEDS ARE COMPUTED
!-----------------------------------------------------------------------
        IF(TOTALTIME.EQ.0.0)THEN
          STRESSNEW(i,1) = STRESSOLD(i,1) + C11*STRAININC(i,1)
     .                                    + C12*STRAININC(i,2)
     .                                    + C12*STRAININC(i,3)
          STRESSNEW(i,2) = STRESSOLD(i,2) + C11*STRAININC(i,2)
     .                                    + C12*STRAININC(i,1)
     .                                    + C12*STRAININC(i,3)
          STRESSNEW(i,3) = STRESSOLD(i,3) + C11*STRAININC(i,3)
     .                                    + C12*STRAININC(i,1)
     .                                    + C12*STRAININC(i,2)
          STRESSNEW(i,4) = STRESSOLD(i,4) + C44*2.0*STRAININC(i,4)
          STRESSNEW(i,5) = STRESSOLD(i,5) + C44*2.0*STRAININC(i,5)
          STRESSNEW(i,6) = STRESSOLD(i,6) + C44*2.0*STRAININC(i,6)
        ELSE
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        ! ELASTIC PREDICTOR STEP (TRIAL STEP)
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
          STRESS(1) = STRESSOLD(i,1) + C11*STRAININC(i,1)
     .                               + C12*STRAININC(i,2)
     .                               + C12*STRAININC(i,3)
          STRESS(2) = STRESSOLD(i,2) + C11*STRAININC(i,2)
     .                               + C12*STRAININC(i,1)
     .                               + C12*STRAININC(i,3)
          STRESS(3) = STRESSOLD(i,3) + C11*STRAININC(i,3)
     .                               + C12*STRAININC(i,1)
     .                               + C12*STRAININC(i,2)
          STRESS(4) = STRESSOLD(i,4) + C44*2.0*STRAININC(i,4)
          STRESS(5) = STRESSOLD(i,5) + C44*2.0*STRAININC(i,5)
          STRESS(6) = STRESSOLD(i,6) + C44*2.0*STRAININC(i,6)
!-----------------------------------------------------------------------
!      THE PRINCIPAL VALUES.
!-----------------------------------------------------------------------
          HYDSTRESS = 1.0/3.0*(STRESS(1) + STRESS(2) + STRESS(3))
          DEVSTRESS(1) = STRESS(1) - HYDSTRESS
          DEVSTRESS(2) = STRESS(2) - HYDSTRESS
          DEVSTRESS(3) = STRESS(3) - HYDSTRESS
          DEVSTRESS(4) = STRESS(4)
          DEVSTRESS(5) = STRESS(5)
          DEVSTRESS(6) = STRESS(6)
          J2 = 0.5*(DEVSTRESS(1)*DEVSTRESS(1)
     .            + DEVSTRESS(2)*DEVSTRESS(2)
     .            + DEVSTRESS(3)*DEVSTRESS(3)
     .            + DEVSTRESS(4)*DEVSTRESS(4)*2.0
     .            + DEVSTRESS(5)*DEVSTRESS(5)*2.0
     .            + DEVSTRESS(6)*DEVSTRESS(6)*2.0)
          J3 =  DEVSTRESS(1)*(DEVSTRESS(2)*DEVSTRESS(3)
     .                      - DEVSTRESS(5)*DEVSTRESS(5))
     .         -DEVSTRESS(4)*(DEVSTRESS(4)*DEVSTRESS(3) 
     .                      - DEVSTRESS(5)*DEVSTRESS(6))
     .         +DEVSTRESS(6)*(DEVSTRESS(4)*DEVSTRESS(5)
     .                      - DEVSTRESS(2)*DEVSTRESS(6))
          LA = 1.0/3.0*ACOS(MAX(-1.0,
     .                       MIN(1.0,3.0*SQRT(3.0)*0.5*J3*J2**(-1.5))))
          TRIAX=HYDSTRESS/SQRT(3*J2)
          DPSTRESS(1) =2.0/SQRT(3.0)*SQRT(J2)*COS(LA)
          DPSTRESS(2) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 - LA)
          DPSTRESS(3) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 + LA)
          PSTRESS(1) = DPSTRESS(1) + HYDSTRESS
          PSTRESS(2) = DPSTRESS(2) + HYDSTRESS
          PSTRESS(3) = DPSTRESS(3) + HYDSTRESS
!-----------------------------------------------------------------------
!       THE EQUIVALENT STRESS PHI.
!-----------------------------------------------------------------------
          PHI = (1.0/2.0*((ABS(PSTRESS(1) -PSTRESS(2)))**(M) + 
     .                    (ABS(PSTRESS(2) -PSTRESS(3)))**(M) +
     .                    (ABS(PSTRESS(3) -PSTRESS(1)))**(M)))**(1.0/M)
!-----------------------------------------------------------------------
!      EQUIVALENT PLASTIC STRAIN, PLASTIC MULTIPLIER AND YIELD STRESS
!-----------------------------------------------------------------------
          P = STATEOLD(i,1)
          SIGMAY = SIGMA0 + QR1*(1-EXP(-CR1*P))
     .                    + QR2*(1-EXP(-CR2*P))
     .                    + QR3*(1-EXP(-CR3*P))
!-----------------------------------------------------------------------
! CHECK YIELD FUNCTION
!-----------------------------------------------------------------------
          F = PHI - SIGMAY
          DLAMBDA = 0.0
          IF(F.GT.0.0)THEN
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
! PLASTIC CORRECTOR STEP
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            DO ITER=1,MXITER
!-----------------------------------------------------------------------
       ! Hardening modulus
!-----------------------------------------------------------------------
              HR = QR1*CR1*EXP(-CR1*P)
     .           + QR2*CR2*EXP(-CR2*P)
     .           + QR3*CR3*EXP(-CR3*P)             
!-----------------------------------------------------------------------
! CALCULATION OF THE DERIVATIVES NEEDED
!-----------------------------------------------------------------------     
!             A, B, C
              A = PSTRESS(1) - PSTRESS(2)
              B = PSTRESS(2) - PSTRESS(3)
              C = PSTRESS(3) - PSTRESS(1)
!-----------------------------------------------------------------------
              IF (ABS(LA).LT.0.00001) THEN
                DENOM = ABS(A)
                IF (DENOM.LT.0.00001) THEN
                     DENOM = 0.00001
                END IF
!             DFDS
                DFDS(1) = A/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(1) 
                DFDS(2) = A/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(2)
                DFDS(3) = A/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(3)
                DFDS(4) = A/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)
                DFDS(5) = A/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(5) 
                DFDS(6) = A/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(6)
!-----------------------------------------------------------------------
              ELSE IF(LA.GT.(PI/3.0-0.00001)) THEN
                DENOM = ABS(B)
                IF (DENOM.LT.0.00001) THEN
                     DENOM = 0.00001
                END IF
!             DFDS
                DFDS(1) = B/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(1) 
                DFDS(2) = B/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(2)
                DFDS(3) = B/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(3)
                DFDS(4) = B/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)
                DFDS(5) = B/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(5) 
                DFDS(6) = B/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(6)
!-----------------------------------------------------------------------
              ELSE
!             DJ3DS
              DJ3DS(1) = 1.0/3.0*(-DEVSTRESS(1)*DEVSTRESS(2) +
     .                           2.0*DEVSTRESS(2)*DEVSTRESS(3) - 
     .                             DEVSTRESS(1)*DEVSTRESS(3) +
     .                             DEVSTRESS(4)**2.0 - 
     .                           2.0*DEVSTRESS(5)**2.0 +
     .                             DEVSTRESS(6)**2.0)
              DJ3DS(2) = 1.0/3.0*(-DEVSTRESS(1)*DEVSTRESS(2) -
     .                             DEVSTRESS(2)*DEVSTRESS(3) + 
     .                           2.0*DEVSTRESS(1)*DEVSTRESS(3) +
     .                             DEVSTRESS(4)**2.0 + 
     .                             DEVSTRESS(5)**2.0 -
     .                           2.0*DEVSTRESS(6)**2.0)
              DJ3DS(3) = 1.0/3.0*(2.0*DEVSTRESS(1)*DEVSTRESS(2) -
     .                              DEVSTRESS(2)*DEVSTRESS(3) - 
     .                              DEVSTRESS(1)*DEVSTRESS(3) -
     .                            2.0*DEVSTRESS(4)**2.0 + 
     .                              DEVSTRESS(5)**2.0 +
     .                              DEVSTRESS(6)**2.0)
              DJ3DS(4) = -DEVSTRESS(3)*DEVSTRESS(4) +
     .                    DEVSTRESS(5)*DEVSTRESS(6)
              DJ3DS(5) = -DEVSTRESS(1)*DEVSTRESS(5) +
     .                    DEVSTRESS(4)*DEVSTRESS(6)
              DJ3DS(6) = -DEVSTRESS(2)*DEVSTRESS(6) +
     .                    DEVSTRESS(4)*DEVSTRESS(5)
!-----------------------------------------------------------------------
!             DLADS
              DENOM = (-2.0*SIN(3.0*LA))
              DLADS(1) = SQRT(3.0)/DENOM*
     .          (DJ3DS(1)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(1))
              DLADS(2) = SQRT(3.0)/DENOM*
     .          (DJ3DS(2)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(2))
              DLADS(3) = SQRT(3.0)/DENOM*
     .          (DJ3DS(3)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(3))
              DLADS(4) = SQRT(3.0)/DENOM*
     .          (DJ3DS(4)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(4))
              DLADS(5) = SQRT(3.0)/DENOM*
     .          (DJ3DS(5)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(5))
              DLADS(6) = SQRT(3.0)/DENOM*
     .          (DJ3DS(6)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(6))
!-----------------------------------------------------------------------
!             DPS1DS,
              DPS1DS(1) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(1)
              DPS1DS(2) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(2)
              DPS1DS(3) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(3)
              DPS1DS(4) = 1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(4)
              DPS1DS(5) = 1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(5)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(5)
              DPS1DS(6) = 1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(6)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(6)
!-----------------------------------------------------------------------
!             DPS2DS,
              DPS2DS(1) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(1)
              DPS2DS(2) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(2)
              DPS2DS(3) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(3)
              DPS2DS(4) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(4)
              DPS2DS(5) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(5)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(5)
              DPS2DS(6) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(6)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(6)
!-----------------------------------------------------------------------
!             DPS3DS,
              DPS3DS(1) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(1)
              DPS3DS(2) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(2)
              DPS3DS(3) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(3)
              DPS3DS(4) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(4)
              DPS3DS(5) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(5)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(5)
              DPS3DS(6) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(6)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(6)
!-----------------------------------------------------------------------
!             DPHIDSP
              DPHIDSP(1) = 0.5*(0.5*((ABS(A))**M+ 
     .                               (ABS(B))**M+ 
     .                               (ABS(C))**M))**((1.0-M)/M)*
     .                       (A*(ABS(A))**(M-2.0) - C*(ABS(C))**(M-2.0))
              DPHIDSP(2) = 0.5*(0.5*((ABS(A))**M+ 
     .                               (ABS(B))**M+ 
     .                               (ABS(C))**M))**((1.0-M)/M)*
     .                      (-A*(ABS(A))**(M-2.0) + B*(ABS(B))**(M-2.0))
              DPHIDSP(3) = 0.5*(0.5*((ABS(A))**M+ 
     .                               (ABS(B))**M+ 
     .                               (ABS(C))**M))**((1.0-M)/M)*
     .                      (-B*(ABS(B))**(M-2.0) + C*(ABS(C))**(M-2.0))
!-----------------------------------------------------------------------
!             DFDS
              DFDS(1) = DPHIDSP(1)*DPS1DS(1) 
     .                + DPHIDSP(2)*DPS2DS(1)
     .                + DPHIDSP(3)*DPS3DS(1)
              DFDS(2) = DPHIDSP(1)*DPS1DS(2) 
     .                + DPHIDSP(2)*DPS2DS(2)
     .                + DPHIDSP(3)*DPS3DS(2)
              DFDS(3) = DPHIDSP(1)*DPS1DS(3) 
     .                + DPHIDSP(2)*DPS2DS(3)
     .                + DPHIDSP(3)*DPS3DS(3)
              DFDS(4) = 2.0*(DPHIDSP(1)*DPS1DS(4) 
     .                + DPHIDSP(2)*DPS2DS(4)
     .                + DPHIDSP(3)*DPS3DS(4))
              DFDS(5) = 2.0*(DPHIDSP(1)*DPS1DS(5) 
     .                + DPHIDSP(2)*DPS2DS(5)
     .                + DPHIDSP(3)*DPS3DS(5))
              DFDS(6) = 2.0*(DPHIDSP(1)*DPS1DS(6) 
     .                + DPHIDSP(2)*DPS2DS(6)
     .                + DPHIDSP(3)*DPS3DS(6))
              END IF 
!-----------------------------------------------------------------------
              DFDSCDFDS = DFDS(1)*(DFDS(1)*C11
     .                           + DFDS(2)*C12 
     .                           + DFDS(3)*C12)
     .                  + DFDS(2)*(DFDS(1)*C12
     .                           + DFDS(2)*C11 
     .                           + DFDS(3)*C12)
     .                  + DFDS(3)*(DFDS(1)*C12
     .                           + DFDS(2)*C12
     .                           + DFDS(3)*C11)
     .                  +(DFDS(4)*DFDS(4) +
     .                    DFDS(5)*DFDS(5) + 
     .                    DFDS(6)*DFDS(6))*C44
              DDLAMBDA = F/(DFDSCDFDS+HR)
              DLAMBDA = DLAMBDA + DDLAMBDA
              P = P + DDLAMBDA
!-----------------------------------------------------------------------
!STRESS UPDATE BECAUSE OF DDLAMBDA.
!-----------------------------------------------------------------------
              STRESS(1) = STRESS(1) - DDLAMBDA*(C11*DFDS(1)
     .                                         +C12*DFDS(2)
     .                                         +C12*DFDS(3))
              STRESS(2) = STRESS(2) - DDLAMBDA*(C11*DFDS(2)
     .                                         +C12*DFDS(1)
     .                                         +C12*DFDS(3))
              STRESS(3) = STRESS(3) - DDLAMBDA*(C11*DFDS(3)
     .                                         +C12*DFDS(1)
     .                                         +C12*DFDS(2))
              STRESS(4) = STRESS(4) - DDLAMBDA*C44*DFDS(4)
              STRESS(5) = STRESS(5) - DDLAMBDA*C44*DFDS(5)
              STRESS(6) = STRESS(6) - DDLAMBDA*C44*DFDS(6)
!-----------------------------------------------------------------------
!CALCULATE THE PRINCIPAL VALUES.
!-----------------------------------------------------------------------
              HYDSTRESS = 1.0/3.0*(STRESS(1) + STRESS(2) + STRESS(3))
              DEVSTRESS(1) = STRESS(1) - HYDSTRESS
              DEVSTRESS(2) = STRESS(2) - HYDSTRESS
              DEVSTRESS(3) = STRESS(3) - HYDSTRESS
              DEVSTRESS(4) = STRESS(4)
              DEVSTRESS(5) = STRESS(5)
              DEVSTRESS(6) = STRESS(6)
              J2 = 0.5*(DEVSTRESS(1)*DEVSTRESS(1)
     .                + DEVSTRESS(2)*DEVSTRESS(2)
     .                + DEVSTRESS(3)*DEVSTRESS(3)
     .                + DEVSTRESS(4)*DEVSTRESS(4)*2.0
     .                + DEVSTRESS(5)*DEVSTRESS(5)*2.0
     .                + DEVSTRESS(6)*DEVSTRESS(6)*2.0)
              J3 =  DEVSTRESS(1)*(DEVSTRESS(2)*DEVSTRESS(3)
     .                          - DEVSTRESS(5)*DEVSTRESS(5))
     .             -DEVSTRESS(4)*(DEVSTRESS(4)*DEVSTRESS(3) 
     .                          - DEVSTRESS(5)*DEVSTRESS(6))
     .             +DEVSTRESS(6)*(DEVSTRESS(4)*DEVSTRESS(5)
     .                          - DEVSTRESS(2)*DEVSTRESS(6))
              LA = 1.0/3.0*ACOS(MAX(-1.0,
     .                        MIN(1.0,3.0*SQRT(3.0)*0.5*J3*J2**(-1.5))))
              TRIAX=HYDSTRESS/SQRT(3*J2)
              DPSTRESS(1) =2.0/SQRT(3.0)*SQRT(J2)*COS(LA)
              DPSTRESS(2) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 - LA)
              DPSTRESS(3) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 + LA)
              PSTRESS(1) = DPSTRESS(1) + HYDSTRESS
              PSTRESS(2) = DPSTRESS(2) + HYDSTRESS
              PSTRESS(3) = DPSTRESS(3) + HYDSTRESS
!-----------------------------------------------------------------------
!CALCULATE THE EQUIVALENT STRESS PHI.
!-----------------------------------------------------------------------
          PHI = (1.0/2.0*((ABS(PSTRESS(1) -PSTRESS(2)))**(M) + 
     .                    (ABS(PSTRESS(2) -PSTRESS(3)))**(M) +
     .                    (ABS(PSTRESS(3) -PSTRESS(1)))**(M)))**(1.0/M)
!-----------------------------------------------------------------------
!UPDATE YIELD STRESS, YIELD CRITERION AND CHECK CONVERGENCE.
!-----------------------------------------------------------------------         
              SIGMAY = SIGMA0 + QR1*(1-EXP(-CR1*P))
     .                        + QR2*(1-EXP(-CR2*P))
     .                        + QR3*(1-EXP(-CR3*P))
              F = PHI - SIGMAY
              RESNOR = ABS(F/SIGMAY)
              IF(RESNOR.LE.TOL)THEN
                !IF(ITER.GT.1)THEN
                  STRESSNEW(i,1) = STRESS(1) 
                  STRESSNEW(i,2) = STRESS(2)
                  STRESSNEW(i,3) = STRESS(3)
                  STRESSNEW(i,4) = STRESS(4)
                  STRESSNEW(i,5) = STRESS(5)
                  STRESSNEW(i,6) = STRESS(6)
                  STATENEW(i,1) = P
                  STATENEW(i,2) = PHI
                  STATENEW(i,3) = F
                  STATENEW(i,4) = SIGMAY
                  STATENEW(i,5) = DLAMBDA
                  STATENEW(i,6) = ITER
                  STATENEW(i,7) = LA
                  STATENEW(i,8) = TRIAX
                  GOTO 90
                !END IF
              ELSE
                IF(ITER.EQ.MXITER)THEN
                  WRITE(*,*)  'RMAP HAS NOT CONVERGED'
                  WRITE(*,*)  'INTEGRATION POINT', i
                  WRITE(*,*)  'CONVERGENCE:', RESNOR
                  WRITE(*,*)  'DLAMBDA, EQ.PLASTIC STRAIN', DLAMBDA, P
                  STOP
                END IF
              END IF
            END DO                   
          ELSE
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
! YIELD FUNCTION SATISFIED IN ELASTIC PREDICTIOR STEP. UPDATE STRESSNEW AND STATENEW
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            STRESSNEW(i,1) = STRESS(1)
            STRESSNEW(i,2) = STRESS(2)
            STRESSNEW(i,3) = STRESS(3)
            STRESSNEW(i,4) = STRESS(4)
            STRESSNEW(i,5) = STRESS(5)
            STRESSNEW(i,6) = STRESS(6)
            STATENEW(i,1) = P
            STATENEW(i,2) = PHI
            STATENEW(i,3) = F
            STATENEW(i,4) = SIGMAY
            STATENEW(i,5) = 0.0
            STATENEW(i,6) = 0
            STATENEW(i,7) = LA
            STATENEW(i,8) = TRIAX
          END IF
        END IF
  90    CONTINUE           
      END DO
      ELSE
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
! SHELL FORMULATION
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
!-----------------------------------------------------------------------
!      ELASTIC COMPONENTS IN PLANE STRESS
!-----------------------------------------------------------------------
        C11 = YOUNGS/(1.0-POISS*POISS)
        C12 = C11*POISS
        C44 = YOUNGS/(2.0*(1.0+POISS))
        FACTOR = (1.0 - 2.0*POISS)/YOUNGS         
        DO i=1,NBLOCK
          IF(TOTALTIME.EQ.0.0)THEN
            STRESSNEW(i,1) = STRESSOLD(i,1) + C11*STRAININC(i,1)
     .                                      + C12*STRAININC(i,2)
            STRESSNEW(i,2) = STRESSOLD(i,2) + C11*STRAININC(i,2)
     .                                      + C12*STRAININC(i,1)
            STRESSNEW(i,3) = 0.0
            STRESSNEW(i,4) = STRESSOLD(i,4) + C44*2.0*STRAININC(i,4)
          ELSE
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
               ! ELASTIC PREDICTOR STEP (TRIAL STEP)
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            STRESS(1) = STRESSOLD(i,1) + C11*STRAININC(i,1)
     .                                 + C12*STRAININC(i,2)
            STRESS(2) = STRESSOLD(i,2) + C11*STRAININC(i,2)
     .                                 + C12*STRAININC(i,1)
            STRESS(3) = 0.0
            STRESS(4) = STRESSOLD(i,4) + C44*2.0*STRAININC(i,4)
!-----------------------------------------------------------------------
       !CALCULATE THE PRINCIPAL VALUES.
!-----------------------------------------------------------------------
            HYDSTRESS = 1.0/3.0*(STRESS(1) + STRESS(2) + STRESS(3))
            DEVSTRESS(1) = STRESS(1) - HYDSTRESS
            DEVSTRESS(2) = STRESS(2) - HYDSTRESS
            DEVSTRESS(3) = STRESS(3) - HYDSTRESS
            DEVSTRESS(4) = STRESS(4)
            J2 = 0.5*(DEVSTRESS(1)*DEVSTRESS(1)
     .              + DEVSTRESS(2)*DEVSTRESS(2)
     .              + DEVSTRESS(3)*DEVSTRESS(3)
     .              + DEVSTRESS(4)*DEVSTRESS(4)*2.0)
            J3 =  DEVSTRESS(1)*DEVSTRESS(2)*DEVSTRESS(3)-
     .            DEVSTRESS(4)*DEVSTRESS(4)*DEVSTRESS(3)
            LA = 1.0/3.0*ACOS(MAX(-1.0,
     .                       MIN(1.0,3.0*SQRT(3.0)*0.5*J3*J2**(-1.5))))
            TRIAX=HYDSTRESS/SQRT(3*J2)
            DPSTRESS(1) =2.0/SQRT(3.0)*SQRT(J2)*COS(LA)
            DPSTRESS(2) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 - LA)
            DPSTRESS(3) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 + LA)
            PSTRESS(1) = DPSTRESS(1) + HYDSTRESS
            PSTRESS(2) = DPSTRESS(2) + HYDSTRESS
            PSTRESS(3) = DPSTRESS(3) + HYDSTRESS
!-----------------------------------------------------------------------
       !CALCULATE THE EQUIVALENT STRESS PHI.
!-----------------------------------------------------------------------
            PHI =(1.0/2.0*((ABS(PSTRESS(1) -PSTRESS(2)))**(M) + 
     .                     (ABS(PSTRESS(2) -PSTRESS(3)))**(M) +
     .                     (ABS(PSTRESS(3) -PSTRESS(1)))**(M)))**(1.0/M)
!-----------------------------------------------------------------------
       !DEFINE EQUIVALENT PLASTIC STRAIN, PLASTIC MULTIPLIER AND YIELD STRESS
!-----------------------------------------------------------------------
            P = STATEOLD(i,1)
            SIGMAY = SIGMA0 + QR1*(1-EXP(-CR1*P))
     .                      + QR2*(1-EXP(-CR2*P))
     .                      + QR3*(1-EXP(-CR3*P))
!-----------------------------------------------------------------------
       ! CHECK YIELD FUNCTION
!-----------------------------------------------------------------------
            F = PHI - SIGMAY
            DLAMBDA = 0.0
            IF(F.GT.0.0)THEN
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
       ! PLASTIC CORRECTOR STEP
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              DO ITER=1,MXITER
!-----------------------------------------------------------------------
!      HARDENING MODULUS
!-----------------------------------------------------------------------
                HR = QR1*CR1*EXP(-CR1*P)
     .             + QR2*CR2*EXP(-CR2*P)
     .             + QR3*CR3*EXP(-CR3*P)             
!-----------------------------------------------------------------------
       ! CALCULATION OF THE DERIVATIVES NEEDED
!-----------------------------------------------------------------------
!             A, B, C
                A = PSTRESS(1) - PSTRESS(2)
                B = PSTRESS(2) - PSTRESS(3)
                C = PSTRESS(3) - PSTRESS(1)
!-----------------------------------------------------------------------
                IF (ABS(LA).LT.0.00001) THEN
                  DENOM = ABS(A)
                  IF (DENOM.LT.0.00001) THEN
                    DENOM = 0.00001
                  END IF
!                 DFDS
                  DFDS(1) = A/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(1) 
                  DFDS(2) = A/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(2)
                  DFDS(3) = 0.0
                  DFDS(4) = A/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)
!-----------------------------------------------------------------------
                ELSE IF(LA.GT.(PI/3.0-0.00001)) THEN
                  DENOM = ABS(B)
                  IF (DENOM.LT.0.00001) THEN
                    DENOM = 0.00001
                  END IF
!               DFDS
                DFDS(1) = B/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(1) 
                DFDS(2) = B/DENOM*SQRT(3.0)*0.5/SQRT(J2)*DEVSTRESS(2)
                DFDS(3) = 0.0
                DFDS(4) = B/DENOM*SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)
!-----------------------------------------------------------------------
                ELSE
!-----------------------------------------------------------------------
!             DJ3DS
                DJ3DS(1) = 1.0/3.0*(-DEVSTRESS(1)*DEVSTRESS(2) +
     .                           2.0*DEVSTRESS(2)*DEVSTRESS(3) - 
     .                               DEVSTRESS(1)*DEVSTRESS(3) +
     .                               DEVSTRESS(4)**2.0)
                DJ3DS(2) = 1.0/3.0*(-DEVSTRESS(1)*DEVSTRESS(2) -
     .                               DEVSTRESS(2)*DEVSTRESS(3) + 
     .                           2.0*DEVSTRESS(1)*DEVSTRESS(3) +
     .                               DEVSTRESS(4)**2.0)
                DJ3DS(3) = 1.0/3.0*(2.0*DEVSTRESS(1)*DEVSTRESS(2) -
     .                                  DEVSTRESS(2)*DEVSTRESS(3) - 
     .                                  DEVSTRESS(1)*DEVSTRESS(3) -
     .                              2.0*DEVSTRESS(4)**2.0)
                DJ3DS(4) = -DEVSTRESS(3)*DEVSTRESS(4)
!-----------------------------------------------------------------------
       !             DLADS
                DENOM = (-2.0*SIN(3.0*LA))
                DLADS(1) = SQRT(3.0)/DENOM*
     .         (DJ3DS(1)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(1))
                DLADS(2) = SQRT(3.0)/DENOM*
     .         (DJ3DS(2)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(2))
                DLADS(3) = SQRT(3.0)/DENOM*
     .         (DJ3DS(3)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(3))
                DLADS(4) = SQRT(3.0)/DENOM*
     .         (DJ3DS(4)*J2**(-1.5)-3.0*0.5*J3*J2**(-2.5)*DEVSTRESS(4))
!-----------------------------------------------------------------------
       !             DPS1DS,
                DPS1DS(1) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(1)
                DPS1DS(2) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(2)
                DPS1DS(3) = 1.0/3.0 +
     .                    1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(3)
                DPS1DS(4)=1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(LA) -
     .                    2.0/SQRT(3.0)*SQRT(J2)*SIN(LA)*DLADS(4)
!-----------------------------------------------------------------------
       !             DPS2DS,
                DPS2DS(1) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(1)
                DPS2DS(2) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(2)
                DPS2DS(3) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(3)
                DPS2DS(4) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(2.0*PI/3.0-LA)+
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0-LA)*DLADS(4)
!-----------------------------------------------------------------------
       !             DPS3DS,
                DPS3DS(1) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(1)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(1)
                DPS3DS(2) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(2)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(2)
                DPS3DS(3) = 1.0/3.0 +
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(3)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(3)
                DPS3DS(4) = 
     .           1.0/SQRT(3.0)/SQRT(J2)*DEVSTRESS(4)*COS(2.0*PI/3.0+LA)-
     .           2.0/SQRT(3.0)*SQRT(J2)*SIN(2.0*PI/3.0+LA)*DLADS(4)
!-----------------------------------------------------------------------
       !             DPHIDSP
                DPHIDSP(1) = 0.5*(0.5*((ABS(A))**M+ 
     .                                 (ABS(B))**M+ 
     .                                 (ABS(C))**M))**((1.0-M)/M)*
     .                       (A*(ABS(A))**(M-2.0) - C*(ABS(C))**(M-2.0))
                DPHIDSP(2) = 0.5*(0.5*((ABS(A))**M+ 
     .                                 (ABS(B))**M+ 
     .                                 (ABS(C))**M))**((1.0-M)/M)*
     .                      (-A*(ABS(A))**(M-2.0) + B*(ABS(B))**(M-2.0))
                DPHIDSP(3) = 0.5*(0.5*((ABS(A))**M+ 
     .                                 (ABS(B))**M+ 
     .                                 (ABS(C))**M))**((1.0-M)/M)*
     .                      (-B*(ABS(B))**(M-2.0) + C*(ABS(C))**(M-2.0))
!-----------------------------------------------------------------------
       !             DFDS
                DFDS(1) = DPHIDSP(1)*DPS1DS(1) 
     .                  + DPHIDSP(2)*DPS2DS(1)
     .                  + DPHIDSP(3)*DPS3DS(1)
                DFDS(2) = DPHIDSP(1)*DPS1DS(2) 
     .                  + DPHIDSP(2)*DPS2DS(2)
     .                  + DPHIDSP(3)*DPS3DS(2)
                DFDS(3) = 0.0
                DFDS(4) = 2.0*(DPHIDSP(1)*DPS1DS(4) 
     .                       + DPHIDSP(2)*DPS2DS(4)
     .                       + DPHIDSP(3)*DPS3DS(4))
                END IF
!-----------------------------------------------------------------------
                DFDSCDFDS = DFDS(1)*(DFDS(1)*C11
     .                             + DFDS(2)*C12)
     .                    + DFDS(2)*(DFDS(1)*C12
     .                             + DFDS(2)*C11)
     .                    +(DFDS(4)*DFDS(4))*C44
                DDLAMBDA = F/(DFDSCDFDS+HR)
                DLAMBDA = DLAMBDA + DDLAMBDA
                P = P + DDLAMBDA
!-----------------------------------------------------------------------
       !STRESS UPDATE BECAUSE OF DDLAMBDA.
!-----------------------------------------------------------------------
                STRESS(1) = STRESS(1) - DDLAMBDA*(C11*DFDS(1)
     .                                           +C12*DFDS(2))
                STRESS(2) = STRESS(2) - DDLAMBDA*(C11*DFDS(2)
     .                                           +C12*DFDS(1))
                STRESS(3) = 0.0
                STRESS(4) = STRESS(4) - DDLAMBDA*C44*DFDS(4)
!-----------------------------------------------------------------------
       !CALCULATE THE PRINCIPAL VALUES.
!-----------------------------------------------------------------------
                HYDSTRESS = 1.0/3.0*(STRESS(1) + STRESS(2) + STRESS(3))
                DEVSTRESS(1) = STRESS(1) - HYDSTRESS
                DEVSTRESS(2) = STRESS(2) - HYDSTRESS
                DEVSTRESS(3) = STRESS(3) - HYDSTRESS
                DEVSTRESS(4) = STRESS(4)
                J2 = 0.5*(DEVSTRESS(1)*DEVSTRESS(1)
     .                  + DEVSTRESS(2)*DEVSTRESS(2)
     .                  + DEVSTRESS(3)*DEVSTRESS(3)
     .                  + DEVSTRESS(4)*DEVSTRESS(4)*2.0)
                J3 =  DEVSTRESS(1)*DEVSTRESS(2)*DEVSTRESS(3)-
     .                DEVSTRESS(4)*DEVSTRESS(4)*DEVSTRESS(3)
                LA = 1.0/3.0*ACOS(MAX(-1.0,
     .                        MIN(1.0,3.0*SQRT(3.0)*0.5*J3*J2**(-1.5))))
                TRIAX=HYDSTRESS/SQRT(3*J2)
                DPSTRESS(1) =2.0/SQRT(3.0)*SQRT(J2)*COS(LA)
                DPSTRESS(2) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 - LA)
                DPSTRESS(3) =2.0/SQRT(3.0)*SQRT(J2)*COS(2.0*PI/3.0 + LA)
                PSTRESS(1) = DPSTRESS(1) + HYDSTRESS
                PSTRESS(2) = DPSTRESS(2) + HYDSTRESS
                PSTRESS(3) = DPSTRESS(3) + HYDSTRESS
!-----------------------------------------------------------------------
       !CALCULATE THE EQUIVALENT STRESS PHI.
!-----------------------------------------------------------------------
                PHI = (1.0/2.0*((ABS(PSTRESS(1) -PSTRESS(2)))**(M) + 
     .                    (ABS(PSTRESS(2) -PSTRESS(3)))**(M) +
     .                    (ABS(PSTRESS(3) -PSTRESS(1)))**(M)))**(1.0/M)
!-----------------------------------------------------------------------
       !UPDATE YIELD STRESS, YIELD CRITERION AND CHECK CONVERGENCE.
!-----------------------------------------------------------------------          
                SIGMAY = SIGMA0 + QR1*(1-EXP(-CR1*P))
     .                          + QR2*(1-EXP(-CR2*P))
     .                          + QR3*(1-EXP(-CR3*P))
                F = PHI - SIGMAY
                RESNOR = ABS(F/SIGMAY)
                 IF(RESNOR.LE.TOL)THEN
                   !IF(ITER.GT.1)THEN
                     STRESSNEW(i,1) = STRESS(1) 
                     STRESSNEW(i,2) = STRESS(2)
                     STRESSNEW(i,3) = STRESS(3)
                     STRESSNEW(i,4) = STRESS(4)
                     STATENEW(i,1) = P
                     STATENEW(i,2) = PHI
                     STATENEW(i,3) = F
                     STATENEW(i,4) = SIGMAY
                     STATENEW(i,5) = DLAMBDA
                     STATENEW(i,6) = ITER
                     STATENEW(i,7) = LA
                     STATENEW(i,8) = TRIAX
                     GOTO 80
                   !END IF
                   ELSE
                    IF(ITER.EQ.MXITER)THEN
                    WRITE(*,*)  'RMAP HAS NOT CONVERGED'
                    WRITE(*,*)  'INTEGRATION POINT', i
                    WRITE(*,*)  'CONVERGENCE:', RESNOR
                    WRITE(*,*)  'DLAMBDA, EQ.PLASTIC STRAIN', DLAMBDA, P
                    STOP
                     END IF
                   END IF
                 END DO                   
               ELSE
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
       ! YIELD FUNCTION SATISFIED IN ELASTIC PREDICTIOR STEP. UPDATE STRESSNEW AND STATENEW
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                 STRESSNEW(i,1) = STRESS(1)
                 STRESSNEW(i,2) = STRESS(2)
                 STRESSNEW(i,3) = STRESS(3)
                 STRESSNEW(i,4) = STRESS(4)
                 STATENEW(i,1) = P
                 STATENEW(i,2) = PHI
                 STATENEW(i,3) = F
                 STATENEW(i,4) = SIGMAY
                 STATENEW(i,5) = 0.0
                 STATENEW(i,6) = 0
                 STATENEW(i,7) = LA
                 STATENEW(i,8) = TRIAX
               END IF
             END IF
  80         CONTINUE
           STRAININC(i,3) = FACTOR*(STRESSNEW(i,1) - STRESSOLD(i,1) + 
     .                              STRESSNEW(i,2) - STRESSOLD(i,2)) -
     .                             (STRAININC(i,1) + STRAININC(i,2))           
           END DO
         END IF    
      RETURN
      END