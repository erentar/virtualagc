### FILE="Main.annotation"
# Copyright:	Public domain.
# Filename:	CM_BODY_ATTITUDE.agc
# Purpose:	Part of the source code for Colossus build 237.  
#		This is for the Command Module's (CM) Apollo Guidance
#		Computer (AGC), we believe for Apollo 8.
# Assembler:	yaYUL
# Contact:	Onno Hommes <ohommes@alumni.cmu.edu>
# Website:	www.ibiblio.org/apollo/index.html
# Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Colossus237/
# Mod history:	2010-05-30 OH	Adapted from corresponding Colossus 249 file.
#		2010-12-04 JL	Remove Colossus 249 header comments. Change to double-has page numbers.
#		2011-02-07 JL	Minor fixes.

## Page 833
		BANK	35

		SETLOC	BODYATT
		BANK

		COUNT	37/CMBAT

#					  PDL 12D - 15D SAFE.

#   VALUES OF GIMBAL AND BODY ANGLES VALID AT PIP TIME ARE SAVED DURING    READACCS.

		EBANK=	RTINIT		# LET INTERPRETER SET EB

CM/POSE		TC	INTPRET		# COME HERE VIA AVEGEXIT.

		SETPD	VLOAD
			0
			VN		# KVSCALE = (12800/ .3048) /2VS
		VXSC	PDVL
			-KVSCALE	# KVSCALE = .81491944
			UNITW		# FULL UNIT VECTOR
		VXV	VXSC		# VREL = V - WE*R
			UNITR
			KWE
		VAD	STADR
		STORE	-VREL		# SAVE FOR ENTRY GUIDANCE.  REF COORDS

		UNIT	LXA,1
			36D		# ABVAL( -VREL) TO X1
		STORE	UXA/2		# -UVREL                   REF COORDS

		VXV	VCOMP
			UNITR		# .5 UNIT                  REF COORDS
		UNIT	SSP		# THE FOLLOWING IS TO PROVIDE A STABLE
			S1		# UN FOR THE END OF THE TERMINAL PHASE.
SPVQUIT		DEC	.019405		# 1000/ 2 VS
		TIX,1	VLOAD		# IF V-VQUIT POS, BRANCH.
			CM/POSE2	# SAME UYA IN OLDUYA
			OLDUYA		# OTHERWISE CONTINUE TO USE OLDUYA.
CM/POSE2	STORE	UYA/2		#                          REF COORDS

		STORE	OLDUYA		# RESTORE, OR SAVE AS CASE MAY BE.

		VXV	VCOMP
			UXA/2		# FINISH OBTAINING TRAJECTORY TRIAD.
		VSL1
		STORE	UZA/2		#                          REF COORDS
## Page 834
		TLOAD			# PICK UP CDUX, CDUY, CDUZ CORRESPONDING
			AOG/PIP		# TO PIPUP TIME IN 2S,C AND SAVE.
CM/TRIO		STODL	24D
			25D		# AIG/PIP

		RTB	PUSH		# TO PDL0
			CDULOGIC
		COS
		STODL	UBX/2		# CI /2
#					  AIG/PIP FROM PDL 0
		SIN	DCOMP
		STODL	UBX/2 +4	# -SI /2
			26D		# AMG/PIP
		RTB	PUSH		# TO PDL 0
			CDULOGIC	
		SIN	PDDL		# XCH PDL 0. SAVE SM /2
		COS	PDDL		# CM /2 TO PDL 2
			0		# SM /2
		DCOMP	VXSC
			UBX/2
		VSL1			# NOISE WONT OVFL.
		STODL	UBY/2		# =(-SMCI, NOISE, SMSI) /2
			2		# CM /2 REPLACES NOISE
		STODL	UBY/2 +2	# UBY/2=(-SMCI, CM, SMSI)/2
			24D		# AOG/PIP
		RTB	PUSH		# TO PDL 4
			CDULOGIC
		SIN	PDDL		# XCH PDL 4. SAVE SO /2
		COS	VXSC		# CO /2
			UBY/2
		STODL	UBY/2		# UBY/2=(-COSMCI, COCM, COSMSI)/4
			4D		# SO /2
		DMP	DCOMP
			UBX/2 +4	# -SI /2
		DAD
			UBY/2		#  INCREMENT BY (SOSI /4)
		STODL	UBY/2
#					  SO /2 FROM PDL 4
		DMP	DAD
			UBX/2		# CI /2
			UBY/2 +4
		STOVL	UBY/2 +4	# YB/4               PLATFORM COORDS

#				  YB = (-COSMCI + SOSI , COCM , COSMSI + SOCI )

			UBY/2
		VXM	VSL2
			REFSMMAT	# .5 UNIT
		STODL	UBY/2		# YB/2 DONE                REF COORDS
## Page 835
					# CM /2 FROM PDL 2
		VXSC	VSL1
			UBX/2
		STODL	UBX/2		# =( CMCI, NOISE, -CMSI)/2
		STADR			# SM /2 FROM PDL 0
		STOVL	UBX/2 +2	# SM /2 REPLACES NOISE
			UBX/2		# XB/2               PLATFORM COORDS

#				  XB = ( CMCI , SM , -CMSI )

		VXM	VSL1
			REFSMMAT	# .5 UNIT
		STORE	UBX/2		# XB/2  DONE               REF COORDS

		VXV	VSL1
			UBY/2
		STOVL	UBZ/2		# ZB/2  DONE               REF COORDS

#				  EQUIVALENT TO
#				  ZB = ( SOSMCI + COSI , -SOCM , -SOSMSI + COCI )

			UXA/2		# -UVREL/2 = -UVA/2
		VXV	UNIT		# GET UNIT(-UVREL*UBY)/2  = UL/2
			UBY/2		# YB/2
		PUSH	DOT		# UL/2 TO PDL 0,5
			UZA/2		# UNA/2
		STOVL	COSTH		# COS(ROLL)/4
			0		# UL/2

		DOT
			UYA/2
		STCALL	SINTH		# -SIN(ROLL)/4
			ARCTRIG
		STOVL	6D		# -(ROLL/180) /2
			UBY/2
		DOT	SL1		# -UVA.UBY = -SIN(BETA)
			UXA/2		# -UVREL/2
		ARCSIN
		STOVL	7D		# -(BETA/180) /2
			UBX/2		# XB/2
		DOT			# UL.UBX = -SIN(ALFA)
			0		# UL/2
		STOVL	SINTH		# -SIN(ALFA)/4
		DOT			# UL/2 FROM PDL 0
			UBZ/2
		STCALL	COSTH		# COS(ALFA)/2
			ARCTRIG
		STOVL	8D		# -(ALFA/180) /2
			UNITR		# UR/2                     REF COORDS
		DOT	SL1
## Page 836
			UZA/2		# MORE ACCURATE AT LARGE ARG.
		ARCCOS
		STORE	10D		# (-GAMA/180)/2

		TLOAD	EXIT		# ANGLES IN MPAC IN THE ORDER
#					  -( (ROLL, BETA, ALFA) /180)/2
			6D		# THESE VALUES CORRECT AT PIPUP TIME.

## Page 837
# BASIC SUBROUTINE TO UPDATE ATTITUDE ANGLES

		EBANK=	AOG

CM/ATUP		CA	EBAOG
		TS	EBANK
CMTR1		INDEX	FIXLOC
		CS	10D		# (GAMA/180)/2
		XCH	GAMA
		TS	L

		INHINT
# 				  MUST REMAIN INHINTED UNTIL UPDATE OF BODY
# 				  ANGLES, SO THAT GAMDIFSW IS VALID FIRST PASS
# 				  INDICATOR.

		CS	CM/FLAGS
		MASK	BIT11		# GAMDIFSW=94D BIT11   INITLY=0
		EXTEND			# DONT CALC GAMA DOT UNTIL HAVE FORMD
#					  ONE DIFFERENCE.
		BZF	DOGAMDOT	# IS OK, GO ON.
		ADS	CM/FLAGS	# KNOW BIT IS 0
		TC	NOGAMDOT	# SET GAMDOT = 0

DOGAMDOT	CS	L
		AD	GAMA		# DEL GAMA/360= T GAMDOT/360
		EXTEND
		MP	TCDU		# TCDU = .1 SEC,   T = 2 SEC.
		TS	GAMDOT		# GAMA DOT TCDU / 180

		EXTEND			# IGNORE GAMDOT IF LEQ  .5 DEG/SEC
		BZMF	+2
		COM
		AD	FIVE
		EXTEND
		BZMF	+3		# SET GAMDOT=+0 AS TAG IF TOO SMALL.

NOGAMDOT	CA	ZERO		# COME HERE INHINTED.
		TS	GAMDOT
#					  FOR NOW LEAVE IN 2S,C
#					  UPDATE ANGLES BY CORRECTING EUILER ANG
#					  FOR ACCRUED INCREMENT SINCE PIPUP
#					  R = R EUIL + R(NOW) -R(PIPUP)
		CS	MPAC		# GET (R EUL/180) /2
		DOUBLE			# POSSIBLE OVERFLOW
		TC	CORANGOV	# CORRECT FOR OVFL IF ANY
		EXTEND
		SU	ROLL/PIP	# GET INCR SINCE PIPUP
		AD	ROLL/180	# ONLY SINGLE OVFL POSSIBLE.
		TC	CORANGOV	# CORRECT FOR OVFL IF ANY
## Page 838
		TS	TEMPROLL

		CS	MPAC +2		# GET (ALFA EUL/180) /2
		DOUBLE			# SAME AS FOR ROLL. NEEDED FOR EXT ATM DAP
		TC	CORANGOV	# CORRECT FOR OVFL IF ANY
		EXTEND
		SU	ALFA/PIP
		AD	ALFA/180
		TC	CORANGOV	# CORRECT FOR OVFL IF ANY
		TS	TEMPALFA

		CS	MPAC +1		# GET (BETA EUL/180) /2
CMTR2		DOUBLE
		EXTEND
		SU	BETA/PIP
		AD	BETA/180
		XCH	TEMPBETA	# OVFL NOT EXPECTED.

		CA	EBANK3
		TS	EBANK

		EBANK=	PHSNAME5
		EXTEND
		DCA	REPOSADR	# THIS ASSUMES THAT THE   TC   PHASCHNG
		DXCH	PHSNAME5	# IS NOT CHANGED IN       OCT  10035
#					  SERVICER.

		CA	EBAOG
		TS	EBANK

		EBANK=	AOG
REDOPOSE	EXTEND			# RE-STARTS COME HERE
		DCA	TEMPROLL
		DXCH	ROLL/180
		CA	TEMPBETA
		TS	BETA/180

		RELINT

		TC	INTPRET		# CANT TC DANZIG AFTER PHASCHNG.
CM/POSE3	VLOAD	ABVAL		# RETURN FROM CM/ATUP.  (RESTART)
			VN		# 2(-7)  M/CS
		STORE	VMAGI		# FOR DISPLAY ON CALL.

		GOTO
			POSEXIT		# ENDEXIT, STARTENT, OR SCALEPOP.

CORANGOV	TS	L
		TC	Q
		INDEX	A
## Page 839
		CA	LIMITS
		ADS	L
		TC	Q		# COSTS 2 MCT TO USE. SEE ANGOVCOR.

-KVSCALE	2DEC	-.81491944	# -12800/(2 VS .3048)
TCDU		DEC	.1		# TCDU = .1 SEC.

		EBANK=	AOG
REPOSADR	2CADR	REDOPOSE
