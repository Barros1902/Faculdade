;***********************************************************************

;  Grupo 30:
; 		Tomás Alexandre Pereira de Barros 	ist1106588
;		Tomás Dias Monteiro					ist1106211

;***********************************************************************
; **********************************************************************
; * Constantes
; **********************************************************************


PLACE		3000H

	STACK 100H			; espaço reservado para a pilha do processo "programa principal"
	SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
	
	STACK 100H			; espaço reservado para a pilha do processo "teclado"
	SP_inicial_teclado:		; este é o endereço com que o SP deste processo deve ser inicializado
	
	STACK		0100H
	SP_cometas:
	
	STACK 100H			; espaço reservado para a pilha do processo "psondas"
	SP_inicial_sonda:		; este é o endereço com que o SP deste processo deve ser inicializado
	
	STACK 100H				; espaço reservado para a pilha do processo "display"
	SP_inicial_display: 	; este é o endereço com que o SP deste processo deve ser inicializado
	
	STACK		0050H		; espaço reservado para a pilha do processo "anime lagosta"
	SP_anime:				; este é o endereço com que o SP deste processo deve ser inicializado
	
	; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3


DISPLAYS	  			EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    				EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    				EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
MASCARA    				EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
LINHA1	   				EQU 1
LINHA2	   				EQU 2
LINHA3	   				EQU 4
LINHA4	   				EQU 8

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter
DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SELECIONA_ECRA			EQU COMANDOS + 04H		; endereço do comando para selecionar o ecra
SOM_MOVIMENTO			EQU COMANDOS + 5AH		; endereço do comando para tocar um som	


LINHA_STAR        		EQU 16        ; linha da star (a meio do ecrã)
COLUNA_STAR				EQU 30        ; coluna do star (a meio do ecrã)


MIN_COLUNA				EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				EQU  63     ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA       		EQU  0
MAX_LINHA       		EQU  31 


LARGURA_STAR			EQU	6		; largura da star
ALTURA_STAR       		EQU 6       ; altura da star


LARGURA_LOBSTER    		EQU 18
ALTURA_LOBSTER    		EQU 21
PRIMEIRA_LINHA_LOBSTER  EQU 26
PRIMEIRA_COLUNA_LOBSTER EQU 22


LARGURA_SONDA			EQU 2
ALTURA_SONDA			EQU 3
NUMERO_MAX_MOV_SONDA	EQU 12


QNT_ATRASO_DISPLAY		EQU 300		; Determina a velocidade de energia que vai ser perdida
QNT_ENERGIA				EQU 3		; Determina a quantidade de energia que vai ser perdida de cada vez
ENERGIA_INICIAL			EQU 100		; Valor inicial do display


_____					EQU  0000H  ; transparente
REDDD					EQU	0FF00H	; vermelho
BLUEE           		EQU 0F00FH  ; azul
GREEN           		EQU 0F0F0H  ; verde
YELOW           		EQU 0FFF0H  ; amarelo
PINKK           		EQU	0FF0FH  ; rosa
CYANN           		EQU 0F0FFH  ; ciano
BROWN					EQU 0F520H	; castanho
WHITE           		EQU 0FFFFH  ; branco
BLACK           		EQU 0F000H  ; black
LBSTR            		EQU 0FD10H  ; lobster red
DLBST            		EQU 0F810H  ; lobster darker red


; **********************************************************************
; * Interrupçoes
; **********************************************************************

; **********************************************************************
; * Esta interrupção trata de mover os asteroides                      *
; **********************************************************************
	
rot_int_0:
	MOV	[lock_asteroides], R0	; desbloqueia processo move stars 
	RFE
	
; **********************************************************************
; * Esta interrupção trata de mover as sondas                          *
; **********************************************************************
	
rot_int_1:
	MOV [lock_sondas], R1		; desbloqueia processo sondas
	RFE

; **********************************************************************
; * Esta interrupção trata de diminuir a energia                       *
; **********************************************************************
	
rot_int_2:
	MOV	[lock_display], R0	; desbloqueia processo display  
	RFE

; **********************************************************************
; * Esta interrupção trata de mover a lagosta                          *
; **********************************************************************
	
rot_int_3:
	PUSH R1
	MOV [lock_asteroides+2], R1	; desbloqueia processo anime lobster
	POP R1
	RFE
	
	
	
	

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
	
	MOV  SP, SP_inicial_prog_princ
	MOV  BTE, tab
	MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 1							; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	JMP teclado
liga_programa:
	CALL comeca_programa 
	EI0
	EI1
	EI2
	EI3
	EI
	CALL teclado
	CALL move_cometa	; cria o processo
	CALL sonda			; cria o processo
	CALL display		; cria o processo
	CALL pinças_lagosta ; cria o processo	
	

; corpo principal do programa
PROCESS SP_inicial_teclado	; indicação de que a rotina que se segue é um processo,

teclado:
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, LINHA4
    MOV  R1, 0
	MOV	 R7, 0
	MOV  R8, 0
linha_1:
	MOV R9, [pausado]	
	MOV R10, 1
	CMP R9,R10		; Verifica se o programa está pausado
	JZ skip_wait	; Se tiver pausado salta o WAIT para evitar ligar as interrupçoes
	WAIT
	NOP				; Necessario para saltar o WAIT
	skip_wait:
	MOV R1, LINHA1
	JMP here
	
espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
	
	CMP R1, R6
	JZ linha_1 
	ADD R1, R1
here:   
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JZ   espera_tecla ; se nenhuma tecla premida, passa para a próxima linha
                       ; vai mostrar a linha e a coluna da tecla
counter_linha:
	
	CMP R1, 1
	JZ continue_linha
	SHR R1, 1
	ADD R7, 1			; R7 - linha
	JMP counter_linha 
	
continue_linha:
	
	counter_coluna:
	
	CMP R0, 1
	JZ diz_tecla_primida
	SHR R0, 1
	ADD R8, 1			; R8 - coluna
	JMP counter_coluna
diz_tecla_primida:	
	SHL R7, 2
	ADD R7, R8			;R7 Corresponde à tecla primida

	
	MOV R6, [comecou]	 
	CMP R6, 1			; Verifica se o programa começou
	JZ testa_teclas		; Caso tenha começado ignora se tentar comecar de novo
	MOV R6, 0CH			 
	CMP R7, R6			; Se o programa não comecou entra e vê se a tecla primida foi o C
	JNZ teclado			; Se a tecla primida não foi o C volta a testar teclas
	MOV R6, comecou
	MOV R8, 1
	MOV [R6], R8		; Se a tecla primida foi o C liga o programa
	JMP liga_programa
	testa_teclas:
	;Ativa prossesso sonda
	MOV R1, 0EH
	CMP R7, R1			; Vê se a tecla primida foi o E
	JZ auto_lose 		; Se a tecla primida foi o E perde se não continua
	CMP R7, 0			; Vê se a tecla primida foi o 0
	JZ ativa_sonda		; Se a tecla primida foi o 0 liga sonda esquerda se não continua
	CMP R7, 1			; Vê se a tecla primida foi o 1 
	JZ ativa_sonda		; Se a tecla primida foi o 1 liga sonda meio se não continua
	CMP R7, 2			; Vê se a tecla primida foi o 2
	JZ ativa_sonda		; Se a tecla primida foi o 2 liga sonda direita se não continua
	MOV R1, 0DH			
	CMP R7, R1			; Vê se a tecla primida foi o D
	JNZ ha_tecla		; Se a tecla primida não foi o D volta a testar teclas
	JMP Pausa			; Se a tecla primida foi o D pausa o jogo 
	
	
	JMP ha_tecla
ativa_sonda:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7
	
	MOV R1, 1				; Valor de estado ativo
	MOV R2, estado_sonda	
	MOV R3, 10
	MUL R7, R3	
	ADD R7, R2				; R7 passa a ter a posicao de memoria da sonda certa
	MOV R3, [R7]
	CMP R3, R1
	JZ fim_ativa_sonda
	
	
	MOV [R7], R1			; Ativa a sonda desejada
	MOV R2, valor_display
	MOV R1, [R2]
	MOV [R2], R1
	MOV  R1, 5
	MOV  [SELECIONA_ECRA], R1
	CALL desenha_sonda
	
	MOV R0, valor_display
	MOV R1, [R0]
	SUB R1, 5
	CALL Energia_suficiente
	MOV [R0], R1
	CALL hexa_to_deci
	MOV R4, DISPLAYS
	MOV [R4], R1
	
fim_ativa_sonda:
	POP R7
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	JMP ha_tecla
auto_lose:
	MOV  R0, 0
	MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 2							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de derrota
	MOV R4, DISPLAYS
	MOV [R4], R0
fim_auto:
	JMP fim_auto
	

	
ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
MOV R9, [pausado]
	MOV R10, 1
	CMP R9,R10
	JZ skip_YIELD
	YIELD
	NOP
	skip_YIELD:
    MOV  R1, LINHA1    ; testar a linha 1 (R1 tinha sido alterado)
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver

    MOV  R1, LINHA2    ; testar a linha 2
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver

    MOV  R1, LINHA3    ; testar a linha 3
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver

    MOV  R1, LINHA4    ; testar a linha 4
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver

    JMP  teclado         ; se nenhuma tecla premida em qualquer linha, volta para o início do ciclo


Pausa:
	DI
	MOV R0, 1
	MOV R1, [pausado]
	CMP R0, R1
	JZ despausa
	MOV R0, 1
	MOV R1, pausado
	MOV [R1], R0
	MOV R1, SELECIONA_CENARIO_FUNDO
	MOV R0, 1
	MOV [R1], R0
	JMP ha_tecla
	
	despausa:
	MOV R0, 0
	MOV R1, pausado
	MOV [R1], R0
	MOV R1, SELECIONA_CENARIO_FUNDO
	MOV [R1], R0
	EI
	
	JMP ha_tecla







PROCESS SP_cometas
	move_cometa:
		MOV  R1, [lock_asteroides]
		
		star_0:
		MOV  R1, [primeira_linha_star]			; linha da star
		MOV  R2, [primeira_coluna_star]		; coluna da star
		MOV  R4, [tipo_star]
		MOV  R7, [pos_star]
		MOV  R5, [R7+8]
		MOV  R6, [R7+10]
		MOV  R9, primeira_linha_star
		MOV R10, primeira_coluna_star
		MOV  R0, 1
		MOV  [SELECIONA_ECRA], R0
		CALL mover
		CALL lose_condition
		CALL fallin_comets
		
		star_1:
		MOV  R1, [primeira_linha_star+2]			; linha da star
		MOV  R2, [primeira_coluna_star+2]		; coluna da star
		MOV  R4, [tipo_star+2]
		MOV  R7, [pos_star+2]
		MOV  R5, [R7+8]
		MOV  R6, [R7+10]
		MOV  R9, primeira_linha_star+2
		MOV R10, primeira_coluna_star+2
		MOV  R0, 2
		MOV  [SELECIONA_ECRA], R0
		CALL mover
		CALL lose_condition
		CALL fallin_comets
		
		star_2:
		MOV  R1, [primeira_linha_star+4]			; linha da star
		MOV  R2, [primeira_coluna_star+4]		; coluna da star
		MOV  R4, [tipo_star+4]
		MOV  R7, [pos_star+4]
		MOV  R5, [R7+8]
		MOV  R6, [R7+10]
		MOV  R9, primeira_linha_star+4
		MOV R10, primeira_coluna_star+4
		MOV  R0, 3
		MOV  [SELECIONA_ECRA], R0
		CALL mover
		CALL lose_condition
		CALL fallin_comets
		
		star_3:
		MOV  R1, [primeira_linha_star+6]			; linha da star
		MOV  R2, [primeira_coluna_star+6]		; coluna da star
		MOV  R4, [tipo_star+6]
		MOV  R7, [pos_star+6]
		MOV  R5, [R7+8]
		MOV  R6, [R7+10]
		MOV  R9, primeira_linha_star+6
		MOV R10, primeira_coluna_star+6
		MOV  R0, 4
		MOV  [SELECIONA_ECRA], R0
		CALL mover
		CALL lose_condition
		CALL fallin_comets
		
		fim_move_cometa:
		CALL verifica_colisoes_todos_cometas
	
		JMP move_cometa
	
lose_condition:
	;só funciona dentro do processo acima
	PUSH R2
	PUSH R4
	
	MOV  R1, [R9]
	MOV  R4, 21							; R4 linha do pixel onde está o cometa quando a lagosta é tocada
	CMP  R1, R4
	JNZ  nao_perdeu
	MOV  R2, [R10]						
	MOV  R4, 7							; R4 coluna do pixel onde está o cometa quando ele cai à esquerda
	CMP  R2, R4
	JZ   nao_perdeu
	MOV  R4, 49							; R4 coluna do pixel onde está o cometa quando ele cai à direita 
	CMP  R2, R4
	JZ   nao_perdeu
	CALL  lose_hit
	nao_perdeu:
	POP R4
	POP R2
	RET
	
fallin_comets:
	;só funciona dentro do processo acima
	PUSH R0
	PUSH R10
	MOV R10, MAX_LINHA
	CMP R1, R10
	JNZ fim_fallin_comets
	SUB R0, 1
	MOV R10, 2
	MUL R0, R10
	MOV R10, -1
	CALL destruir
	fim_fallin_comets:
	POP R10
	POP R0
	RET

















PROCESS SP_inicial_sonda

sonda:
	MOV R1, [lock_sondas]
MOV R2, 10
MOV R7, estado_sonda
MOV R6, [R7]
CMP R6, 1
JNZ proxima
CALL move_sonda
CALL verifica_destruicao_de_sonda

proxima:
ADD R7, R2
MOV R6, [R7]
CMP R6, 1
JNZ proxima1
CALL move_sonda
CALL verifica_destruicao_de_sonda

proxima1:
ADD R7, R2
MOV R6, [R7]
CMP R6, 1
JNZ fim_teste_sondas
CALL move_sonda
CALL verifica_destruicao_de_sonda

fim_teste_sondas:
	JMP sonda


PROCESS SP_inicial_display

display:
	MOV R1, [lock_display]
	
CALL decrementa_atraso
JMP display


decrementa_atraso:
	YIELD
	MOV R0, atraso_display
	MOV R1, [R0]
	SUB R1, 1
	MOV [R0], R1
	CMP R1, 0
	JNZ decrementa_atraso
	CALL decrementa_energia
	RET
decrementa_energia:
	MOV R0, valor_display
	MOV R1, [R0]
	SUB R1, QNT_ENERGIA
	CALL Energia_suficiente
	MOV [R0], R1
	CALL hexa_to_deci
	MOV R4, DISPLAYS
	MOV [R4], R1
	RET
aumenta_energia:
	PUSH R0
	PUSH R1
	PUSH R4


	MOV R0, valor_display
	MOV R1, [R0]
	ADD R1, 5
	MOV [R0], R1
	CALL hexa_to_deci
	MOV R4, DISPLAYS
	MOV [R4], R1
	
	POP R0
	POP R1
	POP R4
	
	RET
PROCESS SP_anime
	pinças_lagosta:
		MOV  R1, [lock_asteroides+2]
		MOV	 R1, 0
		MOV  [SELECIONA_ECRA], R1
		CALL desenha_lobster_2
		MOV  R1, [lock_asteroides+2]
		MOV	 R1, 0
		MOV  [SELECIONA_ECRA], R1
		CALL desenha_lobster
		JMP pinças_lagosta

desenha_sonda: ;recebe R7 qual sonda desenhar 
	PUSH R1
	PUSH R2
	PUSH R4
	ADD  R7, 2			; Poe R7 na linha certa
	MOV  R1, [R7]		; linha da sonda
	ADD  R7, 2			; Poe R7 na coluna certa
    MOV  R2, [R7]		; coluna da sonda
	MOV  R4, DEF_SONDA
	CALL desenhar
	POP  R4
	POP  R2
	POP  R1
	RET


move_sonda: ;Recebe R7 posição de memoria da sonda
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	ADD  R7, 2				; R7 passa a ser o endereço de memória da linha
	MOV  R1, [R7]			; linha da sonda
	MOV  R9, R7				; Copia o endereço de memoria da linha
	ADD  R7, 2				; R7 passa a ser o endereço de memória da coluna
    MOV  R2, [R7]			; coluna da sonda
	MOV  R10, R7			; Copia o endereço de memoria da coluna
	MOV  R4, DEF_SONDA
	ADD  R7, 2
	MOV  R5, [R7]
	ADD  R7, 2
	MOV  R6, [R7]
	MOV  R0, 5
	MOV  [SELECIONA_ECRA], R0
	CALL mover
	MOV R9, 0
	
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
verifica_destruicao_de_sonda: ;R7 posicao de memoria da sonda
	
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R0, 5
	MOV  [SELECIONA_ECRA], R0
	MOV R8, R7						; Cria uma cópia do endereço de memoria
	ADD R8, 2						; Passa para o endereço de memoria da linha
	MOV R6, [R8]					; Copia o endereço de memoria da linha
	MOV R0, NUMERO_MAX_MOV_SONDA				
	CMP R6, R0						
	JNZ nao_destroi					; Vê se a sonda tem de ser destroida
	MOV R8, R7						; Cria uma cópia do endereço de memoria
	ADD R8, 2						; Passa para o endereço de memoria da linha
	MOV R1, [R8]					; Encontra linha
	ADD R8, 2						; Passa para o endereço de memoria da coluna
	MOV R2, [R8]					; Encontra coluna
	MOV R4,DEF_SONDA
	CALL apagar						; Apaga
	MOV R0, 0						
	MOV [R7], R0					; Atualiza o estado para 0
	MOV R8, R7						; Cria uma cópia do endereço de memoria
	ADD R8, 2						; Passa para o endereço de memoria da linha
	MOV R0, 24						; 24 é a linha inicial das sondas
	MOV [R8], R0					; Reseta a linha inicial da sonda
	ADD R8, 2						; Passa para o endereço de memoria da coluna
	MOV R0, 30						; 30 distancia da coluna à sua coluna inicial
	ADD R0, R7						
	MOV R0, [R0]					
	MOV [R8], R0					; Reseta a coluna inicial da sonda
	
	nao_destroi:
	POP R8
	POP R7
	POP R6
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
desenha_stars:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4	
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	CALL rng0_4							; R0 agora é um número de 0 a 4
	MOV  R5, primeira_linha_star		; linha da star
    MOV  R6, primeira_coluna_star		; coluna da star
	MOV	 R3, pos_star                   ; posição da star
	MOV  R9, tipo_star
	MOV  R8, 1
	
	desenha_pos_0:
	CMP  R0, 0
	JZ desenha_pos_1
	MOV  R7, pos_0
	MOV  [R3], R7
	MOV  R7, [pos_0]
	MOV  [R5], R7
	MOV  R7, [pos_0+2]
	MOV  [R6], R7
	MOV  R1, [R5]
	MOV  R2, [R6]
	CALL rng_cometa
	MOV  [R9], R4
	MOV  [SELECIONA_ECRA], R8
	CALL desenhar
	ADD  R3, 2							; pos da star
	ADD  R5, 2							; linha da star
    ADD  R6, 2							; coluna da star
	ADD  R9, 2
	ADD  R8, 1							; prox ecrã
	
	desenha_pos_1:
	CMP  R0, 1
	JZ desenha_pos_2
	MOV  R7, pos_1
	MOV  [R3], R7
	MOV  R7, [pos_1]
	MOV  [R5], R7
	MOV  R7, [pos_1+2]
	MOV  [R6], R7
	MOV  R1, [R5]
	MOV  R2, [R6]
	CALL rng_cometa
	MOV  [R9], R4
	MOV  [SELECIONA_ECRA], R8
	CALL desenhar
	ADD  R3, 2							; pos da star
	ADD  R5, 2							; linha da star
    ADD  R6, 2							; coluna da star
	ADD  R9, 2
	ADD  R8, 1							; prox ecrã
	
	desenha_pos_2:
	CMP  R0, 2
	JZ desenha_pos_3
	MOV  R7, pos_2
	MOV  [R3], R7
	MOV  R7, [pos_2]
	MOV  [R5], R7
	MOV  R7, [pos_2+2]
	MOV  [R6], R7
	MOV  R1, [R5]
	MOV  R2, [R6]
	CALL rng_cometa
	MOV  [R9], R4
	MOV  [SELECIONA_ECRA], R8
	CALL desenhar
	ADD  R3, 2							; pos da star
	ADD  R5, 2							; linha da star
    ADD  R6, 2							; coluna da star
	ADD  R9, 2
	ADD  R8, 1							; prox ecrã
	
	desenha_pos_3:
	CMP  R0, 3
	JZ desenha_pos_4
	MOV  R7, pos_3
	MOV  [R3], R7
	MOV  R7, [pos_3]
	MOV  [R5], R7
	MOV  R7, [pos_3+2]
	MOV  [R6], R7
	MOV  R1, [R5]
	MOV  R2, [R6]
	CALL rng_cometa
	MOV  [R9], R4
	MOV  [SELECIONA_ECRA], R8
	CALL desenhar
	ADD  R3, 2							; pos da star
	ADD  R5, 2							; linha da star
    ADD  R6, 2							; coluna da star
	ADD  R9, 2
	ADD  R8, 1							; prox ecrã
	
	desenha_pos_4:
	CMP  R0, 4
	JZ fim_desenha_stars
	MOV  R7, pos_4
	MOV  [R3], R7
	MOV  R7, [pos_4]
	MOV  [R5], R7
	MOV  R7, [pos_4+2]
	MOV  [R6], R7
	MOV  R1, [R5]
	MOV  R2, [R6]
	CALL rng_cometa
	MOV  [R9], R4
	MOV  [SELECIONA_ECRA], R8
	CALL desenhar
	
	fim_desenha_stars:
	POP  R9
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
desenha_lobster:
	PUSH R1
	PUSH R2
	PUSH R4	 
	MOV  R1, PRIMEIRA_LINHA_LOBSTER			; linha da lobster
    MOV  R2, PRIMEIRA_COLUNA_LOBSTER		; coluna da lobster
	MOV  R4, DEF_BUSTO_LOBSTER
	CALL desenhar
	POP  R4
	POP  R2
	POP  R1
	RET


desenha_lobster_2:
	PUSH R1
	PUSH R2
	PUSH R4	 
	MOV  R1, PRIMEIRA_LINHA_LOBSTER			; linha da lobster
    MOV  R2, PRIMEIRA_COLUNA_LOBSTER		; coluna da lobster
	MOV  R4, DEF_BUSTO_LOBSTER_2
	CALL desenhar
	POP  R4
	POP  R2
	POP  R1
	RET


desenhar:

; R1 primeira linha REQUER MOV
; R2 primeira coluna REQUER MOV
; R3 cor do pixel
; R4 endereço da tabela REQUER MOV
; R5 ultima coluna do boneco
; R6 ultima linha do boneco
; R7 linha atual
; R8 coluna atual
	PUSH R3
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8

	MOV R7, R1		; guardar primeira linha
	MOV R5, [R4]	; buscar a largura
	ADD R5, R2		; encontrar a ultima coluna
	ADD R4, 2		; ler a altura
	MOV R6, [R4]	; buscar a altura
	ADD R6, R1		; encontrar a ultma linha
	ADD R4, 2		; buscar o primeiro pixel
desenha_coluna:
	MOV R8, R2		; voltar para a primeira coluna
desenha_linha: 
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	MOV [DEFINE_LINHA], R7		; seleciona a linha
	MOV [DEFINE_COLUNA], R8		; seleciona a coluna
	MOV [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
	ADD	R4, 2			; endereço da cor do próximo pixel
    ADD R8, 1           ; próxima coluna
    CMP R5, R8			; verificar se chegou ao fim
    JNZ desenha_linha   ; continua até percorrer toda a largura do objeto
	ADD R7, 1			;proxima linha
	CMP R6, R7			;verificar se chegou ao fim
	JNZ desenha_coluna
	
	POP R8
	POP R7
	POP R6
	POP R5
	POP R3
	
	RET
	
	

apagar:

; R1 primeira linha REQUER MOV
; R2 primeira coluna REQUER MOV
; R3 cor do pixel
; R4 endereço da tabela REQUER MOV
; R5 ultima coluna do boneco
; R6 ultima linha do boneco
; R7 linha atual
; R8 coluna atual
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R7, R1		; guardar primeira linha
	MOV R5, [R4]	; buscar a largura
	ADD R5, R2		; encontrar a ultima coluna
	ADD R4, 2		; ler a altura
	MOV R6, [R4]	; buscar a altura
	ADD R6, R1		; encontrar a ultma linha
	MOV R3, 0000H	; guardar a borracha
apaga_coluna:
	MOV R8, R2		; voltar para a primeira coluna
apaga_linha: 
	MOV [DEFINE_LINHA], R7		; seleciona a linha
	MOV [DEFINE_COLUNA], R8		; seleciona a coluna
	MOV [DEFINE_PIXEL], R3		; apaga o pixel na linha e coluna selecionadas
    ADD R8, 1           ; próxima coluna
    CMP R5, R8			; verificar se chegou ao fim
    JNZ apaga_linha   ; continua até percorrer toda a largura do objeto
	ADD R7, 1			;proxima linha
	CMP R6, R7			;verificar se chegou ao fim
	JNZ apaga_coluna
	POP R7
	POP R6
	POP R5
	RET

Energia_suficiente: ;Recebe R1 que corresponde ao novo valor de energia
	CMP R1, 0
	JLE lose_energy
	RET
	
lose_energy:
	MOV  R0, 0
	MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 3							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de derrota
	MOV R4, DISPLAYS
	MOV [R4], R0
fim_energy:
	JMP fim_energy	
	

mover:

; R1 primeira linha REQUER MOV
; R2 primeira coluna REQUER MOV
; R4 endereço da tabela REQUER MOV
; R5 quantas linhas para baixo REQUER MOV
; R6 quantas colunas para a direita REQUER MOV
; R9 endereço da primeira linha REQUER MOV
; R10 endereço da primeira coluna REQUER MOV
	PUSH R7
	MOV R7, R1		; guarda o endereço da linha
	MOV R0, R4		; guardar o endereço da tabela
	CALL apagar		; apagar o desenho
	ADD R1, R5		; mover a linha
	ADD R2, R6		; mover a coluna
	MOV [R9], R1
	MOV [R10], R2
	MOV R4, R0		; repor o endereço da tabela
	CALL desenhar	; desenhar o novo desenho
	POP R7
	RET
	
	
	hexa_to_deci:
    ; R1 tem o número
    ; R0, R2 e R3 são usados, requerem PUSH
	
	PUSH R0
	PUSH R2
	PUSH R3
	
    MOV R3, R1
    MOV R0, 100
    DIV R3, R0
    MOV R0, 256
    MUL R3, R0
    MOV R2, R1
    MOV R0, 10
    DIV R2, R0
    MOD R2, R0
    MOV R0, 16
    MUL R2, R0
    MOV R0, 10
    MOD R1, R0
    ADD R1, R2
    ADD R1, R3
	
	POP R0
	POP R2
	POP R3
	RET
	
	rng0_4:
	;R0 vai ser um número de 0 a 4
	PUSH R1
	MOV R1, 15
	gera_numb0_4:
	MOV R0, [DISPLAYS]
	SHR R0, 12
	CMP R0, R1
	JZ gera_numb0_4
	MOV R1, 3
	DIV R0, R1
	POP R1
	RET
	
	
	rng_cometa:
	;R4 vai ser a tabela do cometa
	PUSH R1
	MOV R1, [DISPLAYS]
	SHR R1, 14
	CMP R1, 0
	JNZ cometa_mau
	MOV R4, DEF_BORGAR
	JMP fim_rng_cometa
	cometa_mau:
	MOV R4, DEF_STAR
	fim_rng_cometa:
	POP R1
	RET
	
	
	
	verifica_colisoes_cometa:
	;R0 recebe o número do cometa
	;R1 recebe a primeira linha do cometa
	;R2 recebe a primeira coluna do cometa
	;R7 recebe a pos do cometa
	;R3 linha de colisão
	;R4 coluna de colisão
	;R5 pos de comparação, linha da sonda
	;R6 coluna da sonda
	;R10 número da sonda
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R10
	
	MOV R5, pos_0
	CMP R7, R5
	JZ col_0
	
	MOV R5, pos_1
	CMP R7, R5
	JZ col_1
	
	MOV R5, pos_2
	CMP R7, R5
	JZ col_2
	
	MOV R5, pos_3
	CMP R7, R5
	JZ col_3
	
	JMP col_4     			;exclusão de partes
	
	col_0:
	MOV R5, [estado_sonda]
	CMP R5, 0
	JZ verif_col_com_fim
	MOV R10, 0
	MOV R5, [estado_sonda+2]
	JMP direct_col
	
	col_1:
	MOV R5, [estado_sonda]
	CMP R5, 0
	JZ verif_col_com_fim
	MOV R10, 0
	MOV R5, [estado_sonda+2]
	MOV R6, [estado_sonda+4]
	JMP side_col
	
	col_2:
	MOV R5, [estado_sonda+10]
	CMP R5, 0
	JZ verif_col_com_fim
	MOV R10, 10
	MOV R5, [estado_sonda+12]
	JMP direct_col
	
	col_3:
	MOV R5, [estado_sonda+20]
	CMP R5, 0
	JZ verif_col_com_fim
	MOV R10, 20
	MOV R5, [estado_sonda+22]
	MOV R6, [estado_sonda+24]
	ADD R6, LARGURA_SONDA
	SUB R6, 1
	JMP side_col
	
	col_4:
	MOV R5, [estado_sonda+20]
	CMP R5, 0
	JZ verif_col_com_fim
	MOV R10, 20
	MOV R5, [estado_sonda+22]
	JMP direct_col
	
	direct_col:
	MOV R3, [R7+4]
	ADD R3, R1
	CMP R3, R5
	JZ destroi
	JMP verif_col_com_fim
	
	side_col:
	MOV R3, [R7+4]			; R3 linha de colisão
	ADD R3, R1
	MOV R4, [R7+6]			; R4 coluna de colisão
	ADD R4, R2
	CMP R3, R5				; R5 linha da sonda
	JZ mesm_linha
	CMP R4, R6				; R6 coluna da sonda
	JZ mesm_coluna
	JMP verif_col_com_fim
	mesm_linha:
	MOV R3, R2				; por no R3 a primeira coluna
	MOV R5, R2
	ADD R5, LARGURA_STAR	; por no R5 a ultima coluna
	ciclo_mesm_linha:
	CMP R6, R3				; comparar com a coluna da sonda
	JZ destroi
	ADD R3, 1				; ver a proxima coluna
	CMP R3, R5				; ver se ainda faz parte
	JZ verif_col_com_fim
	JMP ciclo_mesm_linha
	mesm_coluna:
	MOV R4, R1				; por no R4 a primeira linha
	MOV R6, R1
	ADD R6, ALTURA_STAR		; por no R6 a ultima linha
	ciclo_mesm_coluna:
	CMP R5, R4				; comparar com a linha da sonda
	JZ destroi
	ADD R4, 1				; ver a proxima linha
	CMP R4, R6				; ver se ainda faz parte
	JZ verif_col_com_fim
	JMP ciclo_mesm_coluna
	
	destroi:
	CALL destruir
	
	verif_col_com_fim:
	POP R10
	POP R6
	POP R5
	POP R4
	POP R3
	RET
	
verifica_colisoes_todos_cometas:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R7
	MOV R0, 0
	ciclo_ver_col_tdos_com:
	MOV R3, primeira_linha_star
	ADD R3, R0
	MOV R1, [R3]
	MOV R3, primeira_coluna_star
	ADD R3, R0
	MOV R2, [R3]
	MOV R3, pos_star
	ADD R3, R0
	MOV R7, [R3]
	CALL verifica_colisoes_cometa
	ADD R0, 2
	MOV R3, 8
	CMP R0, R3
	JZ fim_clico_ver_col_tdos_com
	JMP ciclo_ver_col_tdos_com
	fim_clico_ver_col_tdos_com:
	POP R7
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
destruir:
	; R0 recebe o número do cometa
	; R10 recebe o número da sonda
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	; R1 primeira linha REQUER MOV
	; R2 primeira coluna REQUER MOV
	; R4 endereço da tabela REQUER MOV
	MOV R4, R0
	MOV R5, 2
	DIV R4, R5
	ADD R4, 1
	MOV [SELECIONA_ECRA], R4
	MOV R5, primeira_linha_star
	ADD R5, R0
	MOV R1, [R5]
	MOV R6, primeira_coluna_star
	ADD R6, R0
	MOV R2, [R6]
	MOV R4, DEF_STAR
	CALL apagar
	CALL novo_cometa
	
	CMP R10, -1
	JZ fim_destruir
	
	MOV R3, tipo_star
	ADD R3, R0
	MOV R3, [R3]
	MOV R4, DEF_BORGAR
	CMP R3, R4
	JNZ destruir_sonda ; Barros põe aqui o que acontece se o cometa for bom
	CALL aumenta_energia
	
	
	destruir_sonda:
	MOV R4, 5
	MOV [SELECIONA_ECRA], R4
	MOV R5, estado_sonda+2
	ADD R5, R10
	MOV R1, [R5]
	MOV R6, estado_sonda+4
	ADD R6, R10
	MOV R2, [R6]
	MOV R4, DEF_SONDA
	CALL apagar
	MOV R4, 24
	MOV [R5], R4
	MOV R4, estado_sonda+30
	ADD R4, R10
	MOV R4, [R4]
	MOV [R6], R4
	MOV R5, estado_sonda
	ADD R5, R10
	MOV R4, 0
	MOV [R5], R4
	fim_destruir:
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

novo_cometa:
	; R0 recebe o número do cometa
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	
	MOV R1, R0			; R1 número da star
	CALL rng0_4
	MOV R2, pos_star
	ADD R2, R1
	MOV R3, 12
	MUL R0, R3
	MOV R3, pos_0
	ADD R3, R0
	MOV [R2], R3         ; guardar nova pos na star
	MOV R0, [R3]
	MOV R2, primeira_linha_star
	ADD R2, R1
	MOV [R2], R0		; guardar primeira linha
	MOV R0, [R3+2]
	MOV R2, primeira_coluna_star
	ADD R2, R1
	MOV [R2], R0		; guardar primeira coluna
	CALL rng_cometa
	MOV R2, tipo_star
	ADD R2, R1
	MOV [R2], R4
	
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
	
	
	
comeca_programa:
	
	MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0							; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	CALL desenha_stars
	MOV  [SELECIONA_ECRA], R1
	MOV  R1, valor_display
	MOV  R0, ENERGIA_INICIAL
	MOV  [R1], R0
	MOV  R1, R0
	CALL hexa_to_deci
	MOV  R0, DISPLAYS
	MOV  [R0], R1
	CALL desenha_lobster
	
	RET
	
	lose_hit:
	MOV  R0, 0
	MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 2							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de derrota
	MOV R4, DISPLAYS
	MOV [R4], R0
fim_hit:
	JMP fim_hit
	

	
	
	
	
; #######################################################################
; * ZONA DE DADOS 
; #######################################################################

DEF_STAR:					; tabela que define a star
	WORD		LARGURA_STAR, ALTURA_STAR
	WORD		YELOW,_____,YELOW,_____,YELOW,YELOW
	WORD		_____,YELOW,YELOW,YELOW,_____,YELOW
	WORD		YELOW,YELOW,_____,YELOW,YELOW,_____
	WORD		_____,YELOW,YELOW,_____,YELOW,YELOW
	WORD		YELOW,_____,YELOW,YELOW,YELOW,_____
	WORD		YELOW,YELOW,_____,YELOW,_____,YELOW
DEF_BORGAR:
	WORD		LARGURA_STAR, ALTURA_STAR
	WORD		_____,BROWN,BROWN,BROWN,BROWN,_____
	WORD		BROWN,BROWN,BROWN,BROWN,BROWN,BROWN
	WORD		REDDD,REDDD,REDDD,REDDD,REDDD,REDDD
	WORD		BROWN,BROWN,BROWN,BROWN,BROWN,BROWN
	WORD		GREEN,GREEN,GREEN,GREEN,GREEN,GREEN
	WORD		BROWN,BROWN,BROWN,BROWN,BROWN,BROWN
	
DEF_LOBSTER:
	WORD 		LARGURA_LOBSTER,ALTURA_LOBSTER
	WORD		_____,_____,LBSTR,_____,LBSTR,_____,LBSTR,_____,_____,_____,_____,LBSTR,_____,LBSTR,_____,LBSTR,_____,_____
	WORD		_____,LBSTR,LBSTR,_____,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,_____,LBSTR,LBSTR,_____
	WORD		_____,LBSTR,LBSTR,_____,LBSTR,_____,LBSTR,BLACK,LBSTR,LBSTR,BLACK,LBSTR,_____,LBSTR,_____,LBSTR,LBSTR,_____
	WORD		_____,_____,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,_____,_____
	WORD		_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____,_____,_____
	WORD		LBSTR,LBSTR,DLBST,_____,_____,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,_____,_____,DLBST,LBSTR,LBSTR
	WORD		_____,_____,DLBST,LBSTR,LBSTR,DLBST,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,DLBST,LBSTR,LBSTR,DLBST,_____,_____
	WORD		_____,_____,_____,_____,_____,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,_____,_____,_____,_____,_____
	WORD		LBSTR,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,LBSTR
	WORD		_____,_____,_____,_____,_____,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,_____,_____,_____,_____,_____
	WORD		_____,_____,DLBST,LBSTR,LBSTR,DLBST,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,DLBST,LBSTR,LBSTR,DLBST,_____,_____
	WORD		LBSTR,LBSTR,DLBST,_____,_____,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,_____,_____,DLBST,LBSTR,LBSTR
	WORD		_____,_____,_____,_____,_____,_____,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,_____,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,_____,_____,LBSTR,DLBST,DLBST,LBSTR,_____,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,_____,_____,LBSTR,DLBST,DLBST,LBSTR,_____,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,_____,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,_____,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,LBSTR,DLBST,DLBST,_____,_____,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,DLBST,LBSTR,DLBST,LBSTR,LBSTR,DLBST,LBSTR,DLBST,_____,_____,_____,_____,_____
DEF_BUSTO_LOBSTER:
	WORD 		18,6
	WORD		_____,_____,LBSTR,_____,LBSTR,_____,LBSTR,_____,_____,_____,_____,LBSTR,_____,LBSTR,_____,LBSTR,_____,_____
	WORD		_____,LBSTR,LBSTR,_____,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,_____,LBSTR,LBSTR,_____
	WORD		_____,LBSTR,LBSTR,_____,LBSTR,_____,LBSTR,BLACK,LBSTR,LBSTR,BLACK,LBSTR,_____,LBSTR,_____,LBSTR,LBSTR,_____
	WORD		_____,_____,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,_____,_____
	WORD		_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____,_____,_____
DEF_BUSTO_LOBSTER_2:
	WORD 		18,6
	WORD		_____,_____,_____,LBSTR,LBSTR,_____,LBSTR,_____,_____,_____,_____,LBSTR,_____,LBSTR,LBSTR,_____,_____,_____
	WORD		_____,_____,LBSTR,LBSTR,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,_____,_____,LBSTR,LBSTR,LBSTR,_____,_____
	WORD		_____,_____,LBSTR,LBSTR,LBSTR,_____,LBSTR,BLACK,LBSTR,LBSTR,BLACK,LBSTR,_____,LBSTR,LBSTR,LBSTR,_____,_____
	WORD		_____,_____,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,LBSTR,DLBST,LBSTR,LBSTR,_____,_____
	WORD		_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____
	WORD		_____,_____,_____,_____,_____,DLBST,LBSTR,LBSTR,DLBST,DLBST,LBSTR,LBSTR,DLBST,_____,_____,_____,_____,_____

DEF_SONDA:
	WORD		LARGURA_SONDA, ALTURA_SONDA
	WORD		PINKK, PINKK
	WORD		PINKK, PINKK
	WORD		PINKK, PINKK
	
	
comecou:	WORD 0		;Está a zero se o programa não começou passa a 1 quando começa
pausado:		WORD 0		;Está a zero se o programa não está em pausa passa a 1 quando pausa
primeira_linha_star:
	WORD		0
	WORD		0
	WORD		0
	WORD		0
primeira_coluna_star:
	WORD		0
	WORD		0
	WORD		0
	WORD		0
pos_star:
	WORD		0
	WORD		0
	WORD		0
	WORD		0
	
tipo_star:
	WORD		0
	WORD		0
	WORD		0
	WORD		0
	
pos_0:
	WORD		0	; primeira linha
	WORD		0	; primeira coluna
	WORD		5	; linha de colisão
	WORD		5	; coluna de colisão
	WORD		1	; direção para baixo
	WORD		1	; direção para direita

pos_1:
	WORD		0	; primeira linha
	WORD		28	; primeira coluna
	WORD		5	; linha de colisão
	WORD		5	; coluna de colisão
	WORD		1	; direção para baixo
	WORD		-1	; direção para direita
	
pos_2:
	WORD		0	; primeira linha
	WORD		28	; primeira coluna
	WORD		5	; linha de colisão
	WORD		2	; coluna de colisão
	WORD		1	; direção para baixo
	WORD		0	; direção para direita
	
pos_3:
	WORD		0	; primeira linha
	WORD		28	; primeira coluna
	WORD		5	; linha de colisão
	WORD		0	; coluna de colisão
	WORD		1	; direção para baixo
	WORD		1	; direção para direita
	
pos_4:
	WORD		0	; primeira linha
	WORD		58	; primeira coluna
	WORD		5	; linha de colisão
	WORD		0	; coluna de colisão
	WORD		1	; direção para baixo
	WORD		-1	; direção para direita

atraso_display:
	WORD		QNT_ATRASO_DISPLAY
valor_display:  
	WORD		ENERGIA_INICIAL
evento_int_0:
	LOCK 		0				; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
lock_sondas:
	LOCK 		0				; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
lock_display:
	LOCK 		0				; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
evento_int_3:
	LOCK 		0				; LOCK para a rotina de interrupção comunicar ao processo boneco que a interrupção ocorreu
lock_asteroides:
	LOCK 0
	LOCK 0

	
estado_sonda:													;*****************************************************************;
	WORD		0, 24, 24, -1, -1 		;sonda da esquerda		;* Primeiro valor diz o estado da sonda (ativa-1, desativada 0	 *;	
	WORD		0, 24, 30, -1, 0 		;sonda do meio			;* Segundo valor diz a linha atual da sonda 					 *;
	WORD		0, 24, 38, -1, 1		;sonda da direita		;* Terceiro valor diz a coluna atual da sonda					 *;		
	WORD	   24,	0,  0,  0, 0								;* Quarto valor diz quantas linhas se vai deslocar				 *;
	WORD	   30,	0,  0,  0, 0								;* Quinto valor diz quantas colunas se vai deslocar 			 *;
	WORD	   38,	0,  0,  0, 0								;*****************************************************************;
