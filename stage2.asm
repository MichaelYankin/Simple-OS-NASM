%include "/home/michael/shared/stage2info.inc"
ORG STAGE2_RUN_OFS

section .data
	logoLine1:		db '                                 _ _____ _____ ', 13, 10, 0
	logoLine2: 		db '                                | |  _  /  ___|', 13, 10, 0
	logoLine3: 		db '             _ __ __ _ _ __   __| | | | \ `--. ', 13, 10, 0
	logoLine4: 		db "            | '__/ _` | '_ \ / _` | | | |`--. \", 13, 10, 0
	logoLine5: 		db '            | | | (_| | | | | (_| \ \_/ /\__/ /', 13, 10, 0
	logoLine6: 		db '            |_|  \__,_|_| |_|\__,_|\___/\____/ ', 13, 10, 0
	entryLine: 		db '     Press ENTER to continue...', 0
	;
	creditsLine: 	db 'Lab 5. YankinMI, ChernyshovDM. randOS', 13, 10, 0
	optionsLine: 	db '            1 - Roll the dice', 13, 10, '            2 - Riddler', 13, 10, '            3 - Shutdown randOS', 13, 10, 0
	inputLine: 		db "            You're choosing: ", 0
	;
	searchWordsline: db 'you are searching a word', 13, 10, 0
	readbookline: 	db 'you are reading a book', 13, 10, 0
	;
	jumpCursor: 	db 13, 10, '            ', 0
	returnCursor: 	db 10, '            ', 0
	;
	chooseDice: 	db '            Make your choice of Dice:', 13, 10, 0
	diceTypes1: 	db '            1 - D4', 13, 10, '            2 - D6', 13, 10, '            3 - D8', 13, 10, 0
	diceTypes2: 	db '            4 - D10', 13, 10, '            5 - D12', 13, 10, '            6 - D20', 13, 10, '            >ENTER to quit', 13, 10, 0
	diceResult:		db 'Your result is: ', 0
	string :		db 0
	seed:			dw 0
	seed2:			dw 0
	;
	riddlerInstruction: db 'Ask me a question whether you should do something!', 13, 10, 0
	riddlerConfirm: db 'Yes! Definitely!', 13, 10, 0
	riddlerDeny: 	db 'No way!', 13, 10, 0
	riddlerAgain: 	db '            Would you like to ask me another question? [Y/N]', 13, 10, 0
	;
section .text

; очистка экрана
call cls;

; вывод логотипа по строкам
mov si, logoLine1
call printString
mov si, logoLine2
call printString
mov si, logoLine3
call printString
mov si, logoLine4
call printString
mov si, logoLine5
call printString
mov si, logoLine6
call printString
mov si, jumpCursor
call printString
mov si, entryLine
call printString

waitForEnter:
	mov ah, 0x00
	int 16h
	mov ah, 0x0e
	cmp al, 13
	jne waitForEnter

start:

	call cls
	mov si, jumpCursor
	call printString
	mov si, creditsLine
	call printString
	mov si, optionsLine
	call printString
	mov si, inputLine
	call printString
	
	mov ah, 0x00
	int 16h
	mov ah, 0x0e
	int 10h	
	
	cmp al, '1'
	je rollTheDice
	cmp al, '2'
	je riddler
	cmp al, '3'
	je shutdown

	jmp start

; выключение
shutdown:
	mov ax, 0x1000
	mov ax, ss
	mov sp, 0xf000
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 0x15

; кубик	
rollTheDice:
	; очистка экрана
	call cls
	
	mov si, chooseDice
	call printString
	mov si, diceTypes1
	call printString
	mov si, diceTypes2
	call printString
	mov si, inputLine
	call printString
	
	mov ah, 0x00
	int 16h
	mov ah, 0x0e
	int 10h	
	
	mov si, jumpCursor
	call printString
	
	cmp al, '1'
	je dt1
	cmp al, '2'
	je dt2
	cmp al, '3'
	je dt3
	cmp al, '4'
	je dt4
	cmp al, '5'
	je dt5
	cmp al, '6'
	je dt6
	cmp al, 13
	je start
	
	dt1:
		mov di, 4
		jmp next
	dt2:
		mov di, 6
		jmp next
	dt3:
		mov di, 8
		jmp next
	dt4:
		mov di, 10
		jmp next
	dt5:
		mov di, 12
		jmp next
	dt6:
		mov di, 20
		jmp next

	next:
		mov si, 1
		call random
				
		mov si, diceResult
		call printString
		call number2string
		mov si, string
		call printString
		
		; ожидание ввода
		mov si, jumpCursor
		call printString
		mov ah, 0x00
		int 16h
		je rollTheDice

; задать вопрос
riddler:
	mov si, jumpCursor
	call printString
	mov si, riddlerInstruction
	call printString
	mov si, returnCursor
	call printString
	
	mov si, returnCursor
	call printString
	
	riddlerInput:
		mov ah, 0x0
		int 0x16
		cmp al, 13		; если enter, выходим
		je riddlerAnswear
		mov ah, 0x0e
		int 0x10
		jmp riddlerInput
	riddlerAnswear:
		mov si, jumpCursor
		call printString
		
		mov si, 1
		mov di, 2
		call random
		cmp ax, 1
		je cfrm
		cmp ax, 2
		je dny
	cfrm:
		mov si, riddlerConfirm
		call printString
		jmp agn
	dny:
		mov si, riddlerDeny
		call printString
	
	agn:
		mov si, riddlerAgain
		call printString
		mov si, returnCursor
		call printString
		
		mov ah, 0x0
		int 0x16
		mov ah, 0x0e
		int 0x10
		
		mov si, returnCursor
		call printString
		
		cmp al, 'Y'
		je riddlerInput
		cmp al, 'y'
		je riddlerInput
		cmp al, 'N'
		je start
		cmp al, 'n'
		je start
	jmp agn
	
; подпрограмма очистки экрана
cls:
	pusha
	mov ah, 0x00
	mov al, 0x03
	int 0x10
	popa
	ret

; подпрограмма вывода строки
printString:
	pusha
	mov ah, 0Eh

.printLoop:
	lodsb				; получаем символ
	cmp al, 0			; сравниваем его с 0
	je .done			; если 0, выходим из подпрограммы
	int 10h				; иначе печатаем
	jmp .printLoop		; зацикливаем

.done:
	popa
	ret					; выход из подпрограммы

; вывод числа
number2string:
	pusha
	mov bx, 10 ;основание системы счисления (делитель)
	mov cx, 0 ;количество символов в модуле числа
div_num: ;делим число на 10
	xor dx, dx
	div bx
	push dx ;и сохраняем его в стеке
	inc cx ;увеличиваем счётчик цифр
	test ax, ax
	jnz div_num ;повторяем, пока в числе есть цифры
	mov ah, 0x0e
out_div:
	pop dx ;извлекаем цифры (остатки от деления на 10) из стека
	add dl, '0'
	mov al, dl
	int 0x10 ;и выводим их на экран
	dec cx
	jnz out_div
popa
ret

; генератор	
random:
	push	cx
	push	dx
	push	di
	push si
	
	mov	dx, word [seed]
	or	dx, dx
	jnz	l1
	rdtsc
	mov	dx, ax
l1:	
	mov	ax, word [seed2]
	or	ax, ax
	jnz	l2
	in	ax, 40h
l2:		
	mul	dx
	inc	ax
	mov word [seed], dx
	mov	word [seed2], ax
 
	xor	dx, dx
	sub	di, si
	inc	di
	div	di
	mov	ax, dx
	add	ax, si
 
	pop	di
	pop si
	pop	dx
	pop	cx
ret