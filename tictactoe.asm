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

LCD_off:
	ld a, ($FF44) ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, LCD_off

ld hl, $FF40
res 7, [hl] ; reset the bit to turn off LCD
	
ld hl, $9000 + 16 ; load the tile into VRAM
ld de, smiley_sprite
ld b, 32 ; two sprites (16 x 2)
copy_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec b
	jr nz, copy_loop
	
ld hl, $9800 ; set the tilemap
ld [hl], 1

ld hl, $9802
ld [hl], 2

ld hl, $FF47 ; set the palette, super basic one for now
ld [hl], $E4
 
ld hl, $FF40 ; set where it looks for BG tilemap
ld [hl], $81

end:
jp end

smiley_sprite: .DB $00, $00, $00, $00, $24, $24, $00, $00, $81, $81, $7E, $7E, $00, $00, $00, $00, $FF, $BE, $FF, $8C, $FF, $E5, $FF, $F5, $FF, $E0, $FF, $F0, $FF, $03, $FF, $60
