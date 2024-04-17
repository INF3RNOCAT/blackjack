; Alexander Peters CS-274
; Goal: Implement Blackjack using MASM and TASM

; Important Variables
assume cs:code
data segment
   assume ds:data
   card_values db 'A23456789TJQK' ; Ace, nums, Jack, Queen, etc.
   suits db 3 dup('H'), 3 dup('D'), 3 dup('C'), 3 dup('S') ; Hearts, Diamonds, Clubs, Spades
   available_cards db 0 ; Cards left
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
      ; Set initial values
      mov available_cards, 52

      call init_graphics ; Initialize game graphics
      call init_decks ; Initialize decks

   ; This inititalizes the game graphics
   init_graphics:
      mov ax, 0013h ; Set video mode (320x200, 256 colors)
      int 10h ; Video services interrupt
      ret

   random_card:
      ; Random num seed
      mov ah, 2Ch
      int 21h
      mov dx, ax ; Store random seed in dx

      mov al, byte ptr [card_values + 1]


      jmp init_decks

   ; This inititalizes each deck
   init_decks:
      inc current_deck
      cmp current_deck, 2
      jle random_card

code ends
end
