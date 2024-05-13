; MASM.asm
; Author: Sunil Jain
; Course/Project ID: CS271 -Homework 1
; Date: 1/24/24
; Description:

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode : dword

; insert CONSTANT definitions here

     MAX_STR = 80 ; maximum chars to read to name

.data

; insert VARIABLE definitions here

; introduction messages, setting up the program
	intro_msg           Byte      0ah, 0Dh, "HW 1: Fencing a pasture by Sunil Jain", 0
     name_request        Byte      0ah, 0Dh, "Enter your name: ", 0

; prompts for the user
     width_request       Byte      0ah, 0Dh, "Enter the width of the pasture (in feet) : ", 0
     length_request      Byte      "Enter the length of the pasture (in feet) : ", 0
     planks_request      Byte      "Enter the linear feet of wood planks : ", 0

; display messages for the calculated area, perimeter, rails, and remaining wood
     area_msg            Byte      0ah, 0Dh, "The area of the pasture is ", 0
     perimeter_msg       Byte      0ah, 0Dh, "The perimeter of the pasture is ", 0
     planks_msg          Byte      0ah, 0Dh, "You have enough wood for ", 0
     planks_msg2         Byte      " rails and an extra ", 0
     planks_msg3         Byte      " linear feet of 1x6'' planks", 0ah, 0Dh, 0

; prompt to continue the program 
     outro_msg           Byte      0ah, 0Dh, "Would you like to do another calculation (0=NO, 1=YES) : ", 0
     
; good bye message, displayed with the user name
     bye_msg             Byte      0ah, 0Dh, "Good bye ", 0


; user input variables
     name_input          Byte      MAX_STR+1 DUP(?)
     width_input         DWORD     MAX_STR+1 DUP(?)
     length_input        DWORD     MAX_STR+1 DUP(?)
     planks_input        DWORD     MAX_STR+1 DUP(?)


; NAMED VARIABLES TO STORE CALCULATED VALUES
     pasture_area        DWORD     ?
     pasture_perimeter   DWORD     ?
     plank_num           DWORD     ?

.code
main proc

; insert executable instructions here

step1: ; INTRODUCTION

; TITLE:       Print the greeting message.
; DESCRIPTION: displays intro_msg to the screen to greet the player
	mov		edx, OFFSET intro_msg
	Call      WriteString  

; request And read the user name
; TITLE:       Getting the user's name
; DESCRIPTION: prompts for the player's then collects it using ReadString then collects and stores it in a variable
	mov		edx, OFFSET name_request
	Call      WriteString

     mov       edx, OFFSET name_input
     mov       ecx, MAX_STR ; amount of characters to read in
     Call      ReadString

step2: ; GET THE DATA

; TITLE:       Getting the pasture width.
; DESCRIPTION: prompts for the pasture width using ReadInt then collects and stores it in a variable
	mov		edx, OFFSET width_request
	Call      WriteString

     Call      ReadInt
     mov       width_input, eax

; TITLE:       Getting the pasture length.
; DESCRIPTION: prompts for the pasture length using ReadInt then collects and stores it in a variable
	mov		edx, OFFSET length_request
	Call      WriteString

     Call      ReadInt
     mov       length_input, eax
     
; TITLE:       Getting the plank number.
; DESCRIPTION: prompts for the number of available planks using ReadInt then collects and stores it in a variable
	mov		edx, OFFSET planks_request
	Call      WriteString

     Call      ReadInt
     mov       planks_input, eax


step3: ; CALCULATE THE REQUIRED DATA

; TITLE:       Calculate Area
; DESCRIPTION: Uses width and length to calculate Area = w*l then collects and stores it in a variable
     mov       eax, width_input
     mov       ebx, length_input
     mul       ebx

     mov       edx, OFFSET area_msg
     Call      WriteString
     Call      WriteInt
     mov       pasture_area, eax

; TITLE:       Calculate perimeter
; DESCRIPTION: Uses width and length to calculate perimeter = 2(w+l) then collects and stores it in a variable
     mov       eax, width_input
     add       eax, length_input
     mov       ebx, 2
     mul       ebx

     mov       edx, OFFSET perimeter_msg
     Call      WriteString
     Call      WriteInt
     mov       pasture_perimeter, eax

; TITLE:       Calculate the number of rails and remaining wood
; DESCRIPTION: uses perimeter and the number of available wood to calculate the rails and gives the remaining wood left over
     mov       edx, OFFSET planks_msg
     Call      WriteString

     mov       ebx, eax
     cdq
     mov       eax, planks_input
     div       ebx
     Call      WriteInt
     
     mov       edx, OFFSET planks_msg2
     Call      WriteString

     mov       ebx, eax
     mov       eax, pasture_perimeter
     mul       ebx
     mov       ebx, eax
     mov       eax, planks_input
     sub       eax, ebx
     Call      WriteInt
     mov       plank_num, eax

     mov       edx, OFFSET planks_msg3
     Call      WriteString
     

step4: ; PROMPT THE USER TO CONTINUE

; TITLE:       PROMPT THE USER TO CONTINUE
; DESCRIPTION: does so by getting a input from the user, if they input 0: end the program; if they input 1: loop back
     mov       edx, OFFSET outro_msg
     Call      WriteString

     Call      ReadInt
     mov       ebx, 0
     cmp       eax, 1
     je        step2
     jne       step5

step5: ; SAY GOOD BYE

; TITLE:       GOOD BYE
; DESCRIPTION: prints Good Bye + Player_name_here
     mov       edx, OFFSET bye_msg
     Call      WriteString

     mov       edx, OFFSET name_input
     Call      WriteString

	invoke ExitProcess,0
main endp
End main