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
DMA_copy_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec b
	jr nz, DMA_copy_loop

LCD_off:
	ld a, ($FF44) ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, LCD_off

ld hl, $FF40
res 7, [hl] ; reset the bit to turn off LCD
	
ld hl, $9000 ; load the tiles into VRAM
ld de, tictactoe
ld b, 64 ; four sprites (16 x 4)
copy_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec b
	jr nz, copy_loop
	
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

; Wait for vblank
LCD_off1:
	ld a, ($FF44) ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, LCD_off1

; draw the board
ld hl, $9800 + 2
ld [hl], 1
ld hl, $9800 + 5
ld [hl], 1
ld hl, $9800 + 32 + 2
ld [hl], 1
ld hl, $9800 + 32 + 5
ld [hl], 1
ld hl, $9800 + 64
ld [hl], 2
ld hl, $9800 + 64 + 1
ld [hl], 2
ld hl, $9800 + 64 + 2
ld [hl], 3
ld hl, $9800 + 64 + 3
ld [hl], 2
ld hl, $9800 + 64 + 4
ld [hl], 2
ld hl, $9800 + 64 + 5
ld [hl], 3
ld hl, $9800 + 64 + 6
ld [hl], 2
ld hl, $9800 + 64 + 7
ld [hl], 2
ld hl, $9800 + 96 + 2
ld [hl], 1
ld hl, $9800 + 96 + 5
ld [hl], 1
ld hl, $9800 + 128 + 2
ld [hl], 1
ld hl, $9800 + 128 + 5
ld [hl], 1
ld hl, $9800 + 160
ld [hl], 2
ld hl, $9800 + 160 + 1
ld [hl], 2
ld hl, $9800 + 160 + 2
ld [hl], 3
ld hl, $9800 + 160 + 3
ld [hl], 2
ld hl, $9800 + 160 + 4
ld [hl], 2
ld hl, $9800 + 160 + 5
ld [hl], 3
ld hl, $9800 + 160 + 6
ld [hl], 2
ld hl, $9800 + 160 + 7
ld [hl], 2
ld hl, $9800 + 192 + 2
ld [hl], 1
ld hl, $9800 + 192 + 5
ld [hl], 1
ld hl, $9800 + 224 + 2
ld [hl], 1
ld hl, $9800 + 224 + 5
ld [hl], 1

; Wait for vblank... should redo these one day
LCD_off2:
	ld a, ($FF44) ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, LCD_off2
	
ld hl, $8000 ; load the sprites into VRAM
ld de, sprites
ld b, 48 ; three sprites (16 x 3)
sprite_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec b
	jr nz, sprite_loop

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

tictactoe: .DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$18,$18,$18,$18,$18,$18,$FF,$FF,$FF,$FF,$18,$18,$18,$18,$18,$18

sprites: .DB $18,$18,$3C,$3C,$7E,$7E,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$82,$82,$44,$44,$28,$28,$10,$10,$28,$28,$44,$44,$82,$82,$00,$00,$38,$38,$44,$44,$82,$82,$82,$82,$82,$82,$44,$44,$38,$38,$00,$00
