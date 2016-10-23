### FILE="Main.annotation"
# Copyright:    Public domain.
# Filename:	R31.agc
# Purpose:      Part of the source code for Colossus build 237.
#               This is for the Command Module's (CM) Apollo Guidance
#               Computer (AGC), we believe for Apollo 8.
# Assembler:    yaYUL
# Contact:      Jim Lawton <jim DOT lawton AT gmail DOT com>
# Website:      www.ibiblio.org/apollo/index.html
# Page Scans:   www.ibiblio.org/apollo/ScansForConversion/Colossus237/
# Mod history:  2011-02-05 JL   Adapted from corresponding Colossus 249 file.

## Page 494
		BANK	34
		SETLOC	R31
		BANK

		COUNT*	$$/R31

R31CALL		CAF	PRIO3
		TC	FINDVAC
		EBANK=	SUBEXIT
		2CADR	V83CALL

DSPDELAY	CAF	1SEC
		TC	BANKCALL
		CADR	DELAYJOB
		CA	EXTVBACT
		MASK	BIT12
		EXTEND
		BZF	DSPDELAY

DISPN5X		CA	FLAGWRD9	# TEST R31FLAG (IN SUNDANCE R31FLAG WILL
		MASK	BIT4		#     ALWAYS BE SET AS R34 DOES NOT EXIST)
		EXTEND
		BZF	+3
		CAF	V16N54		# R31    USE NOUN 54
		TC	+2
		CAF	V16N53		# R34    USE NOUN 53
		TC	BANKCALL
		CADR	GOMARKF
		TC	B5OFF
		TC	B5OFF
		TCF	DISPN5X

V83		TC	INTPRET
		CALL
			REDOEXTP
		GOTO
			COMPDISP
V83CALL		TC	INTPRET
		CALL
			STATEXTP	# EXTRAPOLATE STATE VECTORS
COMPDISP	VLOAD	VSU
			RATT
			RONE
		PUSH	ABVAL		# RATT-RONE TO 0D              PD= 6
		STORE	RANGE		# METERS B-29
		NORM	VLOAD
			X1		# RATT-RONE                    PD= 0
		VSR1
		VSL*	UNIT
## Page 495
			0,1
		PDVL	VSU		# UNIT(LOS) TO 0D	       PD= 6
			VATT
			VONE
		DOT			# (VATT-VONE).UNIT(LOS)        PD= 0
		SL1
		STCALL	RRATE		# RANGE RATE M/CS B-7
			CDUTRIG		# TO INITIALIZE FOR *NBSM*
		CALL
			R34LOS		# NOTE. PDL MUST = 0.
R34ANG		VLOAD	UNIT
			RONE
		PDVL			# UR TO 0D		      PD= 6
			THISAXIS	# UNITX FOR CM, UNITZ FOR LM
		BON	VLOAD		# CHK R31FLAG. ON=R31 THETA, OFF=R34 PHI
			R31FLAG
			+2		#     R31-THETA
			12D
		CALL	
			*NBSM*
		VXM	PUSH		# UXORZ TO 6D		       PD=12D
			REFSMMAT
		VPROJ	VSL2
			0D
		BVSU	UNIT
			6D
		PDVL	VXV		# UP/2 TO 12D		       PD=18D
			RONE
			VONE
		UNIT	VXV
			RONE
		DOT	PDVL		# SIGN TO 12D, UP/2 TO MPAC    PD=18D
			12D
		VSL1	DOT		# UP.UXORZ
			6D
		SIGN	SL1
			12D
		ACOS
		STOVL	RTHETA
			RONE
		DOT	BPL
			6D
			+5
		DLOAD	BDSU		# IF UXORZ.R NEG, RTHETA = 1 - RTHETA
			RTHETA
			DPPOSMAX
		STORE	RTHETA		# RTHETA BETWEEN 0 AND 1 REV.
		EXIT
		CAF	BIT5		# HAVE WE BEEN ANSWERED
		MASK	EXTVBACT
## Page 496
		EXTEND
		BZF	ENDEXT		# YES, DIE

		CS	EXTVBACT
		MASK	BIT12
		ADS	EXTVBACT

		TCF	V83
V16N54		VN	1654
V16N53		VN	1653

## Page 497
# THE STATEXTP SUBROUTINE DOES A PRECISION EXTRAPOLATION OF BOTH VEHICLES
# STATE VECTORS TO PRESENT TIME AND SAVES THEM AS BASE VECTORS.
# IF SERVICER IS OFF ---
#		  THIS VEHICLES BASE VECTOR IS CONIC EXTRAPOLATED TO
#		  PRESENT TIME AND SAVED AS RONE, VONE.
#		  THE OTHER VEHICLES BASE VECTOR IS CONIC EXTRAPOLATED
#		  TO THE SAME TIME, THE OUTPUT BEING LEFT IN RATT, VATT.
# IF SERVICER IS ON  ---
#		  RONE, VONE ARE SET EQUAL TO RN, VN AND THE OTHER
#		  VEHICLES STATE VECTOR IS PREC. EXTRAPOLATED TO PIPTIME.
STATEXTP	STQ	RTB
			STATEXIT
			LOADTIME
		STCALL	TDEC1
			OTHPREC		# GET BASE VECTORS
		VLOAD
			RATT1
		STOVL	BASEOTP		# OTHER POS.
			VATT1
		STODL	BASEOTV		# OTHER VEL.
			TAT
		STORE	BASETIME
		STCALL	TDEC1
			THISPREC
		VLOAD
			RATT1
		STOVL	BASETHP		# THIS POS.
			VATT1
		STORE	BASETHV		# THIS VEL
HAVEBASE	BON	RTB
			V37FLAG
			GETRVN		# IF AVG ON ,GET RN ETC.
			LOADTIME
		STCALL	TDEC1		# BEGIN SET UP FOR CONIT EXTRAP. FOR THIS.
			INTSTALL
		VLOAD	CLEAR
			BASETHP
			MOONFLAG
		STOVL	RCV
			BASETHV
		STODL	VCV
			BASETIME
		BOF	SET		# GET APPROPRIATE MOONFLAG SETTING
			MOONTHIS
			+2
			MOONFLAG
		SET
			INTYPFLG	# CONIC EXTRAP.
		STCALL	TET
			INTEGRVS	# INTEGRATION --- AT LAST ---
## Page 498
		VLOAD
			RATT
		STOVL	RONE
			VATT
		STCALL	VONE		# GET SET FOR CONIC EXTRAP.,OTHER.
			INTSTALL
		SET	DLOAD
			INTYPFLG
			TAT
OTHINT		STORE	TDEC1
		VLOAD	CLEAR
			BASEOTP
			MOONFLAG
		STOVL	RCV
			BASEOTV
		STODL	VCV
			BASETIME
		BOF	SET
			MOONTHIS
			+2
			MOONFLAG
		STCALL	TET
			INTEGRVS
		GOTO
			STATEXIT	# THIS VEHICLES POS.,VEL. IN PUSHLIST.

GETRVN		VLOAD
			RN
		STOVL	RONE
			VN
		STODL	VONE
			PIPTIME
		CALL
			INTSTALL
		CLEAR	GOTO
			INTYPFLG	# PREC EXTRAP FOR OTHER
			OTHINT

REDOEXTP	STQ	GOTO
			STATEXIT
			HAVEBASE
		SETLOC	R34
		BANK
R34LOS		EXIT
		CA	CDUS
		INDEX	FIXLOC
		TS	9D
		CA	CDUT
		INDEX	FIXLOC
		TS	11D
## Page 499
		CA	FIXLOC
		AD	SIX
		COM
		INDEX	FIXLOC
		TS	X1
		TC	INTPRET
		CALL	
			SXTNB
		STCALL	12D
			R34ANG
