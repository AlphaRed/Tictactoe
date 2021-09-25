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

; LCD_off function - For checking if in v-blank
LCD_off:
	ld a, ($FF44) ; grab horizontal line draw and compare with 145
	cp 145
	jr nz, LCD_off
    ret

; Draw the board function
draw_board:
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

; Tictactoe board
tictactoe: .DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$18,$18,$18,$18,$18,$18,$FF,$FF,$FF,$FF,$18,$18,$18,$18,$18,$18
; Tictactoe sprites
sprites: .DB $18,$18,$3C,$3C,$7E,$7E,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$82,$82,$44,$44,$28,$28,$10,$10,$28,$28,$44,$44,$82,$82,$00,$00,$38,$38,$44,$44,$82,$82,$82,$82,$82,$82,$44,$44,$38,$38,$00,$00

.ENDS