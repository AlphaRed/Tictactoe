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
    jr z, @First_sq

    cp 2
    jr z, @Second_sq

    cp 3
    jr z, @Third_sq

    cp 4
    jr z, @Fourth_sq

    cp 5
    jr z, @Fifth_sq

    cp 6
    jr z, @Sixth_sq

    cp 7
    jr z, @Seventh_sq

    cp 8
    jr z, @Eighth_sq

    cp 9
    jr z, @Ninth_sq

    @End:
    ret

    @First_sq:
	    ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End

    @Second_sq:
        ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    @Third_sq:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

    @Fourth_sq:
        ld hl, $C000 + 1
        ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Fifth_sq:
        ld hl, $C000 + 1
        ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $06
        jr @End

    @Sixth_sq:
        ld hl, $C000 + 1
        ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $04
        jr @End
    
    @Seventh_sq:
        ld hl, $C000 + 1
        ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $08
        jr @End
    
    @Eighth_sq:
        ld hl, $C000 + 1
        ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $09
        jr @End

    @Ninth_sq:
        ld hl, $C000 + 1
        ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $07
        jr @End

move_left:
    ld a, [$C100] ; find out where the cursor is
    cp 1
    jr z, @First_sq

    cp 2
    jr z, @Second_sq

    cp 3
    jr z, @Third_sq

    cp 4
    jr z, @Fourth_sq

    cp 5
    jr z, @Fifth_sq

    cp 6
    jr z, @Sixth_sq

    cp 7
    jr z, @Seventh_sq

    cp 8
    jr z, @Eighth_sq

    cp 9
    jr z, @Ninth_sq

    @End:
    ret

    @First_sq:
	    ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    @Second_sq:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

    @Third_sq:
        ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End
    
    @Fourth_sq:
        ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $06
        jr @End

    @Fifth_sq:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $04
        jr @End
    
    @Sixth_sq:
        ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Seventh_sq:
        ld hl, $C000 + 1
	    ld [hl], $3A ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $09
        jr @End
    
    @Eighth_sq:
        ld hl, $C000 + 1
	    ld [hl], $0E ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $07
        jr @End
    
    @Ninth_sq:
        ld hl, $C000 + 1
	    ld [hl], $24 ; X coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $08
        jr @End

move_up:
    ld a, [$C100] ; find out where the cursor is
    cp 1
    jr z, @First_sq

    cp 2
    jr z, @Second_sq

    cp 3
    jr z, @Third_sq

    cp 4
    jr z, @Fourth_sq

    cp 5
    jr z, @Fifth_sq

    cp 6
    jr z, @Sixth_sq

    cp 7
    jr z, @Seventh_sq

    cp 8
    jr z, @Eighth_sq

    cp 9
    jr z, @Ninth_sq

    @End:
    ret

    @First_sq:
	    ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $07
        jr @End

    @Second_sq:
	    ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $08
        jr @End

    @Third_sq:
	    ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $09
        jr @End

    @Fourth_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

    @Fifth_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End

    @Sixth_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    @Seventh_sq:
        ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $04
        jr @End

    @Eighth_sq:
        ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Ninth_sq:
        ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $06
        jr @End
    
move_down:
    ld a, [$C100] ; find out where the cursor is
    cp 1
    jr z, @First_sq

    cp 2
    jr z, @Second_sq

    cp 3
    jr z, @Third_sq

    cp 4
    jr z, @Fourth_sq

    cp 5
    jr z, @Fifth_sq

    cp 6
    jr z, @Sixth_sq

    cp 7
    jr z, @Seventh_sq

    cp 8
    jr z, @Eighth_sq

    cp 9
    jr z, @Ninth_sq

    @End:
    ret

    @First_sq:
	    ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $04
        jr @End

    @Second_sq:
	    ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $05
        jr @End

    @Third_sq:
	    ld hl, $C000
	    ld [hl], $37 ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $06
        jr @End

    @Fourth_sq:
        ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $07
        jr @End

    @Fifth_sq:
        ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $08
        jr @End

    @Sixth_sq:
        ld hl, $C000
	    ld [hl], $4C ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $09
        jr @End

    @Seventh_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $01
        jr @End

    @Eighth_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $02
        jr @End
    
    @Ninth_sq:
        ld hl, $C000
	    ld [hl], $1F ; Y coord
        ld hl, $C100 ; don't forget to change location
        ld [hl], $03
        jr @End

    A_button: ; to do
    ret

.ENDS