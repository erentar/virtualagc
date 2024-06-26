### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ORBITAL_INTEGRATION.agc
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

# DELETE
		BANK	13
		SETLOC	ORBITAL
		BANK
		COUNT	11/ORBIT

# DELETE
KEPPREP		LXA,2	SETPD
			PBODY
			0
		DLOAD*	SQRT		# SQRT(MU) (+18 OR +15)		0D	PL 2D
			MUEARTH,2
		PDVL	UNIT		#					PL 8D
			RCV
		PDDL	NORM		# NORM R (+29 OR +27 - N1)	2D	PL 4D
			36D
			X1
		PDVL
		DOT	PDDL		# F*SQRT(MU) (+7 OR +5) 	4D	PL 6D
			VCV
			TAU.		# (+28)
		DSU	NORM
			TC
			S1
		SR1
		DDV	PDDL
			2D
		DMP	PUSH		# FS (+6 +N1-N2) 		6D	PL 8D
			4D
		DSQ	PDDL		# (FS)SQ (+12 +2(N1-N2))	8D	PL 10D
			4D
		DSQ	PDDL*		# SSQ/MU (-2 OR +2(N1-N2))	10D	PL 12D
			MUEARTH,2
		SR3	SR4
		PDVL	VSQ		# PREALIGN MU (+43 OR +37) 	12D	PL 14D
			VCV
		DMP	BDSU		#					PL 12D
			36D
		DDV	DMP		#					PL 10D
			2D		# -(1/R-ALPHA) (+12 +3N1-2N2)
		DMP	SL*
			DP2/3
			0 	-3,1	# 10L(1/R-ALPHA) (+13 +2(N1-N2))
		XSU,1	DAD		# 2(FS)SQ - ETCETRA			PL 8D
			S1		# X1 = N2-N1
		SL*	DSU		# -FS+2(FS)SQ ETC (+6 +N1-N2)		PL 6D
			8D,1
		DMP	DMP
			0D
			4D
		SL*	SL*
			8D,1
			0,1		# S(-FS(1-2FS)-1/6...) (+17 OR +16)
		DAD	PDDL		#					PL 6D
			XKEP
		DMP	SL*		# S(+17 OR +16)
			0D
			1,1
		BOVB	DAD
			TCDANZIG
		STADR
		STORE	XKEPNEW
		STQ	AXC,1
			KEPRTN
		DEC	10
		BON	AXC,1
			MOONFLAG
			KEPLERN
		DEC	2
		GOTO
			KEPLERN

FBR3		LXA,1	SSP
			DIFEQCNT
			S1
		DEC	-13
		DLOAD	SR
			DT/2
			9D
		TIX,1	ROUND
			+1
		PUSH	DAD
			TC
		STODL	TAU.
		DAD
			TET
		STCALL	TET
			KEPPREP

# AGC ROUTINE TO COMPUTE ACCELERATION COMPONENTS.

ACCOMP		LXA,1	LXA,2
			PBODY
			PBODY
		VLOAD
			ZEROVEC
		STOVL	FV
			ALPHAV
		VSL*	VAD
			0 -7,2
			RCV
		STORE	BETAV
		BOF	XCHX,2
			DIM0FLAG
			+5
			DIFEQCNT
		STORE	VECTAB,2
		XCHX,2
			DIFEQCNT
		VLOAD	UNIT
			ALPHAV
		STODL	ALPHAV
			36D
		STORE	ALPHAM
		CALL
			GAMCOMP
		VLOAD	SXA,1
			BETAV
			S2
		STODL	ALPHAV
			BETAM
		STORE	ALPHAM
		BOF	DLOAD
			MIDFLAG
			OBLATE
			TET
		CALL
			LSPOS
		AXT,2	LXA,1
			2
			S2
		BOF
			MOONFLAG
			+3
		VCOMP	AXT,2
			0
		STORE	BETAV
		STOVL	RPQV
			2D
		STORE	RPSV
		BOF	VLOAD
			DIM0FLAG
			GETRPSV
			ALPHAV
		VXSC	VSR*
			ALPHAM
			1,2
		VSU	XCHX,2
			BETAV
			DIFEQCNT
		STORE	VECTAB +6,2
		XCHX,2
			DIFEQCNT
GETRPSV		VLOAD	INCR,1
			RPQV
			4
		CLEAR	BOF
			RPQFLAG
			MOONFLAG
			+5
		VSR	VAD
			9D
			RPSV
		STORE	RPSV
		CALL
			GAMCOMP
		AXT,2	INCR,1
			4
			4
		VLOAD
			RPSV
		STCALL	BETAV
			GAMCOMP
		GOTO
			OBLATE
GAMCOMP		VLOAD	VSR1
			BETAV
		VSQ	SETPD
			0
		NORM	ROUND
			31D
		PDDL	NORM		# NORMED B SQUARED TO PD LIST
			ALPHAM		# NORMALIZE (LESS ONE) LENGTH OF ALPHA
			32D		# SAVING NORM SCALE FACTOR IN X1
		SR1	PDVL
			BETAV		# C(PDL+2) = ALMOST NORMED ALPHA
		UNIT
		STODL	BETAV
			36D
		STORE	BETAM
		NORM	BDDV		# FORM NORMALIZED QUOTIENT ALPHAM/BETAM
			33D
		SR1R	PUSH		# C(PDL+2) = ALMOST NORMALIZED RHO.
		DLOAD*
			ASCALE,1
		STORE	S1
		XCHX,2	XAD,2
			S1
			32D
		XSU,2	DLOAD
			33D
			2D
		SR*	XCHX,2
			0 	-1,2
			S1
		PUSH	SR1R		# RHO/4 TO 4D
		PDVL	DOT
			ALPHAV
			BETAV
		SL1R	BDSU		# (RHO/4) - 2(ALPHAV/2.BETAV/2)
		PUSH	DMPR		# TO PDL+6
			4
		SL1
		PUSH	DAD
			DQUARTER
		PUSH	SQRT
		DMPR	PUSH
			10D
		SL1	DAD
			DQUARTER
		PDDL	DAD		# (1/4)+2((Q+1)/4)	TO PD+14D
			10D
			HALFDP
		DMPR	SL1
			8D
		DAD	DDV
			THREE/8
			14D
		DMPR	VXSC
			6
			BETAV		#		-
		PDVL	VSR3		# (G/2)(C(PD+4))B/2 TO PD+16D
			ALPHAV
		VAD	PUSH		# A12 + C(PD+16D) TO PD+16D
		DLOAD	DMP
			0
			12D		# -
		NORM	ROUND
			30D
		BDDV	DMP*
			2
			MUEARTH,2
		DCOMP	VXSC
		XCHX,2	XAD,2
			S1
			S2
		XSU,2	XSU,2
			30D
			31D
		BOV			# CLEAR OVIND
			+1
		VSR*	XCHX,2
			0 	-1,2
			S1
		VAD
			FV
		STORE	FV
		BOV	RVQ		# RETURN IF NO OVERFLOW
			+1
GOBAQUE		VLOAD	ABVAL
			TDELTAV
		BZE
			INT-ABRT
		DLOAD	SR
			H
			9D
		PUSH	BDSU
			TC
		STODL	TAU.
			TET
		DSU	STADR
		STCALL	TET
			KEPPREP
		CALL
			RECTIFY
		SETGO
			RPQFLAG
			TESTLOOP

INT-ABRT	EXIT
		TC	POODOO
		OCT	20430		# SUB-SURFACE STATE VECTOR

# THE OBLATE ROUTINE COMPUTES THE ACCELERATION DUE TO OBLATENESS.  IT USES THE UNIT OF THE VEHICLE
# POSITION VECTOR FOUND IN ALPHAV AND THE DISTANCE TO THE CENTER IN ALPHAM.  THIS IS ADDED TO THE SUM OF THE
# DISTURBING ACCELERATIONS IN FV AND THE PROPER DIFEQ STAGE IS CALLED VIA X1.

OBLATE		LXA,2	DLOAD
			PBODY
			ALPHAM
		SETPD	DSU*
			0
			RDE,2
		BPL	BOF		# GET URPV
			NBRANCH
			MOONFLAG
			COSPHIE
		VLOAD	PDDL
			ALPHAV
			TET
		PDDL	CALL
			3/5
			R-TO-RP
		STOVL	URPV		# RP/R	B-1	IN PLANETARY COORDINATES
			ZUNIT
		PUSH	CALL		# ZUNIT	B-1	IN PLANETARY COORDL	 AT 00D
			MATRIX
		PDVL			# UZ	B-2	IN INERT COORD		 AT 00D
			XUNIT
		PUSH	CALL		# XUNIT	B-1	IN PLANETARY COORD.	 AT 06D
			MATRIX
		VSL1
		STOVL	32D		# UX	B-1	IN INERT. COORD		 AT 32D
		VSL1
COMTERM		STODL	UZ		# UZ	B-1	IN INERTIAL COORD	 AT 20D
			COSPHI/2	#  '		Z-COMPONENT OF URPV
		DMPR	PDDL		# P	B-6	 ,  3COSPHI/64		 AT 00D
			3/32		#  2
			COSPHI/2
		DSQ	DMPR	
			15/16		#  '                            2
		DSU	PUSH		# P	B-5	 ,(1/2)(15COSPHI -3)	 AT 02D
			3/64		#  3
		DMPR	DMP
			COSPHI/2
			7/12
		SL1R	PDDL
			0D
		DMPR	BDSU
			2/3		#  '				 '    '
		PUSH	DMPR		# P	B-7	 ,(1/3)(7COSPHI P  -4P ) AT 04D
			COSPHI/2	#  4				 3    2
		DMPR	PDDL
			9/16
			2D		#  '				 '    '
		DMPR	BDSU		# P	B-10	 ,(1/4)(9COSPHI P  -5P )
			5/128		#  5				 4    3
		DMP*	DDV		#			     '
			J4REQ/J3,2	#	B-	 ,(J RP/J R)P
                        ALPHAM
                DAD     DMPR*
                        4D              #               2     2  '              '
                        2J3RE/J2,2      #     B  ,(2J RP /J2 R )P  +(2J RP/J2R)P
                DDV     DAD             #            4           5     3        4
                        ALPHAM          #    -        2 '  2         '        '
                        2D              #   (R/R)(J RP P /R + 2J RP P /  + J P )
                VXSC                    #          4    5       3    4  2   2 3
                        ALPHAV          #           4       2  '           -
                STODL   TVEC            #     B-6,(SUM((J /R )P   (COSPHI))UR)
                DMP*    SR1             #          I=2   I     I+1
                        J4REQ/J3,2      #                   '
                DDV     DAD             #        (J RP/J R)P
                        ALPHAM          #          4    3   4
                DMPR*   SR3             #             2    2  '              '
                        2J3RE/J2,2      #       (2J RP /J R )P  +(2J RP/J R)P
                DDV     DAD             #          4     2    4     3    2   3
                        ALPHAM
                VXSC    VSL1            #           4   '        -
                        UZ              #     B-6  SUM(P(COSPHI))UZ
                BVSU                    #          I=2  I
                        TVEC            #   4              I-2   '          -
		STODL	TVEC		# SUM((MU J (RP/R)   )(P   (COSPHI)UR -
			ALPHAM		# I=2      I            I+2
		NORM	DSQ		#             P (COSPHI)UZ))	B-6 	AT 20D
			X1		#              I
		DSQ	NORM
			S1		#         4
		PUSH	BDDV*		# NORMED R  TO 0D
			J2REQSQ,2
		VXSC	BOV
			TVEC
			+1		# (RESET OVERFLOW INDICATOR)
		XAD,1	XAD,1
			X1
			X1
		XAD,1	VSL*
			S1
			0	-22D,1
		VAD	BOV
			FV
			GOBAQUE
                STODL   FV              #  B+16 FOR EARTH , B+20 FOR MOON
                        URPV            #  B-1  X-COMPONENT OF POSITION  IN
                BOF     PUSH            #            PLANETORY COORD.      AT 02D
                        MOONFLAG
                        NBRANCH         #         2
                DSQ     PDDL            #  B-2   X                         AT 04D
                        URPV +2         #  B-1  Y-COMPONENT
                DSQ     DSU
                DMP     VXSC
                        5/8             #          2  2 -
                        ALPHAV          #  B-6  5(Y -X )UR    2  2 -
                VSL3    PDDL            #  B-3             5(Y -X )UR      AT 02D
                VXSC    VAD
                        32D             #        2  2 -   2         -
                PDVL    VXV             #    (5(Y.-X )UR/R ) +(2X/R)UX     AT 02D
                        32D             #     B-1   UX
                        UZ              #     B-2  -UY =(UX * UZ)
                VSL1    VXSC            #     B-3   -(2Y/R)UY
                        URPV +2         #             2  2 -   2        -
                VAD     PUSH            #     B-3 (5(X -Y )UR/R )+(2X/R)UX -(
                DLOAD                   #              -
                        COSPHI/2        #         2Y/R)UY                  AT 02D
                DSQ     PUSH            #     B-2 (Z.COMPONENT)            AT 08D
                DMP     PDDL            #                  2
                        5/8             #     B-5  5COSPHI/2               AT 08D
                SR2     DAD
                        08D
                BDSU    DMP             #                      2
                        D1/32           #     B-5  (1 - 7COSPHI )
                        URPV
                DMP     VXSC
                        5/8
                        ALPHAV          #                         2 -
                VSL5    PDDL            #     B-5 (5X/R)(1-7COSPHI )UR     AT 08D
                DSU     VXSC
                        D1/32
                        32D
                VSL1    VAD             #                         2 -           -
                PDDL    DMP             #     B-5 (5X/R)(1-7COSPHI )UR +(5COSPHI
                        URPV            #        -
                        URPV +4         #     -1)UX                        AT 08D
                DMP     VXSC
                        5/8             #     B-5   5X Y
                        UZ              #             M M
                VSL2    VAD             #                         2 -           2
                PDDL    NORM            #     B-5 (5X/R)(1-7COSPHI )UR +(5COSPHI
                        ALPHAM          #        -          2 -
                        X2              #     -1)UX +(10XZ/R )UZ           AT 08D
                PUSH    SLOAD
                        E32C31RM
                DDV     VXSC
                VSL*    PDVL
                        0 -3,2
                PUSH    SLOAD
                        E3J22R2M
                VXSC    VAD
                VSL*    V/SC
                        0 -27D,1        #     B+16 OR B+20 (J   + C  )
                VAD     BOV             #                    22    31
                        FV
                        GOBAQUE
                STORE   FV
                LXA,2
                        PBODY
NBRANCH		SLOAD	LXA,1
			DIFEQCNT
			MPAC
		DMP	CGOTO
			-1/12
			MPAC
			DIFEQTAB
COSPHIE		DLOAD
			ALPHAV +4
		STOVL	COSPHI/2
			ZUNIT
		GOTO
			COMTERM
MATRIX		VXV	VCOMP
			504LM		# ROUTINE TRANSLATES FROM PLANETARY
		VAD			# TO INERTIAL COORDINATES
		VXM	RVQ
			MMATRIX
DIFEQTAB	CADR	DIFEQ+0
		CADR	DIFEQ+1
		CADR	DIFEQ+2
		
TIMESTEP	BOF	CALL
			MIDFLAG
			RECTEST		# SKIP ORIGIN CHANGE LOGIC
			CHKSWTCH
		BMN
			DOSWITCH
			
RECTEST		VLOAD	ABVAL		# RECTIFY IF
			TDELTAV
		BOV
			CALLRECT
		DSU	BPL		#	1) EITHER TDELTAV OR TNUV EQUALS OR
			3/4		#	   EXCEEDS 3/4 IN MAGNITUDE
			CALLRECT	#
		DAD	SL*		#			OR
			3/4		#
			0 -7,2		#	2) ABVAL(TDELTAV) EQUALS OR EXCEEDS
		DDV	DSU		#	   .01(ABVAL(RCV))
			10D
			RECRATIO
		BPL	VLOAD
			CALLRECT
			TNUV
		ABVAL	DSU
			3/4
		BOV
			CALLRECT
		BMN
			INTGRATE
CALLRECT	CALL
			RECTIFY
INTGRATE	VLOAD
			TNUV
		STOVL	ZV
			TDELTAV
		STORE	YV
		CLEAR
			JSWITCH
DIFEQ0		VLOAD	SSP
			YV
			DIFEQCNT
			0
		STODL	ALPHAV
			DPZERO
		STORE	H		# START H AT ZERO.  GOES 0(DELT/2)DELT.
		BON	GOTO
			JSWITCH
			DOW..
			ACCOMP

CHKSWTCH	STQ	BOF
			ORIGEX
			RPQFLAG
			RPQOK		# MOON POSITION IS AVAILABLE
		DLOAD	CALL
			TET
			LUNPOS		# GET MOON POSITION
		BOF	VCOMP
			MOONFLAG
			+1
		STORE	RPQV

RPQOK		LXA,2	VLOAD		# RESTORE X2 AFTER USING LUNPOS
			PBODY
			TDELTAV		#  -
		VSL*	VAD		# |RQC|-RSPHERE WHEN OUTSIDE THE SPHERE.
			0	-7,2	# -   -            -
			RCV		# R = RDEVIATION + RCONIC
		BOF	ABVAL
			MOONFLAG
			EARSPH
		SR2	BDSU		# INSIDE
			RSPHERE
		GOTO	
			ORIGEX
EARSPH		VSU	ABVAL		# OUTSIDE
			RPQV
		DSU	GOTO
			RSPHERE
			ORIGEX
			
DOSWITCH	CALL
			ORIGCHNG
		GOTO
			INTGRATE

ORIGCHNG	STQ	CALL
			ORIGEX
			RECTIFY
		VLOAD	VSL*
			RCV
			0,2
		VSU	VSL*
			RPQV
			2,2
		STORE	RRECT
		STODL	RCV
			TET
		CALL
			LUNVEL
		BOF	VCOMP
			MOONFLAG
			+1
		PDVL	VSL*
			VCV
			0,2
		VSU
		VSL*
			0 +2,2
		STORE	VRECT
		STORE	VCV
		LXA,2	SXA,2
			ORIGEX
			QPRET
		BON	GOTO
			MOONFLAG
			CLRMOON
			SETMOON
# THE RECTIFY SUBROUTINE IS CALLED BY THE INTEGRATION PROGRAM AND OCCASIONALLY BY THE MEASUREMENT INCORPORATION
# ROUTINES TO ESTABLISH A NEW CONIC.

RECTIFY		LXA,2	VLOAD
			PBODY
			TDELTAV
		VSL*	VAD
			0 	-7,2
			RCV
		STORE	RRECT
		STOVL	RCV
			TNUV
		VSL*	VAD
			0 	-4,2
			VCV
MINIRECT	STORE	VRECT
		STOVL	VCV
			ZEROVEC
		STORE	TDELTAV
		STODL	TNUV
			ZEROVEC
		STORE	TC
		STORE	XKEP
		RVQ

# THE THREE DIFEQ ROUTINES - DIFEQ+0, DIFEQ+12, AND DIFEQ+24 - ARE ENTEREDTO PROCESS THE CONTRIBUTIONS AT THE
# BEGINNING, MIDDLE, AND END OF THE TIMESTEP, RESPECTIVELY.  THE UPDATING IS DONE BY THE NYSTROM METHOD.

DIFEQ+0		VLOAD	VSR3
			FV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+1		VLOAD	VSR1
			FV
		PUSH	VAD
			PHIV
		STOVL	PSIV
		VSR1	VAD
			PHIV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+2		DLOAD	DMPR
			H
			DP2/3
		PUSH	VXSC
			PHIV
		VSL1	VAD
			ZV
		VXSC	VAD
			H
			YV
		STOVL	YV
			FV
		VSR3	VAD
			PSIV
		VXSC	VSL1
		VAD
			ZV
		STORE	ZV
		BOFF	CALL
			JSWITCH
			ENDSTATE
			GRP2PC
		LXA,2	VLOAD
			COLREG
			ZV
		VSL3			# ADJUST W-POSITION FOR STORAGE
		STORE	W 	+54D,2
		VLOAD
			YV
		VSL3	BOV
			WMATEND
		STORE	W,2

		CALL
			GRP2PC
		LXA,2	SSP
			COLREG
			S2
			0
		INCR,2	SXA,2
			6
			YV
		TIX,2	CALL
			RELOADSV
			GRP2PC
		LXA,2	SXA,2
			YV
			COLREG

NEXTCOL		CALL
			GRP2PC
		LXA,2	VLOAD*
			COLREG
			W,2
		VSR3			# ADJUST W-POSITION FOR INTEGRATION
		STORE	YV
		VLOAD*	AXT,1
			W 	+54D,2
			0
		VSR3			# ADJUST W-VELOCITY FOR INTEGRATION
		STCALL	ZV
			DIFEQ0

ENDSTATE	BOV	VLOAD
			GOBAQUE
			ZV
		STOVL	TNUV
			YV
		STORE	TDELTAV
		BON	BOFF
			MIDAVFLG
			CKMID2		# CHECK FOR MID2 BEFORE GOING TO TIMEINC
			DIM0FLAG
			TESTLOOP
		EXIT
		TC	PHASCHNG
		OCT	04022		# PHASE 1
		TC	UPFLAG		# PHASE CHANGE HAS OCCURRED BETWEEN
		ADRES	REINTFLG	# INTSTALL AND INTWAKE
		TC	INTPRET
		SSP
			QPRET
			AMOVED
		BON	GOTO
			VINTFLAG
			ATOPCSM
			ATOPLEM
AMOVED		SET	SSP
			JSWITCH
			COLREG
		DEC	-30
		BOFF	SSP
			D6OR9FLG
			NEXTCOL
			COLREG
		DEC	-48
		GOTO
			NEXTCOL

RELOADSV	DLOAD			# RELOAD TEMPORARY STATE VECTOR
			TDEC		# FROM PERMANENT IN CASE OF
		STCALL	TDEC1
			INTEGRV2	# BY STARTING AT INTEGRV2.
DIFEQCOM	DLOAD	DAD		# INCREMENT H AND DIFEQCNT.
			DT/2
			H
		INCR,1	SXA,1
		DEC	-12
			DIFEQCNT	# DIFEQCNT SET FOR NEXT ENTRY.
		STORE	H
		VXSC	VSR1
			FV
		VAD	VXSC
			ZV
			H
		VAD
			YV
		STORE	ALPHAV
		BON	GOTO
			JSWITCH
			DOW..
			FBR3

WMATEND		CLEAR	CLEAR
			DIM0FLAG	# DONT INTEGRATE W THIS TIME
			ORBWFLAG	# INVALIDATE W
		CLEAR
			RENDWFLG
		SET	EXIT
			STATEFLG	# PICK UP STATE VECTOR UPDATE
		TC	ALARM
		OCT	421
		TC	INTPRET
		GOTO
			TESTLOOP	# FINISH INTEGRATING STATE VECTOR

# ORBITAL ROUTINE FOR EXTRAPOLATION OF THE W MATRIX.  IT COMPUTES THE SECOND DERIVATIVE OF EACH COLUMN POSITION
# VECTOR OF THE MATRIX AND CALLS THE NYSTROM INTEGRATION ROUTINES TO SOLVE THE DIFFERENTIAL EQUATIONS.  THE PROGRAM
# USES A TABLE OF VEHICLE POSITION VECTORS COMPUTED DURING THE INTEGRATION OF THE VEHICLES POSITION AND VELOCITY.

DOW..		LXA,2	DLOAD*
			PBODY
			MUEARTH,2
		STCALL	BETAM
			DOW..1
		STORE	FV
		BOF	INCR,1
			MIDFLAG
			NBRANCH
		DEC	-6
		LXC,2	DLOAD*
			PBODY
			MUEARTH 	-2,2
		STCALL	BETAM
			DOW..1
		BON	VSR6
			MOONFLAG
			+1
		VAD
			FV
		STCALL	FV
			NBRANCH
DOW..1		VLOAD	VSR4
			ALPHAV
		PDVL*	UNIT
			VECTAB,1
		PDVL	VPROJ
			ALPHAV
		VXSC	VSU
			3/4
		PDDL	NORM
			36D
			S2
		PUSH	DSQ
		DMP
		NORM	PDDL
			34D
			BETAM
		SR1	DDV
		VXSC
		LXA,2	XAD,2
			S2
			S2
		XAD,2	XAD,2
			S2
			34D
		VSL*	RVQ
			0 -8D,2	

		SETLOC	ORBITAL1
		BANK

3/5		2DEC	.6 B-2
THREE/8		2DEC	.375
.3D		2DEC	.3 B-2
3/64		2DEC	3 B-6
DP1/4		2DEC	.25
DQUARTER	EQUALS	DP1/4
POS1/4		EQUALS	DP1/4
3/32		2DEC	3 B-5
15/16		2DEC	15. B-4
3/4		2DEC	3.0 B-2
7/12		2DEC	.5833333333
9/16		2DEC	9 B-4
5/128		2DEC	5 B-7
DPZERO		EQUALS	ZEROVEC
DP2/3		2DEC	.6666666667
2/3		EQUALS	DP2/3
OCT27		OCT	27
# LM504 IS TEMPORARY
		BANK	13
		SETLOC	ORBITAL2
		BANK
# IT IS VITAL THAT THE FOLLOWING CONSTANTS NOT BE SHUFFLED
		DEC	-11
		DEC	-2
		DEC	-9
		DEC	-6
		DEC	-2
		DEC	-2
		DEC	0
		DEC	-12
		DEC	-9
		DEC	-4
ASCALE		DEC	-7
		DEC	-6
		2DEC*	1.32715445 E16 B-54*	# S
		2DEC*	4.9027780 E8 B-30*	# M
MUEARTH		2DEC*	3.986032 E10 B-36*
		2DEC	0
J4REQ/J3	2DEC*	.4991607391 E7 B-26*
		2DEC	-176236.02 B-25
2J3RE/J2	2DEC*	-.1355426363 E5 B-27*
		2DEC*	.3067493316 E18 B-60*
J2REQSQ		2DEC*	1.75501139 E21 B-72*
5/8		2DEC	5 B-3
-1/12		2DEC	-.1
MUM		=	MUEARTH -2
RECRATIO	2DEC	.01
RSPHERE		2DEC	64373.76 E3 B-29
RDM		2DEC	16093.44 E3 B-27
RDE		2DEC	80467.20 E3 B-29
RATT		EQUALS 	00
VATT		EQUALS	6D
TAT		EQUALS	12D
RATT1		EQUALS	14D
VATT1		EQUALS	20D
MU(P)		EQUALS	26D
TDEC1		EQUALS	32D
URPV		EQUALS	14D
COSPHI/2	EQUALS	URPV 	+4
UZ		EQUALS	20D
TVEC		EQUALS	26D



