      program main

!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
!     Subroutine VUMAT
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
!$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
!-----------------------------------------------------------------------
      SUBROUTINE VUMAT(
     + NBLOCK, NDIR, NSHR, NSTATEV, NFIELDV, NPROPS, LANNEAL, STEPTIME,
     + TOTALTIME, DT, CMNAME, COORDMP, CHARLENGTH, PROPS, DENSITY,
     + STRAININC, RELSPININC, TEMPOLD, STRETCHOLD, DEFGRAdoLD, FIELdoLD,
     + STRESSOLD, STATEOLD, ENERINTERNOLD, ENERINELASOLD, TEMPNEW,
     + STRETCHNEW, DEFGRADNEW, FIELDNEW,
     + STRESSNEW, STATENEW, ENERINTERNNEW, ENERINELASNEW)
C
      INCLUDE 'VABA_PARAM.INC'
!-----------------------------------------------------------------------
!-----Declaration ABAQUS variables
!-----------------------------------------------------------------------
      character*(*) CMNAME
      DIMENSION PROPS(NPROPS), DENSITY(NBLOCK), COORDMP(NBLOCK,*),
     + CHARLENGTH(*), STRAININC(NBLOCK,NDIR+NSHR), RELSPININC(*),
     + TEMPOLD(*), FIELdoLD(NBLOCK,NFIELDV),FIELDNEW(NBLOCK,NFIELDV),
     + STRESSOLD(NBLOCK,NDIR+NSHR), STATEOLD(NBLOCK,NSTATEV),
     + ENERINTERNOLD(NBLOCK),  ENERINELASOLD(NBLOCK), TEMPNEW(*),
     + STRETCHOLD(NBLOCK,NDIR+NSHR), DEFGRADOLD(NBLOCK,NDIR+2*NSHR),
     + STRETCHNEW(NBLOCK,NDIR+NSHR), DEFGRADNEW(NBLOCK,NDIR+2*NSHR),
     + STRESSNEW(NBLOCK,NDIR+NSHR), STATENEW(NBLOCK,NSTATEV),
     + ENERINTERNNEW(NBLOCK), ENERINELASNEW(NBLOCK)
!-----------------------------------------------------------------------
!-----Declaration parameters
!-----------------------------------------------------------------------

!-----------------------------------------------------------------------
!     Initialization step (elastic)
!-----------------------------------------------------------------------
      if((steptime.eq.totaltime).and.(steptime.eq.zero))then

!-----------------------------------------------------------------------
!     Ordinary increment
!-----------------------------------------------------------------------
      else

      endif
!-----------------------------------------------------------------------
!     End of subroutine
!-----------------------------------------------------------------------
      return
      end