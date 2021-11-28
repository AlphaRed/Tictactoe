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

; includes
.INCLUDE "variables.i"

; Read input function - reads the input of all eight buttons and returns in A register
; (1 being pressed and 0 being not pressed)

read_input:
	ld hl, JOYPAD
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
    ld a, [CURSOR_LOC] ; find out where the cursor is
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
	    ld hl, SPRITE_CURSOR + 1
	    ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $02
        jr @End

    @Second_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $03
        jr @End

    @Third_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $01
        jr @End

    @Fourth_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Fifth_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $06
        jr @End

    @Sixth_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $04
        jr @End
    
    @Seventh_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $08
        jr @End
    
    @Eighth_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $09
        jr @End

    @Ninth_sq:
        ld hl, SPRITE_CURSOR + 1
        ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $07
        jr @End

move_left:
    ld a, [CURSOR_LOC] ; find out where the cursor is
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
	    ld hl, SPRITE_CURSOR + 1
	    ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $03
        jr @End

    @Second_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $01
        jr @End

    @Third_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $02
        jr @End
    
    @Fourth_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $06
        jr @End

    @Fifth_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $04
        jr @End
    
    @Sixth_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Seventh_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $3A ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $09
        jr @End
    
    @Eighth_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $0E ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $07
        jr @End
    
    @Ninth_sq:
        ld hl, SPRITE_CURSOR + 1
	    ld [hl], $24 ; X coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $08
        jr @End

move_up:
    ld a, [CURSOR_LOC] ; find out where the cursor is
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
	    ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $07
        jr @End

    @Second_sq:
	    ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $08
        jr @End

    @Third_sq:
	    ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $09
        jr @End

    @Fourth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $01
        jr @End

    @Fifth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $02
        jr @End

    @Sixth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $03
        jr @End

    @Seventh_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $04
        jr @End

    @Eighth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $05
        jr @End
    
    @Ninth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $06
        jr @End
    
move_down:
    ld a, [CURSOR_LOC] ; find out where the cursor is
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
	    ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $04
        jr @End

    @Second_sq:
	    ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $05
        jr @End

    @Third_sq:
	    ld hl, SPRITE_CURSOR
	    ld [hl], $37 ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $06
        jr @End

    @Fourth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $07
        jr @End

    @Fifth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $08
        jr @End

    @Sixth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $4C ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $09
        jr @End

    @Seventh_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $01
        jr @End

    @Eighth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $02
        jr @End
    
    @Ninth_sq:
        ld hl, SPRITE_CURSOR
	    ld [hl], $1F ; Y coord
        ld hl, CURSOR_LOC ; don't forget to change location
        ld [hl], $03
        jr @End

A_button: ; very much work-in-progress
    ld a, [CURSOR_LOC] ; find out where the cursor is
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
        ld hl, SQ_CHOSEN
        ld [hl], $01
        ret

    @First_sq:
        ld hl, SPRITE_1 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP ; update the map
        ld [hl], $01
        jr @End

    @Second_sq:
        ld hl, SPRITE_2 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 1 ; update the map
        ld [hl], $01
        jr @End

    @Third_sq:
        ld hl, SPRITE_3 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 2 ; update the map
        ld [hl], $01
        jr @End

    @Fourth_sq:
        ld hl, SPRITE_4 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 3 ; update the map
        ld [hl], $01
        jr @End

    @Fifth_sq:
        ld hl, SPRITE_5 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 4; update the map
        ld [hl], $01
        jr @End

    @Sixth_sq:
        ld hl, SPRITE_6 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 5 ; update the map
        ld [hl], $01
        jr @End

    @Seventh_sq:
        ld hl, SPRITE_7 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 6 ; update the map
        ld [hl], $01
        jr @End

    @Eighth_sq:
        ld hl, SPRITE_8 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 7 ; update the map
        ld [hl], $01
        jr @End

    @Ninth_sq:
        ld hl, SPRITE_9 + 2 ; change the sprite
        ld [hl], $01
        ld hl, BOARD_MAP + 8 ; update the map
        ld [hl], $01
        jr @End

player_input:
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

    ret

CPU_input: ; might want to make the CPU move the cursor in the future?
    ld a, [BOARD_MAP]
    cp 0
    jr z, @First_sq

    ld a, [BOARD_MAP + 1]
    cp 0
    jr z, @Second_sq

    ld a, [BOARD_MAP + 2]
    cp 0
    jr z, @Third_sq

    ld a, [BOARD_MAP + 3]
    cp 0
    jr z, @Fourth_sq

    ld a, [BOARD_MAP + 4]
    cp 0
    jr z, @Fifth_sq

    ld a, [BOARD_MAP + 5]
    cp 0
    jr z, @Sixth_sq

    ld a, [BOARD_MAP + 6]
    cp 0
    jr z, @Seventh_sq

    ld a, [BOARD_MAP + 7]
    cp 0
    jr z, @Eighth_sq

    ld a, [BOARD_MAP + 8]
    cp 0
    jr z, @Ninth_sq

    @End:
        ld hl, SQ_CHOSEN
        ld [hl], $01
        ret

    @First_sq:
        ld hl, SPRITE_1 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP
        ld [hl], $02
        jr @End

    @Second_sq:
        ld hl, SPRITE_2 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 1
        ld [hl], $02
        jr @End
    
    @Third_sq:
        ld hl, SPRITE_3 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 2
        ld [hl], $02
        jr @End

    @Fourth_sq:
        ld hl, SPRITE_4 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 3
        ld [hl], $02
        jr @End

    @Fifth_sq:
        ld hl, SPRITE_5 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 4
        ld [hl], $02
        jr @End
    
    @Sixth_sq:
        ld hl, SPRITE_6 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 5
        ld [hl], $02
        jr @End

    @Seventh_sq:
        ld hl, SPRITE_7 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 6
        ld [hl], $02
        jr @End

    @Eighth_sq:
        ld hl, SPRITE_8 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 7
        ld [hl], $02
        jr @End
    
    @Ninth_sq:
        ld hl, SPRITE_9 + 2 ; change the sprite
        ld [hl], $02
        ld hl, BOARD_MAP + 8
        ld [hl], $02
        jr @End

.ENDS