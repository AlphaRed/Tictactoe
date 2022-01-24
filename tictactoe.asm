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
call disable_LCD

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
ld b, 80 ; five sprites (16 x 5)
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

menu_setup:
	call wait_vblank
	call draw_menu
	call wait_vblank
	call draw_menu_cursor
	call wait_vblank
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

; draw empty sprites for board
call draw_board_sprites

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
ld [hl], $01 ; Humans first boyzzz

ld hl, BOARD_MAP ; clear map of board for inputing Xs and Os
ld b, 9
call clear_loop

ld hl, SQ_CHOSEN
ld [hl], $00

game_loop:
; Input
ld a, [TURN]
cp 1
call z, player_input ; player's turn

ld a, [TURN]
cp 2
call z, CPU_input ; CPU's turn

; Logic
call check_win_cpu ; check for win

; Draw
call wait_vblank
call HRAM
call draw_player_turn ; need one for CPU too

; Change turns
ld a, [SQ_CHOSEN]
cp 1
call z, end_of_turn

; go to main menu upon win...will need to rewrite once win checking is working
ld a, [WIN]
cp 2
jp z, start ; should be somewhere else

jp game_loop

check_win_cpu: ; to do
	; check horizontals
	ld hl, BOARD_MAP
	ld b, 1
	call check_all

	ld hl, BOARD_MAP + 3
	ld b, 1
	call check_all

	ld hl, BOARD_MAP + 6
	ld b, 1
	call check_all
	
	; check verticals

	; check diagonals

	ret

end_of_turn:
	ld a, [TURN] ; end of turn
	cp 1
	jr z, @change_to_CPU

	ld a, [TURN]
	cp 2
	jr z, @change_to_player

	@done:
		ld hl, SQ_CHOSEN
		ld [hl], $00
		ret

	@change_to_CPU:
		ld hl, TURN
		ld [hl], $02
		jr @done

	@change_to_player:
		ld hl, TURN
		ld [hl], $01
		jr @done

; to remove once I have confidence that check_all works properly
check_horizontals:
		ld a, [hl]
		cp 2
		jr z, @2nd_square
		jr @end

		@2nd_square:
			ld a, [hl+]
			cp 2
			jr z, @3rd_square
			jr @end
		
		@3rd_square:
			ld a, [hl+] ; should be inc two,. doing this so it compiles
			cp 2
			jr z, @winner
			jr @end

		@winner:
			ld hl, WIN
			ld [hl], 2
			jr @end

		@end:
			ret

; need hl to have starting square to check
; need b to hold increment
check_all:
	ld c, b ; for safekeeping
		
	; first square
	ld a, [hl]
	cp 2
	jr z, @2nd_square
	jr @end

	@2nd_square:
		inc hl
		ld a, [hl]
		dec b
		jr z, @do_the_check
		jr @2nd_square

		@do_the_check:
		; already loaded in and ready to go!
		cp 2
		jr z, @3rd_square
		jr @end
		
	@3rd_square:
		inc hl
		ld a, [hl]
		dec c
		jr z, @do_the_check_again
		jr @3rd_square

		@do_the_check_again:
			; already loaded in and ready to go!
			cp 2
			jr z, @winner
			jr @end

	@winner:
		ld hl, WIN
		ld [hl], 2
		jr @end

	@end:
		ret