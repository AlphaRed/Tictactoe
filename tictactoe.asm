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

call Wait_vblank
ld hl, $FF40
res 7, [hl] ; reset the bit to turn off LCD

; Clear the tilemap to zeros
ld hl, $9800
ld bc, 1024 ; 32 x 32 tilemap
other_clear_loop:
	ld [hl], 0
	inc hl
	dec bc
 	ld a, b
 	OR c
 	jr nz, other_clear_loop

; Load the tiles into VRAM
ld hl, $9000
ld de, tiles
ld bc, 480 ; thirty tiles (16 x 30)
call Big_copy_loop

; Clear OAM to zeros
ld hl, $FE00
ld b, 160 ; 40 sprites x 4 bytes
call Clear_loop

; Load the sprites into VRAM
ld hl, $8000 ;
ld de, sprites
ld b, 64 ; four sprites (16 x 4)
call Copy_loop

; Set where it looks for BG tilemap (also turn on sprites)
ld hl, $FF40
ld [hl], $83

; Set the palette, super basic one for now
ld hl, $FF47 
ld [hl], $E4

; Set the sprite palette
ld hl, $FF48
ld [hl], $E4

call Wait_vblank ; not sure I need this but will just for safety

; DMA copy routine!
ld hl, $FF80 ; to HRAM
ld de, DMA_transfer
ld b, DMA_end - DMA_transfer ; how big is it?
call Copy_loop

; Clear RAM area for OAM for DMA transfer!
ld hl, $C000
ld b, 160 ; 40 sprites x 4 bytes
call Clear_loop

; Setup RAM area for DMA transfer
ld hl, $C000
ld [hl], $20 ; Y coord
ld hl, $C000 + 1
ld [hl], $10 ; X coord
ld hl, $C000 + 2
ld [hl], $00 ; tile num
ld hl, $C000 + 3
ld [hl], $00 ; attributes, keep zero for now

;call $FF80 ; for testing purposes

call Wait_vblank

call draw_menu

; Set the default cursor
draw_menu_cursor:
	ld hl, $C000
	ld [hl], $40 ; Y coord
	ld hl, $C000 + 1
	ld [hl], $30 ; X coord
	ld hl, $C000 + 2
	ld [hl], $03 ; tile num
	ld hl, $C000 + 3
	ld [hl], $00 ; attributes, keep zero for now

call $FF80

MENU_LOOP:
; Input
ld hl, $FF00
res 5, [hl] ; set the bit to check button keys
ld a, [hl]
cpl
and 1 ; check for A key
cp 0
call nz, move_it

; Logic
; Draw
call Wait_vblank
call $FF80
jp MENU_LOOP

;call draw_board
GAME_LOOP:
; Input
; Logic
; Draw
jp GAME_LOOP
	
end:
jp end

move_it:
	ld hl, $C000
	ld [hl], $50 ; Y coord
	ret