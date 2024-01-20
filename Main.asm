INCLUDE Irvine32.inc
INCLUDE macros.inc

includelib Winmm.lib

PlaySound PROTO,
        pszSound:PTR BYTE,
        hmod:DWORD,
        fdwSound:DWORD

BUFFER_SIZE = 501

.data
pacman_beginning db "pacman_beginning.wav",0  ; Replace with the actual path to your sound file
pacman_beginning2 db "sada.wav",0  ; player collision with enemy
bg db "bg.wav",0  ; in-game sound
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FILE HANDLING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    buffer BYTE "                                                                                        ", 0
    filename BYTE "output.txt", 0
    fileHandle HANDLE ?
    stringLength DWORD ?
    bytesWritten DWORD ?
    
    str1 BYTE "Cannot create file ", 0
    str2 BYTE "Bytes written to file [output.txt]:", 0

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    menu1 db "                   _____           __  __              ", 0
    menu2 db "                  |  __ \         |  \/  |              ", 0
    menu3 db "                  | |__) |_ _  ___| \  / | __ _ _ __    ", 0
    menu4 db "                  |  ___/ _` |/ __| |\/| |/ _` | '_ \   ", 0
    menu5 db "                  | |  | (_| | (__| |  | | (_| | | | |  ", 0
    menu6 db "                  |_|   \__,_|\___|_|  |_|\__,_|_| |_|  ", 0
    menu7 db "                                                        ", 0
    menu8 db "                         A Challenge Devine              ", 0

    start1 db "                             S T A R T      ", 0
    start2 db "                         H I G H S C O R E      ", 0
    start3 db "                      I N S T R U C T I O N S      ", 0
    start4 db "                              E X I T      ", 0

    highscore1 db "                   _    _  _         _        _____                                ", 0
    highscore2 db "                  | |  | |(_)       | |      / ____|                               ", 0
    highscore3 db "                  | |__| | _   __ _ | |__   | (___    ___  ___   _ __  ___  ___    ", 0
    highscore4 db "                  |  __  || | / _` || '_ \   \___ \  / __|/ _ \ | '__|/ _ \/ __|   ", 0
    highscore5 db "                  | |  | || || (_| || | | |  ____) || (__| (_) || |  |  __/\__ \   ", 0
    highscore6 db "                  |_|  |_||_| \__, ||_| |_| |_____/  \___|\___/ |_|   \___||___/   ", 0
    highscore7 db "                               __/ |                                               ", 0
    highscore8 db "                              |___/                                                ", 0

    arrow db "->", 0

    instruction1 db "                   _____              _                       _    _                       ", 0
    instruction2 db "                  |_   _|            | |                     | |  (_)                      ", 0
    instruction3 db "                    | |   _ __   ___ | |_  _ __  _   _   ___ | |_  _   ___   _ __   ___    ", 0
    instruction4 db "                    | |  | '_ \ / __|| __|| '__|| | | | / __|| __|| | / _ \ | '_ \ / __|   ", 0
    instruction5 db "                   _| |_ | | | |\__ \| |_ | |   | |_| || (__ | |_ | || (_) || | | |\__ \   ", 0
    instruction6 db "                  |_____||_| |_||___/ \__||_|    \__,_| \___| \__||_| \___/ |_| |_||___/   ", 0
    instruction7 db "              1. Navigate Pac-Man ('X') through the maze and collect points ", 0 
    instruction8 db "              2. Use the arrow keys (Up, Down, Left, Right) to move Pac-Man through the maze. ", 0 
    instruction9 db "              3. Special points that provide Pac-Man temporary power. ", 0 
    instruction10 db "             4. During power mode, Pac-Man can eat enemies. ", 0 
    instruction11 db "             5. Collect points by moving Pac-Man over dots. ", 0 
    instruction12 db "             6. Additional points may be awarded for eating energizers. ", 0 
    instruction13 db "             7. The game may end if Pac-Man collides with an enemy (ghost), or the player completes all levels. ", 0 
    instruction14 db "             8. Advance through levels by collecting all dots in the maze. ", 0 
    instruction15 db "             9. Watch out for enemy characters (ghosts) that may move throughout the maze. ", 0 
    instruction16 db "            10. Some dots may have special effects, such as energizing Pac-Man or altering enemy behavior. ", 0 

    paused1 db "                   _____                         _    ", 0
    paused2 db "                  |  __ \                       | |   ", 0
    paused3 db "                  | |__) |_ _ _   _ ___  ___  __| |   ", 0
    paused4 db "                  |  ___/ _` | | | / __|/ _ \/ _` |   ", 0
    paused5 db "                  | |  | (_| | |_| \__ \  __/ (_| |   ", 0
    paused6 db "                  |_|   \__,_|\__,_|___/\___|\__,_|   ", 0
    paused7 db "                                                      ", 0                                                         

    end1 db "          _____                           ____                       ", 0
    end2 db "         / ____|                         / __ \                      ", 0
    end3 db "        | |  __   __ _  _ __ ___    ___ | |  | |__   __ ___  _ __    ", 0
    end4 db "        | | |_ | / _` || '_ ` _ \  / _ \| |  | |\ \ / // _ \| '__|   ", 0
    end5 db "        | |__| || (_| || | | | | ||  __/| |__| | \ V /|  __/| |      ", 0
    end6 db "         \_____| \__,_||_| |_| |_| \___| \____/   \_/  \___||_|      ", 0
    end7 db "                                                                     ", 0

space BYTE "  ", 0
ground BYTE "-------------------------------------------------------------------------------------------------------------------",0
ground1 BYTE "|",0ah,0
ground2 BYTE "|",0
details BYTE " Lives:                                             PacMan                                               Level:", 0

temp byte ?
temp2 byte ?

dot BYTE '.', 0

bool_2 db 1
bool_3 db 0
bool_fruit db 0

lives_count db 3
lives BYTE '@', 0
level BYTE 1
display_level db "Level: ", 0

strScore BYTE "Your score is:",0
score BYTE 40

xPos BYTE 59
yPos BYTE 5

enemy_x1 BYTE 23
enemy_y1 BYTE 5
enemy_x2 BYTE 39
enemy_y2 BYTE 13
enemy_x3 BYTE 88
enemy_y3 BYTE 20

fruit_x1 BYTE 10
fruit_y1 BYTE 1
fruit_x2 BYTE 70
fruit_y2 BYTE 1
fruit_x3 BYTE 110
fruit_y3 BYTE 1

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE ?

prompt_start db "Enter your choice: ", 0
enter_start db ?

enter_name db "Enter Player's Name: ", 0
display_name db "Player's Name: ", 0
player_name db ?

grid_width = 120
grid_height = 25

grid byte grid_width * grid_height dup('0')

.code
main PROC

    INVOKE PlaySound, OFFSET  pacman_beginning   , NULL,11h

        call Menu
restart:
        call clrscr
        call StartGame
    INVOKE PlaySound, OFFSET bg   , NULL,11h
            call DrawFruit1
            call DrawFruit2
            call DrawFruit3
        call clrscr

start:
        mov inputChar,"d"
        call PrintDot
        call maze_level1
        
    mov eax,white + (black*16)
    call setTextColor
    
    mov dh, 0
    mov dl, 40
    call gotoxy
    mov edx, offset display_name
    call writestring
    mov dl, 50
    mov edx, offset player_name
    call writestring

    mov dh, 28
    mov dl, 2
    call gotoxy
    mov edx, offset details
    call writestring

        ; draw ground at (0,26):
    
    mov dl,0
    mov dh,27
    call Gotoxy
    mov eax,black+(black*16)
    mov edx,OFFSET space        ;sets the space "  " before border
    call writestring
    mov eax,black+(blue*16)
    call setTextColor
    mov dl,2
    mov dh,26
    call Gotoxy
    mov edx,OFFSET ground        ;sets the border
    call WriteString
    mov dl,0
    mov dh,1
    call Gotoxy
    mov eax,black+(black*16)
    mov edx,OFFSET space        ;sets the space "  " before border
    mov dl,2
    mov dh,1
    call Gotoxy
    mov eax,black+(blue*16)
    mov edx,OFFSET ground        ;sets the border
    call WriteString

    mov ecx,25
    mov dh,2
    mov temp, dh
    l1:
    mov dh, temp
    mov dl,2
    call Gotoxy
    mov edx,OFFSET ground1
    call WriteString
    inc temp
    loop l1

    mov ecx,25
    mov dh,2
    mov temp,dh
    l2:
    mov dh,temp
    mov dl,116
    call Gotoxy
    mov edx,OFFSET ground2
    call WriteString
    inc temp
    loop l2

    call DrawLives

    call DrawPlayer

    call DrawEnemy1
    call DrawEnemy2
    call DrawEnemy3

    call Randomize

    gameLoop:
    
    cmp level, 3
    jne no_powerUPS
        call DrawPowerUps

        call CheckPowerUps3
        call CheckPowerUps2
        call CheckPowerUps1
    no_powerUPS:

        call moveANDcheckCollision_enemy1
        call moveANDcheckCollision_enemy2
        call moveANDcheckCollision_enemy3

        cmp bool_2, 1
        jne not_levelUP2
        cmp score, 50
        ja levelUP2
        jmp not_levelUP2
levelUP2:
    mov bool_2, 0
    mov bool_3, 1
    inc level
    mov dh, 28
    mov dl, 114
    call gotoxy
    mov al, 2
    call writedec

        call maze_level2

    jmp levelUP_done
not_levelUP2:
        cmp bool_3, 1
        jne not_levelUP3
        cmp score, 100
        ja levelUP3
        jmp not_levelUP3
levelUP3:
    mov bool_3, 0
    inc level
    mov dh, 28
    mov dl, 114
    call gotoxy
    mov al, 3
    call writedec
    
        call maze_level3

not_levelUP3:
levelUP_done:
        
            ;collision with enemy
    mov bl,xPos
    cmp bl,enemy_x1
    jne not_Colliding1
    mov bl,yPos
    cmp bl,enemy_y1
    jne not_Colliding1
            ; player is intersecting enemy1
    INVOKE PlaySound, OFFSET  pacman_beginning2   , NULL,11h
        call checkCollisionwith_enemy1
       
not_Colliding1: 
            ;collision with enemy
    mov bl,xPos
    cmp bl,enemy_x2
    jne not_Colliding2
    mov bl,yPos
    cmp bl,enemy_y2
    jne not_Colliding2
            ; player is intersecting enemy1
    INVOKE PlaySound, OFFSET  pacman_beginning2   , NULL,11h
        call checkCollisionwith_enemy2
    
not_Colliding2:
            ;collision with enemy
    mov bl,xPos
    cmp bl,enemy_x3
    jne not_Colliding3
    mov bl,yPos
    cmp bl,enemy_y3
    jne not_Colliding3
            ; player is intersecting enemy1
    INVOKE PlaySound, OFFSET  pacman_beginning2   , NULL,11h
        call checkCollisionwith_enemy3
    
not_Colliding3:

    call checkCoin          ;;checks if any coin is collected

        mov eax,white +(black * 16)
        call SetTextColor

        ; draw score:
        mov dl,0
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString
        mov al,score
        call WriteInt

        call Fruit1_gravity            ;;checks if the fruit is collected
        call checkFruit1            ;;checks if the fruit is collected

        call Fruit2_gravity            ;;checks if the fruit is collected
        call checkFruit2            ;;checks if the fruit is collected

        call Fruit3_gravity            ;;checks if the fruit is collected
        call checkFruit3            ;;checks if the fruit is collected

        ; get user key input:
        call ReadKey
        ;call ReadChar
        jz noKey						;jump if no key is entered
	processInput:
		mov inputChar,al				;assign variables
		noKey:
        mov eax, 80
        call Delay

        ; exit game if user types 'x':
        cmp inputChar,"x"
        je exitGame

        cmp inputChar,"p"       ;checks if the game is paused
        je paused_occured
        jmp not_paused
    paused_occured:
        call Paused
        jmp start
    not_paused:

        cmp inputChar,"w"
        je moveUp

        cmp inputChar,"s"
        je moveDown

        cmp inputChar,"a"
        je moveLeft

        cmp inputChar,"d"
        je moveRight

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveUp:
    mov esi, 0
    mov edi, 0
    movzx esi, xPos
    movzx edi, yPos
    mov eax, 0

    mov eax, esi
    imul eax, 25
    dec edi
    add eax, edi

        cmp grid[eax], 2

    je gameloop
        cmp yPos, 3     ;;checks for the last line
        jb not_up
        call UpdatePlayer
        dec yPos
        call DrawPlayer
    not_up:
        jmp gameLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DOWN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

moveDown:
    mov esi, 0
    mov edi, 0
    movzx esi, xPos
    movzx edi, yPos
    mov eax, 0

    mov eax, esi
    imul eax, 25
    inc edi
    add eax, edi

        cmp grid[eax], 2

        je gameloop
            cmp yPos,24     ;;checks for the last line
            ja not_down
            call UpdatePlayer
            inc yPos
            call DrawPlayer
        not_down:
            jmp gameLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

moveLeft:
    mov esi, 0
    mov edi, 0
    movzx esi, xPos
    movzx edi, yPos
    mov eax, 0
    
    dec esi
    mov eax, esi
    imul eax, 25
    add eax, edi

        cmp grid[eax], 2

    je gameloop
            cmp xPos, 4     ;;checks for the last line
            jb not_left
            call UpdatePlayer
            dec xPos
            call DrawPlayer
        not_left:
            jmp gameLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

moveRight:
    mov esi, 0
    mov edi, 0
    movzx esi, xPos
    movzx edi, yPos
    mov eax, 0
    
    inc esi
    mov eax, esi
    imul eax, 25
    add eax, edi

        cmp grid[eax], 2

    je gameloop
        cmp xPos, 114     ;;checks for the last line
        ja not_right
        call UpdatePlayer
        inc xPos
        call DrawPlayer
    not_right:
        jmp gameLoop

    jmp gameLoop

    exitGame:
    exit
main ENDP

moveANDcheckCollision_enemy1 PROC
    cmp enemy_x1, 4
        jb enemy_shiftX
        call UpdateEnemy1
        dec enemy_x1
        call DrawEnemy1
        jmp not_shift
    enemy_shiftX:
        call UpdateEnemy1
        mov enemy_x1, 115
        call DrawEnemy1
    not_shift:
    ret
moveANDcheckCollision_enemy1 ENDP
moveANDcheckCollision_enemy2 PROC
        ;;checks for DOWN movement
    cmp enemy_x2, 80
    jb not_down
    cmp enemy_x2, 87
    jnb not_down
    cmp enemy_y2, 15
    jnb not_down
    call UpdateEnemy2           ;moves up
    inc enemy_y2
    call DrawEnemy2
    jmp down_done
not_down:

down_done:
        ;;checks for UP movement
    cmp enemy_x2, 36
    jnb not_up
    cmp enemy_y2, 10
    jb not_up
    call UpdateEnemy2           ;moves up
    dec enemy_y2
    call DrawEnemy2
    jmp up_done
not_up:
        call UpdateEnemy2       ;moves left
        dec enemy_x2
        call DrawEnemy2
up_done:

    cmp enemy_x2, 4
        jb enemy_shiftX
        jmp not_shift
    enemy_shiftX:
        call UpdateEnemy2
        mov enemy_x2, 115
        call DrawEnemy2
    not_shift:
    ret
moveANDcheckCollision_enemy2 ENDP
moveANDcheckCollision_enemy3 PROC

        ;;checks for UP movement
    cmp enemy_x3, 28
    jnb not_up
    cmp enemy_y3, 16
    jb not_up
    call UpdateEnemy3           ;moves up
    dec enemy_y3
    call DrawEnemy3
    jmp up_done
not_up:

up_done:
    
    cmp enemy_x3, 90
    jb not_down1
    cmp enemy_x3, 100
    jnb not_down1
    cmp enemy_y3, 20
    jnb not_down1
    call UpdateEnemy3
    inc enemy_y3
    call DrawEnemy3
not_down1:
        call UpdateEnemy3       ;moves left
        sub enemy_x3, 2
        call DrawEnemy3

    cmp enemy_x3, 5
        jb enemy_shiftX
        jmp not_shift
    enemy_shiftX:
        call UpdateEnemy3
        mov enemy_x3, 115
        call DrawEnemy3
    not_shift:
    ret
moveANDcheckCollision_enemy3 ENDP

checkCollisionwith_enemy1 PROC

    dec lives_count
    
    call UpdatePlayer
    mov xPos,10
    mov yPos,10
    call DrawPlayer
    call update_lives

    ret
checkCollisionwith_enemy1 ENDP
checkCollisionwith_enemy2 PROC

    dec lives_count
    
    call UpdatePlayer
    mov xPos,10
    mov yPos,10
    call DrawPlayer
    call update_lives

    ret
checkCollisionwith_enemy2 ENDP
checkCollisionwith_enemy3 PROC

    dec lives_count
    
    call UpdatePlayer
    mov xPos,10
    mov yPos,10
    call DrawPlayer
    call update_lives

    ret
checkCollisionwith_enemy3 ENDP

update_lives PROC
        cmp lives_count, 2
        je lives_2
        cmp lives_count, 1
        je lives_1
        cmp lives_count, 0
        je lives_0
        jmp next
    lives_2:
        mov dl, 14
        mov dh, 28
        call gotoxy
        mov al,' '
        call WriteChar
        jmp next
    lives_1:
        mov dl, 12
        mov dh, 28
        call gotoxy
        mov al,' '
        call WriteChar
        jmp next
    lives_0:
        call clrscr
        call EndGame
        exit
    next:
    ret
update_lives ENDP

DrawPlayer PROC
    ; draw player at (xPos,yPos):
    mov eax,yellow ;(blue*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al,"X"
    call WriteChar
    ret
DrawPlayer ENDP

DrawFruit1 PROC
    ; draw player at (xPos,yPos):
    mov eax,green ;(blue*16)
    call SetTextColor
    mov dl,fruit_x1
    mov dh,fruit_y1
    call Gotoxy
    mov al,"#"
    call WriteChar
    ret
DrawFruit1 ENDP
UpdateFruit1 PROC
    mov dl,fruit_x1
    mov dh,fruit_y1
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateFruit1 ENDP
Fruit1_gravity PROC

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GRAVITY LOGIC FOR FRUIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    cmp level, 2
        jne onGround
gravity:                    ; gravity logic:
    cmp fruit_y1,5
    jg onGround    ; make player fall:
    call UpdateFruit1
    inc fruit_y1
    call DrawFruit1
    mov eax,80
    call Delay
    jmp gravity
onGround:
    ret
Fruit1_gravity ENDP
checkFruit1 PROC

    mov bl,xPos
    cmp bl,fruit_x1
    jne not_taken
    mov bl,yPos
    cmp bl,fruit_y1
    jne not_taken
        call updateFruit1
        add score, 20
not_taken:

    ret
checkFruit1 ENDP

DrawFruit2 PROC
    ; draw player at (xPos,yPos):
    mov eax,green ;(blue*16)
    call SetTextColor
    mov dl,fruit_x2
    mov dh,fruit_y2
    call Gotoxy
    mov al,'@'
    call WriteChar
    ret
DrawFruit2 ENDP
UpdateFruit2 PROC
    mov dl,fruit_x2
    mov dh,fruit_y2
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateFruit2 ENDP
Fruit2_gravity PROC

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GRAVITY LOGIC FOR FRUIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    cmp level, 3
        jne onGround
gravity:                    ; gravity logic:
    cmp fruit_y2,16
    jg onGround    ; make player fall:
    call UpdateFruit2
    inc fruit_y2
    call DrawFruit2
    mov eax,80
    call Delay
    jmp gravity
onGround:
    ret
Fruit2_gravity ENDP
checkFruit2 PROC

    mov bl,xPos
    cmp bl,fruit_x2
    jne not_taken
    mov bl,yPos
    cmp bl,fruit_y2
    jne not_taken
        call updateFruit2
        add score, 30
not_taken:

    ret
checkFruit2 ENDP

DrawFruit3 PROC
    ; draw player at (xPos,yPos):
    mov eax,green ;(blue*16)
    call SetTextColor
    mov dl,fruit_x3
    mov dh,fruit_y3
    call Gotoxy
    mov al,"@"
    call WriteChar
    ret
DrawFruit3 ENDP
UpdateFruit3 PROC
    mov dl,fruit_x3
    mov dh,fruit_y3
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateFruit3 ENDP
Fruit3_gravity PROC

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GRAVITY LOGIC FOR FRUIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    cmp level, 3
        jne onGround2
    cmp score, 250
        jb onGround2
gravity2:                    ; gravity logic:
    cmp fruit_y3,24
    jg onGround2    ; make player fall:
    call UpdateFruit3
    inc fruit_y3
    call DrawFruit3
    mov eax,80
    call Delay
    jmp gravity2
onGround2:
    ret
Fruit3_gravity ENDP
checkFruit3 PROC

    mov bl,xPos
    cmp bl,fruit_x3
    jne not_taken
    mov bl,yPos
    cmp bl,fruit_y3
    jne not_taken
        call updateFruit3
        add score, 50
not_taken:

    ret
checkFruit3 ENDP

DrawEnemy1 PROC
    ; draw enemy at (enemy_x,emeny_y)
    mov eax,red ;(blue*16)
    call SetTextColor
    mov dl,enemy_x1
    mov dh,enemy_y1
    call Gotoxy
    mov al,"1"
    call WriteChar
    ret
DrawEnemy1 ENDP
DrawEnemy2 PROC
    ; draw enemy at (enemy_x,emeny_y)
    mov eax,red ;(blue*16)
    call SetTextColor
    mov dl,enemy_x2
    mov dh,enemy_y2
    call Gotoxy
    mov al,"2"
    call WriteChar
    ret
DrawEnemy2 ENDP
DrawEnemy3 PROC
    ; draw enemy at (enemy_x,emeny_y)
    mov eax,red ;(blue*16)
    call SetTextColor
    mov dl,enemy_x3
    mov dh,enemy_y3
    call Gotoxy
    mov al,"3"
    call WriteChar
    ret
DrawEnemy3 ENDP

UpdateEnemy1 PROC
    mov dl,enemy_x1
    mov dh,enemy_y1
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateEnemy1 ENDP
UpdateEnemy2 PROC
    mov dl,enemy_x2
    mov dh,enemy_y2
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateEnemy2 ENDP
UpdateEnemy3 PROC
    mov dl,enemy_x3
    mov dh,enemy_y3
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdateEnemy3 ENDP

UpdatePlayer PROC
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdatePlayer ENDP

DrawCoin PROC
    mov eax,yellow ;(red * 16)
    call SetTextColor
    mov dl,xCoinPos
    mov dh,yCoinPos
    call Gotoxy
    mov al,"."
    call WriteChar
    ret
DrawCoin ENDP

CreateRandomCoin PROC
    mov eax,55
    inc eax
    call RandomRange
    mov xCoinPos,al
    call RandomRange
    mov yCoinPos,al
    ret
CreateRandomCoin ENDP

DrawLives PROC

    mov eax, red + (black*16)
    call setTextColor

    mov dh, 28
    mov dl, 114
    call gotoxy
    mov al,1
    call writedec

    mov ecx, 3
    mov temp, 10
L1:
    mov dh, 28
    mov dl, temp
    call gotoxy
    mov al, '@'
    call WriteChar
    add temp, 2
    loop L1

    ret
DrawLives ENDP

StartGame PROC
    mov eax, yellow +(black*16)
    call setTextColor

    mov dh, 4
    mov dl, 20
    call gotoxy
    lea edx, menu1
    call writestring
    call crlf
    
    mov dh, 5
    mov dl, 20
    call gotoxy
    lea edx, menu2
    call writestring
    call crlf
    
    mov dh, 6
    mov dl, 20
    call gotoxy
    lea edx, menu3
    call writestring
    call crlf
    
    mov dh, 7
    mov dl, 20
    call gotoxy
    lea edx, menu4
    call writestring
    call crlf
    
    mov dh, 8
    mov dl, 20
    call gotoxy
    lea edx, menu5
    call writestring
    call crlf
    
    mov dh, 9
    mov dl, 20
    call gotoxy
    lea edx, menu6
    call writestring
    call crlf
    
    mov dh, 10
    mov dl, 20
    call gotoxy
    lea edx, menu7
    call writestring
    call crlf
    
    mov eax,red+(black*16)
    call setTextColor

    mov dh, 12
    mov dl, 20
    call gotoxy
    lea edx, menu8
    call writestring
    call crlf
    
    mov eax,gray+(black*16)
    call setTextColor
    mov dh, 14
    mov dl, 20
    call gotoxy
    lea edx, start1
    call writestring
    call crlf
    
    mov dh, 16
    mov dl, 20
    call gotoxy
    lea edx, start2
    call writestring
    call crlf
    
    mov dh, 18
    mov dl, 20
    call gotoxy
    lea edx, start3
    call writestring
    call crlf

    mov dh, 20
    mov dl, 20
    call gotoxy
    lea edx, start4
    call writestring
    call crlf
    
    mov eax,red+(black*16)
    call setTextColor

    mov dh, 22
    mov dl, 42
    call gotoxy
    mov edx, offset prompt_start
    call writestring
    mov edx, offset enter_start
    mov ecx, 255
    call readstring

    mov al, enter_start
    cmp al, "s"
    je start_game
    jmp not_start
start_game:
    ret
not_start:

    cmp al, "h"
    je high_game
    jmp not_high
high_game:
    call clrscr
    call DrawHighScore
    call waitmsg
    call clrscr
    call StartGame
    ret
not_high:

    cmp al, "i"
    je instr_game
    jmp not_instr
instr_game:
    call clrscr
    call DrawInstructions
    call waitmsg
    call clrscr
    call StartGame
    ret
not_instr:
    cmp al, "e"
    je exit_game
    jmp not_exit
exit_game:
    exit
not_exit:
StartGame ENDP

Menu PROC
    
    mov eax,yellow+(black*16)
    call setTextColor

    mov dh, 10
    mov dl, 20
    call gotoxy
    lea edx, menu1
    call writestring
    call crlf
    
    mov dh, 11
    mov dl, 20
    call gotoxy
    lea edx, menu2
    call writestring
    call crlf
    
    mov dh, 12
    mov dl, 20
    call gotoxy
    lea edx, menu3
    call writestring
    call crlf
    
    mov dh, 13
    mov dl, 20
    call gotoxy
    lea edx, menu4
    call writestring
    call crlf
    
    mov dh, 14
    mov dl, 20
    call gotoxy
    lea edx, menu5
    call writestring
    call crlf
    
    mov dh, 15
    mov dl, 20
    call gotoxy
    lea edx, menu6
    call writestring
    call crlf
    
    mov dh, 16
    mov dl, 20
    call gotoxy
    lea edx, menu7
    call writestring
    call crlf
    
    mov dh, 17
    mov dl, 20
    call gotoxy
    mov eax,red+(black*16)
    call setTextColor
    lea edx, menu8
    call writestring
    call crlf
    
    mov dh, 19
    mov dl, 42
    call gotoxy

    mov edx, offset enter_name
    call writestring
    mov edx, offset player_name
    mov ecx, 10
    call readstring

    ret
Menu ENDP

Paused PROC
       call clrscr

    mov eax,yellow + (black*16)
    call setTextColor

       mov dh, 10
       mov dl, 20
       call gotoxy
       lea edx, paused1
       call writestring
       call crlf
       
       mov dh, 11
       mov dl, 20
       call gotoxy
       lea edx, paused2
       call writestring
       call crlf
       
       mov dh, 12
       mov dl, 20
       call gotoxy
       lea edx, paused3
       call writestring
       call crlf
       
       mov dh, 13
       mov dl, 20
       call gotoxy
       lea edx, paused4
       call writestring
       call crlf
       
       mov dh, 14
       mov dl, 20
       call gotoxy
       lea edx, paused5
       call writestring
       call crlf
       
       mov dh, 15
       mov dl, 20
       call gotoxy
       lea edx, paused6
       call writestring
       call crlf
       
       mov dh, 16
       mov dl, 20
       call gotoxy
       lea edx, paused7
       call writestring
       call crlf
       
       mov dh, 18
       mov dl, 40
       call gotoxy
       mov eax, red+(black*16)
       call setTextColor

       call waitmsg
       call clrscr
    ret
Paused ENDP

EndGame PROC

    mov eax,red + (black*16)
    call setTextColor

       mov dh, 4
       mov dl, 20
       call gotoxy
       lea edx, end1
       call writestring
       call crlf
       
       mov dh, 5
       mov dl, 20
       call gotoxy
       lea edx, end2
       call writestring
       call crlf
       
       mov dh, 6
       mov dl, 20
       call gotoxy
       lea edx, end3
       call writestring
       call crlf
       
       mov dh, 7
       mov dl, 20
       call gotoxy
       lea edx, end4
       call writestring
       call crlf
       
       mov dh, 8
       mov dl, 20
       call gotoxy
       lea edx, end5
       call writestring
       call crlf
       
       mov dh, 9
       mov dl, 20
       call gotoxy
       lea edx, end6
       call writestring
       call crlf
       
       mov dh, 10
       mov dl, 20
       call gotoxy
       lea edx, end7
       call writestring
       call crlf
       
       mov dh, 12
       mov dl, 40
       call gotoxy
       mov eax, yellow+(black*16)
       call setTextColor

       mov edx, offset display_name
       call writestring
       mov edx, offset player_name
       call writestring
       
       mov dh, 14
       mov dl, 40
       call gotoxy
       mov edx, offset strScore
       call writestring
       mov edx, offset Score
       call writedec
       
       mov dh, 16
       mov dl, 40
       call gotoxy
       mov eax, red+(black*16)
       call setTextColor

       call waitmsg
       call crlf

       mov dh, 18
       mov dl, 40
       call gotoxy
       mov eax, red+(black*16)
       call setTextColor

       ; Create a new text file.
    mov edx,OFFSET filename
    call CreateOutputFile
    
    mov fileHandle, eax
   
    cmp eax, INVALID_HANDLE_VALUE   ;Check for errors.
    jne letsWriteToFile ; if error not found
  
    mov edx,OFFSET str1 ; display error
    call WriteString
    jmp quit

letsWriteToFile:   
    
    mov esi, offset buffer
    mov ecx, lengthof display_name
    dec ecx
    mov edi, offset display_name
L1:
    mov bl, [edi]
    mov [esi], bl
    inc esi
    inc edi
    loop L1 
    
    mov ecx, 8
    mov edi, offset player_name
L2:
    mov bl, [edi]
    mov [esi], bl
    inc esi
    inc edi
    loop L2
    
    mov bl, 'a'
    mov [esi], bl
    inc esi
    mov bl, 'n'
    mov [esi], bl
    inc esi
    mov bl, 'd'
    mov [esi], bl
    inc esi
    mov bl, ' '
    mov [esi], bl
    inc esi

    mov ecx, lengthof strScore
    mov edi, offset strScore
L3:
    mov bl, [edi]
    mov [esi], bl
    inc esi
    inc edi
    loop L3
    
    mov bl, score
    add bl, 30
    mov [esi], bl

    mov bl, ' '
    mov [esi], bl
    inc esi
    mov bl, 'a'
    mov [esi], bl
    inc esi
    mov bl, 'n'
    mov [esi], bl
    inc esi
    mov bl, 'd'
    mov [esi], bl
    inc esi
    mov bl, ' '
    mov [esi], bl
    inc esi

    mov ecx, lengthof display_level
    mov edi, offset display_level
L4:
    mov bl, [edi]
    mov [esi], bl
    inc esi
    inc edi
    loop L4

    mov bl, level
    mov [esi], bl

    mov stringLength, lengthof buffer   ; counts chars of buffer

    mov eax, fileHandle      ; Write the buffer to the output file.
    mov edx, OFFSET buffer
    mov ecx, stringLength
    call WriteToFile
    
    mov bytesWritten, eax
    
    ; save return value
    call CloseFile

quit:
    ret
EndGame ENDP

checkCoin PROC
    mov esi, 0
    mov edi, 0
    movzx esi, xPos
    movzx edi, yPos
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

    mov ebx, 0
    mov bl, grid[eax]
    cmp bl, 1
    jne no_coin

    inc score
    mov grid[eax], '0'

no_coin:
    ret
checkCoin ENDP

PrintDot PROC
    mov eax, yellow+(black*16)
    call SetTextColor

    mov ebx, 25
    mov dh, 2
L1:
    mov ecx, 28
    mov temp, 5
L2:
    mov dl, temp

    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 1
        
    call gotoxy
    mov al, '.'
    call writeChar

    add temp, 4
    loop L2
    inc dh
    dec ebx
    mov ecx, ebx
    loop L1
    
    ret
PrintDot ENDP

DrawPowerUps PROC
                                            ; DRAWING THE PORTAL
    mov eax, black+(lightRed*16)
    call setTextColor
    
    ; DRAWING THE FIRST HALF OF THE PORTAL
    mov dh, 10
    mov dl, 100
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 11
    mov dl, 99
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 11
    mov dl, 101
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 12
    mov dl, 100
    call gotoxy
    mov al, ' '
    call writeChar

    ; DRAWING THE SECOND HALF OF THE PORTAL
    mov dh, 18
    mov dl, 11
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 19
    mov dl, 10
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 19
    mov dl, 12
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 20
    mov dl, 11
    call gotoxy
    mov al, ' '
    call writeChar

    ; DRAWING THE THIRD HALF OF THE PORTAL
    mov dh, 6
    mov dl, 51
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 7
    mov dl, 50
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 7
    mov dl, 52
    call gotoxy
    mov al, ' '
    call writeChar

    mov dh, 8
    mov dl, 51
    call gotoxy
    mov al, ' '
    call writeChar

    mov eax, black+(black*16)
    call setTextColor

    ret
DrawPowerUps ENDP

CheckPowerUps1 PROC
    
    cmp xPos, 100
    jne no_fly
    cmp yPos, 11
    jne no_fly
    call UpdatePlayer
    mov xPos, 11
    mov yPos, 19
    call DrawPlayer
no_fly:

    ret
CheckPowerUps1 ENDP
CheckPowerUps2 PROC
    
    cmp xPos, 11
    jne no_fly
    cmp yPos, 19
    jne no_fly
    call UpdatePlayer
    mov xPos, 51
    mov yPos, 7
    call DrawPlayer
no_fly:

    ret
CheckPowerUps2 ENDP
CheckPowerUps3 PROC
    
    cmp xPos, 51
    jne no_fly
    cmp yPos, 7
    jne no_fly
    call UpdatePlayer
    mov xPos, 100
    mov yPos, 11
    call DrawPlayer
no_fly:
    call DrawPowerUps

    ret
CheckPowerUps3 ENDP

maze_level1 PROC
    mov eax, black+(red*16)
    call setTextColor

    mov ebx, 5
    mov temp2 , 47
r2:
    mov dl, temp2
    mov ecx, 10         ;draws the vertical line for middle maze
    mov temp, 7
r1:
    mov dh, temp
    
    cmp dh, 8
    je no_write
    cmp dh, 15
    je no_write

    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    no_write:
    inc temp
    loop r1
    dec ebx
    mov ecx, ebx
    add temp2, 8
    loop r2

    mov ecx, 30         ;draws the horizontal line for upper-left maze
    mov temp, 10
L1:
    mov dh, 7
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L1

    mov ecx, 5         ;draws the vertical line for upper-left maze
    mov temp, 7
L2:
    mov dh, temp
    mov dl, 39
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L2

    mov ecx, 30         ;draws the horizontal line for upper-right maze
    mov temp, 80
L3:
    mov dh, 7
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L3

    mov ecx, 5         ;draws the vertical line for upper-right maze
    mov temp, 7
L4:
    mov dh, temp
    mov dl, 79
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L4

    mov ecx, 8         ;draws the vertical line for lower maze
    mov temp, 11
L5:
    mov dh, temp
    mov dl, 29
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L5

    mov ecx, 60         ;draws the horizontal line for lower maze
    mov temp, 30
L6:
    mov dh, 18
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L6

    mov ecx, 8         ;draws the vertical line for lower maze
    mov temp, 11
L7:
    mov dh, temp
    mov dl, 89
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L7

    ret
maze_level1 ENDP
maze_level2 PROC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 2 MAZE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov eax,black +(lightCyan * 16)
        call SetTextColor

    mov ecx, 5         ;draws the vertical line for lower-right maze "_|"
    mov temp, 17
L8:
    mov dh, temp
    mov dl, 99
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L8

    mov ecx, 15         ;draws the horizontal line for lower-left maze
    mov temp, 99
L9:
    mov dh, 22
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    dec temp
    loop L9

    mov ecx, 5         ;draws the vertical line for lower-left maze "|_"
    mov temp, 17
L10:
    mov dh, temp
    mov dl, 19
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L10

    mov ecx, 15         ;draws the horizontal line for lower-left maze "|_"
    mov temp, 19
L11:
    mov dh, 22
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writechar
    inc temp
    loop L11

    mov eax,black +(black * 16)
        call SetTextColor

    ret
maze_level2 ENDP
maze_level3 PROC
    
        mov eax, black+(lightMagenta*16)
        call setTextColor

    mov ecx, 3
    mov temp, 22
L1:
    mov dh, temp
    mov dl, 43

    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writeChar
    inc temp
    loop L1

    mov ecx, 32
    mov temp, 43
L2:
    mov dh, 22
    mov dl, temp
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writeChar
    inc temp
    loop L2

    mov ecx, 3
    mov temp, 22
L3:
    mov dh, temp
    mov dl, 75
    
    mov esi, 0
    mov edi, 0
    movzx esi, dl
    movzx edi, dh
    mov eax, 0

    mov eax, esi
    imul eax, 25
    add eax, edi

        mov grid[eax], 2

    call gotoxy
    mov al, ' '
    call writeChar
    inc temp
    loop L3

    mov eax, black+(black*16)
    call setTextColor
    ret
maze_level3 ENDP

DrawHighScore PROC
    
    mov eax, yellow+(black*16)
    call setTextColor

    mov dh, 4
    mov dl, 10
    call gotoxy
    lea edx, highscore1
    call writestring
    call crlf
    
    mov dh, 5
    mov dl, 10
    call gotoxy
    lea edx, highscore2
    call writestring
    call crlf
    
    mov dh, 6
    mov dl, 10
    call gotoxy
    lea edx, highscore3
    call writestring
    call crlf
    
    mov dh, 7
    mov dl, 10
    call gotoxy
    lea edx, highscore4
    call writestring
    call crlf
    
    mov dh, 8
    mov dl, 10
    call gotoxy
    lea edx, highscore5
    call writestring
    call crlf
    
    mov dh, 9
    mov dl, 10
    call gotoxy
    lea edx, highscore6
    call writestring
    call crlf
    
    mov dh, 10
    mov dl, 10
    call gotoxy
    lea edx, highscore7
    call writestring
    call crlf

    mov dh, 11
    mov dl, 10
    call gotoxy
    lea edx, highscore8
    call writestring
    call crlf

    ; Open the file for input.
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle, eax
	
	cmp eax, INVALID_HANDLE_VALUE ; error opening file?
	jne letsOpenFile 
	
	mWrite "Cannot open file"	; prompt that we cannot open file
	jmp quit	; and quit
	
	letsOpenFile:
		mov edx, OFFSET buffer	; Read the file into a buffer.
		mov ecx, BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size
	
	mWrite "Error reading file. " ;	error reading?
	call WriteWindowsMsg	 ;	yes: show error message
	jmp close_file
	
	check_buffer_size:
		cmp eax,BUFFER_SIZE
		jb buf_size_ok	; buffer large enough?
		mWrite <"Error: Buffer too small for the file",0dh,0ah>	; yes
		jmp quit	 ; and quit
	
	buf_size_ok:
		mov buffer[eax],0	; insert null terminator
        mov dh, 11
        mov dl, 77
        call gotoxy
		mWrite "File size: "
		call WriteDec	; display file size
		call Crlf
	

    mov dh, 15
    mov dl, 35
    call gotoxy
    mov edx, offset arrow
    call writestring

    mov dh, 15      ; Display the buffer.
    mov dl, 38
    call gotoxy
	mov edx,OFFSET buffer
	call WriteString	    ; display the buffer
	call Crlf
	
	close_file:
		mov eax,fileHandle
		call CloseFile
	
	quit:
    
       mov dh, 22
       mov dl, 40
       call gotoxy

    ret
DrawHighScore ENDP

DrawInstructions PROC
    
    mov eax, yellow+(black*16)
    call SetTextColor

       mov dh, 2
       mov dl, 2
       call gotoxy
       lea edx, instruction1
       call writestring
       call crlf
    
       mov dh, 3
       mov dl, 2
       call gotoxy
       lea edx, instruction2
       call writestring
       call crlf
    
       mov dh, 4
       mov dl, 2
       call gotoxy
       lea edx, instruction3
       call writestring
       call crlf
    
       mov dh, 5
       mov dl, 2
       call gotoxy
       lea edx, instruction4
       call writestring
       call crlf
    
       mov dh, 6
       mov dl, 2
       call gotoxy
       lea edx, instruction5
       call writestring
       call crlf
    
       mov dh, 7
       mov dl, 2
       call gotoxy
       lea edx, instruction6
       call writestring
       call crlf
       
    mov eax, red+(black*16)
    call SetTextColor
    
       mov dh, 10
       mov dl, 2
       call gotoxy
       lea edx, instruction7
       call writestring
       call crlf
    
       mov dh, 11
       mov dl, 2
       call gotoxy
       lea edx, instruction8
       call writestring
       call crlf
    
       mov dh, 12
       mov dl, 2
       call gotoxy
       lea edx, instruction9
       call writestring
       call crlf
    
       mov dh, 13
       mov dl, 2
       call gotoxy
       lea edx, instruction10
       call writestring
       call crlf
    
       mov dh, 14
       mov dl, 2
       call gotoxy
       lea edx, instruction11
       call writestring
       call crlf
    
       mov dh, 15
       mov dl, 2
       call gotoxy
       lea edx, instruction12
       call writestring
       call crlf
    
       mov dh, 16
       mov dl, 2
       call gotoxy
       lea edx, instruction13
       call writestring
       call crlf
    
       mov dh, 17
       mov dl, 2
       call gotoxy
       lea edx, instruction14
       call writestring
       call crlf
    
       mov dh, 18
       mov dl, 2
       call gotoxy
       lea edx, instruction15
       call writestring
       call crlf
    
       mov dh, 19
       mov dl, 2
       call gotoxy
       lea edx, instruction16
       call writestring
       call crlf

       mov dh, 22
       mov dl, 40
       call gotoxy

    ret
DrawInstructions ENDP

END main
