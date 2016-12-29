### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ALARM_AND_DISPLAY_PROCEDURES.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
## Mod history:	2009-09-15 JL	Created.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.

## Page 293

# 	THE FOLLOWING SUBROUTINE MAY BE CALLED TO DISPLAY A NON-ABORTIVE ALARM CONDITION. IT MAY BE CALLED
# EITHER IN INTERRUPT OR UNDER EXECUTIVE CONTROL.
#
#	CALLING SEQUENCE IS AS FOLLOWS:
#
#	TC	ALARM
#	OCT	AAANN		ALARM NO. NN IN GENERAL AREA AAA.
#				(RETURNS HERE)

		BANK	1
ALARM		INHINT
		XCH	Q
		TS	ITEMP1

		CCS	FAILREG		# SEE IF ONE FAILURE HAS OCCURRED SINCE
					#  THE LAST ERROR RESET.
		TC	MULTFAIL	# YES - INDICATE MULTIPLE FAILURES.
		TC	NEWALARM	# FIRST SINCE RESET.
MULTEXIT	XCH	ITEMP1		# FREE ITEMP1 BEFORE RELINT.

ENDALARM	RELINT
		INDEX	A
		TC	1		# RETURN TO CALLER.

MULTFAIL	AD	CSQ		# BIT 15 = 1 INDICATES MULTIPLE FAILURES.
		TS	FAILREG		# CSQ = BIT15 + BIT1.
		TC	MULTEXIT

NEWALARM	XCH	ITEMP1		# SAVE RETURN ADDRESS FOR CALL TO NOVAC.
		TS	FAILREG

		TC	PROGLARM	# TURN ON THE PROGRAM ALARM LIGHT.

		CAF	PRIO37
		TC	NOVAC
		CADR	DOALARM		# CALL (SEPARATE) JOB FOR DISPLAY.

		INDEX	FAILREG		# (RETURN ADDRESS AT THIS POINT).
		CAF	0
		XCH	FAILREG		# SET FAILREG AND GET BACK RETURN ADDRESS.
NEWALM2		TC	ENDALARM

## Page 294

#	JOB WHICH CALLS NVSUB FOR ALARM DISPLAY.

		BANK	11
DOALARM		TC	GRABDSP		# DISPLAY FAILREG.
		TC	PREGBSY
		CAF	FAILDISP
		TC	NVSUB
		TC	PRENVBSY
		TC	FREEDSP
		TC	ENDOFJOB



		SETLOC	NEWALM2 +1

PROGLARM	CS	ONE		# TURNS ON PROGRAM FAIL LIGHT ON THE
		MASK	OUT1		# PANEL.  CALLED ONLY BY ALARM AND ABORT.
		AD	ONE
		TS	OUT1
		TC	Q

FAILDISP	OCT	00531

## Page 295

#	THE FOLLOWING ROUTINE IS CALLED TO INITIATE AN ABORT. FAILREG IS SET (ACCORDING TO THE MULTIPLE
# FAILURES CONVENTION) AND A RE-START IS INITIATED BY TC-SELF. THIS IS CALLED ONLY UNDER RARE CIRCUMSTANCES.

ABORT		INHINT			# MAY BE CALLED IN INTERRUPT OR UNDER EXEC
		INDEX	Q		# PICK UP FAILURE CODE.
		CAF	0
		TS	ITEMP1

		CCS	FAILREG		# SEE IF THIS IS A MULTIPLE FAILURE.
		TC	SETMULTF	# SET BIT 15 TO INDICATE YES.
		TC	NEWABORT	# FIRST FAILURE.

WHIMPER		TC	WHIMPER		# NOT WITH A BANG...

SETMULTF	AD	CSQ		# RESTORE AND SET BIT15
		TC	+3

NEWABORT	TC	PROGLARM	# FIRST FAILURE - TURN ON ALARM LIGHT.
		XCH	ITEMP1
 +3		TS	FAILREG
		TC	WHIMPER		# UNIVERSAL ABORT LOCATION.

CCSHOLE		XCH	Q
		TS	SFAIL
		TC	ABORT
		OCT	1103

#	MISSION PROGRAM DETECTED FAILURES (ERROR RETURNS TO IMUSTALL, ETC.)

CURTAINS	XCH	Q		# PROGRAM DETECTED FLUSH.
		TC	POSTJUMP
		CADR	THATSALL	# FRESH START AND PROGRAM ALARM.

ENDFAILF	EQUALS
