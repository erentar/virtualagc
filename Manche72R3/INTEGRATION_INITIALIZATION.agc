### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	INTEGRATION_INITIALIZATION.agc
## Purpose:	A section of Manche72 revision 3.
##		It is part of the reconstructed source code for the final, flown
##		release of the software for the Command Module's (CM) Apollo
##		Guidance Computer (AGC) for Apollo 13. No original listings
##		of this program are available; instead, this file was recreated
##		from a reconstructed copy of Comanche 072. It has been adapted
##		such that the resulting bugger words exactly match those
##		specified for Manche72 revision 3 in NASA drawing 2021153G,
##		which gives relatively high confidence that the reconstruction
##		is correct.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2024-05-19 MAS	Created from Comanche 072.

# 1.0 INTRODUCTION
# ----------------
#
# FROM A USERS POINT OF VIEW, ORBITAL INTEGRATION IS ESSENTIALLY THE SAME AS THE 278 INTEGRATION
# PROGRAM.  THE SAME ENTRANCES TO THE PROGRAM WILL BE MAINTAINED, THE SAME STALLING ROUTINE WILL BE USED AND
# OUTPUT WILL STILL BE VIA THE PUSHLIST.  THE PRIMARY DIFFERENCES TO A USER INVOLVE THE ADDED CAPABILITY OF
# TERMINATING INTEGRATION AT A SPECIFIC FINAL RADIUS AND THE DIFFERENCE IN STATE VECTOR SCALING INSIDE AND OUT-
# SIDE THE LUNAR SPHERE OF INFLUENCE.
#
# IN ORDER TO MAKE THE CSM(LEM)PREC AND CSM(LEM)CONIC ENTRANCES SIMILAR TO FLIGHT 278, THE INTEGRATION PROGRAM
# WILL ITSELF SET THE FINAL RADIUS (RFINAL) TO 0 SO THAT REACHING THE DESIRED TIME ONLY WILL TERMINATE
# INTEGRATION.  THE DP REGISTER RFINAL MUST BE SET BY USERS OF INTEGRVS AND INTEGRV, AND MUST BE DONE AFTER THE
# CALL TC INTSTALL.
#
# WHEN THE LM IS ON THE LUNAR SURFACE (INDICATED BY LUNAR SURFACE FLAG SET) CALLS TO LEMCONIC, LEMPREC, AND
# INTEGRV WITH VINFLAG = 0 WILL RESULT IN THE USE OF THE PLANETARY INERTIAL ORIENTATION SUBROUTINES TO PROVIDE
# BOTH THE LMS POSITION AND VELOCITY IN THE REFERENCE COORDINATE SYSTEM.
# THE PROGRAM WILL PROVIDE OUTPUT AS IF INTEGRATION WAS USED.  THAT IS, THE PUSHLIST WILL BE SET AS NOTED BELOW AND
# THE PERMANENT STATE VECTOR UPDATED WHEN SPECIFIED BY AN INTEGRV CALL.
#
# USERS OF INTEGRVS DESIRING INTEGRATION (INTYPFLG = 0) SHOULD NOTE THAT THE OBLATENESS PERTURBATION COMPUTATION
# IN LUNAR ORBIT IS TIME DEPENDENT.  THEREFORE, THE USER SHOULD SUPPLY AN INITIAL STATE VECTOR VALID AT SOME REAL
# TIME AND THE DESIRED TIME (TDEC1) ALSO AT SOME REAL TIME.  FOR CONIC ,,INTEGRATION,, THE USER MAY STILL USE ZERO
# AS THE INITIAL TIME AND DELTA TIME AS THE DESIRED TIME.
#
# 2.0 GENERAL DESCRIPTION
# -----------------------
#
# THE INTEGRATION PROGRAM OPERATES AS A CLOSED INTERPRETIVE SUBROUTINE AND PERFORMS THESE FUNCTIONS ---
#	1) INTEGRATES (PRECISION OR CONIC) EITHER CSM OR LM STATE VECTOR
#	2) INTEGRATES THE W-MATRIX
#	3) PERMANENT OR TEMPORARY UPDATE OF THE STATE VECTOR
#
# THERE ARE SIX ENTRANCES TO THE INTEGRATION PROGRAM.  FOUR OF THESE (CSMPREC, LEMPREC, CSMCONIC, LEMCONIC) SET
# ALL THE FLAGS REQUIRED IN THE INTEGRATION PROGRAM ITSELF TO CAUSE THE PRECISION OR CONIC INTEGRATION (KEPLER) OF
# THE LM OR CSM STATE VECTOR, AS THE NAMES SUGGEST.  ONE ENTRANCE (INTEGRVS) PERMITS THE CALLING PROGRAM TO
# PROVIDE A STATE VECTOR TO BE INTEGRATED.  THE CALLING PROGRAM MUST SET THE FLAGS INDICATING (1) PRECISION OR
# CONIC INTEGRATION, (2) IN OR OUT OF LUNAR SPHERE, (3) MIDCOURSE OR NOT, AND THE INTEGRATION PROGRAM COMPLETES
# THE FLAG SETTING TO BYPASS W-MATRIX INTEGRATION.  THE LAST ENTRANCE (INTEGRV, USED IN GENERAL BY THE
# NAVIGATION PROGRAMS) PERMITS THE CALLER TO SET FIVE FLAGS (NOT MOONFLAG OR MIDFLAG) BUT NOT TO INPUT A STATE
# VECTOR.  ANY PROGRAM WHICH CALLS INTEGRVS OR INTEGRV MUST CALL INTSTALL BEFORE IT SETS THE INTEGRATION FLAGS
# AND/OR STATE VECTOR.
#
# THREE SETS OF 42 REGISTERS AND 2 FLAGS ARE USED FOR THE STATE VECTORS.  TWO SETS, WHICH MAY NOT BE OVERLAYED, ARE
# USED FOR THE PERMANENT STATE VECTORS FOR THE CSM AND LM.  THE THIRD SET, WHICH MAY BE OVERLAYED WHEN INTEGRATION
# IS NOT BEING DONE, IS USED IN THE COMPUTATIONS.
#
# THE PERMANENT STATE VECTORS WILL BE PERIODICALLY UPDATED SO THAT THE VECTORS WILL NOT BE OLDER THAN 4 TIMESTEPS.
# THE PERMANENT STATE VECTORS WILL ALSO BE UPDATED WHENEVER THE W-MATRIX IS INTEGRATED OR WHEN A CALLER OF INTEGRV
# SETS STATEFLG (THE NAVIGATION PROGRAMS P20, P22.)
#
# APPENDIX B OF THE USERS GUIDE LISTS THE STATE VECTOR QUANTITIES.
#
# 2.1 RESTARTS
#
# PHASE CHANGES WILL BE MADE IN THE INTEGRATION PROGRAM ONLY FOR THE INTEGRV ENTRANCE (I.E., WHEN THE W-MATRIX IS
# INTEGRATED OR PERMANENT STATE VECTOR IS UPDATED.)  THE GROUP NUMBER USED WILL BE THAT FOR THE P20-25 PROGRAMS
# (I.E., GROUP2) SINCE THE INTEGRV ENTRANCE WILL ONLY BE USED BY THESE PROGRAMS.  IF A RESTART OCCURS DURING AN
# INTEGRATION OF THE STATE VECTOR ONLY, THE RECOVERY WILL BE TO THE LAST PHASE IN THE CALLING PROGRAM.  CALLING
# PROGRAMS WHICH USE THE INTEGRV OR INTEGRVS ENTRANCE OF INTEGRATION SHOULD ENSURE THAT IF PHASE CHANGING IS DONE
# THAT IT IS PRIOR TO SETTING THE INTEGRATION INPUTS IN THE PUSHLIST.
# THIS IS BECAUSE THE PUSHLIST IS LOST DURING A RESTART.
#
# 2.2 SCALING
#
# THE INTEGRATION ROUTINE WILL MAINTAIN THE PERMANENT MEMORY STATE VECTORS IN THE SCALING AND UNITS DEFINED IN
# APPENDIX B OF THE USERS GUIDE.  THE SCALING OF THE OUTPUT POSITION VECTOR DEPENDS ON THE ORIGIN OF THE COORDINATE
# SYSTEM AT THE DESIRED INTEGRATION TIME.  THE COORDINATE SYSTEM TRANSFORMATION WILL BE DONE AUTOMATICALLY ON
# MULTIPLE TIMESTEP ENCKE INTEGRATION ONLY.  THUS IT IS POSSIBLE TO HAVE OUTPUT FROM SUCCESSIVE INTEGRATIONS IN
# DIFFERENT SCALING.
# HOWEVER, RATT, VATT WILL ALWAYS BE SCALED THE SAME.
#
# 3.0 INPUT/OUTPUT
# ----------------
#
# PROGRAM INPUTS ARE THE FLAGS DESCRIBED IN APPENDIX A AND THE PERMANENT STATE VECTOR QUANTITIES DESCRIBED IN AP-
# PENDIX B OF THE USERS GUIDE, PLUS THE DESIRED TIME TO INTEGRATE TO IN TDEC1 (A PUSH LIST LOCATION).
# FOR INTEGRVS, THE RCV,VCV,TET OF THE TEMPORARY STATE VECTOR MUST BE SET, PLUS MOONFLAG AND MIDFLAG
#
# FOR SIMULATION THE FOLLOWING QUANTITIES MUST BE PRESET ---
#										EARTH	MOON
#										 29	 27
#	RRECTCSM(LEM) 	-	RECTIFIED POSITION VECTOR	METERS		2	2
#
#										 7	 5
#	VRECTCSM(LEM)	-	RECTIFIED VELOCITY VECTOR	M/CSEC		2	2
#
#										 28	 28
#	TETCSM(LEM)	-	TIME STATE VECTOR IS VALID	CSEC		2	2
#				CUSTOMARILY 0, BUT NOTE LUNAR
#				ORBIT DEPENDENCE ON REAL TIME.
#
#										 22	 18
#	DELTAVCSM(LEM)	-	POSITION DEVIATION		METERS		2	2
#				0 IF TCCSM(LEM) = 0
#
#										 3	 -1
#	NUVCSM(LEM)	-	VELOCITY DEVIATION		M/CSEC		2	2
#				0 IF TCCSM(LEM) = 0
#										 29	 27
#	RCVCSM(LEM)	-	CONIC POSITION			METERS		2	2
#				EQUALS RRECTCSM(LEM) IF
#				TCCSM(LEM) = 0
#
#										 7	 5
#	VCVCSM(LEM)	-	CONIC VELOCITY			M/CSEC		2	2
#				EQUALS VRECTCSM(LEM) IF
#				TCCSM(LEM) = 0
#
#										 28	 28
#	TCCSM(LEM)	-	TIME SINCE RECTIFICATION	CSECS		2	2
#				CUSTOMARILY 0
#
#								 1/2		 17	 16
#	XKEPCSM(LEM)	-	ROOT OF KEPLERS EQUATION	M		2	2
#				0 IF TCCSM(LEM) = 0
#
#	CMOONFLG	-	PERMANENT FLAGS CORRESPONDING			0	0
#	CMIDFLAG		TO MOONFLAG AND MIDFLAG				0,1	0,1
#	LMOONFLG		C = CSM, L = LM					0	0
#	LMIDFLG									0,1	0,1
#
#	SURFFLAG	-	LUNAR SURFACE FLAG				0,1	0,1
#
# IN ADDITION, IF (L)CMIDFLAG IS SET, THE INITIAL INPUT VALUES FOR LUNAR
# SOLAR EPHEMERIDES SUBROUTINE AND PLANETARY INERTIAL ORIENTATION SUB-
# ROUTINE MUST BE PRESET.
#
# OUTPUT
#	AFTER EVERY CALL TO INTEGRATION
#									EARTH	MOON
#									 29	 29
#	0D	RATT	POSITION			METERS		2	2
#
#									 7	 7
#	6D	VATT	VELOCITY			M/CSEC		2	2
#
#									 28	 28
#	12D	TAT	TIME						2	2
#
#									 29	 27
#	14D	RATT1	POSITION			METERS		2	2
#
#									 7 	 5
#	20D	VATT1	VELOCITY			M/CSEC		2	2
#
#						 	 3   2		 36	 30
#	26D	MU(P)	MU				M /CS		2	2
#
#	X1		MUTABLE ENTRY					-2	-10D
#
#	X2		COORDINT
#	X2		COORDINATE SYSTEM ORIGEN			0	2
#			(THIS, NOT MOONFLAG, SHOULD BE
#			USED TO DETERMINE ORIGIN.)
#
# IN ADDITION TO THE ABOVE, THE PERMANENT STATE VECTOR IS UPDATED WHENEVER
# STATEFLG WAS SET AND WHENEVER A W-MATRIX IS TO BE INTEGRATED.  THE PUSH
# COUNTER IS SET TO 0 AND OVERFLOW IS CLEARED BEFORE RETURNING TO THE
# CALLING PROGRAM.
#
# 4.0 CALLING SEQUENCES AND SAMPLE CODE
# -------------------------------------
#
#	A) PRECISION ORBITAL INTEGRATION.  CSMPREC, LEMPREC ENTRANCES
#		L-X	STORE TIME TO 95T5791T5 T 95 PUS L9ST (T4531)
#		L	CALL
#		L+1		CSMPREC (OR LEMPREC)
#		L+2	RETURN
#	   INPUT							   28
#		TDEC1 (PD 32D) TIME TO INTEGRATE TO...CENTISECONDS SCALED 2
#	   OUTPUT
#		THE DATA LISTED IN SECTION 3.0 PLUS
#		RQVV	POSITION VECTOR OF VEHICLE WITH RESPECT TO SECONDARY
#		BODY... METERS B-29 ONLY IF MIDFLAG = DIMOFLAG = 1
#	B) CONIC INTEGRATION.  CSMCONIC, LEMCONIC ENTRANCES
#		L-X	STORE TIME IN PUSH LIST (TDEC1)
#		L	CALL
#		L+1		CSMCONIC (OR LEMCONIC)
#	   INPUT/OUTPUT
#		SAME AS PRECISION INTEGRATION, EXCEPT RQVV NOT SET
#	C) INTEGRATE GIVEN STATE VECTOR.  INTEGRVS ENTRANCE
#		CALL
#				INTSTALL
#		VLOAD
#				POSITION VECTOR
#		STOVL		RCV
#				VELOCITY VECTOR
#		STODL		VCV
#				TIME STATE VECTOR VALID
#		STODL		TET
#				FINAL RADIUS
#		STORE		RFINAL
#		SET(CLEAR)	SET(CLEAR)
#				INTYPFLAG
#				MOONFLAG
#		SET(CLEAR)	DLOAD
#				DESIRED TIME
#		STCALL		TDEC1
#				INTEGRVS
#	  INPUT
#		RCV	POSITION VECTOR			METERS
#		VCV	VELOCITY VECTOR			M/CSEC
#		TET	TIME OF STATE VECTOR (MAY = 0)	CSEC B-28
#		TDEC1	TIME TO INTEGRATE TO		CSEC B-28 (PD 32D)
#			(MAY BE INCREMENT IF TET=0)
#	  OUTPUT
#		SAME AS FOR PRECISION OR CONIC INTEGRATION,
#		DEPENDING ON INTYPFLG.
#	D) INTEGRATE STATE VECTOR.  INTGRV ENTRANCE
#		L-X	STORE TIME IN PUSH LIST (TDEC1) (MAY BE DONE AFTER CALL TO INTSTALL)
#		L-8	CALL
#		L-7
#		L-6	SET(CLEAR)	SET(CLEAR)
#		L-5			VINTFLAG	1=CSM, 0=LM
#		L-4			INTYPFLAG	1=CONIC, 0=PRECISION
#		L-3	SET(CLEAR)	SET(CLEAR)
#		L-2			DIMOFLAG	1=W-MATRIX, 0=NO W-MATRIX
#		L-1			D6OR9FLG	1=9X9, 0=6X6
#		L	SET		DLOAD
#		L+1			STATEFLG	DESIRE PERMANENT UPDATE
#		L+2			FINAL RAD.	OF STATE VECTOR
#		L+3	STCALL		RFINAL
#		L+4			INTEGRV
#		L	CALL				NORMAL USE -- WILL UPDATE STATE
#		L+1			INTEGRV		VECTOR IF DIMOFLAG=1. (STATEFLG IS
#		L+2	RETURN				ALWAYS RESET IN INTEGRATION AFTER
#							IT IS USED.)
#	  INPUT
#		TDEC1 (PD 32D) TIME TO INTEGRATE TO 	CSEC B-28
#	  OUTPUT
#		SAME AS FOR PRECISION OR CONIC INTEGRATION
#	  THE PROGRAM WILL SET MOONFLAG, MIDFLAG DEPENDING ON
#	  THE PERMANENT STATE VECTOR REPRESENTATION.

		BANK	11
		SETLOC	INTINIT
		BANK
		EBANK=	RRECTCSM
		COUNT	13/INTIN
		
STATEINT	TC	PHASCHNG
		OCT	00052
		CAF	PRIO5
		TC	FINDVAC
		EBANK=	RRECTCSM
		2CADR	STATINT1

		TC	TASKOVER
STATINT1	TC	INTPRET
		BON	RTB
			QUITFLAG
			NOINT		# NO STATEINT IF V96
			LOADTIME
		STORE	TDEC1
		CLEAR	CALL
			V96ONFLG
			INTSTALL
		SET	CALL
			NODOFLAG
			SETIFLGS
## <b>Reconstruction:</b> The setting of POOFLAG here was added as part
## of the fix for anomaly COM-21, "Backwards integration can occur in
## P27 uplink".
		SET	GOTO		# INHIBIT BACKWARDS INTEGRATION
			POOFLAG
			STATEUP
600SECS		2DEC	60000

ENDINT		CLEAR	EXIT
			STATEFLG
		TC	PHASCHNG
		OCT	20032
		EXTEND
		DCA	600SECS
		TC	LONGCALL
		EBANK=	RRECTHIS
		2CADR	STATEINT

		TC	ENDOFJOB
SETIFLGS	SET	CLEAR
			STATEFLG
			INTYPFLG
		CLEAR	CLEAR
			DIM0FLAG
			D6OR9FLG
		RVQ
NOINT		EXIT
		TC	PHASCHNG
		OCT	2

		TC	DOWNFLAG
		ADRES	QUITFLAG
		
		TC	ENDOFJOB

# ATOPCSM TRANSFERS RRECT TO RRECT +41 TO RRECTCSM TO RRECTCSM +41
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		ATOPCSM
#
# NORMAL EXIT AT L+2

ATOPCSM		STQ	RTB
			S2
			MOVEACSM
		SET	CALL
			CMOONFLG
			SVDWN1
		BON	CLRGO
			MOONFLAG
			S2
			CMOONFLG
			S2
MOVEACSM	TC	SETBANK
		TS	DIFEQCNT	# INITIALIZE INDEX
		INDEX	DIFEQCNT
		CA	RRECT
		INDEX	DIFEQCNT
		TS	RRECTCSM
		CCS	DIFEQCNT	# IS TRANSFER COMPLETE
		TCF	MOVEACSM +1	# NO-LOOP
		TC	DANZIG		# COMPLETE - RETURN

# PTOACSM TRANSFERS RRECTCSM TO RRECTCSM +41 TO RRECT TO RRECT +41
#
# CALLING SEQUENCE
#	L	CALL
#			PTOACSM
#
# NORMAL EXIT AT L+2

PTOACSM		RTB	BON
			MOVEPCSM
			CMOONFLG
			SETMOON
CLRMOON		CLEAR	SSP
			MOONFLAG
			PBODY
			0
		RVQ
SETMOON		SET	SSP
			MOONFLAG
			PBODY
			2
		RVQ
MOVEPCSM	TC	SETBANK
		TS	DIFEQCNT
		INDEX	DIFEQCNT
		CA	RRECTCSM
		INDEX	DIFEQCNT
		TS	RRECT
		CCS	DIFEQCNT
		TCF	MOVEPCSM +1
		TC	DANZIG

# ATOPLEM TRANSFERS RRECT TO RRECT +41 TO RRECTLEM TO RRECTLEM +41
ATOPLEM		STQ	RTB
			S2
			MOVEALEM
		SET	CALL
			LMOONFLG
			SVDWN2
		BON	CLRGO
			MOONFLAG
			S2
			LMOONFLG
			S2
MOVEALEM	TC	SETBANK
		TS	DIFEQCNT
		INDEX	DIFEQCNT
		CA	RRECT
		INDEX	DIFEQCNT
		TS	RRECTLEM
		CCS	DIFEQCNT
		TCF	MOVEALEM +1
		TC	DANZIG

# PTOALEM TRANSFERS RRECTLEM TO RRECTLEM +41 TO RRECT TO RRECT +41

PTOALEM		BON	RTB
			SURFFLAG
			USEPIOS
			MOVEPLEM
		BON	GOTO
			LMOONFLG
			SETMOON
			CLRMOON
MOVEPLEM	TC	SETBANK
		TS	DIFEQCNT
		INDEX	DIFEQCNT
		CA	RRECTLEM
		INDEX	DIFEQCNT
		TS	RRECT
		CCS	DIFEQCNT
		TCF	MOVEPLEM +1
		TC	DANZIG

USEPIOS		SETPD	VLOAD
			0
			RLS
		PDDL	PUSH
			TDEC1
		STODL	TET
			5/8
		CALL
			RP-TO-R
		STOVL	RCV
			ZUNIT
		STODL	0D
			TET
		STODL	6D
			5/8
		SET	CALL		# NEEDED FOR SETTING X1 ON EXIT
			MOONFLAG
			RP-TO-R
		VXV	VXSC
			RCV
			OMEGMOON
		STOVL	VCV
			ZEROVEC
		STORE	TDELTAV
		AXT,2	SXA,2
			2
			PBODY
		STCALL	TNUV
			A-PCHK
OMEGMOON	2DEC*	2.66169947 E-8 B+23*
			
SETBANK		CAF	INTBANK
		TS	BBANK
		CAF	FORTYONE
		TC	Q
		EBANK=	RRECTCSM
INTBANK		BBCON	INTEGRV

# SPECIAL PURPOSE ENTRIES TO ORBITAL INTEGRATION.  THESE ROUTINES PROVIDE ENTRANCES TO INTEGRATION WITH
# APPROPRIATE SWITCHES SET OR CLEARED FOR THE DESIRED INTEGRATION.
#
# CSMPREC AND LEMPREC PERFORM ORBIT INTEGRATION BY THE ENCKE METHOD TO THE TIME INDICATED IN TDEC1
# ACCELERATIONS DUE TO OBLATENESS ARE INCLUDED.  NO W-MATRIX INT. IS DONE.
# THE PERMANENT STATE VECTOR IS NOT UPDATED.
# CSMCONIC AND LEMCONIC PERFORM ORBIT INTEG. BY KEPLERS METHOD TO THE TIME INDICATED IN TDEC1
# NO DISTURBING ACCELERATIONS ARE INCLUDED.  IN THE PROGRAM FLOW THE GIVEN
# STATE VECTOR IS RECTIFIED BEFORE SOLUTION OF KEPLERS EQUATION
#
# THE ROUTINES ASSUME THAT THE CSM (LEM) STATE VECTOR IN P-MEM IS VALID.
# SWITCHES SET PRIOR TO ENTRY TO THE MAIN INTEG. PROG ARE AS FOLLOWS
#			CSMPREC		CSMCONIC	LEMPREC		LEMCONIC
#	VINTFLAG	SET		SET		CLEAR		CLEAR
#	INTYPFLG	CLEAR		SET		CLEAR		SET
#	DIM0FLAG	CLEAR		CLEAR		CLEAR		CLEAR
#
# CALLING SEQUENCE
#	L-X	STORE	TDEC1
#	L	CALL			(STCALL TDEC1)
#	L+1		CSMPREC		(CSMCONIC, LEMPREC, LEMCONIC)
#
# NORMAL EXIT TO L+2
#
# SUBROUTINES CALLED
#	INTEGRV1
#	PRECOUT FOR CSMPREC AND LEMPREC
#	CONICOUT FOR CSMCONIC AND LEMCONIC
#
# OUTPUT - SEE PAGE 2 OF THIS LOG SECTION
#
# INPUT
#	TDEC1		TIME TO INTEGRATE TO.  CSECS B-28

CSMPREC		STQ	CALL
			X1
			INTSTALL
		SXA,1	SET
			IRETURN
			VINTFLAG

IFLAGP		SET	CLEAR
			PRECIFLG
			DIM0FLAG
		CLRGO
			INTYPFLG
			INTEGRV1
LEMPREC		STQ	CALL
			X1
			INTSTALL
		SXA,1	CLRGO
			IRETURN
			VINTFLAG
			IFLAGP

CSMCONIC	STQ	CALL
			X1
			INTSTALL
		SXA,1	SET
			IRETURN
			VINTFLAG
IFLAGC		CLEAR	SETGO
			DIM0FLAG
			INTYPFLG
			INTEGRV1
LEMCONIC	STQ	CALL
			X1
			INTSTALL
		SXA,1	CLRGO
			IRETURN
			VINTFLAG
			IFLAGC

INTEGRVS	SET	SSP
			PRECIFLG
			PBODY
			0
		BOF	SSP
			MOONFLAG
			+3
			PBODY
			2
		STQ	VLOAD
			IRETURN
			ZEROVEC
		STORE	TDELTAV
		STCALL	TNUV
			RECTIFY
		CLEAR	SET
			DIM0FLAG
			NEWIFLG
		SETGO
			RPQFLAG
			ALOADED

# INTEGRV IS AN ENTRY TO ORBIT INTEGRATION WHICH PERMITS THE CALLER,
# NORMALLY THE NAVIGATION PROGRAM, TO SET THE INTEG. FLAGS.  THE ROUTINE
# IS ENTERED AT INTEGRV1 BY CSMPREC ET. AL. AND AT ALOADED BY INTEGRVS.
# THE ROUTINE SETS UP A-MEMORY IF ENTERED AT INTEGRV,1 AND SETS THE INTEG.
# PROGRAM FOR PRECISION OR CONIC
#
# THE CALLER MUST FIRST CALL INTSTALL TO CHECK IF INTEG. IS IN USE BEFORE
# SETTING ANY FLAGS.
#
# THE FLAGS WHICH SHOULD BE SET OR CLEARED ARE
#	VINTFLAG	(IGNORED WHEN ENTERED FROM INTEGRVS)
#	INTYPFLG
#	DIM0FLAG
#	D6OR9FLG
#
# CALLING SEQUENCE
#	L-X	CALL
#	L-Y		INTSTALL
#	L-1	SET OR CLEAR ALL FOUR FLAGS.  ALSO CAN SET STATEFLG IF DESIRED
#		AND DIM0FLAG IS CLEAR.
#	L	CALL
#	L+1		INTEGRV
#
# INITIALIZATION
#	FLAGS AS ABOVE
#	STORE TIME TO INTEGRATE TO IN TDEC1
#
# OUTPUT
#	RATT	AS
#	VATT	      DEFINED
#	TAT			BEFORE

INTEGRV		STQ
			IRETURN
INTEGRV1	SET	SET
			RPQFLAG
			NEWIFLG
INTEGRV2	SSP
			QPRET
			ALOADED
		BON	GOTO
			VINTFLAG
			PTOACSM
			PTOALEM
		SETLOC	INTINIT1
		BANK
ALOADED		DLOAD
			TDEC1
		STORE	TDEC
		BOFF	GOTO
			INTYPFLG
			TESTLOOP
			RVCON
		SETLOC	INTINIT
		BANK
A-PCHK		BOF	CALL
			MIDFLAG
			ANDOUT		# DONT MAKE ORIGIN CHANGE CHECK
			CHKSWTCH
		BPL	CALL
			ANDOUT		# NO ORIGIN CHANGE
			ORIGCHNG	# MAKE THE SWITCH
ANDOUT		BOFCLR	EXIT
			STATEFLG
			RECTOUT
		TC	PHASCHNG
		OCT	04022
		TC	UPFLAG		# PHASE CHANGE HAS OCCURRED BETWEEN
		ADRES	REINTFLG	# INTSTALL AND INTWAKE
		TC	INTPRET
		SSP
			QPRET
			PHEXIT
		BON	GOTO
			VINTFLAG
			ATOPCSM
			ATOPLEM
PHEXIT		CALL
			GRP2PC
RECTOUT		SETPD	CALL
			0
			RECTIFY
		VLOAD	VSL*
			RRECT
			0,2
		PDVL	VSL*		# RATT TO PD0
			VRECT
			0,2
		PDDL	PDVL		# VATT TO PD6	TAT TO PD12
			TET
			RRECT
		PDVL	PDDL*
			VRECT
			MUEARTH,2
		PUSH	AXT,1
		DEC	-10
		BON	AXT,1
			MOONFLAG
			+2
		DEC	-2
INTEXIT		SETPD	BOV
			0
			+1
		CLEAR
			MIDAVFLG
		CLEAR	CLEAR
			AVEMIDSW	# ALLOW UPDATE OF DOWNLINK STATE VECTOR
			PRECIFLG
		SLOAD	EXIT
			IRETURN
		CA	MPAC
		INDEX	FIXLOC
		TS	QPRET
		TC	INTWAKE

# RVCON SETS UP ORBIT INTEGRATION TO DO A CONIC SOLUTION FOR POSITION AND
# VELOCITY FOR THE INTERVAL (TET-TDEC)

RVCON		DLOAD	DSU
			TDEC
			TET
		STCALL	TAU.
			RECTIFY
		CALL
			KEPPREP
		DLOAD	DAD
			TC
			TET
		STCALL	TET
			RECTOUT

# TESTLOOP

TESTLOOP	BOF	CLRGO
			QUITFLAG
			+3
			STATEFLG
			INTEXIT		# STOP INTEGRATION
 +3		SETPD	LXA,2
			10D
			PBODY
		VLOAD	ABVAL
			RCV
		PUSH	CLEAR		# RC TO 10D
			MIDFLAG
		DSU*	BMN		# MIDFLAG=0 IF R G.T. RMP
			RME,2
			+3
		SET
			MIDFLAG
NORFINAL	DLOAD	DMP
			10D
			34D
		SR1R	DDV*
			MUEARTH,2
		SQRT	DMP
			.3D
		SR3	SR4		# DT IS TRUNCATED TO A MULTIPLE
		DLOAD	SL
			MPAC
			15D		#	OF 128 CSECS.
		PUSH	BOV
			MAXDT
		BDSU	BMN
			DT/2MAX
			MAXDT
DT/2COMP	DLOAD	DSU
			TDEC
			TET
		RTB	SL
			SGNAGREE
			8D
		STORE	DT/2		# B-19
		BOV	ABS
			GETMAXDT
		DSU	BMN		# IS TIME TO INTEG. TO GR THAN MAXTIME
			12D
			P00HCHK
USEMAXDT	DLOAD	SIGN
			12D
			DT/2
		STCALL	DT/2
			P00HCHK
MAXDT		DLOAD	PDDL		# EXCHANGE DT/2MAX WITH COMPUTED MAX.
			DT/2MAX
		GOTO
			DT/2COMP
GETMAXDT	RTB
			SIGNMPAC
		STCALL	DT/2
			USEMAXDT
P00HCHK		DLOAD	ABS
			DT/2
		DSU	BMN
			DT/2MIN
			A-PCHK
## <b>Reconstruction:</b> Comanche 67 and earlier examine MODREG
## here instead of checking POOFLAG. The change was made as part
## of the fix for anomaly COM-21, "Backwards integration can occur in
## P27 uplink".
		BOFF	BON
			POOFLAG		# IS BACKWARDS INTEGRATION INHIBITED
			TIMESTEP	# NO
			PRECIFLG	# WAS THIS CALL VIA CSM(LEM)PREC
			TIMESTEP	# YES
		DLOAD	DSU
			DT/2
			12D
		BMN	BOFCLR
			A-PCHK
			NEWIFLG
			TIMESTEP
		DLOAD	DSU
			TDEC
			TET
		BMN			# NO BACKWARD INTEGRATION
			INTEXIT
		PDDL	SR4
			DT/2		# IS 4(DT) LS (TDEC - TET)
		SR2R	BDSU		# NO
		BMN	GOTO
			INTEXIT
			TIMESTEP
DT/2MIN		2DEC	3 B-20

DT/2MAX		2DEC	4000 E2 B-20

INTSTALL	EXIT
		CAF	ZERO
ALLSTALL	TS	L
		CA	RASFLAG
		INDEX	L
		MASK	INTBITAB	# IS THIS STALL AREA FREE
		EXTEND
		BZF	OKTOGRAB	# YES
		INDEX	L
		CAF	WAKESTAL
		TC	JOBSLEEP
INTWAKE0	EXIT
		TCF	INTWAKE1

INTWAKE		CS	RASFLAG		# IS THIS INTSTALLED ROUTINE TO BE
		MASK	REINTBIT	#	RESTARTED
		CCS	A
		TC	INTWAKE1	# NO

		INDEX	FIXLOC
		CA	QPRET
		TS	TBASE2		# YES, DONT RESTART WITH SOMEONE ELSES Q

		TC	PHASCHNG
		OCT	04022

		CA	TBASE2
		INDEX	FIXLOC
		TS	QPRET

		CAF	REINTBIT
		MASK	RASFLAG
		EXTEND
		BZF	GOBAC		# DONT INTWAKE IF WE CAME HERE VIA RESTART

INTWAKE1	CAF	ZERO
WAKE		TS	STALTEM		# INDEX OF ANY STALL USER
WAKE1		INDEX	STALTEM
		CAF	WAKESTAL
		INHINT
		TC	JOBWAKE
		CCS	LOCCTR
		TCF	WAKE1		# MAY BE MORE TO WAKE UP
FORTYONE	DEC	41
		INDEX	STALTEM
		CS	INTBITAB
		MASK	RASFLAG
		TS	RASFLAG		# RELEASE STALL AREA
		RELINT
		TCF	GOBAC
OKTOGRAB	INDEX	L		# NO, WAIT UNTIL AVAILABLE
		CAF	INTFLBIT
		ADS	RASFLAG
GOBAC		TC	INTPRET
		RVQ
ERASTAL1	EXIT
		CAF	ONE
		TCF	ALLSTALL
ERASTAL2	EXIT
		CAF	TWO
		TCF	ALLSTALL
ERASWAK1	CAF	ONE
		TCF	WAKE
ERASWAK2	CAF	TWO
		TCF	WAKE
WAKESTAL	CADR	INTSTALL +1
		CADR	ERASTAL1 +1
		CADR	ERASTAL2 +1
STALTEM		EQUALS	MPAC
INTBITAB	OCT	20100
		OCT	10040
		OCT	04020

# AVETOMID
#
# THIS ROUTINE PERFORMS THE TRANSITION FROM A THRUSTING PHASE TO THE COAST
# PHASE BY INITIALIZING THIS VEHICLES PERMANENT STATE VECTOR WITH THE
# VALUES LEFT BY THE AVERAGEG ROUTINE IN RN,VN,PIPTIME.
#
# BEFORE THIS IS DONE THE W-MATRIX, IF ITS VALID (ORWFLAG OR RENDWFLG IS
# SET) IS INTEGRATED FORWARD TO PIPTIME WITH THE PRE-THRUST STATE VECTOR.
#
# IN ADDITION, THE OTHER VEHICLE IS INTEGRATED (PERMANENT) TO PIPTIME.
#
# FINALLY TRKMKCNT IS ZEROED

		SETLOC	INTINIT2
		BANK

		COUNT*	$$/INTIN
AVETOMID	STQ	BON
			EGRESS
			RENDWFLG
			INT/W		# W-MATRIX VALID, GO INTEGRATE IT
		BON
			ORBWFLAG
			INT/W		# W-MATRIX VALID, GO INTEGRATE IT

SETCOAST	AXT,2	CALL		# NOW MOVE PROPERLY SCALED RN,VN AND
			2		# PIPTIME TO INTEGRATION ERASABLES.
			INTSTALL
		BON	AXT,2
			AMOONFLG
			+2
			0
		VLOAD	VSR*
			RN
			0,2
		STORE	RRECT
		STODL	RCV
			PIPTIME
		STOVL	TET
			VN
		VSR*	CALL
			0,2
			MINIRECT	# FINISH SETTING UP STATE VECTOR
		RTB	SSP
			MOVATHIS	# PUT TEMP STATE VECTOR INTO PERMANENT
			TRKMKCNT
			0
		SET	BON
			CMOONFLG
			AMOONFLG
			+3
		CLEAR
			CMOONFLG
		
		BON	DLOAD		# NOW DO LM
			SURFFLAG
			FAZAB5		# NO COASTING LM
			PIPTIME
		STCALL	TDEC1
			SETIFLGS
		CLEAR	CALL
			VINTFLAG
			INTEGRV
		GOTO
			EGRESS
INT/W		DLOAD	CALL
			PIPTIME		# INTEGRATE W THRU BURN
			INTSTALL
		SET	SET
			DIM0FLAG	# DO W-MATRIX
			AVEMIDSW	# SO WONT CLOBBER RN,VN,PIPTIME
		CLEAR	SET
			D6OR9FLG
			VINTFLAG
		STCALL	TDEC1
			INTEGRV
		GOTO
			SETCOAST

# MIDTOAV1
#
# THIS ROUTINE INTEGRATES (PRECISION) TO THE TIME SPECIFIED IN TDEC1.
# IF, AT THE END OF AN INTEGRATION TIME STEP, CURRENT TIME PLUS A DELTA
# TIME (SEE TIMEDELT.....BASED ON THE COMPUTATUON TIME FOR ONE TIME STEP)
# IS GREATER THAN THE DESIRED TIME, ALARM 1703 IS SET AND THE INTEGRATION
# IS DONE AS IT IS FOR MIDTOAV2.
# RETURN IS IN BASIC TO THE RETURN ADDRESS PLUS ONE.
#
# IF THE INTEGRATION IS FINISHED TO THE DESIRED TIME, RETURN IS IN BASIC
# TO THE RETURN ADDRESS
#
# IN EITHER CASE, BEFORE RETURNING, THE EXTRAPOLATED STATE VECTOR IS TRAN
# FERRED FROM R,VATT TO R,VN1-PIPTIME1 IS SET TO THE FINISHING INTEGRA-
# TION TIME AND MPAC IS SET TO THE DELTA TIME---
#			            TAT MINUS CURRENT TIME.

# MIDTOAV2
#
# THIS ROUTINE INTEGRATES THE CSM STATE VECTOR TO CURRENT TIME PLUS
# INCREMENTS OF TIMEDELT SUCH THAT THE DIFFERENCE BETWEEN CURRENT TIME
# AND THE STATE VECTOR TIME AT THE END OF THE LAST STEP IS AT LEAST 5.6
# SECS.
# NO INPUTS ARE REQUIRED OF THE CALLER.  RETURN IS IN BASIC TO THE RETURN
# ADDRESS WITH THE ABOVE TRANSFERS TO R,VN1-PIPTIME1-AND MPAC DONE

		SETLOC	INTINIT
		BANK
		EBANK=	IRETURN1
MIDTOAV2	STQ	CALL
			IRETURN1
			INTSTALL
		DLOAD	CLEAR
			TIMEDELT
			MID1FLAG
		STCALL	T-TO-ADD
			ENTMID2

MIDTOAV1	STQ	CALL
			IRETURN1
			INTSTALL
		SET	RTB
			MID1FLAG
			LOADTIME
		DAD	BDSU		# INITIAL CHECK, IS TDEC1 IN THE FUTURE.
			TIMEDELT
			TDEC1
		BPL	CALL
			ENTMID1
			NOTIME		# NO SET ALARM.SWITCH TO MIDTOAV2

ENTMID2		RTB	DAD
			LOADTIME
			T-TO-ADD
		STORE	TDEC1

ENTMID1		CLEAR	CALL
			DIM0FLAG	# NO W-MATRIX
			THISVINT
		CLEAR	SET
			INTYPFLG
			MIDAVFLG	# LET INTEG. KNOW THE CALL IS FOR MIDTOAV.
		CALL
			INTEGRV		# GO INTEGRATE
		SXA,2	SXA,1
			RTX2
			RTX1
		CLEAR	SLOAD
			AMOONFLG
			RTX2
		BZE	SET
			+2
			AMOONFLG
		VLOAD	
			RATT
		STOVL	RN1
			VATT
		STODL	VN1
			TAT
		STORE	PIPTIME1
		EXIT

		INHINT
		EXTEND
		DCS	TIME2
		DAS	MPAC
		TC	TPAGREE

		CA	IRETURN1
		TC	BANKJUMP
CKMID2		BOF	RTB
			MID1FLAG
			MID2
			LOADTIME
		DAD	BDSU
			TIMEDELT
			TDEC
		BPL	CALL
			TESTLOOP	# YES
			NOTIME

TIMEINC		RTB	DAD
			LOADTIME
			T-TO-ADD
		STCALL	TDEC
			TESTLOOP

MID2		DLOAD	DSU
			TDEC
			TET
		ABS	DSU
			3CSECS
		BPL
			TIMEINC
			
		RTB	BDSU		# SEE IF 5.6 SECS. AVAILABLE TO CALLER.
			LOADTIME
			TET
		DSU	BPL
			5.6SECS
			A-PCHK		# YES,GET OUT.
			
		DLOAD	DAD		# NO,ADD TIMEDELT TO T-TO-ADD AND TRY
			T-TO-ADD	# AGAIN.
			TIMEDELT
		STCALL	T-TO-ADD
			TIMEINC
NOTIME		CLEAR	EXIT		# TOO LATE
			MID1FLAG
		INCR	IRETURN1	# SET ERROR EXIT (CALLOC +2)
		TC	ALARM		# INSUFFICIENT TIME FOR INTEGRATION --
		OCT	1703		#	TIG WILL BE SLIPPED...
		TC	INTPRET
		DLOAD
			TIMEDELT
		STORE	T-TO-ADD
		RVQ

3CSECS		2DEC	3

TIMEDELT	2DEC	1250

5.6SECS		2DEC	560

		BANK	27
		SETLOC	UPDATE2
		BANK
		EBANK=	INTWAKUQ

		COUNT*	$$/INTIN

INTWAKUQ	=	INTWAK1Q	# TEMPORARY UNTIL NAME OF INTWAK1Q IS CHNG

INTWAKEU	RELINT
		EXTEND
		QXCH	INTWAKUQ	# SAVE Q FOR RETURN

		TC	INTPRET

		SLOAD	BZE		# IS THIS A CSM/LEM STATE VECTOR UPDATE
			UPSVFLAG	# REQUEST.  IF NOT GO TO INTWAKUP.
			INTWAKUP

		VLOAD			# MOVE RRECT(6) AND VRECT(6) INTO
			RRECT		#	RCV(6) AND VCV(6) RESPECTIVELY.
		STOVL	RCV
			VRECT		# NOW GO TO 'RECTIFY +13D' TO
		CALL			# STORE VRECT INTO VCV AND ZERO OUT
			RECTIFY +13D	# TDELTAV(6),TNUV(6),TC(2) AND XKEP(2)
		SLOAD	ABS		# COMPARE ABSOLUTE VALUE OF 'UPSVFLAG'
			UPSVFLAG	# TO 'UPDATE MOON STATE VECTOR CODE'
		DSU	BZE		# TO DETERMINE WHETHER THE STATE VECTOR TO
			UPMNSVCD	# BE UPDATED IS IN THE EARTH OR LUNAR
			INTWAKEM	# SPHERE OF INFLUENCE.........
		AXT,2	CLRGO		# EARTH SPHERE OF INFLUENCE.
		DEC	0
			MOONFLAG
			INTWAKEC
INTWAKEM	AXT,2	SET		# LUNAR SPHERE OF INFLUENCE.
		DEC	2
			MOONFLAG
INTWAKEC	SLOAD	BMN		# COMMON CODING AFTER X2 INITIALIZED AND
					# MOONFLAG SET (OR CLEARED).
			UPSVFLAG	# IS THIS A REQUEST FOR A LEM OR CSM
			INTWAKLM	# 	STATE VECTOR UPDATE......
		CALL			# UPDATE CSM STATE VECTOR
			ATOPCSM

		CLEAR	GOTO
			ORBWFLAG
			INTWAKEX

INTWAKLM	CALL			# UPDATE LM STATE VECTOR
			ATOPLEM

INTWAKEX	CLEAR
			RENDWFLG

INTWAKUP	SSP	CALL		# REMOVE :UPDATE STATE VECTOR INDICATOR:
			UPSVFLAG
			0
			INTWAKE0	# RELEASE :GRAB: OF ORBIT INTEG
		EXIT

		TC	PHASCHNG
		OCT	04026
		TC	INTWAKUQ

UPMNSVCD	OCT	2
		OCT	0

GRP2PC		STQ	EXIT
			GRP2SVQ
		TC	PHASCHNG
		OCT	04022
		TC	INTPRET
		GOTO
			GRP2SVQ



