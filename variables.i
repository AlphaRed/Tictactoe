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
.DEFINE BOARD_MAP $C102 ; map of baord that stores who has each square

; Sprites
.DEFINE SPRITE_CURSOR SPRITE_AREA ; cursor sprite
.DEFINE SPRITE_X SPRITE_AREA + 4 ; X sprite
.DEFINE SPRITE_O SPRITE_AREA + 8 ; O sprite
