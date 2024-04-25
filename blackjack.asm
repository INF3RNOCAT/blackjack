; Alexander Peters CS-274
; Goal: Implement Blackjack using MASM and TASM

; Important Variables
assume cs:code
data segment
   assume ds:data
   card_values db 'A23456789TJQK' ; Ace, nums, Jack, Queen, etc.
   suits db 'HDCS'
   ;suits db 3 dup('H'), 3 dup('D'), 3 dup('C'), 3 dup('S') ; Hearts, Diamonds, Clubs, Spades
   available_cards db 52 ; Cards left
   used_cards db 0 ; Cards used so far
   current_deck dw 0 ; Current deck being operated upon

   ; Declare deck arrays
   player_deck db 26 dup(?)
   computer_deck db 26 dup(?) 

   ; Card indexes
   p_index dw 0 
   c_index dw 0 
data ends



; Begin the code
code segment
   ; set data segment pointer
   ; This allows us to access our previously defined data + call certain procedures
   push ax
   mov ax, data
   mov ds, ax
   pop ax  

   start:
      ; Initialize everything
      call init_graphics ; Initialize game graphics
      call init_decks ; Initialize decks


   ; This inititalizes the game graphics
   init_graphics:
      mov ax, 0013h ; Set video mode (320x200, 256 colors)
      int 10h ; Video services interrupt
      ret

   print_al:
      mov ah, 02h
      mov dl, al
      int 21h
      ret

   draw_card:
      mov ah, 0Ch ; BIOS function to plot pixel
      mov bh, 0 ; Video page
      mov bl, 15 ; White color
      mov cx, bx ; X-coordinate
      mov dx, ax ; Y-coordinate
      int 10h ; Plot pixel      

   store_player:
      mov bx, p_index     ; Load the index of the player_deck into bx
      mov byte ptr [player_deck + bx], al ; Store the card into the player_deck array
      inc p_index         ; Increment the player index for the next card

   store_computer:
      mov bx, c_index     ; Load the index of the computer_deck into bx
      mov byte ptr [computer_deck + bx], al ; Store the card into the computer_deck array
      inc c_index         ; Increment the computer index for the next card

   add_ace:

   calculate_deck:
      cmp di, 21
      je exit_game
      cmp si, 26
      je calculate_values
      mov al, byte ptr [player_deck + si]
      cmp al, 'A'
      je add_ace
      cmp al, ''
      inc si
      call calculate_deck

   exit_game:
   ; This terminates the program
      mov ah, 4Ch     ; Function code for terminating program
      mov al, 0       ; Return code (0 for successful termination)
      int 21h         ; Call DOS interrupt to terminate program

   calculate_values:
      mov si, 0 ; Inititalize si to 0
      mov di, 0 ; this stores the calculated amt
      mov ax, current_deck
      sub ax, ax

      inc current_deck
      call calculate_deck ; Calculate value of first deck
      inc current_deck 
      call calculate_deck ; Calculate next deck value

   prompt_card:
      mov ah, 0Ah
      lea dx, word [0x00, 0xff] ; address of buffer
      int 21h ; Call interrupt for user input
      mov si, 0
      lods byte ; Load character
      cmp al, 1 ; If the player enters 1, give them a random card, otherwise ret.
      je random_card
      ret

   random_card:
      ; Random num seed
      mov ah, 2Ch
      int 21h
      mov dx, ax ; Store random seed in dx

      ; Get card type
      mov al, byte ptr [card_values + 1]
      call draw_card

      ; Get suit type for card
      ; mov al, byte ptr [suits + 1]
      ; call draw_card

      ; Store card in array
      cmp current_deck, 1
      je store_player
      jne store_computer
      

      ; Decrease available cards
      dec available_cards
      inc used_cards

      ; Change position of next card
      inc bx

      jmp init_decks

   ; This inititalizes each deck
   init_decks:
      inc current_deck
      cmp current_deck, 2
      jle random_card
      jg game_loop

   ; Game runner
   game_loop:
      call prompt_card ; Ask user if they want a card
      ;call computer_prompt ; computer algorithm
      call calculate_values ; Calculate deck values after turns
      jmp game_loop
      

code ends
end
