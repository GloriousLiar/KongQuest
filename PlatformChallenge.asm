;************************************
; Platform Challenge
; by GloriousLiar
; 05/25/2021
;************************************

;************************************
; CONSTANTS & ADDRESSES
;************************************
[ControllerInput]: 0x80014DC4

[CurrentMap]: 0x8076A0AB
[DestinationMap]: 0x807444E7
[CurrentExit]: 0x8076A0AF
[DestinationExit]: 0x807444EB
[ParentExit]: 0x8076A175
[ParentMap]: 0x8076A173

[ReturnPosition]: 0x8076A164

[SharedCollectables]: 0x807FCC40

[PlayerPointer]: 0x807FBB4C
[ZipperBitfield]: 0x807FBB62
[DKTransitionSpeed]: 0x807FD888
[KongBase]: 0x807FC950
[AutowalkPointer]: 0x807FD70C; 0x12 - x, 0x16 - z

[CharacterChangeObject]: 0x807FC924
[KongReloadFunction]: 0x003B

;0x001B - car race
;0x0022 - pause menu
;0x0050 - mermaid
;0x0052 - mad maze maul
;0x0053 - crystal caves
;0x006F - BFI
;0x0077 - rotating room
;0x0082 - aztec lobby
;0x0083 - japes lobby
;0x0084 - factory lobby
;0x0086 - main menu
;0x0097 - banana medal sfx
;0x0099 - fungi lobby
;0x009E - end sequence
;0x00A8 - multiplayer
[MusicChannel1]: 0x807458DC
[MusicChannel2]: 0x807458DE
[MusicChannel3]: 0x807458E0

;a0 = flag (byte*8)+bit
;a1 = true/false
;a2 = flag type (0 = permanent, 1 = global, 2 = temp)
[SetFlag]: 0x8073129C

;a0 = flag
;a1 = type
;v0 = return true/false
[CheckFlag]: 0x8073110C

;a0 = style
;a1 = x (s16)
;a2 = y (s16)
;a3 = textpointer
[SpawnTextOverlay]: 0x8069D0F8

;For temp storage
[TinyInstrument]: 0x807FCA6C
[DKInstrument]: 0x807FC954

[MenuTextScale]: 0x80033C64

[MenuBackgroundTopRed]: 0x80754F4C
[MenuBackgroundTopBlue]: 0x80754F4D
[MenuBackgroundTopGreen]: 0x80754F4E
[MenuBackgroundBottomRed]: 0x80754F4F
[MenuBackgroundBottomBlue]: 0x80754F50
[MenuBackgroundBottomGreen]: 0x80754F51
 
[MenuBarrelOneStartX]: 0x8003373C
[MenuBarrelTwoStartX]: 0x8003374C
[MenuBarrelThreeStartX]: 0x8003375C
[MenuBarrelFourStartX]: 0x8003376C
[MenuBarrelFiveStartX]: 0x8003377C
[MenuBarrelOneStartY]: 0x8003378C
[MenuBarrelTwoStartY]: 0x8003379C
[MenuBarrelThreeStartY]: 0x800337AC
[MenuBarrelFourStartY]: 0x800337BC
[MenuBarrelFiveStartY]: 0x800337CC

[MenuBarrelOneEndX]: 0x80033730
[MenuBarrelTwoEndX]: 0x80033740
[MenuBarrelThreeEndX]: 0x80033750
[MenuBarrelFourEndX]: 0x80033760
[MenuBarrelFiveEndX]: 0x80033770
[MenuBarrelOneEndY]: 0x80033780
[MenuBarrelTwoEndY]: 0x80033790
[MenuBarrelThreeEndY]: 0x800337A0
[MenuBarrelFourEndY]: 0x800337B0
[MenuBarrelFiveEndY]: 0x800337C0

[GameMode]:0x80755314
[GameModeCopy]: 0x80755318
[GameModeHack]: 0x807132CB
[StorySkip]: 0x8074452C
[FileSlot]: 0x807467C8

;Progress Tracker ADDRESSES
[DKCBs]: 0x807FC968
[DKGBs]: 0x807FC9A0
[DKCoins]: 0x807FC956
[DiddyCBs]: 0x807FC9BC
[DiddyGBs]: 0x807FC9F4
[DiddyCoins]: 0x807FC9B4
[LankyCBs]: 0x807FCA1E
[LankyGBs]: 0x807FCA56
[LankyCoins]: 0x807FCA12
[TinyCBs]: 0x807FCA74
[TinyGBs]: 0x807FCAAC
[TinyCoins]: 0x807FCA70
[ChunkyCBs]: 0x807FCAE0
[ChunkyGBs]: 0x807FCB18
[ChunkyCoins]: 0x807FCACE

;**********
; Hook
;**********
.org 0x805FC164 // retroben's hook but up a few functions
J Start

.org 0x8000DE88 // In the Expansion Pak pic, TODO: Better place to put this

Start:
// Run the code we replaced
JAL     0x805FC2B0
NOP

PUSH	at
PUSH	t0
PUSH	t1
PUSH	t2
PUSH	t3
PUSH	t4
PUSH	t5
PUSH	t6
PUSH	a0
PUSH	a1
PUSH	a2
PUSH	v0


;Check if in credits room
LBU		at, @CurrentMap
LI		t0, 0x59
BNE		at, t0, CheckStartupMaps
NOP
;Should only be this for one frame
LW		at, @DKTransitionSpeed
LI		t0, 0x3f800000
BNE		at, t0, CheckStartupMaps
NOP
;Check if overlay already spawned
;LA		t0, @DKInstrument
;LW		t1, 0x0(t0)
;BNEZ	t1, CheckStartupMaps
;NOP

;Progress overlays
LI		a0, 0x0;style
LI		a1, 18;xpos
LI		a2, 15;ypos
LA		a3, ProgressText
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0xFF
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

;DK PROGRESS
;CB INDEX AT 0xA
LA		t0, DKProgress
LHU		t1, @DKCBs
LI		t2, 10
DIV		t1, t2
MFLO	t1
MFHI	t2
ADDIU 	t1, t1, 0x30
ADDIU	t2, t2, 0x30
SB		t1, 0xA(t0)
SB		t2, 0xB(t0)
LH		t1, @DKGBs
ADDI 	t1, t1, 0x30
SB		t1, 0x19(t0)
LH		t1, @DKCoins
ADDI 	t1, t1, 0x30
SB		t1, 0x25(t0)

LI		a0, 0x0;style
LI		a1, -35;xpos
LI		a2, 32;ypos
LA		a3, DKProgress
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0x00
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

;DIDDY PROGRESS
;CB INDEX AT 0x8
LA		t0, DiddyProgress
LHU		t1, @DiddyCBs
LI		t2, 10
DIV		t1, t2
MFLO	t1
MFHI	t2
ADDIU 	t1, t1, 0x30
ADDIU	t2, t2, 0x30
SB		t1, 0x8(t0)
SB		t2, 0x9(t0)
LH		t1, @DiddyGBs
ADDI 	t1, t1, 0x30
SB		t1, 0x17(t0)
LH		t1, @DiddyCoins
ADDI 	t1, t1, 0x30
SB		t1, 0x23(t0)

LI		a0, 0x0;style
LI		a1, -35;xpos
LI		a2, 60;ypos
LA		a3, DiddyProgress
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0x00
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

;LANKY PROGRESS
;CB INDEX AT 0x8
LA		t0, LankyProgress
LHU		t1, @LankyCBs
LI		t2, 10
DIV		t1, t2
MFLO	t1
MFHI	t2
ADDIU 	t1, t1, 0x30
ADDIU	t2, t2, 0x30
SB		t1, 0x8(t0)
SB		t2, 0x9(t0)
LH		t1, @LankyGBs
ADDI 	t1, t1, 0x30
SB		t1, 0x17(t0)
LH		t1, @LankyCoins
ADDI 	t1, t1, 0x30
SB		t1, 0x23(t0)

LI		a0, 0x0;style
LI		a1, -35;xpos
LI		a2, 88;ypos
LA		a3, LankyProgress
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0x00
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

;TINY PROGRESS
;CB INDEX AT 0x9
LA		t0, TinyProgress
LHU		t1, @TinyCBs
LI		t2, 10
DIV		t1, t2
MFLO	t1
MFHI	t2
ADDIU 	t1, t1, 0x30
ADDIU	t2, t2, 0x30
SB		t1, 0x9(t0)
SB		t2, 0xA(t0)
LH		t1, @TinyGBs
ADDI 	t1, t1, 0x30
SB		t1, 0x18(t0)
LH		t1, @TinyCoins
ADDI 	t1, t1, 0x30
SB		t1, 0x24(t0)

LI		a0, 0x0;style
LI		a1, -35;xpos
LI		a2, 116;ypos
LA		a3, TinyProgress
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0x00
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

;Chunky PROGRESS
;CB INDEX AT 0x7
LA		t0, ChunkyProgress
LHU		t1, @ChunkyCBs
LI		t2, 10
DIV		t1, t2
MFLO	t1
MFHI	t2
ADDIU 	t1, t1, 0x30
ADDIU	t2, t2, 0x30
SB		t1, 0x8(t0)
SB		t2, 0x9(t0)
LH		t1, @ChunkyGBs
ADDI 	t1, t1, 0x30
SB		t1, 0x17(t0)
LH		t1, @ChunkyCoins
ADDI 	t1, t1, 0x30
SB		t1, 0x23(t0)

LI		a0, 0x0;style
LI		a1, -35;xpos
LI		a2, 144;ypos
LA		a3, ChunkyProgress
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0x00
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20

LI		t0, 1
LA		t1, @DKInstrument
SW		t0, 0x0(t1)

;Check Startup maps
CheckStartupMaps:
LBU		t0, @CurrentMap
LI		t1, 0x28
BNE		t0, t1, MainMenuCheck
NOP
LI		t2, 0x50 ;main menu
SB		t2, @DestinationMap
LI		t0, 0x05 ;MMM
SB		t0, @GameModeHack

MainMenuCheck:
LI		t1, 0x50
BNE		t0, t1, SetFlags
NOP

;Main Menu Stuff --
LA		at, @MusicChannel1
LI		t0, 0x00A8
SH		t0, 0x0(at)

;Change Background
ChangeBackground:
LA		t0, @MenuBackgroundTopRed
LA		t1, @MenuBackgroundTopBlue
LA		t2,	@MenuBackgroundTopGreen
LI		t3, 0x00
SB		t3, 0x00(t0)
SB		t3, 0xCC(t1)
SB		t3, 0xCC(t2)
LA		t0, @MenuBackgroundBottomRed
LA		t1, @MenuBackgroundBottomBlue
LA		t2,	@MenuBackgroundBottomGreen
SB		t3, 0x33(t0)
SB		t3, 0x00(t1)
SB		t3, 0x33(t2)

;Set Story Skip
LI		t0, 0x1
SB		t0, @StorySkip

;Change Barrel Placement
LA		t0, @MenuBarrelOneStartX
LA		t1, @MenuBarrelTwoStartX
LA		t2, @MenuBarrelThreeStartX
LA		t3,	@MenuBarrelFourStartX
LA		t4, @MenuBarrelFiveStartX
LA		at, Menu_XPos
;LW		t5, 0x00(at)
;SW		t5, 0x00(t0)
LW		t5, 0x04(at)
SW		t5, 0x00(t1)
LW		t5, 0x08(at)
SW		t5, 0x00(t2)
LW		t5, 0x0C(at)
SW		t5, 0x00(t3)
LW		t5, 0x10(at)
SW		t5, 0x00(t4)

LA		t0, @MenuBarrelOneStartY
LA		t1, @MenuBarrelTwoStartY
LA		t2, @MenuBarrelThreeStartY
LA		t3,	@MenuBarrelFourStartY
LA		t4, @MenuBarrelFiveStartY
LA		at, Menu_YPos
;LW		t5, 0x00(at)
;SW		t5, 0x00(t0)
LW		t5, 0x04(at)
SW		t5, 0x00(t1)
LW		t5, 0x08(at)
SW		t5, 0x00(t2)
LW		t5, 0x0C(at)
SW		t5, 0x00(t3)
LW		t5, 0x10(at)
SW		t5, 0x00(t4)

LA		t0, @MenuBarrelOneEndX
LA		t1, @MenuBarrelTwoEndX
LA		t2, @MenuBarrelThreeEndX
LA		t3,	@MenuBarrelFourEndX
LA		t4, @MenuBarrelFiveEndX
LA		at, Menu_XPos
;LW		t5, 0x00(at)
;SW		t5, 0x00(t0)
LW		t5, 0x04(at)
SW		t5, 0x00(t1)
LW		t5, 0x08(at)
SW		t5, 0x00(t2)
LW		t5, 0x0C(at)
SW		t5, 0x00(t3)
LW		t5, 0x10(at)
SW		t5, 0x00(t4)

LA		t0, @MenuBarrelOneEndY
LA		t1, @MenuBarrelTwoEndY
LA		t2, @MenuBarrelThreeEndY
LA		t3,	@MenuBarrelFourEndY
LA		t4, @MenuBarrelFiveEndY
LA		at, Menu_YPos
;LW		t5, 0x00(at)
;SW		t5, 0x00(t0)
LW		t5, 0x04(at)
SW		t5, 0x00(t1)
LW		t5, 0x08(at)
SW		t5, 0x00(t2)
LW		t5, 0x0C(at)
SW		t5, 0x00(t3)
LW		t5, 0x10(at)
SW		t5, 0x00(t4)

LA		t0, @TinyInstrument
LW		t1, 0x0(t0)
BNEZ	t1, SetFlags
NOP

LA		at, @MenuTextScale
LI		t0, 0
SW		t0, 0x0(at)
LI		a0, 0x1;style
LI		a1, 170;xpos
LI		a2, 50;ypos
LA		a3, TitleText
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0xFF
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20
LI		a0, 0x1;style
LI		a1, 215;xpos
LI		a2, 70;ypos
LA		a3, TitleText
ADDIU	a3, a3, 10
LI		t0, 0x0
LI		t1, 0xFFFF
LI		t2, 0xFF
LI		t3, 0xFF
SUBI	sp, 0x20
SW		t0, 0x10(sp)
SW		t1, 0x14(sp)
SW		t2, 0x18(sp)
SW		t3, 0x1C(sp)
JAL		@SpawnTextOverlay
NOP
NOP
ADDIU	sp, 0x20
LI		t0, 1
LA		t1, @TinyInstrument
SW		t0, 0x0(t1)

SetFlags:
;Set Flags
LI		a0, 378 ;0x2F * 8 + 2 = intro cutscene watched
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 383 ;0x2F * 8 + 7 = training barrels spawned
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 780 ;0x61 * 8 + 4 = factory ftt
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 140 ;0x11 * 8 + 4 = chunky help me
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 6 ;0x00 * 8 + 6 = diddy unlocked
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 66 ;0x08 * 8 + 2 = tiny unlocked
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 70 ;0x08 * 8 + 6 = lanky unlocked
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 117 ;0x0E * 8 + 5 = chunky unlocked
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 781 ;0x61 * 8 + 5 = galleon ftt
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 194 ;0x18 * 8 + 2 = galleon cutscene intro
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP
LI		a0, 277 ;0x22 * 8 + 5 = rotating room ftt
LI		a1, 0x1 ;true
LI		a2, 0x0 ;global ?
JAL		@SetFlag
NOP
NOP

;Map Check for Music-fix on return from barrels
LI		t5, 0x0 ;map index
LI		t6, 0x0 ;map value
MapCheckLoop2:
	;check if outside map range
	LBU		t0, NumberOfMaps
	BGT		t5, t0, TransitionCheck	;if(map index > number of maps) return;
	;map check
	LBU		t0, @CurrentMap	;t0 = map value
	LA		t6, Maps		;t6 = address start of map block
	ADDU	t6, t6, t5		;t6 = t6 + map index
	LBU		t6, 0x0(t6)		;t6 = map at map block + map index
	ADDIU	t5, t5, 0x1		;increment map index before loop
	BNE		t0, t6, MapCheckLoop2 ; if(t0 != t6) loop
	NOP
;Fix Index
SUBI	t5, t5, 0x1 ;correct for index going too far
LI		t6, 0x18 ;size of map data
MULT	t5, t6
MFLO	t5		;t5 = t5 * t6
;Find correct map
LA		t6, MapData
ADD		t5, t6, t5	;t5 = start of map data

;Set Music
LA		at, @MusicChannel1
LH		t0, 0xE(t5)
SH		t0, 0x0(at)

;Reset Chunky CBs if he dies
LA		at, @SharedCollectables
LBU		t0, 0xD(at)
LI		t1, 0xC0 ;death?
BNE 	t0, t1, TransitionCheck
NOP
LBU		t0, @CurrentMap
LI		t1, 0xC2 ;caves lobby
BNE		t0, t1, TransitionCheck
NOP
LI		t0, 0x00
SH 		t0, @ChunkyCBs
SH		t0, @ChunkyGBs
SH		t0, @ChunkyCoins


;transition status check - if 0x04 zip instead
TransitionCheck:
LB		t0, @ZipperBitfield
LI		t1, 0x02
AND		t0, t0, t1
BNEZ	t0, MapCheck
NOP
LB		t0, @ZipperBitfield
LI		t1, 0x04
AND		t0, t0, t1
BEQZ	t0, Return
NOP

MapCheck:
LI		t5, 0x0 ;map index
LI		t6, 0x0 ;map value
MapCheckLoop:
	;check if outside map range
	LBU		t0, NumberOfMaps
	BGT		t5, t0, Return		;if(map index > number of maps) return;
	;map check
	LBU		t0, @CurrentMap	;t0 = map value
	LA		t6, Maps		;t6 = address start of map block
	ADDU	t6, t6, t5		;t6 = t6 + map index
	LBU		t6, 0x0(t6)		;t6 = map at map block + map index
	ADDIU	t5, t5, 0x1		;increment map index before loop
	BNE		t0, t6, MapCheckLoop ; if(t0 != t6) loop
	NOP
	

IndexFix:
SUBI	t5, t5, 0x1 ;correct for index going too far
LI		t6, 0x18 ;size of map data
MULT	t5, t6
MFLO	t5		;t5 = t5 * t6

LA		t6, MapData
ADD		t5, t6, t5	;t5 = start of map data


;Set Game Mode to MMM
SetGameMode:
LA		at, @GameMode
LI		t0, 5
SB		t0, 0x0(at)
LA		at, @GameModeCopy
SB		t0, 0x0(at)

;Set Position/Rotation
LW		at, @PlayerPointer
LW		t0, 0x0(t5) ;x
LW		t1, 0x4(t5) ;y
LW		t2, 0x8(t5) ;z
LH		t3, 0xC(t5) ;rot
SW		t0, 0x7C(at) ;xpos
SW		t1, 0x80(at) ;ypos
SW		t2, 0x84(at) ;zpos
SH		t3, 0xE6(at) ;yrot

;Set Music
LA		at, @MusicChannel1
LH		t0, 0xE(t5)
SH		t0, 0x0(at)

;Set Character
LW		at, @PlayerPointer
LB		t0, 0x10(t5)
ADDIU	t0, t0, 0x2
SB		t0, 0x36F(at)

LW		at, @CharacterChangeObject
LI		t0, @KongReloadFunction
SH		t0, 0x29C(at)

;Give Moves & Ammo
LI		t0, 3 ;grants all moves
LI		t1, 1 ;basic sim slam
LA		at, @KongBase
SB		t0, 0x0(at) ;dk moves
SB		t1, 0x1(at) ;dk sim slam
SB		t0, 0x5E(at) ;diddy moves
SB		t1, 0x5F(at) ;diddy sim slam
SB		t0, 0xBC(at) ;tiny moves
SB		t1, 0xBD(at) ;tiny sim slam
SB		t0, 0x11A(at) ;lanky moves
SB		t1, 0x11B(at) ;lanky sim slam
SB		t0, 0x178(at) ;chunky moves
SB		t1, 0x179(at) ;chunky sim slam
LA		at, @SharedCollectables
LI		t0, 0x14
SB		t0, 0x6(at) ;give crystals

;Set Parent Map
SetParentMap:
LBU		t0, 0x11(t5) ;parent map
LA		at, @ParentMap
SB		t0, 0x0(at)
LW		at, @PlayerPointer
LW		t0, 0x7C(at)
LW		t1, 0x80(at)
LW		t2, 0x84(at)
LA		at, @ReturnPosition
SW		t0, 0x0(at)
SW		t1, 0x4(at)
SW		t2, 0x8(at)


;Fix auto-walk
LW		at, @AutowalkPointer
BEQZ	at, Return
NOP
LH		t0, 0x12(t5) ;autowalk x
LH		t1, 0x14(t5) ;autowalk z
SH		t0, 0x12(at)
SH		t1, 0x16(at)

Return:
POP		v0
POP		a2
POP		a1
POP		a0
POP		t6
POP		t5
POP		t4
POP		t3
POP		t2
POP		t1
POP		t0
POP		at
J       0x805FC15C // retroben's hook but up a few functions
NOP
NOP

.align
NumberOfMaps:
.byte 0x5

.align
Maps:
.byte 0xB0 ;Tgrounds
.byte 0x1A ;Factory
.byte 0x40 ;Giant Mushroom
.byte 0x04 ;Japes Mountain
.byte 0xC2 ;Caves Lobby

.align
MapData:
;Training Grounds
.word 0x451BB573 ;x
.word 0x4343F333 ;y
.word 0x44816609 ;z
.half 0x03F1 ;rotation
.half 0x0083 ;music
.byte 0x00 ;kong
.byte 0xB0 ;parent map
.half 0x0000 ;autowalk x
.half 0x0000 ;autowalk z
.half 0x0000
;Factory
.word 0x44C1F860 ;x
.word 0x448D7AAB ;y
.word 0x44102190 ;z
.half 0x0200 ;rotation
.half 0x0084 ;music
.byte 0x01 ;kong
.byte 0x1A ;parent map
.half 0x060F ;autowalk x
.half 0x0240 ;autowalk z
.half 0x0000
;Giant Mushroom
.word 0x43dec000 ;x
.word 0x42abaa7f ;y
.word 0x433e3127 ;z
.half 0x0000 ;rotation
.half 0x0099 ;music
.byte 0x02 ;kong
.byte 0x40 ;parent map
.half 0x01bd ;autowalk x
.half 0x00be ;autowalk z
.half 0x0000
;Japes Mountain
.word 0x43F2EFCF ;x
.word 0x430C0000 ;y
.word 0x43FD1030 ;z
.half 0x0A9B ;rotation
.half 0x0050 ;music
.byte 0x03 ;kong
.byte 0x04 ;parent map
.half 0x01E5 ;autowalk x
.half 0x01FA ;autowalk z
.half 0x0000
;Crystal Caves Lobby
.word 0x44CC77D0 ;x
.word 0x41580000 ;y
.word 0x442B370D ;z
.half 0x0862 ;rotation
.half 0x0053 ;music
.byte 0x04 ;kong
.byte 0xC2 ;parent map
.half 0x0663 ;autowalk x
.half 0x02AD ;autowalk z
.half 0x0000

;Menu Stuff
.align
Menu_XPos:
.word	0x00000000
.word	0xC2C80000
.word	0xC2C80000
.word	0xC2C80000
.word	0xC2C80000

.align
Menu_YPos:
.word	0x428C0000
.word	0x428C0000
.word	0x41C80000
.word	0xC1A00000
.word	0xC2820000

.align
TitleText:
.asciiz "KONGQUEST"
.asciiz "BY GL"

.align
ProgressText:
.asciiz "YOU FOUND ..."
.align
DKProgress:
.asciiz "DK........00 OF 25 CBS...0 OF 1 GB...0 OF 1 COIN"
.align
DiddyProgress:
.asciiz "DIDDY...00 OF 25 CBS...0 OF 1 GB...0 OF 1 COIN"
.align
LankyProgress:
.asciiz "LANKY...00 OF 25 CBS...0 OF 1 GB...0 OF 1 COIN"
.align
TinyProgress:
.asciiz "TINY.....00 OF 25 CBS...0 OF 1 GB...0 OF 1 COIN"
.align
ChunkyProgress:
.asciiz "CHUNKY..00 OF 25 CBS...0 OF 1 GB...0 OF 1 COIN"
.align
.word 0x0