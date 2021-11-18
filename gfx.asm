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

.BANK 0
.SECTION "gfx" FREE

; includes
.INCLUDE "variables.i"

; Wait_vblank - for checking if in v-blank and waiting until it starts if not
; No inputs
wait_vblank:
	ld a, [LCDY] ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, wait_vblank
    ret

; Draw the board function
draw_board:
    ld hl, BGTILES + 2
    ld [hl], 1
    ld hl, BGTILES + 5
    ld [hl], 1
    ld hl, BGTILES + 32 + 2
    ld [hl], 1
    ld hl, BGTILES + 32 + 5
    ld [hl], 1
    ld hl, BGTILES + 64
    ld [hl], 2
    ld hl, BGTILES + 64 + 1
    ld [hl], 2
    ld hl, BGTILES + 64 + 2
    ld [hl], 3
    ld hl, BGTILES + 64 + 3
    ld [hl], 2
    ld hl, BGTILES + 64 + 4
    ld [hl], 2
    ld hl, BGTILES + 64 + 5
    ld [hl], 3
    ld hl, BGTILES + 64 + 6
    ld [hl], 2
    ld hl, BGTILES + 64 + 7
    ld [hl], 2
    ld hl, BGTILES + 96 + 2
    ld [hl], 1
    ld hl, BGTILES + 96 + 5
    ld [hl], 1
    ld hl, BGTILES + 128 + 2
    ld [hl], 1
    ld hl, BGTILES + 128 + 5
    ld [hl], 1
    ld hl, BGTILES + 160
    ld [hl], 2
    ld hl, BGTILES + 160 + 1
    ld [hl], 2
    ld hl, BGTILES + 160 + 2
    ld [hl], 3
    ld hl, BGTILES + 160 + 3
    ld [hl], 2
    ld hl, BGTILES + 160 + 4
    ld [hl], 2
    ld hl, BGTILES + 160 + 5
    ld [hl], 3
    ld hl, BGTILES + 160 + 6
    ld [hl], 2
    ld hl, BGTILES + 160 + 7
    ld [hl], 2
    ld hl, BGTILES + 192 + 2
    ld [hl], 1
    ld hl, BGTILES + 192 + 5
    ld [hl], 1
    ld hl, BGTILES + 224 + 2
    ld [hl], 1
    ld hl, BGTILES + 224 + 5
    ld [hl], 1
    ret

; Draw the menu function
draw_menu:
	ld hl, BGTILES + (32 * 4) + 5 ; T
    ld [hl], 23
	ld hl, BGTILES + (32 * 4) + 6 ; I
    ld [hl], 12
	ld hl, BGTILES + (32 * 4) + 7 ; C
    ld [hl], 6
	ld hl, BGTILES + (32 * 4) + 8 ; T
    ld [hl], 23
	ld hl, BGTILES + (32 * 4) + 9 ; A
    ld [hl], 4
	ld hl, BGTILES + (32 * 4) + 10 ; C
    ld [hl], 6
	ld hl, BGTILES + (32 * 4) + 11 ; T
    ld [hl], 23
	ld hl, BGTILES + (32 * 4) + 12 ; O
    ld [hl], 18
	ld hl, BGTILES + (32 * 4) + 13 ; E
    ld [hl], 8
	ld hl, BGTILES + (32 * 6) + 7 ; S
    ld [hl], 22
	ld hl, BGTILES + (32 * 6) + 8 ; T
    ld [hl], 23
	ld hl, BGTILES + (32 * 6) + 9 ; A
    ld [hl], 4
	ld hl, BGTILES + (32 * 6) + 10 ; R
    ld [hl], 21
	ld hl, BGTILES + (32 * 6) + 11 ; T
    ld [hl], 23
    ret

; Copy loop - for copying into a section of RAM (also good for DMA transfer)
; hl - output location
; de - input location
; b - counter
copy_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec b
	jr nz, copy_loop
    ret

; Bigger copy loop - for copying into a section of RAM for counter > 255 (8 bits)
; hl - output location
; de - input location
; bc - counter
big_copy_loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec bc
	ld a, b
	OR c
	jr nz, big_copy_loop
    ret

; Clearing loop - for clearing sections to nil (0-255 sections)
; hl - section location
; b - counter (0 - 255)
clear_loop:
	ld [hl], c
    inc hl
	dec b
	jr nz, clear_loop
    ret

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

; Clearing loop - for clearing sections to nil (larger than 8 bits)
; hl - section location
; bc - counter
big_clear_loop:
	ld [hl], 0
	inc hl
	dec bc
 	ld a, b
 	OR c
 	jr nz, big_clear_loop
    ret

; Tictactoe tiles
tiles:
    .DB $00,$00,$00,$00,$00,$00,$00,$00
    .DB $00,$00,$00,$00,$00,$00,$00,$00
    .DB $18,$18,$18,$18,$18,$18,$18,$18
    .DB $18,$18,$18,$18,$18,$18,$18,$18
    .DB $00,$00,$00,$00,$00,$00,$FF,$FF
    .DB $FF,$FF,$00,$00,$00,$00,$00,$00
    .DB $18,$18,$18,$18,$18,$18,$FF,$FF
    .DB $FF,$FF,$18,$18,$18,$18,$18,$18
    .DB $00,$00,$7C,$7C,$82,$82,$82,$82
    .DB $82,$82,$FE,$FE,$82,$82,$82,$82
    .DB $00,$00,$FC,$FC,$82,$82,$82,$82
    .DB $FC,$FC,$82,$82,$82,$82,$FC,$FC
    .DB $00,$00,$7C,$7C,$82,$82,$80,$80
    .DB $80,$80,$80,$80,$82,$82,$7C,$7C
    .DB $00,$00,$FC,$FC,$82,$82,$82,$82
    .DB $82,$82,$82,$82,$82,$82,$FC,$FC
    .DB $00,$00,$FE,$FE,$80,$80,$80,$80
    .DB $FC,$FC,$80,$80,$80,$80,$FE,$FE
    .DB $00,$00,$FE,$FE,$80,$80,$80,$80
    .DB $F8,$F8,$80,$80,$80,$80,$80,$80
    .DB $00,$00,$7C,$7C,$82,$82,$80,$80
    .DB $9E,$9E,$82,$82,$82,$82,$7E,$7E
    .DB $00,$00,$82,$82,$82,$82,$82,$82
    .DB $FE,$FE,$82,$82,$82,$82,$82,$82
    .DB $00,$00,$FE,$FE,$10,$10,$10,$10
    .DB $10,$10,$10,$10,$10,$10,$FE,$FE
    .DB $00,$00,$FE,$FE,$08,$08,$08,$08
    .DB $08,$08,$08,$08,$88,$88,$70,$70
    .DB $00,$00,$82,$82,$84,$84,$88,$88
    .DB $F0,$F0,$88,$88,$84,$84,$82,$82
    .DB $00,$00,$80,$80,$80,$80,$80,$80
    .DB $80,$80,$80,$80,$80,$80,$FE,$FE
    .DB $00,$00,$82,$82,$C6,$C6,$AA,$AA
    .DB $92,$92,$82,$82,$82,$82,$82,$82
    .DB $00,$00,$82,$82,$C2,$C2,$A2,$A2
    .DB $92,$92,$8A,$8A,$86,$86,$82,$82
    .DB $00,$00,$7C,$7C,$82,$82,$82,$82
    .DB $82,$82,$82,$82,$82,$82,$7C,$7C
    .DB $00,$00,$FC,$FC,$82,$82,$82,$82
    .DB $FC,$FC,$80,$80,$80,$80,$80,$80
    .DB $00,$00,$7C,$7C,$82,$82,$82,$82
    .DB $92,$92,$8A,$8A,$86,$86,$7C,$7C
    .DB $00,$00,$FC,$FC,$82,$82,$82,$82
    .DB $82,$82,$FC,$FC,$82,$82,$82,$82
    .DB $00,$00,$7C,$7C,$82,$82,$80,$80
    .DB $7C,$7C,$02,$02,$82,$82,$7C,$7C
    .DB $00,$00,$FE,$FE,$10,$10,$10,$10
    .DB $10,$10,$10,$10,$10,$10,$10,$10
    .DB $00,$00,$82,$82,$82,$82,$82,$82
    .DB $82,$82,$82,$82,$82,$82,$7C,$7C
    .DB $00,$00,$82,$82,$82,$82,$82,$82
    .DB $82,$82,$44,$44,$28,$28,$10,$10
    .DB $00,$00,$82,$82,$82,$82,$82,$82
    .DB $92,$92,$92,$92,$AA,$AA,$44,$44
    .DB $00,$00,$82,$82,$44,$44,$28,$28
    .DB $10,$10,$28,$28,$44,$44,$82,$82
    .DB $00,$00,$82,$82,$82,$82,$44,$44
    .DB $28,$28,$10,$10,$10,$10,$10,$10
    .DB $00,$00,$FE,$FE,$04,$04,$08,$08
    .DB $10,$10,$20,$20,$40,$40,$FE,$FE

; Tictactoe sprites
sprites: 
    .DB $18,$18,$3C,$3C,$7E,$7E,$FF,$FF
    .DB $00,$00,$00,$00,$00,$00,$00,$00
    .DB $82,$82,$44,$44,$28,$28,$10,$10
    .DB $28,$28,$44,$44,$82,$82,$00,$00
    .DB $38,$38,$44,$44,$82,$82,$82,$82
    .DB $82,$82,$44,$44,$38,$38,$00,$00
    .DB $08,$08,$0C,$0C,$0E,$0E,$0F,$0F
    .DB $0F,$0F,$0E,$0E,$0C,$0C,$08,$08
.ENDS