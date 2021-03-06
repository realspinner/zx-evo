;ROM WRITER v0.2
;(C) BUDDER/MGN/2012
;(C) ZBOSZOR/2015
;    VIRTUAL ROM @ RAM #F8 PAGE
;---------------------------------------
        ORG #6000
;-------
WLD     EQU #6006
;---------------------------------------
;HEADER:
        DS 16
        DB "WildCommanderMDL";    Header
        DB #02;                  Version
        DB 0;                       Type
        DB 1; Pages
        DB 0; Page to #8000
;-------
;       page number + block size
;       (4*512 bytes)
        DB 0,4

.5      DB 0,0
;-------
        DS 16
;-------
        DB "ROM"
        DS 31*3
;-------
        DB 0
;-------
        DW #0000,#0001; MAX SIZE
;-------
        DB "ROM WRITER v0.2 "
        DB "                "
;-------
        DB 0;0-BY EXTENSION ONLY
;            1-IF LOADED
;            2-BY TIMER
;            3-FROM MENU
;---------------------------------------
        ORG #8000,#6200
;-------
LOBU    EQU #A000
;---------------------------------------
PLUGIN  PUSH IX
        LD (DAHL),HL,(DADE),DE

        CALL ROMLOAD,ROMCOPY

        LD IX,PLWND:CALL PRWOW
_LD HL,TXT0,DE,#000A,BC,15:CALL PRSRW
        LD A,%11110111:CALL PRIAT

        CALL STATUS
        CALL GEDPL

        LD HL,0,(BLKN),HL
;LD A,1:CALL TURBO
;-------
NAIN    LD IX,PLWND
        LD A,1:CALL YN
MAIN    EI:HALT:XOR A:CALL YN

        CALL BLK40

        CALL ESC:JR NZ,EXIT
        CALL ENKE:JR Z,MAIN

        LD A,#FF:CALL YN:JR NZ,EXIT

        LD IX,FIWND:CALL PRWOW
_LD HL,TXT2,DE,#0101,BC,22:CALL PRSRW

        LD A,1:CALL YN
MAIN2   EI:HALT:XOR A:CALL YN

;CALL ESC:JR NZ,EXIT
        CALL ENKE:JR Z,MAIN2

        CALL RRESB

        LD A,#FF:CALL YN:JR NZ,NAIN

        LD A,(BLKN)
        CP 8: JR C,C_LVD
        CALL F8COPY
        JR EXIT
C_LVD   CALL LVD

EXIT    CALL TURBOD
        LD IX,PLWND:CALL RRESB
        LD A,(ESTAT)
        POP IX
        RET
;---------------------------------------
BLK40   CALL UPPP,NZ,IBLK
        CALL DWWW,NZ,DBLK
        LD A,(BLKN)
        CP 8: JR C,BLK40R
_LD HL,SR01,DE,#0401,BC,17:CALL PRSRW
        RET
BLK40R
_LD HL,SR00+12,A,(BLKN):CALL NORK
_LD HL,SR00,DE,#0401,BC,17:CALL PRSRW
        RET
;-------
IBLK    LD A,(BLKN):INC A:JR BLK
DBLK    LD A,(BLKN):DEC A
BLK     CP 9:RET NC
        LD (BLKN),A
        RET
;---------------------------------------
MEPRNT  ;i:HL - Text Address
;          BC - Lenght

        PUSH HL,BC
        LD IX,MEWND:CALL PRWOW
        POP BC,HL

        LD A,(IX+4):SUB C:SRL A:LD E,A
        LD D,#01:CALL PRSRW
        RET
;-------
MERRES  LD IX,MEWND:JP RRESB
;---------------------------------------
ERPRNT  ;i:HL - Text Address
;          BC - Lenght

        PUSH HL,BC
        LD IX,ERWND:CALL PRWOW
        POP BC,HL

        LD A,(IX+4):SUB C:SRL A:LD E,A
        LD D,#01:CALL PRSRW
        RET
;-------
ERRRES  LD IX,ERWND:JP RRESB
;---------------------------------------
STATUS  LD DE,ENTRY:CALL TENTRY2
        LD HL,ENTRY,DE,TXT02:CALL NAMENA

_LD IX,PLWND
_LD HL,TXT01,DE,#0101,BC,5:CALL PRSRW
        LD A,%01110001:CALL PRIAT
_LD HL,TXT02,DE,#0106,BC,12:CALL PRSRW
        LD A,%01110000:CALL PRIAT

        CALL SIZEK
_LD HL,TXT03,DE,#0201,BC,5:CALL PRSRW
        LD A,%01110010:CALL PRIAT
_LD HL,TXT04,DE,#0206,BC,10:CALL PRSRW
        LD A,%01110000:CALL PRIAT
        RET
;---------------------------------------
NAMENA  LD B,8
ENA     LD A,(HL):CP 32:JR Z,NNA
        LD (DE),A:INC HL,DE
        DJNZ ENA
NNA     LD C,B,B,0:ADD HL,BC
        LD A,".",(DE),A:INC DE
        LD A,C
.3      LDI
        LD B,A:OR A:RET Z
        LD A,32,(DE),A:INC DE:DJNZ $-2
        RET
;-------
SIZEK   LD HL,TXT04+1
        LD DE,(DADE)
        LD A,D:CALL NORK
        LD A,E:CALL NORK
        LD HL,TXT05+1
        LD DE,(DAHL)
        LD A,D:CALL NORK
        LD A,E:CALL NORK
        RET
;---------------------------------------
ROMLOAD LD A,8-1,(PAG),A
PIN     LD A,(PAG):INC A:CP 8+4:RET NC
        LD (PAG),A:CALL MNGCVPL
        LD HL,#C000,B,32:CALL LOAD512
        CP #0F:JR NZ,PIN
        RET
;-------
ROMCOPY LD A,0-1,(PAG),A
        LD A,8-1,(PA2),A
COPY    LD A,(PA2):INC A:CP 8+4:RET NC
        LD (PA2),A:CALL MNGCVPL
_LD HL,#C000,DE,LOBU,BC,#2000:LDIR
        LD A,(PAG):INC A
        LD (PAG),A:CALL MNGCVPL
_LD HL,LOBU,DE,#C000,BC,#2000:LDIR
        LD A,(PA2):CALL MNGCVPL
_LD HL,#E000,DE,LOBU,BC,#2000:LDIR
        LD A,(PAG):CALL MNGCVPL
_LD HL,LOBU,DE,#E000,BC,#2000:LDIR
        JR COPY
;-------
ROMCHE  LD A,0-1,(PAG),A
        LD A,8-1,(PA2),A
CHEG    LD A,(PA2):INC A:CP 8+4:RET NC
        LD (PA2),A:CALL MNGCVPL
_LD HL,#C000,DE,LOBU,BC,#2000:LDIR
        LD A,(PAG):INC A
        LD (PAG),A:CALL MNGCVPL
_LD HL,LOBU,DE,#C000,BC,#2000
_CALL CHECK:RET NZ
        LD A,(PA2):CALL MNGCVPL
_LD HL,#E000,DE,LOBU,BC,#2000:LDIR
        LD A,(PAG):CALL MNGCVPL
_LD HL,LOBU,DE,#E000,BC,#2000
_CALL CHECK:RET NZ
        JR CHEG
;-------
CHECK   LD A,(DE):CP (HL):RET NZ
        INC HL,DE
        DEC BC:LD A,B:OR C:JR NZ,CHECK
        RET
;---------------------------------------
PAGEC   EQU #6003
;---------------------------------------
F8COPY  CALL GIPAGPL ; rewind file
        LD A,#F8-1: LD (PAG),A
F8C     LD A,(PAG): INC A
        CP #F8+4: RET NC
        LD (PAG), A:LD (PAGEC),A
        LD HL,#C000,B,32:CALL LOAD512
        JR F8C
;---------------------------------------
PW0     EQU #10AF
PE0     EQU #21AF

WRE     EQU %00000110
WRD     EQU %00001110
;---------------------------------------
;BASED ON SOURCE by LVD:
LVD     DI
;enable ROM write:
        LD BC,PE0,A,WRE:OUT A
        XOR A:LD (ERR),A

        LD HL,ME00,BC,10:CALL MEPRNT

;erase 64Kb block:
        LD DE,(BLKN)
        LD HL,#0000:CALL ERASblk

        CALL MERRES
;-------
        LD HL,ME01,BC,10:CALL MEPRNT

;PROGRAM 64Kb:
        LD A,0-1,(PAG),A
        LD DE,(BLKN),HL,#0000:CALL SVPG
        JR NC,DOT:LD A,1,(ERR),A
DOT     CALL MERRES
;-------
        LD HL,ME02,BC,10:CALL MEPRNT

;READ 64Kb:
        LD A,0-1,(PAG),A
        LD DE,(BLKN),HL,#0000:CALL RDPG
        CALL MERRES

        LD HL,ME03,BC,12:CALL MEPRNT
;VERIFY:
        CALL ROMCHE
        PUSH AF:CALL MERRES
        POP AF:JR Z,WHU
        LD A,(ERR):OR 2:LD (ERR),A

;disable ports disable ROM write:
WHU     LD BC,PE0,A,WRD:OUT A
        LD BC,PW0,A,(#6000):OUT A
        EI

        LD A,(ERR):OR A:JR NZ,ERD
        LD HL,ME04,BC,7:CALL MEPRNT
WTT     CALL NUSP
        JP RRESB
;-------
ERD     CP 2:JR NZ,ER2
        LD HL,ER00,BC,16:CALL ERPRNT
        JR WTT
ER2     LD HL,ER01,BC,15:CALL ERPRNT
        JR WTT
;---------------------------------------
;WRITE PAGE:
SVPG    LD A,(PAG):INC A:CP 0+4:RET NC
        LD (PAG),A:CALL MNGCVPL

        LD IX,#C000;Data
        LD BC,#4000;Lenght
L2      LD A,(IX)
        CP #FF:CALL NZ,PGM_BT:RET C

        INC IX:CALL INC_EHL:DEC BC
        LD A,B:OR C:JR NZ,L2
        JR SVPG

;---------------------------------------
;READ PAGE:
RDPG    LD A,(PAG):INC A:CP 0+4:RET NC
        LD (PAG),A:CALL MNGCVPL

        LD IX,#C000;Data
        LD BC,#4000;Lenght
L1      CALL RDBYTE:LD (IX),A

        CALL INC_EHL:INC IX:DEC BC
        LD A,B:OR C:JR NZ,L1
        JR RDPG

INC_EHL INC L:RET NZ:INC H:RET NZ:INC E
        RET

;---------------------------------------
PGM_BT
;programs byte to the given location
;address in EHL (512kB only)
;byte in A preserves BC,DE,HL
;returns carry=1 if error

        PUSH DE,HL,AF
        LD DE,#0000
        LD HL,#0555
        LD A,#AA:CALL WRBYTE
        LD HL,#02AA
        LD A,#55:CALL WRBYTE
        LD HL,#0555
        LD A,#A0:CALL WRBYTE
        POP AF,HL,DE
        CALL WRBYTE
        JR ERR_END;wait for end/error
;                  as always

;---------------------------------------
ERASblk
;erases 64kB block of ROM.
;block address is given in EHL
;(any addr in block)

;returns carry=1 if error
;BC,DE,HL are preserved

        PUSH DE,HL
        LD DE,#0000
        LD HL,#0555
        LD A,#AA:CALL WRBYTE
        LD HL,#02AA
        LD A,#55:CALL WRBYTE
        LD HL,#0555
        LD A,#80:CALL WRBYTE
        LD A,#AA:CALL WRBYTE
        LD HL,#02AA
        LD A,#55:CALL WRBYTE
        POP HL,DE
        LD A,#30:CALL WRBYTE

;now wait 100uS @ 14MHz to start actual
;block erase:
        LD A,87:DEC A:JR NZ,$-1

;then wait for erase end:
ERR_END CALL WAITend:RET NC;no errors

;send read/reset command to ROM:
        LD A,#F0:CALL WRBYTE

;then wait 10uS @ 14MHz:
        LD A,9:DEC A:JR NZ,$-1

        SCF
        RET ;set error condition

;---------------------------------------
WAITend ;wait for ROM to end op or
;        to indicate error

        PUSH BC
WE_REPE CALL RDBYTE
        LD B,A
        CALL RDBYTE:XOR B

;no toggle - end! (carry is clear):
        BIT 6,A:JR Z,WE_END

;if toggle and error bit toggles -
;repeat reading:
        BIT 5,A:JR NZ,WE_REPE

;toggle, error bit is set - error:
        BIT 5,B:JR Z,WE_REPE
;otherwise - just toggle, wait more

        SCF
WE_END  POP BC
        RET

;---------------------------------------
WRBYTE
;writes given in A byte to ROM
;at address EHL in a range 0..512kB
;uses paging in #0000..#3FFF window

        PUSH BC
        EXA
        LD A,E:AND %00000111; 512kB only
        LD B,A,A,H:AND #C0:OR B
.2      RLCA
        AND #1F:LD BC,PW0:OUT A

        LD A,H:AND #3F:LD B,A,C,L
        EXA:LD (BC),A
        POP BC
        RET

;---------------------------------------
RDBYTE
;read byte (same as WRBYTE), reads in A
        PUSH BC

        LD A,E:AND %00000111; 512kB only
        LD B,A,A,H:AND #C0:OR B
.2      RLCA
        AND #1F:LD BC,PW0:OUT A

        LD A,H:AND #3F:LD B,A,C,L,A,(BC)
        POP BC
        RET
;---------------------------------------
PRWOW   LD A,1:JP WLD
RRESB   LD A,2:JP WLD
PRSRW   LD A,3:JP WLD
PRIAT   EXA:LD A,4:JP WLD
YN      EXA:LD A,8:JP WLD
NORK    EXA:LD A,10:JP WLD
TURBO   LD B,0,A,14:JP WLD
TURBOD  LD B,#FF,A,14:JP WLD
GEDPL   LD A,15:JP WLD
;-------
UPPP    LD A,17:JP WLD
DWWW    LD A,18:JP WLD
ENKE    LD A,22:JP WLD
ESC     LD A,23:JP WLD

USPO    LD A,46:JP WLD
NUSP    LD A,47:JP WLD
;-------
LOAD512 LD A,48:JP WLD
TENTRY2 LD A,51:JP WLD
;-------
MNGCVPL EXA:LD A,65:JP WLD
;-------
GIPAGPL LD A,50:JP WLD
;---------------------------------------
PLWND   DB 0,0
        DB 23,9;     X,Y
        DB 32+2,6+2; W,H
        DB %01111111;PAPER+INK
        DB 0
        DW #0000;    BUFFER
        DB 2,0;      LINES
;-------
FIWND   DB 0,0
        DB 28,12;    X,Y
        DB 22+2,4+2; W,H
        DB %01101110;PAPER+INK
        DB 0
        DW #0000;    BUFFER
        DB 2,0;      LINES
;-------
MEWND   DB 0,0
        DB 31,13+2;  X,Y
        DB 16+2,1+2; W,H
        DB %01011111;PAPER+INK
        DB 0
        DW #0000;    BUFFER
        DB 2,0;      LINES
;-------
ERWND   DB 0,0
        DB 24,13;    X,Y
        DB 30+2,1+2; W,H
        DB %00101111;PAPER+INK
        DB 0
        DW #0000;    BUFFER
        DB 0,0;      LINES
;-------
TXT0    DB "ROM WRITER v0.2"
TXT2    DB "START PROGRAMMING ROM?"
;-------
ME00    DB "ERASING..."
ME01    DB "WRITING..."
ME02    DB "READING..."
ME03    DB "Verifying..."
ME04    DB "DONE!!!"

ER00    DB "Verify Failed!!!"
ER01    DB "Writing Failed!"
;-------
TXT01   DB "File:"
TXT02   DB "12345678.123"
TXT03   DB "Size:"
TXT04   DB "#0000"
TXT05   DB " 0000"
;-------
SR00    DB "Block: ROM #00 ",#18,#19
SR01    DB "Block: RAM #F8 ",#18,#19
;---------------------------------------
ERR     NOP

PAG     NOP
PA2     NOP
BLKN    DS 2
;-------
DAHL    DS 2
DADE    DS 2

ESTAT   NOP
;-------
ENTRY   DS 32
;---------------------------------------
