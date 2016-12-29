### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	BANK_03_INTERPRETER_SECTION.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
## Mod history:	2009-09-17 JL	Created.
## 		2009-09-22 JL	Fixed typo.
##		2016-08-18 RSB	Some corrections.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.

## Page 70
		SETLOC	6000

BMN1		TC	BRANCH		# BRANCH MINUS
		TC	RE-ENTER
		TC	RE-ENTER
		TC	DOBR

BPL1		TC	BRANCH		# BRANCH PLUS
		TC	DOBR
		TC	DOBR
		TC	RE-ENTER

BZE1		TC	BRANCH		# BRANCH ZERO
		TC	RE-ENTER
		TC	DOBR
		TC	RE-ENTER

BHIZ1		CCS	MPAC		# BRANCH ON HIGH ORDER ZERO
		TC	RE-ENTER	# PNZ
		TC	DOBR
		TC	RE-ENTER
		TC	DOBR

BRANCH		XCH	Q
		TS	BRANCHQ
		CCS	MPAC
		TC	BRANCHQ
		TC	+2
		TC	MINUS

		CCS	MPAC +1
		TC	BRANCHQ
		TC	+2
		TC	MINUS

		CCS	MPAC +2
		TC	BRANCHQ
		TC	+2
MINUS		CAF	ONE
		AD	ONE
		AD	BRANCHQ
		XAQ

## Page 71

TRUE2		CS	FIXLOC		# RESTORES INTEGER ADDRESSES
		AD	ADDRWD
		TS	ADDRWD
		CCS	A		# WE MUST ELIMINATE THE MINUS ZERO CASE
		TC	Q		# OK HERE
		TC	CCSHOLE
		TC	+2		# IF ADDRESS WAS NEGATIVE
		TC	DANZIG		# FAST EXIT FOR ZERO SHIFT COUNTS
		INDEX	MODE		# RIGHT SHIFT INSTEAD OF A LEFT ONE
		TC	+3		# CCS  FOLLOWED BY ADD LEFT THE COUNT POS.
		TC	SHIFTR1 +3	# SO WE NEED ONLY CALL THE APPROPRIATE
		TC	SHIFTR1 +3	# SHIFT RIGHT INSTRUCTION.
		CS	ADDRWD		# PUT POSITIVE COUNT IN ADDRWD.
		TS	ADDRWD
		AD	NEG1		# DECREMENT LIKE CCS BEFORE RETURNING.
		TC	VSRT1 +4

AST		TC	TAG
		CS	POLISH
SSTORE		INDEX	TAG1
		XCH	40D		# STEP REGISTER
		TC	RE-ENTER

AXC		TC	TAG		# ADDRESS TO INDEX COMPLEMENTED
		XCH	POLISH
		TC	XSTORE

AXT		TC	TAG
		CS	POLISH
XSTORE		INDEX	TAG1
		XCH	38D		# MAY HAVE OVERFLOWED
		TC	RE-ENTER

LXA		TC	TAG
		INDEX	ADDRWD		# MUST BE ERASABLE - NOT NEEDED OTHERWISE
		CS	0
 +3		CS	A
		TC	XSTORE

LXC		TC	TAG		# LOAD INDEX FROM ADDRESS COMPLEMENTED
		INDEX	ADDRWD
		CS	0
		TC	XSTORE

SXA		TC	TAG
		INDEX	TAG1
		CS	38D		# GET INDEX
		CS	A
		TC	STOR1

## Page 72

TIX		TC	TAG
		INDEX	TAG1		# GET APPROPRIATE STEP REGISTER
		CS	40D		# STEP REGISTER
		INDEX	TAG1
		AD	38D
		TS	TEM2		# TO TEMPORARY
		CCS	A
		XCH	TEM2		# DECREMENT INDEX AND BRANCH
		TC	TIXBR
		TC	RE-ENTER	# INDEX LEFT ALONE AND NO BRANCH
LNOBR		TC	RE-ENTER

TIXBR		INDEX	TAG1
		TS	38D
		CS	POLISH
		TC	DOBR2

INCR		TC	TAG
		CS	POLISH
		INDEX	TAG1
		AD	38D
		TC	XSTORE

XCHX		TC	TAG
		INDEX	ADDRWD
		XCH	0
		INDEX	TAG1
		XCH	38D
		TC	STOR1

XSU		TC	TAG		# INDEX REGISTER SUBTRACT FROM ERASABLE
		INDEX	ADDRWD
		CS	0
		TC	INCR +2

XAD		TC	TAG		# INDEX REGISTER ADD FROM ERASABLE
		INDEX	ADDRWD
		CS	0
		COM
		TC	INCR +2

## Page 73

VDEF		CAF	ZERO
		AD	VACLOC		# USES MPAC AS V0, PUSHES UP FOR V1, AND
		TS	TEM2		# PUSHES UP AGAIN FOR V2. THE RESULTING
		CAF	DAD2 +4		# VECTOR IS LEFT IN VAC
		TC	8TO2
		TC	INCRT2
		TC	PUSHUP1
		TC	8TO2
		TC	INCRT2
		TC	PUSHUP1
		TC	8TO2
		TC	ZEROEXIT	# T0 DECLAIN MO45 IS VECTOR

ITA1		CCS	CYR
		TC	+6		# FOR ITA
		TC	CCSHOLE
		INDEX	ADDRWD		# PICK UP ADDRESS
		CS	0
		COM
		TC	DOBR2		# AND DO THE BRANCH

 +6		INDEX	FIXLOC
		CS	QPRET
		TC	SXA +3		# COMPLEMENT AND DEPOSIT

EXIT		CCS	CYR		# RETURN TO BASIC
		TC	EXIT2		# EXIT.

		TC	CCSHOLE

		CS	POLISH		# HERE TO RETURN TO BASIC AT X
		TC	SWCALL

SIGN		INDEX	ADDRWD		# AFFIX SIGN OF X TO MPAC OR VAC
		CCS	0		# MUST BE NON-ZERO
		TC	DANZIG
		TC	+2		# EXAMINE MINOR PART
		TC	COMP		# COMPLEMENT VECTOR OR SCALAR.

		INDEX	ADDRWD
		CCS	1
		TC	DANZIG
		TC	DANZIG		# NO OPERATION IF C(ADDRWD,ADDRWD+1) = 0
		TC	COMP
		TC	DANZIG

## Page 74

VSQ		CS	VACLOC		# TAKE SQUARE OF LENGTH OF VECTOR IN VAC.
		COM
		TS	ADDRWD
		TC	DOT1 +1		# FINISH IN DOT PRODUCT ROUTINE.

		AD	ONE		# FROM TRUE2

SHIFTR		XCH	Q
		TS	TEM5		# SHIFT TP MPAC RIGHT ACCORDING TO INTEGER
		CCS	Q		# PICK UP COUNT, SUBTRACTING ONE
 +3		AD	NEG13		# RETURNS HERE FROM SR14
		CCS	A
		AD	ONE		# SHIFT COUNT MORE THAN 14 - DECREMENT BY
		TC	SR14		# 14 AND EXCHANGE
		TC	+2		# REMAINING SHIFT COUNT BETWEEN 1 AND 13
		TC	SR14		# MULTIPLES OF 14 END UP HERE
		COM
		INDEX	A		# PICK UP PROPER SHIFTING BIT
		CAF	BIT2
		TC	SHORTMP		# DO SHIFT BY MULTIPLICATION
		TC	TEM5		# (TEM5 CONTAINS SQRT RETURN IF SQRT CALL)

SR14		XCH	MPAC		# SAVE REDUCED COUNT
		XCH	MPAC +1
		XCH	MPAC +2
		CAF	ZERO
		XCH	MPAC		# NOW BRING IT BACK
		CCS	A		# SEE IF REMAINING COUNT IS ZERO
		TC	SHIFTR +3	# NON-ZERO - BACK TO SHIFT LOOP
		TC	TEM5		# FINISHED

## Page 75

ABVAL1		TC	ABVAL
		TC	DPEXIT		# MODE IS NOW DP

ABVAL		XCH	Q		# TAKES HALF THE LENGTH OF THE VECTOR IN
		TS	TEM10		# VAC
		TC	VSR1		# SHIFT VECTOR RIGHT ONE
		TC	DOT2		# TAKE THE SQUARE OF ITS LENGTH
		CS	FOUR		# STORE SQUARE OF LENGTH IN REGISTERS 28
		AD	VACLOC		# AND 29 OF VAC AREA.
		TC	STORDAC
		TC	MPACCOM
		TC	SQRT3		# TAKE A TRIPLE-PRECISION SQRT (DP ANSWER)
		TC	TEM10		# AND EXIT

VSR1		XCH	Q		# SUBROUTINE WHICH SHIFTS VECTOR IN VAC
		TS	TEM9		# RIGHT ONE PLACE, USED BY ABVAL AND UNIT
		CAF	FOUR
		AD	VACLOC		# USED BY ABVAL AND UNIT
		TC	SR1		# VECTOR IS SHIFTED RIGHT SO DOT PRODUCT
		XCH	TEM11		# WONT OVERFLOW.
		AD	MINUS2
		TC	SR1
		XCH	TEM11
		AD	MINUS2
		TS	ADDRWD		# FOR THE DOT ROUTINE.
		TC	SR1		# VECTOR IS NOW SHIFTED RIGHT

		TC	TEM9

SSM		TC	BRANCH		# SET SIGN OF MPAC,MPAC+1 MINUS, USED BY
		TC	MPACCOM		# SIGN INSTRUCTION
		TC	DANZIG
		TC	DANZIG

SSP		TC	BRANCH
		TC	DANZIG
		TC	DANZIG
		TC	MPACCOM
		TC	DANZIG

## Page 76

SQUARE		CAF	BUGMPAC		# SQUARE MPAC AND LEAVE RESULT IN MPAC, +2
		TC	DSQ2		# CONTINUE AS IN DMP.

COMP		CS	MODE
		DOUBLE
		INDEX	A
		TC	+1
		TC	VACCOM
		TC	DANZIG
		TC	MPACCOM		# FOR TP
		TC	DANZIG
		TC	-2

SMOVE		CAF	ZERO
		TS	MPAC +1
		TC	DANZIG

NEXT		CCS	CYR		# NEXT AND ITCQ OPERATORS
		CCS	ADRLOC		# NEXT - KNOCK DOWN ADRLOC BY ONE
		TC	+4		# AND BEGIN NEXT EQUN IMMEDIATELY
		INDEX	FIXLOC		# ITCQ - PICK UP QPRET AND BRANCH
		XCH	QPRET
		TC	DOBR2

 +4		TS	ADRLOC
		CAF	ONE		# TURN ON LOAD INDICATOR
		TC	SWLODIND

NOLOAD		CCS	ADRLOC		# NOLOD AND ROUND OPERATORS. DECREMENT
		TS	ADRLOC		# ADRLOC SINCE WE SHOULDNT HAVE TAKEN AN
		CCS	CYR		# ADDRESS. SEE IF NOLOD OR ROUND
		CAF	ZERO		# NOLOD - SET NEWEQIND TO ZERO
		TC	+4
		CS	ONE		# MODE IS NOW DP
		TS	MODE
		TC	MPACRND		# GO ROUND MPAC AND RETURN TO DANZIG

SWLODIND	TS	NEWEQIND
		TC	DANZIG

## Page 77

SL1		XCH	MPAC +2		# ROUTINE WHICH SHIFTS TRIPLE ACCUMULATOR
		DOUBLE			# LEFT ONE PLACE. IT IS USED BY TSLT AND
		TS	MPAC +2		# TSLC
		CAF	ZERO
		AD	MPAC +1
		AD	MPAC +1
		TS	MPAC +1
		CAF	ZERO
		AD	MPAC
		AD	MPAC
		TS	MPAC
		TC	Q
		TS	OVFIND		# SET OVFIND IF ENTIRE WORD OVERFLOWS
		TC	Q

SHIFTL		TC	TRUE2		# TP LEFT SHIFT - GET INTEGER ADDRESS
		TC	+3
LEFTLOOP	TS	ADDRWD
		TC	SL1
 +3		CCS	ADDRWD
		TC	LEFTLOOP
		TC	DANZIG

TSLC		CAF	ZERO		# NORMALIZATION - START BY SETTING COUNT
		TS	TEM2		# TO ZERO
		TC	BRANCH
		TC	+2
		TC	SLCANS

RETRN		CS	MPAC		# HERE FOR NON-ZERO
		DOUBLE
		OVSK			# SKIP ON OVERFLOW
		TC	+2		# NO OVERFLOW - SHIFT AGAIN
		TC	SLCANS		# DONE - WE OVERFLOWED
		XCH	TEM2
		AD	ONE
		TS	TEM2
		TC	SL1		# DO THE SHIFT
		TC	RETRN		# AND LOOP

SLCANS		CS	TEM2		# STORE COMPLEMENT OF COUNT
		INDEX	ADDRWD
		TS	0
		TC	DANZIG

## Page 78

SWITCHEM	CS	POLISH		# SWITCH AND TEST INSTRUCTIONS.
		TS	ADDRWD		# DECOMPOSE ADDRESS INTO SWITCH WORD AND
		MASK	SBITMASK	# BIT. MULTIPLES OF 16 ARE EXCLUDED.
		XCH	ADDRWD
		EXTEND
		MP	BIT11
		TS	TEM8		# 0, 1, OR 2.

		INDEX	ADDRWD		# PICK UP A 1 IN SPECIFIED SWITCH POS.
		CAF	BIT15 -1	# SWITCHES ARE NUMBERED 1 - 15 D.
		TS	TEM4
		INHINT
		INDEX	TEM8
		MASK	STATE		# GET BS WHERE B IS BIT AND S IS *STATE*
		TS	TEM5		#  - THE WORD CONTAINING THE 15 SWITCHES

		CCS	CYR		# DECIDE WHETHER INST. IS *SWITCH* OR TEST
		TC	INCADR		# TO PICK UP NEXT ADDRESS
		TC	+3
		CS	TEM4
		TC	SWITCHIT	# SWITCH BIT.

		RELINT
		CCS	TEM5		# TEST SWITCH
		TC	RE-ENTER	# IT WAS ON - DONT BRANCH
		TC	SWF/F		# OFF - GO TO FIXED-FIXED TO PICK UP ADR.
		TC	RE-ENTER	# COMES HERE IF BIT 15 WAS ON

SWITCHIT	INDEX	TEM8		# WE DESIRE THE LOGICAL EXCLUSIVE OR OF B
		MASK	STATE
		TS	Q		# SET THIS BIT TO OSO AD IS OR.
		INDEX	TEM8
		CS	STATE
		MASK	TEM4		# COMPLEMENT OF SWITCH BIT.
		AD	Q		# OR
		INDEX	TEM8
		TS	STATE
		RELINT
		TC	RE-ENTER	# DONT PUSH-DOWN IF AT END.

## Page 79

VSLT2		TS	MPAC +1		# SET TO ZERO IN CASE OF RIGHT SHIFT.
		TC	TRUE2		# RETURNS TO CALLER IF COUNT PNZ.

		TC	VSLTEST
VSLTLOOP	TS	ADDRWD
		CAF	ZERO
		AD	VACLOC
		TS	TEM2
		TC	VSL1
		TC	INCRT2
		TC	VSL1
		TC	INCRT2
		TC	VSL1
VSLTEST		CCS	ADDRWD
		TC	VSLTLOOP
		TC	DANZIG

VSL1		INDEX	TEM2
		XCH	1
		DOUBLE
		INDEX	TEM2
		TS	1
		CAF	ZERO
		INDEX	TEM2
		AD	0
		INDEX	TEM2
		AD	0
		INDEX	TEM2
		TS	0
		TC	Q
		TS	OVFIND
		TC	Q

## Page 80

# DOUBLE-PRECISION SINE-COSINE ROUTINES.
#
# THESE PROGRAMS ARE ENTERED AND EXIT IN THE INTERPRETIVE MODE, WITH
# THE ARGUMENT IN MPAC AT ENTRY AND THE ANSWER IN MPAC AT EXIT.  THEY
# COMPUTE, RESPECTIVELY, (1/2) COS (PI X)  AND  (1/2) SIN (PI X) WHERE
# X = C(MPAC) RANGES OVER THE INTERVAL (-1, +1).
#
# PROGRAM USES THE SERIES
#                             3       5       7        9
# (1/2) SIN(PI X) = C X + 4C X + 16C X + 64C X + 256C X .
#                    1      3       5       7        9
# WHERE THE C COEFFICIENTS ARE FROM HASTINGS SERIES
#                        3     5     7     9
# SIN(PI X/2) = C X + C X + C X + C X + C X .
#                1     3     5     7     9

COSINE		XCH	Q		# CLOSED COSINE ROUTINE
		TS	TEM8
		TC	TSGNABS		# FORM 1/2 - (ABS(X)) AND COMPUTE SINE
		TC	DACCOM+
		TC	SINE +2

SINE		XCH	Q		# CLOSED SINE ROUTINE
		TS	TEM8
		TC	PARTSL1		# DOUBLE ARGUMENT
		TS	MPAC
		TC	+2		# IF DIDNT SKIP
		TC	DACCOM		# IF SO, WE WANT -SIN(X) = SIN(-X)

		CS	MPAC
		TS	VBUF +2		# SAVE NEGATIVE OF ARGUMENT
		TS	TEM2
		DOUBLE
		TS	Q
		TC	SN1		# IF ABS(X) LESS THAN 1/2

		INDEX	A		# CONTAINS +-1
		CS	NEG1/2 +1
		XCH	TEM2
		AD	TEM2
		AD	TEM2		# (ADD +-1/2 TWICE TO MAKE +-1.0)
		TS	MPAC
		CS	MPAC +1
		TS	MPAC +1
		CS	MPAC
		TS	VBUF +2

## Page 81

SN1		CS	MPAC +1		# SAVE REST OF ARGUMENT
		TS	VBUF +3
		CAF	BUGMPAC		# ADDRESS OF MPAC WITH MP BITS
		TS	TEM4
		CAF	DAD2 +4		# SQUARE MPAC
		TC	DMP1
		TC	TCS1 +2

		TC	POLY
		DEC	8
		2DEC	-0.3926990796	# 	(   C /4)
					#	     1

		2DEC	+0.6459637111	# 	(  4C /4)
					#	     3

		2DEC	-0.318758717	#	( 16C /4)
					#	     5

		2DEC	+0.074780249	#	( 64C /4)
					#	     7

		2DEC	-0.009694988	#	(256C /4)
					#	     9

		TC	DMP		# DMP BY X
		XCADR	VBUF +2
		TC	SL1		# AND SHIFT LEFT 2
		TC	SL1
		TC	TEM8		# DONE

SIN1		TC	SINE		# INTERPRETER LINKAGE
		TC	DANZIG

COS1		TC	COSINE
		TC	DANZIG

## Page 82

ARCSIN		CAF	TCTAG+1		# PICK UP ARCSIN BRANCH
		AD	POSMAX		# TO FORCE OVERFLOW
		OVSK			# SKIP AND RESTORE NON-OVERFLOW

ARCCOS		CAF	TCEX		# SET ARCCOS SWITCH
		XCH	ESCAPE		# NO SKIP, PLEASE
		XCH	Q		# ONLY HAVE TO SAVE Q IN ONE PLACE
		TS	ARETURN
		TC	TPAGREE		# FORCE SIGN AGREEMENT SO WE CAN CHECK
		CCS	A		# SIZE OF ARGUMENT (SIGNUM RETURNS IN A).
		TC	ACOSST		# POSITIVE
		TC	+2		# ARCCOS = PI/2
		TC	NEGARGU

		CAF	QUARTER		# ARCCOS(0) = .25(2PI).
		TS	MPAC		#  (MPAC +1 IS ALREADY ZERO).
		TC	ESCAPE

ACOSST		TC	PARTSL1		# DOUBLE ARGUMENT
		XCH	MPAC		# NO SKIP, BUT EXAMINE ORIGINAL MPAC
		AD	NEG1/2		# MUST BE LESS THAN OR EQUAL TO 1/2
		CCS	A
		TC	ABORT		# MAJOR PART GREATER THAN 1/2. NOTE THAT
		OCT	01301		# MPAC+1 IS NOT CHECKED SO A MARGIN EXISTS

		TC	+4		# NORMAL CASE
		TS	MPAC		# ARGUMENT WAS 1 (SCALED). LEAVE ZERO
		TS	MPAC +1		# AS RESULT AND EXIT
		TC	ESCAPE

## Page 83

 +4		CS	MPAC +1
		TS	MPAC +1
		TS	B +1
		CS	MPAC
		TS	B
		AD	HALF
		AD	HALF
		TS	MPAC		# SQRT ARGUMENT IS NOW READY

		TC	+6		# NORMAL PATH.

		CAF	POSMAX		# WE HAVE FALSE OVERFLOW PRESENT AND IT
		TS	MPAC		#  MUST BE CORRECTED. MAJOR PART WAS ZERO
		AD	MPAC +1		#  AND MINOR PART PNZ, SO FORM 1.0 - MPAC
		AD	ONE		#  PROPERLY FOR THIS CASE.
		TS	MPAC +1		# GUARANTEED NO OVERFLOW.

 +6		TC	SQRT2		# GO TAKE THE SQUARE ROOT.

		CS	B +1
		XCH	MPAC +1
		TS	B +1
		CS	B
		XCH	MPAC
		TS	B
## Page 84
		TC	POLY		# EVALUATE HASTINGS POLYNOMIAL/2PI
		DEC	14
		2DEC*	 .4999999920 B-1*	# HASTINGS COEFFICIENTS/2PI
		2DEC*	-.0683089201 B-1*
		2DEC*	 .0283228913 B-1*
		2DEC*	-.0159709772 B-1*
		2DEC*	 .0098331911 B-1*
		2DEC*	-.0054393193 B-1*
		2DEC*	 .0021231556 B-1*
		2DEC*	-.0004018634 B-1*

		TC	DMP		# INTERPRETER SUBROUTINE ONLY
		XCADR	B
		TC	ESCAPE		# GO TO ARCSIN/ARCCOS SWITCH (OR NEGARGU)

TAGIT		TC	DACCOM+
		TC	ARETURN
PARTSL1		XCH	MPAC +1		# DOES A DOUBLE SHIFT LEFT EXCEPT FOR THE
		DOUBLE			# FINAL TS. USED BY SIN, COS, ASIN, AND
		TS	MPAC +1		# ACOS.
		CAF	ZERO
		AD	MPAC
		AD	MPAC
		TC	Q		# POSSIBLY WITH OVERLOW PRESENT

NEGARGU		TC	DACCOM		# ARCCOS(-X)=PI-ARCCOS(X)
		CAF	TCSUBTR		# SET SWITCH TO PERFORM ABOVE
		XCH	ESCAPE
		TS	ESCAPE2		# ADDITIONAL SWITCH HERE.
		TC	ACOSST

## Page 85

SUBTR		CS	MPAC
		AD	HALF
		TS	MPAC
		CS	MPAC +1
		TS	MPAC +1
		TC	ESCAPE2		# THIS IS NOW THE ARCSIN/ARCCOS SWITCH



TCTAG+1		TC	TAGIT +1
TCEX		EQUALS	TCTAG+1
TCSUBTR		TC	SUBTR

ARCSIN1		TC	ARCSIN
		TC	DANZIG

ARCCOS1		TC	ARCCOS
		TC	DANZIG

DACCOM+		CS	MPAC +1		# USED BY SIN-COS AND ARCSIN-ARCCOS
		TS	MPAC +1
		CS	MPAC
		AD	QUARTER
		TS	MPAC
		TC	Q

## Page 86

MBXCH		XCH	BUF		# TO EXCHANGE MPAC AND BUF
		XCH	MPAC
		TS	BUF
		XCH	BUF +1
		XCH	MPAC +1
		TS	BUF +1
		TC	Q

DDV0		TS	MPAC +2		# SET MPAC+2 TO ZERO TO RESUME DDV
		TC	TSGNABS		# SIGN AGGREMENT ETC
		TS	TEM2		# SAVE SGN
		TC	MBXCH		# SWITCH CONTENTS
		TC	TSGNABS		# SAME FOR ARGUMENT
		AD	TEM2
		CCS	A		# TO GET SIGN OF RESULT
		TC	+3
		TC	DPDOFLO +1	# HERE FOR 0/0 CASE
		TC	+1
		TS	TEM2
		CCS	DVSW
		TC	MBXCH		# INTERCHANGE OLD DIVISOR AND DIVIDEND

		CS	BUF		# CHECK TO SEE IF C(BUF,BUF+1) LESS
		AD	MPAC		# THAN C(MPAC,MPAC+1). OVERFLOW CONDITION
		CCS	A		# IF NOT
		TC	DDVOK		# SCALING OK
		TC	CCSHOLE
		TC	DPDOFLO		# TROUBLE HERE
		CS	BUF +1		# CHECK MINOR PARTS IF MAJORS EQUAL
		AD	MPAC +1
		CCS	A
		TC	DDVOK
		TC	CCSHOLE
		TC	DPDOFLO		# TROUBLE HERE
		TC	DPDOFLO		# AS WELL AS WHEN C(BUF,BUF+1)=C(MPAC,+1)

DDVOK		CAF	ZERO
		AD	MPAC
		TC	DPDNORT		# TO NORMALIZE

## Page 87

SQRTDIV		XCH	Q		# ENTRY FROM SQRT ROUTINE
		TS	TEMQ3
		TC	DVSTART

DPDNORM		XCH	BUF +1
		DOUBLE
		TS	BUF +1
		CAF	ZERO
		AD	BUF
		AD	BUF
		TS	BUF
		TC	SL1 +3		# TO DOUBLE MPAC

DPDNORT		TS	CYL		# TO LOOK AT BIT 14
		CCS	CYL
		TC	DPDNORM
		TC	+2
		TC	DVSTART
		XCH	BUF +1		# HIGH ORDER ZERO
		XCH	BUF
		XCH	MPAC +1		# SET MPAC +1 TO ZERO
		TS	MPAC
		TC	DPDNORT		# AND TRY AGAIN

## Page 88

DVSTART		XCH	BUF		# OK
		INDEX	OPOVF
		DV	MPAC
		TS	OVCTR
		INDEX	OPOVF
		MP	MPAC +1
-1/2+2		AD	Q		# COMPLIMENT OF REMAINDER.
		CS	A
		AD	BUF +1
		OVSK
		TC	+3		# IF NOT
		INDEX	OPOVF		# IF OVERFLEW
		SU	MPAC
 +3		TS	BUF
		CCS	A
		AD	ONE
		TC	+2
		AD	ONE
 +2		EXTEND			# WE NOW HAVE ABS(CORRECT BUF)
		SU	MPAC
		CCS	A
		AD	ONE
		TC	+2
		TC	+4
 +2		XCH	BUF
		DOUBLE
		CCS	A
 +4		XCH	BUF
		TC	+2
		CS	BUF
		INDEX	OPOVF
		DV	MPAC

## Page 89

DPDSGNT		TS	MPAC +1
		CCS	TEM2
		TC	POSQUOT
		CS	MPAC +1
		TS	MPAC +1
		CS	OVCTR
		TS	MPAC
		TC	TEMQ3

POSQUOT		XCH	OVCTR
		TC	-3

DPDOFLO		CCS	TEM2
		CAF	TWO
		AD	NEG1
		TS	OVFIND
		EXTEND			# SET MPAC = +- POSMAX
		MP	POSMAX
		XCH	LP
		TS	MPAC +1
		TC	POSQUOT -2

## Page 90

TSGNABS		XCH	Q		# SIGNUM AND ABSOLUTE VALUE
		TS	TEMQ2
		TC	TPAGREE

		CCS	A		# TEST SIGNUM
		AD	ONE
		TC	TEMQ2

		TC	MPACCOM		# COMPLEMENT IF NEGATIVE
		CS	ONE
		TC	TEMQ2

TPAGREE		XCH	Q		# FORCE SIGN AGREEMENT IN TP WORD IN MPAC
		TS	TEMQ
		TC	BRANCH
		TC	SGN=+
		TC	SGN=0

		CS	POSMAX
		TS	SGNDMAX
		CS	ONE
		TC	SGFORCE

SGN=0		CAF	ZERO
		TS	MPAC
		TS	MPAC +1
		TS	MPAC +2
		TC	TEMQ

SGN=+		CAF	POSMAX
		TS	SGNDMAX
		CAF	ONE

## Page 91

SGFORCE		AD	MPAC +2
		AD	SGNDMAX
		TS	MPAC +2
		CAF	ZERO

		AD	MPAC +1
		AD	SGNDMAX
		TS	MPAC +1
		CAF	ZERO

		AD	MPAC
		AD	SGNDMAX
		TS	MPAC
SBITMASK	OCT	17
		TC	TEMQ

## Page 92

UNIT		TC	ABVAL		# UNIT VECTOR ROUTINE - START BY GETTING
					# LENGTH
		TC	VSR1		# LEAVES 1/2 UNIT VECTORS

		CCS	NEWJOB		# ALLOW FOR INTERRUPTS
		TC	UNITRUPT	# SO WE CAN RETURN IN BASIC

UNITRSM		AD	VACLOC		# RETURNS HERE FROM BREAKPOINT IF CALLED.
		TS	ADDRWD
		CAF	TWO
		TS	DVSW		# NON-ZERO FOR BACKWARDS DIVIDE
UNITLOOP	TS	COMPON
		CS	MPAC
		CS	A
		INDEX	ADDRWD
		XCH	0		# LENGTH TO COMPONENT AND COMPONENT TO BUF
		TS	BUF
		CS	MPAC +1
		CS	A
		INDEX	ADDRWD
		XCH	1
		TS	BUF +1

		CAF	+4		# CALL BACKWARDS DIVIDE
		TS	TEMQ3
		CAF	ZERO
		TC	DDV0
		TC	+1

		XCH	MPAC		# RESULT BACK TO COMPONENT BRINGING BACK
		INDEX	ADDRWD		# LENGTH
		XCH	0
		TS	MPAC
		XCH	MPAC +1
		INDEX	ADDRWD
		XCH	1
		TS	MPAC +1

		TC	AD2		# INCREMENT ADDRWD
		CCS	COMPON
		TC	UNITLOOP
		CS	TWO		# STORE LENGTH OF ARGUMENT IN REGISTERS 30
		AD	VACLOC
		TS	TEM2		# AND 31 OF VAC AREA.
		CAF	DAD2 +4
		TC	8TO2
		TC	DANZIG

## Page 93

UNITRUPT	CS	BANKSET		# REQUESTS FOR INTERPRETIVE INTERRUPT
		TS	MPAC +2		# COME HERE DURING THE UNIT OPERATION.
		XCH	LOC		# SINCE WE DESIRE TO RETURN IN BASIC BUT
		INDEX	FIXLOC		# BUT STILL SAVE THE INTERPRETER CENTRALS
		TS	30D		# (BANKSET AND LOC)
		TC	CHANG1

		CS	MPAC +2		# ON RETURN, RESTORE AS BEFORE
		TS	BANKSET
		INDEX	FIXLOC
		XCH	30D
		TS	LOC
		CAF	ZERO
		TC	UNITRSM		# ENTER UNIT DIVIDE LOOP.
MPACSR1		CAF	DAD2 +4

SR1		TS	TEM11		# SHIFTS RIGHT ONE USING ADDRESS IN A
		INDEX	A
		XCH	0
		INDEX	OPOVF
		MP	HALF
		INDEX	TEM11
		TS	0
		INDEX	TEM11
		XCH	1
		TS	SR
		XCH	SR
		AD	LP
		INDEX	TEM11
		TS	1
		TC	Q

## Page 94

SQRT2		CAF	ZERO		# ENTRY TO IGNORE C(MPAC+2)
		TS	MPAC +2

SQRT3		XCH	Q		# HERE TO TREAT TRIPLE-PRECISION CASES
		TS	TEMQ2
		TC	TPAGREE		# FORCE SIGN AGREEMENT
		CCS	A		# TEST SIGNUM
		TC	SETNORM		# PNZ - OK.
		TC	TEMQ2		# FAST EXIT FOR ZERO ARGUMENT
		CCS	MPAC		# IF ARGUMENT WAS NEGATIVE BUT MAJOR PART

		TC	ABORT		# (MPAC IS NEGATIVE) IS ZERO, ANSWER IS 
		OCT	01302		# TAKEN AS ZERO WITH NO FURTHER ACTION.
		TC	-2		# IF NON-ZERO, IT IS ASSUMED A TRANSIENT
					# ERROR HAS PRODUCED THE BAD DATA.

		TS	MPAC +1		# ARGUMENT NEGATIVE BUT MORE THAN -10-4.
		TC	TEMQ2		# SET MPAC,+1 TO ZERO AND EXIT.

SETNORM		TS	ADDRWD		# SET NORMALIZATION COUNT TO ZERO
		CS	MPAC
		TS	CYL		# WE WILL USE A/2, SO MUST CHECK FOR
		CCS	CYL		# NORMALIZATION FIRST
		TC	MPACSR1		# NORMALIZED - SHIFT RIGHT ONE.
		TC	ARGHI

		TC	SRTEST		# LESS THAN 1/2 - SEE IF AT LEAST 1/8.

		TC	A0=0		# MAJOR PART (POSSIBLY MINOR PART) = 0.

SRTEST		AD	-1/2+2		# SEE IF ARG GREATER THAN OR EQUAL TO 1/4.
		CCS	A
		TC	MPACSR1		# IT IS - SHIFT RIGHT ONE AND GO TO ARGLO.
		TC	ARGLO		# (+0 WAS IMPOSSIBLE THIS CCS.)

		TC	SQRTNORM +1	# LESS THAN 1/4 - PUT IN EFFECTIVE RIGHT
					# BY SHIFTING LEFT ONLY ONCE WHEN ADDING
					# ONE TO THE RIGHT SHIFT COUNT.

## Page 95

A0=0		XCH	MPAC +2		# MOVE ARGUMENT UP
		XCH	MPAC +1
		XCH	MPAC
		AD	ADDRWD
		AD	SEVEN		# INCREASE SHIFT COUNT BY 14/2 = 7
		TC	SETNORM

SQRTNORM	TC	SL1
		CAF	ONE		# ARGUMENT LESS THAN 1/8, SO SHIFT IT LEFT
		AD	ADDRWD		# TWO PLACES AND INCREASE SHIFT COUNT FOR
		TS	ADDRWD		# RESULT
		TC	SL1
		TS	CYL
		CS	CYL

## Page 96

NORMTEST	CCS	CYL
		CCS	CYL
		TC	SQRTNORM	# HERE IF LESS THAN 1/8
		TC	ARGHI		# HERE IF AT LEAST 1/4, LESS THAN 1/2

ARGLO		CAF	SLOPELO		# HERE IF AT LEAST 1/8, LESS THAN 1/4
		INDEX	OPOVF
		MP	MPAC
		AD	BIASLO		# X0/2 = .8324(A0/2) + .2974/2
		TC	ARGHI +4

SLOPELO		DEC	.8324
BIASLO		DEC	.2974 B-1
SLOPEHI		DEC	.5884
BIASHI		DEC	.4192 B-1

ARGHI		CAF	SLOPEHI
		INDEX	OPOVF
		MP	MPAC
		AD	BIASHI
 +4		XCH	MPAC		# X0/2 TO MPAC
		TS	BUF		# A0/2 TO BUF
		TS	TEM2		# SET UP POSITIVE QUOTIENT SIGNAL AND
		CAF	ZERO
		XCH	MPAC +1		# ZERO LOW-ORDER DIVIDEND FOR DP DIVIDE
		TS	BUF +1		# A1/2 TO BUF+1. A2 NOW DISCARDED
		CS	BUF
		INDEX	OPOVF
		DV	MPAC		# -(A0/2)/(X0/2).
		TS	SR
		CS	SR
		AD	MPAC		# X1 IS GOOD TO 14 BITS
		TS	MPAC		# X1 = X0/2 + ((A0/2)/(X0/2))/2
		TS	TEM3		# SAVE X1 FOR ADDITION
		TC	SQRTDIV		# GO TO FORM DP QUOTIENT OF A0/2, A1/2
		XCH	TEM3		# OVER X1, 0. RESULT IN MPAC, MPAC +1
		INDEX	OPOVF
		MP	HALF
		AD	MPAC
		TS	OVCTR		# AND MAYBE SKIP, IF ARG WAS NEAR POSMAX
## Page 97
		TC	+4		# IF NO OVERFLOW
		CAF	POSMAX
		TS	MPAC +1
		TC	+5

 +4		XCH	LP		# FOR NORMAL CASES
		AD	MPAC +1		# ABOVE AND X1/2
		XCH	MPAC +1
		XCH	OVCTR
 +5		TS	MPAC

		CAF	ZERO		# ZERO MPAC+2 SO SHIFT LEFT MAKES SENSE.
		TS	MPAC +2

		CCS	ADDRWD		# RE-NORMALIZE IF COUNT NON-ZERO
		TC	SHIFTR +3	# FITS IN WITH MAIN SHIFT LOOP
		TC	TEMQ2		# NO RE-SCALING REQUIRED

SQRTS		CS	MODE		# INTERPRETER LINKAGE
		DOUBLE			# TAKE APPROPRIATE SQRT
		INDEX	A
		TC	-1

		TC	SQRT2		# FOR DP
		TC	DANZIG

		TC	SQRT3
		TC	DANZIG

NEG13		EQUALS	MINUS13
DMOVE		EQUALS	DANZIG		# LOADING ONLY
VMOVE		EQUALS	DANZIG
TMOVE		CS	TWO		# SET MODE TO TRIPLE FOR TP OPERATIONS
		TC	DPEXIT +1
