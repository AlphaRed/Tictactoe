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
	reti
.ORG $0048 ; LCD scanline
	reti
.ORG $0050 ; timer 
	reti
.ORG $0058 ; serial
	reti
.ORG $0060 ; joypad int
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

; DMA copy routine!
ld hl, $FF80 ; to HRAM
ld de, DMA_transfer
ld b, DMA_end - DMA_transfer ; how big is it?
call copy_loop

call LCD_off

ld hl, $FF40
res 7, [hl] ; reset the bit to turn off LCD
	
ld hl, $9000 ; load the tiles into VRAM
ld de, tictactoe
ld b, 64 ; four sprites (16 x 4)
call copy_loop
	
ld hl, $FF47 ; set the palette, super basic one for now
ld [hl], $E4
 
ld hl, $FF40 ; set where it looks for BG tilemap (also turn on sprites)
ld [hl], $83

; clear the tilemap to zeros
ld hl, $9800
ld bc, 1024 ; 32 x 32 tilemap
clear_loop:
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	OR c
	jp nz, clear_loop

call LCD_off

call draw_board

call LCD_off
	
ld hl, $8000 ; load the sprites into VRAM
ld de, sprites
ld b, 48 ; three sprites (16 x 3)
call copy_loop

; Load into sprite attributes into OAM, do it the janky way for now then change to DMA another day
ld hl, $FE00
ld [hl], $10 ; Y coord
ld hl, $FE00 + 1
ld [hl], $08 ; X coord
ld hl, $FE00 + 2
ld [hl], $00 ; tile num
ld hl, $FE00 + 3
ld [hl], $00 ; attributes, keep zero for now

; set the sprite palette
ld hl, $FF48
ld [hl], $E4

; clear RAM area for OAM for DMA transfer!
ld hl, $C000
ld b, 160 ; 40 sprites x 4 bytes
OAM_clear_loop:
	ld [hl], 0
	inc hl
	dec b
	jr nz, OAM_clear_loop

; Setup RAM area for DMA transfer
ld hl, $C000
ld [hl], $20 ; Y coord
ld hl, $C000 + 1
ld [hl], $10 ; X coord
ld hl, $C000 + 2
ld [hl], $00 ; tile num
ld hl, $C000 + 3
ld [hl], $00 ; attributes, keep zero for now

call $FF80
	
end:
jp end

; Start the DMA transfer, write the source in RAM!
DMA_transfer:
	ld a, $C0 ; to change! where is the stuff!
	ld [$FF46], a ; $C000 divided by $100
	ld b, 40
@DMA_wait:
	dec b
	jr nz, @DMA_wait
	ret
DMA_end: ; just for calculating size!