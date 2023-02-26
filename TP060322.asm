.model small
.stack 300h
.386
.data
    username db 30,0,30 DUP('$') ; Buffer, EOS, Duplicate
    separator db 0dh,0ah,0dh,0ah,78 DUP('-'),0dh,0ah,0dh,0ah,'$'
    login_prompt db '              Welcome to the APU FSEC-SS Cash Register System!$'
    username_prompt db 'Please enter your name: $'
    welcome_prompt db 0dh,0ah,0dh,0ah,'Welcome, user $'
    
    menu_title db '                  APU FSEC-SS Cash Register System Main Menu$'
    menu db 9,'1. Workshops',0dh,0ah,9,'2. Competitions',0dh,0ah,9,'3. Activities',0dh,0ah,9,'4. Exit$'
    select_ws db 0dh,0ah,'You chose Option 1 - Workshops$'
    select_comp db 0dh,0ah,'You chose Option 2 - Competitions$'
    select_act db 0dh,0ah,'You chose Option 3 - Activities$'
    
    menu_w_title db '                       List of All Workshops by FSEC-SS$'
    menu_w_subt db 9,'Workshop Name                                   Pax     Price$'
    menu_w1 db 0dh,0ah,9,'1. Windows x86 Buffer Overflow Workshop$'
    menu_w2 db 0dh,0ah,9,'2. Pentesting 101 Workshop$'
    menu_w3 db 0dh,0ah,9,'3. Exploit Development 101 Python Workshop$'
    menu_w4 db 0dh,0ah,9,'4. Exit$'
    select_ws1 db 0dh,0ah,'You chose Option 1 - Windows x86 Buffer Overflow Workshop$'
    ws1_pax db 10
    ws1_price db 5
    select_ws2 db 0dh,0ah,'You chose Option 2 - Pentesting 101 Workshop$'
    ws2_pax db 20
    ws2_price db 10
    select_ws3 db 0dh,0ah,'You chose Option 3 - Exploit Development 101 Python Workshop$'
    ws3_pax db 15
    ws3_price db 15
    
    menu_c_title db '                     List of All Competitions by FSEC-SS$'
    menu_c_subt db 9,'Competition Name                                Pax     Price$'
    menu_c1 db 9,'1. Internal CTF 2023$'
    menu_c2 db 0dh,0ah,9,'2. Battle of Hackers CTF 2023$'
    menu_c3 db 0dh,0ah,9,'3. Exit$'
    select_c1 db 0dh,0ah,"You chose Option 1 - Internal CTF 2023$"
    c1_pax db 8
    c1_price db 0
    select_c2 db 0dh,0ah,"You chose Option 2 - Battle of Hackers CTF 2023$"
    c2_pax db 35
    c2_price db 50
    
    menu_a_title db '                       List of All Activities by FSEC-SS$'
    menu_a_subt db 9,'Activity Name                                   Pax     Price$'
    menu_a1 db 9,'1. REBoot Camp$'
    menu_a2 db 0dh,0ah,9,'2. CTF Crash Course$'
    menu_a3 db 0dh,0ah,9,'3. Across Verticals Company Visit$'
    menu_a4 db 0dh,0ah,9,'4. Exit$'
    select_a1 db 0dh,0ah,'You chose Option 1 - REBoot Camp$'
    a1_pax db 20
    a1_price db 5
    select_a2 db 0dh,0ah,'You chose Option 2 - CTF Crash Course$'
    a2_pax db 8
    a2_price db 10
    select_a3 db 0dh,0ah,'You chose Option 3 - Across Verticals Company Visit$'
    a3_pax db 3
    a3_price db 0
    
    select_prompt db 0dh,0ah,0dh,0ah,'Please enter your choice: $'
    sum db 0
    select_others db 0dh,0ah,0dh,0ah,'Please only choose options that are available on the menu.$'
    pax_zero db 0dh,0ah,0dh,0ah,'Sorry, there are no more slots left ...$',0dh,0ah,'Returning to main menu ...$'
    any_key db 0dh,0ah,0dh,0ah,'Press ANY KEY to continue ...$'
    
    ptc_prompt db 0dh,0ah,'Do you want to proceed to checkout now? [y OR n] : $'
    member_prompt db 0dh,0ah,'Are you a FSEC-SS member? [y OR n] : $'
    total db 0dh,0ah,0dh,0ah,'The amount that you have to pay is RM$'
    
    select_exit db 0dh,0ah,'Thank you for using our system, user $'
    TAB db 9
    TAB2 db 9,9,'$'
    TAB3 db 9,9,9,'$'
    TAB4 db 9,9,9,9,'$'
    TAB5 db 9,9,9,9,9,'$'
    CRLF db 0dh,0ah,'$'
.code

; Diplay the message on the screen
DispMsg MACRO Msg
   lea dx,Msg    ; Load message address
   mov ah,9h     ; Function to display string
   int 21h       ; Call DOS
ENDM


; Diplay char on the screen
DispChar MACRO Char
   mov ah,2         ; Function to display char
   mov dl,Char      ; Load message address
   int 21h          ; Call DOS
ENDM


; Display digits on the screen
Disp2D MACRO Digit
    mov al,Digit
    aam
    add ax,3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
ENDM


; Clear screen
ClrScr MACRO
    mov dx, 0       ; Row number
    mov cx, 0       ; Column number
    mov bx, 0       ; Color of the screen after it's cleared
    mov ax, 3h      ; Set cursor position
    int 10h         ; BIOS call
ENDM


; Input range validation to main_menu
InputValM MACRO
    DispMsg select_others
    DispMsg any_key
    mov ah, 0ah
    int 21h
    ClrScr
    jmp main_menu
ENDM


; Input range validation to exit
InputValE MACRO
    DispMsg select_others
    DispMsg any_key
    mov ah, 0ah
    int 21h
    ClrScr
    jmp exit
ENDM



MAIN PROC
    mov ax, @data
    mov ds, ax

    DispMsg separator
    DispMsg login_prompt
    DispMsg separator
    DispMsg username_prompt

    ; Get user input
    mov ah, 0ah
    mov dx, offset username
    int 21h
    
    jmp main_menu

    main_menu:
        ; Clear screen
        ClrScr
        
        DispMsg separator
        DispMsg menu_title
        DispMsg separator
        DispMsg menu
        DispMsg welcome_prompt
        DispMsg [username+2]    ; First 2 bytes are for the input interrupt call
        DispMsg select_prompt
        
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, '1'             ; Compare user input to '1'
        je ws
        cmp al, '2'             ; Compare user input to '2'
        je comp
        cmp al, '3'             ; Compare user input to '3'
        je act
        cmp al, '4'             ; Compare user input to '4'
        je exit

        ; If input is not 1 - 4, RESTART
        InputValM               

    
        
    ws:
        ; Code for option 1
        ClrScr
        DispMsg select_ws
        DispMsg separator
        DispMsg menu_w_title
        DispMsg separator
        DispMsg menu_w_subt
        DispMsg CRLF
        
        DispMsg menu_w1
        DispMsg TAB2
        Disp2D ws1_pax
        DispChar TAB
        Disp2D ws1_price
        
        DispMsg menu_w2
        DispMsg TAB3
        Disp2D ws2_pax
        DispChar TAB
        Disp2D ws2_price
        
        DispMsg menu_w3
        DispChar TAB
        Disp2D ws3_pax
        DispChar TAB
        Disp2D ws3_price
        
        DispMsg menu_w4
        DispMsg select_prompt
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, '1'             ; Compare user input to '1'
        je ws1
        cmp al, '2'             ; Compare user input to '2'
        je ws2
        cmp al, '3'             ; Compare user input to '3'
        je ws3
        cmp al, '4'             ; Compare user input to '4'
        je exit
           
        ; If input is not 1 - 4, RESTART
        InputValM

        ws1:
            ClrScr
            DispMsg select_ws1
            cmp ws1_pax,0       ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec ws1_pax         ; If there are still pax left, go to ptc
            add sum, 5
            jmp ptc
        ws2:
            ClrScr
            DispMsg select_ws2
            cmp ws2_pax,0       ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec ws2_pax
            add sum, 10
            jmp ptc
        ws3:
            ClrScr
            DispMsg select_ws3
            cmp ws3_pax,0       ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec ws3_pax
            add sum, 15
            jmp ptc
        
        
    comp:
        ; Code for option 2
        ClrScr
        DispMsg select_comp
        DispMsg separator
        DispMsg menu_c_title
        DispMsg separator
        DispMsg menu_c_subt
        DispMsg CRLF
        DispMsg CRLF
        
        DispMsg menu_c1
        DispMsg TAB4
        Disp2D c1_pax
        DispChar TAB
        Disp2D c1_price
        
        DispMsg menu_c2
        DispMsg TAB3
        Disp2D c2_pax
        DispChar TAB
        Disp2D c2_price

        DispMsg menu_c3
        DispMsg select_prompt
        
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, '1'             ; Compare user input to '1'
        je comp1
        cmp al, '2'             ; Compare user input to '2'
        je comp2
        cmp al, '3'             ; Compare user input to '3'
        je exit
        
        ; If input is not 1 - 3, RESTART
        InputValM
        
        comp1:
            ClrScr
            DispMsg select_c1
            cmp c1_pax,0        ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec c1_pax
            add sum, 0
            jmp ptc
        comp2:
            ClrScr
            DispMsg select_c2
            cmp c2_pax,0        ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec c2_pax
            add sum, 50
            jmp ptc

        
    act:
        ; Code for option 3
        ClrScr
        DispMsg select_act
        DispMsg separator
        DispMsg menu_a_title
        DispMsg separator
        DispMsg menu_a_subt
        DispMsg CRLF
        DispMsg CRLF
        
        DispMsg menu_a1
        DispMsg TAB5
        Disp2D a1_pax
        DispChar TAB
        Disp2D a1_price
        
        DispMsg menu_a2
        DispMsg TAB4
        Disp2D a2_pax
        DispChar TAB
        Disp2D a2_price
        
        DispMsg menu_a3
        DispMsg TAB2
        Disp2D a3_pax
        DispChar TAB
        Disp2D a3_price
        
        DispMsg menu_a4
        DispMsg select_prompt
        
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, '1'             ; Compare user input to '1'
        je act1
        cmp al, '2'             ; Compare user input to '2'
        je act2
        cmp al, '3'             ; Compare user input to '3'
        je act3
        cmp al, '4'             ; Compare user input to '4'
        je exit
        
        ; If input is not 1 - 4, RESTART
        InputValM

        act1:
            ClrScr
            DispMsg select_a1
            cmp a1_pax,0        ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec a1_pax
            add sum, 5
            jmp ptc
        act2:
            ClrScr
            DispMsg select_a2
            cmp a2_pax,0        ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec a2_pax
            add sum, 10
            jmp ptc
        act3:
            ClrScr
            DispMsg select_a3
            cmp a3_pax,0        ; If there are no more pax left, return to main_menu
            je no_pax_left
            
            dec a3_pax
            add sum, 0
            jmp ptc
    
    
            
    ; If there are no more pax left
    no_pax_left:
        DispMsg pax_zero
        DispMsg any_key
        mov ah, 0ah
        int 21h
        jmp main_menu
        
            
    ; Prompt to proceed to checkout
    ptc:
        DispMsg ptc_prompt
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, 'y'             ; Compare user input to 'y'
        je member
        cmp al, 'n'             ; Compare user input to 'n'
        je main_menu
        ; If input is not y OR n, RESTART
        InputValE
        
        
    ; Ask if the user is a member or not
    member:
        DispMsg member_prompt
        mov ah, 01h             ; Get user input
        int 21h
        cmp al, 'y'             ; Compare user input to 'y'
        je member_discount
        cmp al, 'n'             ; Compare user input to 'n'
        je checkout
        ; If input is not y OR n, RESTART
        InputValE
        
        
    ; Provide member discount (50%) - Not rounded up, then checkout
    member_discount:
        DispMsg total
        mov al,sum
        sar al,1                ; Shift arithmetic right AX by 1 bit, effectively dividing by 2
        mov sum,al
        Disp2D sum
        DispMsg any_key
        mov sum,0               ; Reset value to 0 for next user
        mov ah, 0ah
        int 21h
        ClrScr
        jmp main
    
        
    ; Checkout without discount
    checkout:
        DispMsg total
        Disp2D sum
        DispMsg any_key
        mov sum,0               ; Reset value to 0 for next user
        mov ah, 0ah
        int 21h
        ClrScr
        jmp main
        
        
    ; Exit program  
    exit:
        DispMsg select_exit
        DispMsg [username+2]    ; First 2 bytes are for the input interrupt call
        DispMsg any_key
        mov sum,0               ; Reset value to 0 for next user
        mov ah, 0ah
        int 21h
        ClrScr
        
        mov ax, 4c00h
        int 21h

MAIN ENDP
END MAIN