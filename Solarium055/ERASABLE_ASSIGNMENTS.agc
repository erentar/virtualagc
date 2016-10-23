### FILE="Main.annotation"
# Copyright:	Public domain.
# Filename:	ASSEMBLY_AND_OPERATION_INFORMATION.agc
# Purpose:	Part of the source code for Solarium build 55. This
#		is for the Command Module's (CM) Apollo Guidance
#		Computer (AGC), for Apollo 6.
# Assembler:	yaYUL --block1
# Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
# Website:	www.ibiblio.org/apollo/index.html
# Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
# Mod history:	2009-09-11 JL	Created.

## Page 12

# COUNTER AND SPECIAL REGISTERS TAGS
# ------- --- ------- --------- ----

A		EQUALS	0
Q		EQUALS	1
Z		EQUALS	2
LP		EQUALS	3
IN0		EQUALS	4
IN1		EQUALS	5
IN2		EQUALS	6
IN3		EQUALS	7
OUT0		EQUALS	10
OUT1		EQUALS	11
OUT2		EQUALS	12
OUT4		EQUALS	14
BANKREG		EQUALS	15
RELINT		EQUALS	16
INHINT		EQUALS	17
CYR		EQUALS	20
SR		EQUALS	21
CYL		EQUALS	22
SL		EQUALS	23
ZRUPT		EQUALS	24
BRUPT		EQUALS	25
ARUPT		EQUALS	26
QRUPT		EQUALS	27

BANKRUPT	EQUALS	30
OVRUPT		EQUALS	31
LPRUPT		EQUALS	32
DSRUPTSW	EQUALS	33		# T4RUPT PHASE COUNT GOES 7(-1)0

OVCTR		EQUALS	34
TIME2		EQUALS	35
TIME1		EQUALS	36
TIME3		EQUALS	37
TIME4		EQUALS	40
UPLINK		EQUALS	41
OUTCR1		EQUALS	42
OUTCR2		EQUALS	43
PIPAX		EQUALS	44
PIPAY		EQUALS	45
PIPAZ		EQUALS	46
CDUX		EQUALS	47
CDUY		EQUALS	50
CDUZ		EQUALS	51
OPTX		EQUALS	52
OPTY		EQUALS	53
## Page 13
VAC		EQUALS	32D		# RELATIVE TO FIXLOC
VACX		EQUALS	VAC
VACY		EQUALS	VAC + 2
VACZ		EQUALS	VAC + 4
X1		EQUALS	38D		# INDEXES ARE RELATIVE TO FIXLOC
X2		EQUALS	39D
S1		EQUALS	40D		# AND SO ARE STEP REGISTERS
S2		EQUALS	41D
QPRET		EQUALS	42D		# AS IS QPRET

## Page 14
		SETLOC	60

#	THE FOLLOWING REGISTERS ARE USED BY THE INTERPRETER, AND MAY BE USED BY A BASIC JOB OR BASIC
# PORTIONS OF AN INTERPRETIVE JOB (SOME RESTRICTIONS APPEAR WITH RTB FOLLOWED BY TC DANZIG, BUT THE NINE REGISTERS
# VBUF AND BUF ARE AVAILABLE THEN). THE REGISTERS ARE NOT SAVED IN THEIR ENTIRETY DURING CHANGE JOB (MOST OF THEM
# ARE IGNORED), SO THAT THESE MUST BE USED ONLY AS TEMPORARIES BETWEEN CCS NEWJOBS.

NNADTEM		EQUALS	54		# TEMP FOR NOUN ADDRESS TABLE ENTRY.
NNTYPTEM	EQUALS	55		# TEMP FOR NOUN TYPE TABLE ENTRY.
IDAD1TEM	EQUALS	56		# TEMP FOR INDIR ADRES TABLE ENTRY(MIXNN)
					# MUST = IDAD2TEM-1, = IDAD3TEM-2.
IDAD2TEM	EQUALS	57		# TEMP FOR INDIR ADRES TABLE ENTRY(MIXNN)
					# MUST = IDAD1TEM+1, = IDAD3TEM-1.
IDAD3TEM	ERASE			# TEMP FOR INDIR ADRES TABLE ENTRY(MIXNN)
					# MUST = IDAD1TEM+2, = IDAD2TEM+1.



BANKSET		ERASE			# STORGAE FOR BANK BITS OF OBJECT PROGRAM
ADDRWD		ERASE			# THIS WILL CONTAIN A PROPER 12 BIT ADDR
ORDER		ERASE			# STORAGE FOR RIGHT-HAND OPERATORS
UPDATRET	=	ORDER		# RETURN FOR UPDATNN, UPDATVB
CHAR		=	ORDER		# TEMP FOR CHARIN
ERCNT		=	ORDER		# COUNTER FOR ERROR LIGHT RESET
DECOUNT		=	ORDER		# COUNTER FOR SCALING AND DISPLAY (DEC)
TEM11		ERASE
SGNON		=	TEM11		# TEMP FOR +,- ON
NOUNTEM		=	TEM11		# COUNTER FOR MIXNOUN FETCH
DISTEM		=	TEM11		# COUNTER FOR OCTAL DISPLAY VERBS
DECTEM		=	TEM11		# COUNTER FOR FETCH (DEC DISPLAY VERBS)
DECTEM1		=	TEM11		# TEMP FOR NUM
MODE		ERASE			# DENOTES VECTOR, DP, OR TP.
ENTRET		=	MODE		# EXIT FROM ENTER
LOADIND		ERASE			# LOAD INDICATOR
NEWEQIND	EQUALS	LOADIND
MONTEM		=	NEWEQIND	# TEMP RETURN FOR MONITOR
FIXLOC		ERASE			# ADDRESS OF CURRENT VAC AREA
VACLOC		ERASE			# ADDRESS OF CURRENT VAC (= FIXLOC+32D)
VBUF		ERASE	+5		# 6 WORD TEMPORARY BLOCK FOR VXV, MXV, ETC
TEMQS		EQUALS	VBUF		# TEMP STORAGE FOR SWCALL ROUTINE
BANKTEM		EQUALS	VBUF +1		# LIKEWISE
B		EQUALS	VBUF +2		# ARGUMENT STORAGE IN FUNCTIONS
PROGREG		=	VBUF +2		# FOR GO EXEC PROGRAM
MIXTEMP		=	VBUF +2		# FOR MIXNOUN DATA
SIGNRET		=	VBUF +2		# RETURN FOR +,- ON
# ALSO PROGREG+1, PROGREG+2.  MIXTEMP+1, MIXTEMP+2.
ESCAPE2		EQUALS	VBUF +4		# NEGATIVE ARGUMENT SWITCH IN ARCCOS
TAG1		EQUALS	VBUF +4		# USED FOR PICKING UP INDEX AND STEP REGS
TEMQ3		EQUALS	VBUF +5		# RETURN FROM DDV AND SQRTDIV
POLISH		EQUALS	VBUF +5		# TEMPORARY STORAGE FOR COMPLETE ADDRESSES
## Page 15
WDCNT		=	VBUF +5		# CHAR COUNTER FOR DSPWD
INREL		=	VBUF +5		# INPUT BUFFER SELECTIOR ( X,Y,Z, REG )
BUF		ERASE	+2		# USED BY DMP1, SQRTDIV
LOGTEM		EQUALS	BUF		# LOG SUBROUTINE TEMP.
SGNDMAX		EQUALS	BUF +2		# USED IN TPAGREE
TEM3		EQUALS	BUF +2
GCOMPSW		EQUALS	BUF +2
TEM2		ERASE
DSREL		=	TEM2		# REL ADDRESS FOR DSPIN(TEM2 USED BY DAD1)
TEM4		ERASE
TEMQ		EQUALS	TEM4		# RETURN FROM TPAGREE
DSMAG		=	TEM4		# MAGNITUDE STORE FOR DSPIN
IDADDTEM	=	TEM4		# MIXNOUN INDIRECT ADDRESS STORAGE
TEM5		ERASE
TEMQ2		EQUALS	TEM5
BASE		=	TEM5
COUNT		=	TEM5		# FOR DSPIN  (TEM5 IS USED BY DAD)
TEM8		ERASE
TEM6		EQUALS	TEM8		# ERASABLE ASSIGNMENTS BY EQUALS
TEM9		ERASE
WRDRET		=	TEM9		# RETURN FOR 5BLANK
WDRET		=	TEM9		# RETURN FOR DSPWD
DECRET		=	TEM9		# RETURN FOR PUTCOM(DEC LOAD)
21/22REG	=	TEM9		# TEMP FOR CHARIN
TEM10		ERASE
IND		EQUALS	TEM10		# USED IN CROSS ROUTINE
MIXBR		=	TEM10		# INDICATOR FOR MIXED OR NORMAL NOUN
DSPMMTEM	=	TEM10		# DSPCOUNT SAVE FOR DSPMM
DVSW		ERASE			# (THIS CAN PROBABLY BE EQUATED)
SGNOFF		=	DVSW		# TEMP FOR +,- ON
NVTEMP		=	DVSW		# TEMP FOR NVSUB
SFTEMP1		=	DVSW		# STORAGE FOR SF CONST HI PART(=SFTEMP2-1)
BRANCHQ		ERASE			# (DITTO)
CODE		=	BRANCHQ		# FOR DSPIN
SFTEMP2		=	BRANCHQ		# STORAGE FOR SF CONST LO PART(=SFTEMP1+1)
COMPON		ERASE			# (DITTO)
DSEXIT		=	COMPON		# RETURN FOR DSPIN
EXITEM		=	COMPON		# RETURN FOR SCALE FACTOR ROUTINE SELECT
BLANKRET	=	COMPON		# RETURN FOR 2BLANK
ARETURN		ERASE			# RETURN ADDRESS FOR ARCSIN/ARCCOS.
LSTPTR		=	ARETURN		# LIST POINTER FOR GRABUSY
RELRET		=	ARETURN		# RETURN FOR RELDSP
FREERET		=	ARETURN		# RETURN FOR FREEDSP

ESCAPE		ERASE			# ARCSIN/ARCCOS SWITCH
CADRTEM		=	ESCAPE		# TEMP STORAGE FOR GRAB ROUTINES

#	THE FOLLOWING REGISTERS ARE USED EXCLUSIVELY BY THE EXECUTIVE.
## Page 16
MPAC		ERASE	+2		# MULTIPLE-PRECISION ACCUMULATOR
LOC		ERASE			# LOCATION COUNTER FOR OPERATOR WORDS
ADRLOC		ERASE			# LOCATION COUNTER FOR OPERAND ADDRESSES
OVFIND		ERASE			# 0 FOR NO OVERFLOW, NON-ZERO OTHERWISE
PUSHLOC		ERASE			# NEXT AVAILABLE ENTRY IN PUSH-DOWN LIST
PRIORITY	ERASE			# PRIORITY OF CURRENT JOB

		ERASE	+55D		# EIGHT JOBS POSSIBLE

NEWJOB		ERASE			# SET NON-ZERO TO SIGNAL EXECUTIVE RUPT

VAC1USE		ERASE			# SEE EXECUTIVE PROGRAMS FOR USE OF THESE
VAC1		ERASE	+42D		# REGISTERS
VAC2USE		ERASE
VAC2		ERASE	+42D
VAC3USE		ERASE
VAC3		ERASE	+42D
VAC4USE		ERASE
VAC4		ERASE	+42D
VAC5USE		ERASE
VAC5		ERASE	+42D

#	THE FOLLOWING REGISTERS ARE USED EXCLUSIVELY BY THE WAITLIST.

LST1		ERASE	+6		# DELTA T'S.
LST2		ERASE	+7		# TASK CADRS.
RUPTAGN		ERASE			# WAITLIST ADDITIONAL TASK INDICATOR.

KEYTEMP2	=	RUPTAGN		# TEMP FOR KEYRUPT, UPRUPT

#	THE FOLLOWING GROUP OF REGISTERS MAY BE USED AS TEMPORARY STORAGE BY ANY INTERRUPT PROGRAM OR BY ANY
# PROGRAM WHICH INHIBITS INTERRUPT. CARE MUST BE TAKEN, HOWEVER, TO SEE THAT THEY ARE NOT USED DURING A CALL
# TO THE EXECUTIVE (FOR EXAMPLE), FOR THE EXECUTIVE MAY USE THEM AS TEMPORARIES TOO.

EXECTEM1	ERASE			# THESE REGISTERS, EXECTEM1-3, MAY BE USED
RUPTSTOR	=	EXECTEM1
IN1HITEM	=	EXECTEM1	# INTERRUPT TEMP FOR STANDBY PREP
EXECTEM2	ERASE			# INHIBITS INTERRUPTS.
PROG		EQUALS	EXECTEM2
IN1LOTEM	=	EXECTEM2	# INTERRUPT TEMP FOR STANDBY PREP
EXECTEM3	ERASE			# INHIBITS INTERRUPTS
ITEMP3		EQUALS	EXECTEM3
SRRUPT		EQUALS	EXECTEM3	# SHORT STORAGE FOR SR DURING INTERRUPT.
LOOKRET		=	EXECTEM3	# INTERRUPT TEMP FOR STANDBY PREP
EXECTEM4	ERASE
EXECTEM5	ERASE			# BANK RETURN FROM PHASE CONTROL.
NEWPRIO		ERASE			# PRIORITY OF NEW JOB
NVAL		=	NEWPRIO
DELT		=	NVAL
ITEMP1		=	NEWPRIO
## Page 17
WTEXIT		ERASE
ITEMP2		=	WTEXIT
KEYTEMP1	=	WTEXIT		# TEMP FOR KEYRUPT, UPRUPT
DSRUPTEM	=	WTEXIT		# TEMP FOR DSPOUT
LOCCTR		ERASE			# USED TO LOCATE STORAGE FOR CORE REGISTERS
PHASDATA	EQUALS	LOCCTR

# ERASABLE ASSIGNMENTS SPECIFIC TO PINBALL

VERBREG		ERASE			# VERB CODE
NOUNREG		ERASE			# NOUN CODE
XREG		ERASE			# R1 INPUT BUFFER
YREG		ERASE			# R2 INPUT BUFFER
ZREG		ERASE			# R3 INPUT BUFFER
XREGLP		ERASE			# LO PART OF XREG (FOR DEC CONV ONLY)
YREGLP		ERASE			# LO PART OF YREG (FOR DEC CONV ONLY)
ZREGLP		ERASE			# LO PART OF ZREG (FOR DEC CONV ONLY)
MODREG		ERASE			# MODE CODE
REQRET		ERASE			# RETURN REGISTER FOR LOAD
DSPCOUNT	ERASE			# DISPLAY POSITION INDICATOR
DECBRNCH	ERASE			# +DEC, - DEC, OCT INDICATOR
		SETLOC	616		# NEEDED FOR PINBALL AUTO CHECK
DSPTEM1		ERASE	+2		# BUFFER STORAGE AREA 1 (MOSTLY FOR TIME)
LANDMARK	EQUALS	DSPTEM1
V75TEMP		EQUALS	DSPTEM1
DSPTEM2		ERASE	+2		# BUFFER STORAGE AREA 2 (MOSTLY FOR DEG)
NOUNADD		ERASE			# MACHINE ADDRESS FOR NOUN
MONSAVE		ERASE			# N/V CODE FOR MONITOR. ALSO ACTIVITY
MONSAVE1	ERASE			# NOUNADD STORAGE FOR MONITOR WITH MATBS
CADRSTOR	ERASE			# ENDIDLE STORAGE
GRABLOCK	ERASE			# INTERNAL INTERLOCK FRO DISPLAY SYSTEM
NVSBCADR	ERASE			# NVSUB STORAGE FOR CALLING CADR
LOADSTAT	ERASE			# STATUS INDICATOR FOR LOADTST
CLPASS		ERASE			# PASS INDICATOR FOR CLEAR
DSPLIST		ERASE	+2		# WAITING REG FOR DSP SYST INTERNAL USE



# LONG-TERM STORAGE USED DURING INTERRUPT, NOT USED BY EXECUTIVE, WAITLIST, ETC/
 
RUPTREG1	ERASE
KSAMPTEM	EQUALS	RUPTREG1
RUPTREG2	ERASE
OSAMPTEM	EQUALS	RUPTREG2
RUPTREG3	ERASE
RUPTREG4	ERASE

# MISCELLANEOUS RESERVATIONS

SAMPTIME	ERASE	+1		# SAMPLED TIME FOR PINBALL REFERENCE.

## Page 18

# 	INTERPRETER SWITCH ASSIGNMENTS.

STATE		ERASE	+2		# 45 SWITCHES USED BY INTERPRETIVE PROGS.

DSPLOCK		EQUALS	STATE		# BIT 4
EXTVBACT	EQUALS	STATE		# BIT 3
UPLOCK		EQUALS	STATE		# BIT 2
FLAGWRD1	EQUALS	STATE +1
FLAGWRD2	EQUALS	STATE +2

JSWITCH		EQUALS	1		# FREE-FALL INTEGRATION.
ABORTSIG	EQUALS	2		# SET WHEN GROUND ABORT V72 IS RECEIVED.
TFF2FLAG	EQUALS	3		# TOM D. NAMED THIS
BIASFLAG	EQUALS	4		# CAUSES DELV TO BE ZEROED AFTER 1/PIPA
NBSMBIT		EQUALS	5		# IN-FLIGHT ALIGNMENT.
GONEPAST	EQUALS	6		#  RE-ENTRY
RELVELSW	EQUALS	7D		# RE-ENTRY.
EGSW		EQUALS	8D		# RE-ENTRY.
HUNTSW1		EQUALS	9D		# RE-ENTRY.
HIND		EQUALS	10D		# ENTRY.
VERIFLAG	EQUALS	10D
#DSKYFLAG	EQUALS	11D		# GUARDS AGAINST DOUBLE KEYBOARD ENTRIES.
#DSPLOCK	EQUALS	12D		# KEYBOARD/SUBROUTINE CALL INTERLOCK
#EXTVBACT	EQUALS	13D		# EXTENDED VERB ACTIVITY
#UPLOCK		EQUALS	14D		# UPLINK INTERLOCK (ACTIVATED BY RECPTION
#					# OF A BAD CODE IN UPLINK)

INRLSW		EQUALS	15D		# PROGSTALL NOT USED DURING ENTRY.
PRGSW		EQUALS	15D		# USED BY PRGSTALL.

COASTFLG	EQUALS	17D		# 17 TO 47 ARE 501 SEQUENCE CONTROL FLAGS.
UPDATFLG	EQUALS	18D
SOAKFLAG	EQUALS	19D
SHTDNFLG	EQUALS	20D
ACTIVFLG	EQUALS	21D
INTPFLAG	EQUALS	22D
INITFLAG	EQUALS	23D
S4BSMFLG	EQUALS	24D
INT1FLAG	EQUALS	25D
MONITFLG	EQUALS	26D
DVMONFLG	EQUALS	27D
STEERFLG	EQUALS	28D
ENTRYFLG	EQUALS	29D
LIFTFLAG	EQUALS	30D
TUMBFLAG	EQUALS	31D

DRIFTFLG	EQUALS	33D
CDUXFLAG	EQUALS	34D
BACKFLAG	EQUALS	35D
ROLLFLAG	EQUALS	36D
## Page 19
CALCFLAG	EQUALS	37D
DOMANFLG	EQUALS	38D
NEGFLAG		EQUALS	39D
BEGINFLG	EQUALS	40D
SPS4FLAG	EQUALS	41D
SPS3FLAG	EQUALS	42D
SPS2FLAG	EQUALS	43D
SPS1FLAG	EQUALS	44D
TABTFLAG	EQUALS	45D
ABRTFLAG	EQUALS	46D
ARRSTFLG	EQUALS	47D

#	STORAGE USED BY PHASE CONTROL.

PHASETAB	ERASE	+5		# PHASE VALUES FOR 6 PROGRAMS
PHASE1		EQUALS	PHASETAB
PHASE2		EQUALS	PHASETAB +1
PHASE3		EQUALS	PHASETAB +2
PHASE4		EQUALS	PHASETAB +3
PHASE5		EQUALS	PHASETAB +4
PHASE6		EQUALS	PHASETAB +5
PHASEBAR	ERASE	+5		# COMPLEMENTED COPY.
-PHASE1		EQUALS	PHASEBAR
TBASE2		ERASE
TBASE3		ERASE
TBASE4		ERASE
TBASE5		ERASE			#  SHOULD COMPLETE THIS SET.

#	THE FOLLOWING REGISTERS ARE USED BY THE DOWNRUPT PROGRAM.

TELCOUNT	ERASE			# ENDPULSE FREQUENCY MONITORING COUNTER.
LDATALST	ERASE
DNLSTADR	ERASE			# BASE ADDRESS OF APPROPRIATE TM LIST.
DNTMGOTO	ERASE			# ADDRESS OF CURRENT DOWNLINK PHASE.
TMINDEX		ERASE			# STEPS THROUGH THE DOWNLIST
TMMARKER	ERASE
MARKERCT	ERASE

#	THE FOLLOWING STORAGE IS USED BY T4RUPT.

CDUIND		ERASE			# IMU CDU STATUS INDICATOR AND INDEXER.
THETAD		ERASE	+2		# SET OF THREE DESIRED ANGLES IN 2S COMPL.
OPTIND		ERASE			# OPTICS CDU STATUS INDICATOR AND INDEXER.
DESOPTX		ERASE	+1		# DEISROED OPTICS CDU ANGLES.

DSPCNT		ERASE			# STEPS THROUGH K-RELAY SLOTS IN DSPTAB.
NOUT		ERASE			# HOLDS NUMBER OF RELAY WORDS TO CHANGE.
DSPTAB		ERASE	+13D		# HOLDS STATE OF ALL RELAYS AND CHANGE INF

OLDERR		ERASE			# LAST-SAMPLED SYSTEM ERROR BITS.
## Page 20
#	THE BITS OF OLDERR HAVE THE FOLLOWING MEANINGS:
#
# BIT  1 = 1 IF THE PILOTS ATTITUDE BUTTON IS DEPRESSED.
# BIT  2 = 1 IF RESTART FAILED (AND DID A FRESH START).
# BIT  3 = 1 IF BIT 4 OF OUT1 WAS NOT INVERTED LAST NWJOB.
# BIT  4 = 1 TO INHIBIT IMU FAIL FOR 5 SECONDS AFTER COARSE ALIGN.
# BIT  5 = 1 IF CURTAINS CALLED (IMU MODING FAILURE, ETC.)
# BIT 10 = 1 IF CDU FAIL IS ON IN FINE ALIGN.
# BIT 11 = 1 IF PIPA FAIL IS ON.
# BIT 12 = 1 IF IMU FAIL IS ON IN ANY MODE BUT COARSE ALIGN.
#
#	IN FLIGHT 501, BITS 2, 5, 11, AND 12 INHIBIT MAINTENANCE OF THE NIGHT WATCHMAN ALARM
# SO THAT IF THEY ARE PRESENT FOR 2 CONSECUTIVE NWJOBS, G & N FAIL WILL BE SENT TO THE MCP.

WASKSET		ERASE			# LAST SETTING OF IMU MODE SWITCHES.
WASOPSET	ERASE			# LAST SETTING OF OPTICS MODE SWITCHES.

DESKSET		ERASE			# DESIRED SETTING OF IMU MODE SWITCHES.
DESOPSET	ERASE			# DESIRED OPTICS MODES.

#	THE FOLLOWING REGISTERS ARE USED BY THE MODE SWITCHING AND MASK PROGRAMS.

IMUCADR		ERASE			# USED BY IMUSTALL.
MODECADR	EQUALS	IMUCADR		# FOR INDEXING PURPOSES.
OPTCADR		ERASE			# USED BY OPTSTALL.

MARKSTAT	ERASE			# MARK BUTTON STATUS REGISTER.

## Page 21

# 	THE FOLLOWING STORAGE IS RESERVED FOR IMU COMPENSATION PARAMETERS.

PBIASX		ERASE			# PIPA BIAS, PIPA SCALE FACTOR TERMS
PIPABIAS	EQUALS	PBIASX		# INTERMIXED.
PIPASCFX	ERASE
PIPASCF		EQUALS	PIPASCFX
PBIASY		ERASE
PIPASCFY	ERASE
PBIASZ		ERASE
PIPASCFZ	ERASE

GBIASX		ERASE			# GYRO BIAS DRIFTS.
GBIASY		ERASE
GBIASZ		ERASE

ADIAX		ERASE			# ACCELERATION SENSITIVE DRIFT ALONG THE
ADIAY		ERASE			# INPUT AXIS.
ADIAZ		ERASE

ADSRAX		ERASE			# ACCELERATION SENSITIVE DRIFT
ADSRAY		ERASE			# ALONG THE SPIN-REFERENCE AXIS.
ADSRAZ		ERASE

1/PIPADT	ERASE			# DELTA TIME FOR 1/PIPA.

OLDBT1		EQUALS	1/PIPADT	# TIME1 STORAGE DURING FREE-FALL COMP.

GCOMP		ERASE	+5		# CONTAINS COMPENSATING GYRO TORQUES.

#	THE FOLLOWING INTERLOCK REGISTER IS USED BY THE GYRO ROUTINES.

LGYRO		ERASE			# ZERO IF GYROS AVAILABLE - ADDRESS OF
					# COMMANDS IF IN USE

## Page 22

# 	THE FOLLOWING STORAGE CONTAINS REFERENCE VARIABLES FOR SEVERAL MISSION PROGRAMS. INCLUDED HERE ARE
# POSITION, VELOCITY, THEIR ASSOCIATED TIME, AND IMU STABLE MEMBER ORIENTATION (WHEN THE IMU IS ALIGNED).

REFRRECT	ERASE	+5		# REFERENCE RECTIFICATION VECTORS.
REFVRECT	ERASE	+5
DELTAV		ERASE	+5		# REFERENCE DEVIATION VECTORS.
NUV		ERASE	+5
REFRCV		ERASE	+5		# REFERENCE CONIC POSITION VECTOR.

REFVCV		ERASE	+5		# REFERENCE CONIC VELOCITY VECTOR.
REFTC		ERASE	+1		# REFERENCE TIME SINCE RECTIFICATION.
TE		ERASE	+1		# TIME CORRESPONDING TO POSITION AND VEL.

REFXKEP		ERASE	+1		# REFERENCE CONIC VARIABLE X.
PBODY		ERASE

NSHIFT		ERASE			# AVERGAE G INTEGRATOR PARAMETERS REQUIR-
XSHIFT		ERASE			# ING PERMANENT STORAGE
CALCG		ERASE
UNITW		ERASE	+5

RN		EQUALS	REFRRECT	# SYMBOLS FOR POSITION AND VELOCY
RPIP		EQUALS	REFRRECT	# DURING ACCELERATED PHASES.
VN		EQUALS	REFVRECT
VPIP		EQUALS	REFVRECT

DELV		EQUALS	DELTAV		# PIPA DATA DURING ACCELERATED PHASES.
DELVX		EQUALS	DELV
DELVY		EQUALS	DELV +2
DELVZ		EQUALS	DELV +4
GRAVITY		EQUALS	NUV		# AVERAGE G INTEGRATOR VARIABLES
UNITR		EQUALS	REFRCV
RMAG		EQUALS	REFVCV
RMAGSQ		EQUALS	REFVCV +2
DELTAT		EQUALS	REFVCV +4

TEMX		EQUALS	REFTC
TEMY		EQUALS	REFTC +1
TEMZ		EQUALS	TE
TEMXY		EQUALS	TE +1
PIPAGE		EQUALS	REFXKEP

REFSMMAT	ERASE	+17D		# REFERENCE TO SM MATRIX
DTEPOCH		ERASE	+1

REDOCNTR	ERASE			# RESTART DAATA SAVED IN THESE REGISTERS
REDOTIME	ERASE	+1

## Page 23

#	THE FOLLOWING STORAGE IS TIME-SHARED BY MISSION PROGRAMS UNDER THE SUPERVISION OF MASTER COMTROL. IT IS
# ORGANIZED INTO THREE PARTS REFERRED TO AS A MEMORY, B MEMORY, AND C MEMORY. A PARTICULAR MISSION PHASE IS
# ASSIGNED TO ONE OF THE SEGMENTS IN SUCH A WAY THAT NO OTHER MISSION PHASE USING THE SAME SEGMENT WILL EVER RUN
# CONCURRENTLY; E.G., RE-ENTRY WILL NEVER RUN CONCURRENT WITH TVC. THE NUMBER OF AREAS (3) IS DETERMINED BY THE
# MAXIMUM NUMBER OF DISTINCT MISSION PROGRAMS WHICH RUN SIMULTANEOUSLY.
#
#	A MEMORY IS USED BY NAVIGATION PROGRAMS; MID-COURSE DURING FREE-FALL PORTIONS OF THE MISSION AND 
# AVERAGE G INTEGRATION DURING ACCELERATED PHASES. GUIDANCE PROGRAMS SUCH AS TVC USE B MEMORY TOGETHER WITH THEIR 
# ASSOCIATED ALIGNMENTS. THE C MEMORY PORTION IS USED THROUGHOUT MOST OF THE MISSION FOR THE MIDCOURSE ERROR
# TRANSITION MATRIX W, AND LATER BY RE-RENTRY AFTER THE LAST MEASUREMENT HAS BEEN INCORPORATED. THE EXCEPTION IS
# SYSTEM TEST, ASSIGNED TO A MEMORY, WHICH NEVER RUNS CONCURRENTLY WITH MISSION PROGRAMS.

AMEMORY		ERASE	+139D
BMEMORY		ERASE	+164D
CMEMORY		ERASE	+71D



# 	STORAGE USED TO SAVE T1+2 DURING STANDBY.

TIME2SAV	EQUALS	AMEMORY +000D
TIME1SAV	EQUALS	AMEMORY +001D
IN1HISAV	EQUALS	AMEMORY +002D
IN1LOSAV	EQUALS	AMEMORY +003D
IN1HIDIF	EQUALS	AMEMORY +004D
IN1LODIF	EQUALS	AMEMORY +005D

#	THE FOLLOWING A MEMORY LOCATIONS ARE USED BY MID-COURSEE NAVIGATION:

RRECT		EQUALS	AMEMORY +000D
RIGNTION	EQUALS	AMEMORY +000D
VRECT		EQUALS	AMEMORY +006D
VIGNTION	EQUALS	AMEMORY +006D
TDELTAV		EQUALS	AMEMORY +012D
NEWDLTAV	EQUALS	AMEMORY +012D
YV		EQUALS	AMEMORY +012D
TNUV		EQUALS	AMEMORY +018D
-UPADR		EQUALS	TNUV
STCNTR		EQUALS	TNUV +1
NEWNUV		EQUALS	AMEMORY +018D
ZV		EQUALS	AMEMORY +018D
RCV		EQUALS	AMEMORY +024D
FOUNDR		EQUALS	AMEMORY +024D
VCV		EQUALS	AMEMORY +030D
FOUNDV		EQUALS	AMEMORY +030D
TC		EQUALS	AMEMORY +036D
TET		EQUALS	AMEMORY +038D
XKEP		EQUALS	AMEMORY +040D
ALPHAV		EQUALS	AMEMORY +042D
## Page 24
DELR		EQUALS	AMEMORY +042D
BETAV		EQUALS	AMEMORY +048D
DELVEL		EQUALS	AMEMORY +048D
UVL		EQUALS	AMEMORY +048D
PHIV		EQUALS	AMEMORY +054D
STARMEAS	EQUALS	AMEMORY +054D
LNDMRKV		EQUALS	AMEMORY +060D
PSIV		EQUALS	AMEMORY +060D
ROTLMV		EQUALS	AMEMORY +066D
FV		EQUALS	AMEMORY +066D

VECTAB		EQUALS	AMEMORY +072D

TAVEGON		EQUALS	AMEMORY +072D
TRESUME		EQUALS	AMEMORY +074D
RAVEGON		EQUALS	AMEMORY +076D
BVECTOR		EQUALS	AMEMORY +080D
UNE		EQUALS	AMEMORY +080D
VAVEGON		EQUALS	AMEMORY +082D
UNP		EQUALS	AMEMORY +088D
RIG-4SEC	EQUALS	AMEMORY +088D
ERADSQ/4	EQUALS	AMEMORY +094D
ERAD/2		EQUALS	AMEMORY +096D
ALPHAM		EQUALS	AMEMORY +108D
BETAM		EQUALS	AMEMORY +110D
LONGDES		EQUALS	AMEMORY +110D
TAU		EQUALS	AMEMORY +112D
GIVENT		EQUALS	AMEMORY +112D
DLONG		EQUALS	AMEMORY +112D
DT/2		EQUALS	AMEMORY +114D
LAT		EQUALS	AMEMORY +114D
H		EQUALS	AMEMORY +116D
LONG		EQUALS	AMEMORY +116D
TDEC		EQUALS	AMEMORY +118D
AZ		EQUALS	AMEMORY +120D
FBRANCH		EQUALS	AMEMORY +120D
HBRANCH		EQUALS	AMEMORY +121D
GMODE		EQUALS	AMEMORY +122D
NUMBTEMP	EQUALS	AMEMORY +122D
NUMBOPT		EQUALS	AMEMORY +123D
VARIANCE	EQUALS	AMEMORY +124D
HMAG		EQUALS	AMEMORY +124D
MEASQ		EQUALS	AMEMORY +126D
COTGAM		EQUALS	AMEMORY +126D
DELTAQ		EQUALS	AMEMORY +126D

MEASMODE	EQUALS	AMEMORY +128D
SITENUMB	EQUALS	AMEMORY +128D
NVCODE		EQUALS	AMEMORY +129D
MIDEXIT		EQUALS	AMEMORY +130D
## Page 25
DSPRTRN		EQUALS	AMEMORY +130D
WMATFLAG	EQUALS	AMEMORY +131D
INCORPEX	EQUALS	AMEMORY +131D
STEPEXIT	EQUALS	AMEMORY +132D
DIFEQCNT	EQUALS	AMEMORY +133D
NORMGAM		EQUALS	AMEMORY +133D
SCALEA		EQUALS	AMEMORY +134D
SCALEB		EQUALS	AMEMORY +135D
SCALEDT		EQUALS	AMEMORY +136D
SCALDELT	EQUALS	AMEMORY +137D
SCALER		EQUALS	AMEMORY +138D

FFFLAGS		EQUALS	AMEMORY +139D



#	A MEMORY ASSIGNMENTS FOR UPDATE ROUTINE

STBUFF		EQUALS	AMEMORY +000D
UPOLDMD		EQUALS	AMEMORY +014D
COMPNUMB	EQUALS	AMEMORY +015D



#	ENTRY ITEMS IN A MEMORY TO BE INCLUDED IN DOWN-LINK.

FX		EQUALS	AMEMORY +0	# SHARES THIS LOC WITH RRECT.
PREDANG		EQUALS	AMEMORY +06D	# SHARES THIS LOC WITH VRECT.
JJ		EQUALS	AMEMORY +07D	# SHARES THIS LOC WITH VRECT.
THETAH		EQUALS	AMEMORY +08D	# SHARES THIS LOC WITH VRECT.
LATANG		EQUALS	AMEMORY +010D	# SHARES THIS LOC WITH VRECT.
L/D		EQUALS	AMEMORY +082D	# SHARES THIS LOC WITH VAVEGON.
DIFF		EQUALS	AMEMORY +084D	# SHARES THIS LOC WITH VAVEGON.



#	A MEMORY ASSIGNMENTS FOR ROTATING EARTH ROUTINE.

RTINIT		EQUALS	AMEMORY +012D
RTEAST		EQUALS	AMEMORY +018D
RTNORM		EQUALS	AMEMORY +024D
RT		EQUALS	AMEMORY +076D	# SHARES THIS LOCATION WITH RAVEGON
DTEAROT		EQUALS	AMEMORY +036D



#	A MEMORY TEMPORARIES USED BY PRELAUNCH

PTEMP		EQUALS	AMEMORY +99D

## Page 26

#	A MEMORY  USAGE AS TEMPORARIES BY AVERAGE G ROUTINE.

RN1		EQUALS	AMEMORY +127D
VN1		EQUALS	AMEMORY +133D
AVGRETRN	EQUALS	AMEMORY +139D



#	A MEMORY TEMPORARIES USED BY SERVICER

VGCNT1		EQUALS	AMEMORY +113D
DVCNT1		EQUALS	AMEMORY +114D
VR1		EQUALS	AMEMORY +115D	# 12 LOCATIONS FOR VR, DIFFVECT



#	SYSTEM TEST A MEMORY USAGE:

GENPL		EQUALS	AMEMORY +000D
TAR1POS		EQUALS	GENPL
FILDELX		EQUALS	AMEMORY +012D
TMARK		EQUALS	AMEMORY +060D
VMARK		EQUALS	AMEMORY +062D
COARSAGN	EQUALS	AMEMORY +075D
TESTTIME	EQUALS	AMEMORY +077D
LTSTNDX		EQUALS	AMEMORY +078D
COUNTPL		EQUALS	AMEMORY +080D
PIPINDEX	EQUALS	AMEMORY +081D
PIPANO		EQUALS	AMEMORY +082D
POSITON		EQUALS	AMEMORY +083D
RESULTCT	EQUALS	AMEMORY +084D
NDXCTR		EQUALS	RESULTCT
QPLACE		EQUALS	AMEMORY +085D

PIPNDX		EQUALS	AMEMORY +086D
STOREPL		EQUALS	AMEMORY +088D
NBPOS		EQUALS	AMEMORY +89D
TESTNDX		EQUALS	AMEMORY +90D
CDUNDX		EQUALS	AMEMORY +91D
GYROD		EQUALS	AMEMORY +92D
DATAPL		EQUALS	AMEMORY +98D

VACADR		EQUALS	AMEMORY +130D
MKSTAT1		EQUALS	AMEMORY +132D
COAROFIN	EQUALS	AMEMORY +133D
MAXPTS2		EQUALS	AMEMORY +135D
QPLAC		EQUALS	AMEMORY +136D
PTS		EQUALS	AMEMORY +137D
RUN		EQUALS	AMEMORY +138D
EROPTN		EQUALS	AMEMORY +139D

## Page 27
TESTNO		EQUALS	CMEMORY +000D
SAVE		EQUALS	CMEMORY +001D
PLOW		EQUALS	CMEMORY +002D
CUSSANG		EQUALS	CMEMORY +003D
NEGCDU1		EQUALS	CMEMORY +004D
NEGCDU2		EQUALS	CMEMORY +005D
LOCNO		EQUALS	CMEMORY +006D
CALCDIR		EQUALS	CMEMORY +007D
BUBBLE		EQUALS	CMEMORY +008D
TEMDELV		EQUALS	CMEMORY +009D
RETAA		EQUALS	CMEMORY +010D
RETBB		EQUALS	CMEMORY +011D
STARNUMB	EQUALS	DSPTEM2


# B MEMORY USED BY POWERED FLIGHT AND ATTITUDE MANEUVERS

CDUTEMP		EQUALS	BMEMORY +000D
CDUBUF		EQUALS	BMEMORY +006D
WC		EQUALS	BMEMORY +006D
UNITN		EQUALS	BMEMORY +006D
RTRNSLUN	EQUALS	BMEMORY +006D
VF		EQUALS	BMEMORY +006D
SINCDU		EQUALS	BMEMORY +012D
COSCDU		EQUALS	BMEMORY +018D
DCDU		EQUALS	BMEMORY +024D
DUPCDU		EQUALS	BMEMORY +024D
STEERROR	EQUALS	BMEMORY +024D
DNB		EQUALS	BMEMORY +030D
VG		EQUALS	BMEMORY +030D
UNITVG		EQUALS	BMEMORY +030D
ERRORSUM	EQUALS	BMEMORY +036D
XSC		EQUALS	BMEMORY +042D
UNITRXV		EQUALS	BMEMORY +042D
UNITF		EQUALS	BMEMORY +042D
UNITD		EQUALS	BMEMORY +042D
YSC		EQUALS	BMEMORY +048D
UNITHORZ	EQUALS	BMEMORY +048D
UNITS		EQUALS	BMEMORY +048D
ZSC		EQUALS	BMEMORY +054D
UNITMDT		EQUALS	BMEMORY +054D
XSCD		EQUALS	BMEMORY +060D
CBDT		EQUALS	BMEMORY +060D
YSCD		EQUALS	BMEMORY +066D
VR		EQUALS	BMEMORY +066D
ZSCD		EQUALS	BMEMORY +072D
SGNTHETA	EQUALS	BMEMORY +072D
DIFFVECT	EQUALS	BMEMORY +072D
RTARG		EQUALS	BMEMORY +078D
## Page 28
DTEMP1		EQUALS	BMEMORY +078D
S		EQUALS	BMEMORY +078D
DN		EQUALS	BMEMORY +080D
SMA		EQUALS	BMEMORY +082D
ANORMAL		EQUALS	BMEMORY +084D
LOOKANG		EQUALS	BMEMORY +086D
DISPCNTR	EQUALS	BMEMORY +087D
MDT		EQUALS	BMEMORY +088D
VGCNTR		EQUALS	BMEMORY +090D
DVCNTR		EQUALS	BMEMORY +091D
#K1ROLL		EQUALS	BMEMORY +092D	# N.B. THIS LOCATION SHARED WITH ENTRY
DTHETA		EQUALS	BMEMORY +094D
THETAMAN	EQUALS	BMEMORY +096D
TFF		EQUALS	BMEMORY +098D
LONGTIME	EQUALS	BMEMORY +100D
TLIFTOFF	EQUALS	BMEMORY +102D
TENGON		EQUALS	BMEMORY +102D
TCUTOFF		EQUALS	BMEMORY +102D
PIPTIME		EQUALS	BMEMORY +104D
LONGEXIT	EQUALS	BMEMORY +106D
CALLCADR	EQUALS	BMEMORY +107D
VRCADR		EQUALS	BMEMORY +108D
EXITCADR	EQUALS	BMEMORY +109D
ROLLC		EQUALS	BMEMORY +110D	# N.B. THIS LOCATION SHARED WITH ENTRY
EXITCAD1	EQUALS	BMEMORY +112D

# B, C MEMORY USED FOR ERASABLE 501 LAUNCH, AIMPOINT, VEHICLE DATA.

TATLAN1		EQUALS	CMEMORY +030D
TATLANT		EQUALS	BMEMORY +138D
RTATLAN1	EQUALS	CMEMORY +032D
RTATLANT	EQUALS	BMEMORY +140D
TPACIF1		EQUALS	CMEMORY +038D
TPACIFC		EQUALS	BMEMORY +146D
RTPACIF1	EQUALS	CMEMORY +040D
RTPACIFC	EQUALS	BMEMORY +148D
ESQ(VR)		EQUALS	BMEMORY +154D
SEMILAT		EQUALS	BMEMORY +158D
TCOAST		EQUALS	BMEMORY +162D
TDECAY		EQUALS	BMEMORY +164D



#	THE FOLLOWING ARE RE-ENTRY AND PRE-RE-ENTRY ASSIGNMENTS:

(V)		EQUALS	BMEMORY +000D
DIFFOLD		EQUALS	BMEMORY +008D
Q7		EQUALS	BMEMORY +010D
## Page 29
FACT2		EQUALS	BMEMORY +012D
ESQ		EQUALS	BMEMORY +014D
LEWD		EQUALS	BMEMORY +020D
VSQUARE		EQUALS	BMEMORY +022D
DADV1		EQUALS	BMEMORY +24D
RDOT		EQUALS	BMEMORY +026D
TENTRY		EQUALS	BMEMORY +028D
ROLLBIAS	EQUALS	BMEMORY +30D
#   A HOLE.
ETA		EQUALS	BMEMORY +034D
D		EQUALS	BMEMORY +038D
V1		EQUALS	BMEMORY +040D
NEGTHET		EQUALS	BMEMORY +042D
V1OLD		EQUALS	BMEMORY +044D
K2ROLL		EQUALS	BMEMORY +046D
GOTOADDR	EQUALS	BMEMORY +048D
XPIPSUM		EQUALS	BMEMORY +049D
YPIPSUM		EQUALS	BMEMORY +050D
ZPIPSUM		EQUALS	BMEMORY +051D
XPIPBUF		EQUALS	BMEMORY +052D
YPIPBUF		EQUALS	BMEMORY +056D
ZPIPBUF		EQUALS	BMEMORY +060D
PIPCTR		EQUALS	BMEMORY +64D
DOLD		EQUALS	BMEMORY +65D
#   A HOLE.
TEM1B		EQUALS	BMEMORY +68D
M1		EQUALS	BMEMORY +69D
GRAD		EQUALS	BMEMORY +70D
#   A HOLE.
LEQ		EQUALS	BMEMORY +77D
DHOOK		EQUALS	BMEMORY +79D
AHOOKDV		EQUALS	BMEMORY +81D
DVL		EQUALS	BMEMORY +83D
K1ROLL		EQUALS	BMEMORY +092D	# N.B. THIS LOCATION SHARED WITH ENTRY
#   UNB,X,Y,Z ARE DEFINED LATER.

#					END OF RE-ENTRY STUFF



#	B MEMORY ASSIGNMENTS FOR PRE-LAUNCH ALIGNMENT.

LATITUDE	EQUALS	BMEMORY +000D
AZIMUTH		EQUALS	BMEMORY +002D
GYROCSW		EQUALS	BMEMORY +004D
PRELTEMP	EQUALS	BMEMORY +005D
PRELXGA		EQUALS	BMEMORY +006D
PRELYGA		EQUALS	BMEMORY +007D
PRELZGA		EQUALS	BMEMORY +008D
INFLANG		EQUALS	BMEMORY +014D
## Page 30
GYROANG		EQUALS	BMEMORY +020D
TAZ		EQUALS	BMEMORY +26D
TEL		EQUALS	BMEMORY +28D
VAZ		EQUALS	BMEMORY +30D
CHKNVTEM	EQUALS	BMEMORY +32D
FILTER		EQUALS	BMEMORY +34D
DELE		EQUALS	BMEMORY +36D
FILDELZ		EQUALS	DELE
DELS		EQUALS	BMEMORY +38D
FILDELY		EQUALS	DELS
INT		EQUALS	BMEMORY +40D
PREVTIME	EQUALS	BMEMORY +44D
THETAY		EQUALS	BMEMORY +90D
THETAZ		EQUALS	BMEMORY +92D
THETAX		EQUALS	BMEMORY +94D
THETASTH	EQUALS	BMEMORY +96D
THETAE		EQUALS	BMEMORY +98D
VECTEM		EQUALS	BMEMORY +48D
TIME2GR		EQUALS	BMEMORY +106D
TIME1GR		EQUALS	BMEMORY +107D
TARGET1		EQUALS	BMEMORY +054D



#	THE FOLLOWING LOCATIONS ARE USED BY IN-FLIGHT ALIGNMENT:

STARS		EQUALS	BMEMORY +052D
STARAD		EQUALS	TARGET1
STAR		EQUALS	BMEMORY +066D
XSM		EQUALS	BMEMORY +072D
YSM		EQUALS	BMEMORY +078D
ZSM		EQUALS	BMEMORY +084D
XNB		EQUALS	BMEMORY +114D
XDC		EQUALS	BMEMORY +114D
XDSMPR		EQUALS	BMEMORY +114D
YNB		EQUALS	BMEMORY +120D
YDC		EQUALS	BMEMORY +120D
YDSMPR		EQUALS	BMEMORY +120D
ZNB		EQUALS	BMEMORY +126D
ZDC		EQUALS	BMEMORY +126D
ZDSMPR		EQUALS	BMEMORY +126D
OGC		EQUALS	BMEMORY +132D
SAC		EQUALS	BMEMORY +132D
IGC		EQUALS	BMEMORY +134D
PAC		EQUALS	BMEMORY +134D
MGC		EQUALS	BMEMORY +136D



#    RE-ENTRY ATTITUDE CONTROL UNIT VECTORS ALONG NAV BASE.
## Page 31
UXNB		EQUALS	XNB		# USED IN RE-ENTRY CONTROL.
UYNB		EQUALS	YNB		# USED IN RE-ENTRY CONTROL.
UZNB		EQUALS	ZNB		# USED IN RE-ENTRY CONTROL.



# THE FOLLOWING IS USED FOR ATTITUDE CONTROL

ROLL		EQUALS	BMEMORY +000D
PITCH		EQUALS	BMEMORY +001D
YAW		EQUALS	BMEMORY +002D


#	CMEMORY USED FOR STORAGE OF 501 BOOST ATTITUDE MONITOR PARAMETERS

TROLL		EQUALS	CMEMORY +001D
TPITCH		EQUALS	CMEMORY +003D
TENDPTCH	EQUALS	CMEMORY +005D
TMONITOR	EQUALS	CMEMORY +007D
TTUMON		EQUALS	CMEMORY +009D
POLYENTR	EQUALS	CMEMORY +010D
POLYORDR	EQUALS	CMEMORY +011D
POLYCOEF	EQUALS	CMEMORY +012D
POLYEND		EQUALS	CMEMORY +026D
ROLLDTH		EQUALS	CMEMORY +027D



#	THE FOLLOWING IS THE MIDCOURSE 6X6 ERROR TRANSITION MATRIX:

W		EQUALS	CMEMORY +000D



#	C MEMORY ASSIGNMENTS FOR RE-RNTRY:

UNI		EQUALS	CMEMORY +000D
UNITV		EQUALS	CMEMORY +006D
INITL/D		EQUALS	CMEMORY +12D
VCORR		EQUALS	CMEMORY +014D
A0		EQUALS	CMEMORY +016D
VBARS		EQUALS	CMEMORY +018D
COSG/2		EQUALS	CMEMORY +020D
GAMMAL		EQUALS	CMEMORY +022D
VS		EQUALS	CMEMORY +024D
D0		EQUALS	CMEMORY +026D
VL		EQUALS	CMEMORY +28D
V		EQUALS	CMEMORY +030D
FACTOR		EQUALS	CMEMORY +032D
## Page 32
VREF		EQUALS	CMEMORY +034D
RDOTREF		EQUALS	CMEMORY +036D
ALP		EQUALS	CMEMORY +038D
FACT1		EQUALS	CMEMORY +040D

## Page 33

#



# 	SAVE RRECT AND VRECT IN CMEMORY TO RESTART ORBITAL INTEGRATION.

RRECCMEM	EQUALS	CMEMORY +60D
VRECCMEM	EQUALS	CMEMORY +66D



#		ERASABLE ADDED TO THE END OF 202 ASSIGNMENTS FOR FLIGHTS 501 & 2.

UPTIME		ERASE	+1		# SHOULD BE SET TO 37777, 37777 DURING
					# PRELAUNCH ERASABLE LOAD.
ANGLEX		ERASE			# COLDSOAK -  X GIMBAL ANGLE
ANGLEY		ERASE			# COLDSOAK -  Y GIMBAL ANGLE
ANGLEZ		ERASE			# COLDSOAK -  Z GIMBAL ANGLE
TFFMIN		ERASE	+1		# TIME TO START SPS2 BURN SEQUENCE
1/RLLRTE	ERASE	+1		# ROLL RATE DURING BOOST MONITOR
MAXROLL		ERASE	+1		# MAX DELTA ROLL ANGLE DURING ROLL MONITOR
CGY		ERASE	+3		# C.G. ROTATION ABOUT Y S/C AXIS
CGZ		ERASE	+3		# C.G. ROTATION ABOUT Z S/C AXIS
ATDT		ERASE	+3		# INTEGRATED INITIAL THRUST ACC. MAGNITUDE
TFFNOM		ERASE	+1		# NOMINAL TIME FROM NOMCASE TO 400,000 FT.
S2SWITCH	ERASE			# SET NEGATIVE TO RECOMPUTE SPS2 ATTITUDE
REFSWTCH	ERASE			# SET NEGATIVE FOR UNCOND. 280K FT FF REF
REDOSPS1	ERASE			# SET NEGATIVE TO REDO SPS1 AT AVGON
ECC		ERASE	+1		#FOR SIMULATION EDITING

## Page 34

# THE FOLLOWING STORAGE IS RESERVED EXCLUSIVELY FOR SELF-CHECK

SELFERAS	ERASE	1760 - 1777
ERESTORE	=	1760
QADRS		EQUALS	MPAC		# RESERVED
2OPTIONS	=	1761
SMODE		=	1762
FAILREG		=	1763
SFAIL		=	1764
ERCOUNT		=	1765
SCOUNT		=	1766
SKEEP1		=	1771
SKEEP2		=	1772
SKEEP3		=	1773
SKEEP4		=	1774
SKEEP5		=	1775
SKEEP6		=	1776
SKEEP7		EQUALS	1777
