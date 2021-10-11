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
.SECTION "input" FREE

; Read input function - reads the input of all eight buttons and returns in A register
; (1 being pressed and 0 being not pressed)

readinput:
	ld hl, $FF00
	ld [hl], %11011111 ; check buttons (not Dpad) first
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl] ; do it four times for stability purposes
	and $0F
	swap a ; remove the first four bits
	ld b, a ; for safekeeping
	ld [hl], %11101111 ; check dpad buttons now
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	and $0F
	OR b ; get the first four back in there
	cpl ; flip it and we are ready to go
	ret

move_right:
    ld a, [$C100] ; find out where the cursor is
    cp 1
    jr z, @First_col

    cp 2
    jr z, @Second_col

    cp 3
    jr z, @Third_col

    @End:
    ret

    @First_col:
	    ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End

    @Second_col:
        ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    @Third_col:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

move_left:
    ld a, [$C100] ; find out where the cursor is
    cp 1
    jr z, @First_col

    cp 2
    jr z, @Second_col

    cp 3
    jr z, @Third_col

    @End:
    ret

    @First_col:
	    ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    @Second_col:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

    @Third_col:
        ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End

.ENDS