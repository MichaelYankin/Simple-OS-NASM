%include "/home/michael/shared/stage2info.inc"
ORG STAGE2_RUN_OFS

start:
	
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
	mov si, logoLine7
	call printString
	mov si, logoLine8
	call printString

	logoLine1 db ' _______  _______ _________          _______  _______ ', 13, 10, 0
	logoLine2 db '(  ___  )(  ____ )\__   __/|\     /|(  ___  )(  ____ \', 13, 10, 0
	logoLine3 db '| (   ) || (    )|   ) (   | )   ( || (   ) || (    \/', 13, 10, 0
	logoLine4 db '| |   | || (____)|   | |   | (___) || |   | || (_____ ', 13, 10, 0
	logoLine5 db '| |   | ||     __)   | |   |  ___  || |   | |(_____  )', 13, 10, 0
	logoLine6 db '| |   | || (\ (      | |   | (   ) || |   | |      ) |', 13, 10, 0
	logoLine7 db '| (___) || ) \ \__   | |   | )   ( || (___) |/\____) |', 13, 10, 0
	logoLine8 db '(_______)|/   \__/   )_(   |/     \|(_______)\_______)', 13, 10, 0
	
	push bx ;push registers
	push cx
	push dx
	mov ah,0h
	int 16h
	
	jmp $


cls:
	pusha
	
	mov ah, 6			; Scroll full-screen
	mov al, 0			; Normal white on black
	mov bh, 7			;
	mov cx, 0			; Top-left
	mov dh, 24			; Bottom-right
	mov dl, 79
	int 10h

	popa
	ret


; подпрограмма вывода строки
printString:
	mov ah, 0Eh         ;Set function

.printLoop:
	lodsb               ; получаем символ
	cmp al, 0           ; сравниваем его с 0
	je .done            ; если 0, выходим из подпрограммы
	int 10h             ; иначе печатаем
	jmp .printLoop           ; зацикливаем

.done:
	ret                 ; выход из подпрограммы