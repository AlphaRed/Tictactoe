.ROMDMG
.NAME "TICTACTOE"
.CARTRIDGETYPE 0
.RAMSIZE 0
.COMPUTEGBCHECKSUM
.COMPUTEGBCOMPLEMENTCHECK
.LICENSEECODENEW "00"
.EMPTYFILL $00

.MEMORYMAP
SLOTSIZE $4000
DEFAULTSLOT 0
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

.BANK 0 SLOT 0

; includes
.INCLUDE "variables.i"

; Interrupts
.ORG $0040 ; Vblank
	;call $FF80 ; do the DMA transfer since the board won't need to change
	reti
.ORG $0048 ; LCD scanline
	reti
.ORG $0050 ; timer
	reti
.ORG $0058 ; serial
	reti
.ORG $0060 ; joypad
	reti

.ORG $0100
nop
jp start

.ORG $0104
.DB $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C
.DB $00, $0D, $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6
.DB $DD, $DD, $D9, $99, $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC
.DB $99, $9F, $BB, $B9, $33, $3E

.ORG $0150
start:

call wait_vblank
ld hl, LCDC
res 7, [hl] ; reset the bit to turn off LCD

; Clear the tilemap to zeros
ld hl, BGTILES
ld bc, 1024 ; 32 x 32 tilemap
other_clear_loop:
	ld [hl], 0
	inc hl
	dec bc
 	ld a, b
 	OR c
 	jr nz, other_clear_loop

; Load the tiles into VRAM
ld hl, $9000 ; WHAT IS THIS FOR?
ld de, tiles
ld bc, 480 ; thirty tiles (16 x 30)
call big_copy_loop

; Clear OAM to zeros
ld hl, OAMTBL
ld b, 160 ; 40 sprites x 4 bytes
call clear_loop

; Load the sprites into VRAM
ld hl, $8000
ld de, sprites
ld b, 64 ; four sprites (16 x 4)
call copy_loop

; Set where it looks for BG tilemap (also turn on sprites)
ld hl, LCDC
ld [hl], $83

; Set the palette, super basic one for now
ld hl, BGPAL
ld [hl], $E4

; Set the sprite palette
ld hl, SPRPAL
ld [hl], $E4

call wait_vblank ; not sure I need this but will just for safety

; DMA copy routine!
ld hl, HRAM ; to HRAM
ld de, DMA_transfer
ld b, DMA_end - DMA_transfer ; how big is it?
call copy_loop

; Clear RAM area for OAM for DMA transfer!
ld hl, SPRITE_AREA
ld b, 160 ; 40 sprites x 4 bytes
call clear_loop

; Setup RAM area for DMA transfer
ld hl, SPRITE_AREA
ld [hl], $20 ; Y coord
ld hl, SPRITE_AREA + 1
ld [hl], $10 ; X coord
ld hl, SPRITE_AREA + 2
ld [hl], $00 ; tile num
ld hl, SPRITE_AREA + 3
ld [hl], $00 ; attributes, keep zero for now

call wait_vblank

call draw_menu

; Set the default cursor
draw_menu_cursor:
	ld hl, SPRITE_AREA
	ld [hl], $40 ; Y coord
	ld hl, SPRITE_AREA + 1
	ld [hl], $30 ; X coord
	ld hl, SPRITE_AREA + 2
	ld [hl], $03 ; tile num
	ld hl, SPRITE_AREA + 3
	ld [hl], $00 ; attributes, keep zero for now

call HRAM

menu_loop:
; Input
call read_input
and %00010000 ; check for A key
cp 0
jp nz, game_setup

; Logic
; Draw
call wait_vblank
call HRAM
jp menu_loop

game_setup:
call wait_vblank
ld hl, LCDC
res 7, [hl] ; reset the bit to turn off LCD
; Clear the tilemap to zeros
ld hl, BGTILES
ld bc, 1024 ; 32 x 32 tilemap
call big_clear_loop

; draw the game board!
call draw_board

; draw the cursor in the right spot
ld hl, SPRITE_CURSOR
ld [hl], $1F ; Y coord
ld hl, SPRITE_CURSOR + 1
ld [hl], $0E ; X coord
ld hl, SPRITE_CURSOR + 2
ld [hl], $00 ; tile num, change to a below arrow
ld hl, SPRITE_CURSOR + 3
ld [hl], $00 ; attributes, keep zero for now

call HRAM

ld hl, LCDC
set 7, [hl] ; set the bit to turn on LCD

ld hl, CURSOR_LOC ; set current location (can change this to somewhere else if needed)
ld [hl], $01 ; top left is one, counting left to right and down

ld hl, TURN ; set player turn (Human = 1, CPU = 2), if I decide to add two player this will need to change
ld [hl], $02 ; Humans first boyzzz

ld hl, BOARD_MAP ; clear map of board for inputing Xs and Os
ld b, 9
call clear_loop

game_loop:
; Input
ld a, [TURN] ; check who's turn it is
cp 2
jr z, @CPU_turn

call read_input
ld c, a
@input_loop:
	call read_input ; loop until you let go
	cp c
	jr z, @input_loop
ld a, c ; load back in what you pressed

ld b, a ; store
and %00000001 ; check for right dpad
cp 0
call nz, move_right

ld a, b ; need to replace value in A after each AND
and %00000010 ; check for left dpad
cp 0
call nz, move_left

ld a, b ; need to replace value in A after each AND
and %00000100 ; check for up dpad
cp 0
call nz, move_up

ld a, b ; need to replace value in A after each AND
and %00001000 ; check for up dpad
cp 0
call nz, move_down

ld a, b ; need to replace value in A after each AND
and %00010000 ; check for A button
cp 0
call nz, A_button

; Logic
@CPU_turn:
	ld hl, SPRITE_AREA + 4
	ld [hl], $16 ; Y coord
    ld hl, SPRITE_AREA + 4 + 1
	ld [hl], $0E ; X coord
    ld hl, SPRITE_AREA + 4 + 2
	ld [hl], $02 ; tile number
    ld hl, SPRITE_AREA + 4 + 3
	ld [hl], $00 ; attributes
    ld hl, $C101 ; end your turn
    ld [hl], $01

; Draw
call wait_vblank
call HRAM

jp game_loop
	
end:
jp end