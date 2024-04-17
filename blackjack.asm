; Alexander Peters CS-274
; Goal: Implement Blackjack using MASM and TASM

; I struggled greatly with the random number generator and was unable to complete this aspect of the program unfortunately.

; Important Variables
assume cs:code
data segment
   assume ds:data
   card_values db 'A23456789TJQK' ; Ace, nums, Jack, Queen, etc.
   suits db 'HDCS'
   ;suits db 3 dup('H'), 3 dup('D'), 3 dup('C'), 3 dup('S') ; Hearts, Diamonds, Clubs, Spades
   available_cards db 52 ; Cards left
   used_cards db 0 ; Cards used so far
   current_deck db 0 ; Current deck being operated upon
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

   random_card:
      ; Random num seed
      mov ah, 2Ch
      int 21h
      mov dx, ax ; Store random seed in dx

      ; Get card type
      mov al, byte ptr [card_values + 1]
      call draw_card

      ; Get suit type for card
      mov al, byte ptr [suits + 1]
      call draw_card

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
      
code ends
end
