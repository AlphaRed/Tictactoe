; For all my defining needs

; Hardware related stuff
.DEFINE LCDC $FF40 ; LCD control
.DEFINE OAMTBL $FE00 ; OAM table
.DEFINE BGTILES $9800 ; BG tile map area
.DEFINE BGPAL $FF47 ; BG palette
.DEFINE SPRPAL $FF48 ; Sprite/object palette
.DEFINE HRAM $FF80 ; High RAM (for DMA transfers)
.DEFINE LCDY $FF44 ; Y coordinate for vblank
.DEFINE JOYPAD $FF00 ; Joypad read/write

; Variables/constants/etc.
.DEFINE SPRITE_AREA $C000 ; RAM area for sprite data (40 sprites x 4 bytes)
.DEFINE CURSOR_LOC $C100 ; current location for cursor (1 - 9)
.DEFINE TURN $C101 ; current turn (Human => 1, CPU => 2)
.DEFINE SQ_CHOSEN $C102 ; if player has picked a square this will be 1, otherwise 0
.DEFINE BOARD_MAP $C103 ; map of board that stores who has each square

; Sprites
.DEFINE SPRITE_CURSOR SPRITE_AREA ; cursor sprite
.DEFINE SPRITE_1 SPRITE_AREA + 4 ; SQ1 sprite
.DEFINE SPRITE_2 SPRITE_AREA + 8 ; SQ2 sprite
.DEFINE SPRITE_3 SPRITE_AREA + 12 ; SQ3 sprite
.DEFINE SPRITE_4 SPRITE_AREA + 16 ; SQ4 sprite
.DEFINE SPRITE_5 SPRITE_AREA + 20 ; SQ5 sprite
.DEFINE SPRITE_6 SPRITE_AREA + 24 ; SQ6 sprite
.DEFINE SPRITE_7 SPRITE_AREA + 28 ; SQ7 sprite
.DEFINE SPRITE_8 SPRITE_AREA + 32 ; SQ8 sprite
.DEFINE SPRITE_9 SPRITE_AREA + 36 ; SQ9 sprite