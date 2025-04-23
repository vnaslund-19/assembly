.include "dacio_def.s"

.text
	li s0, GPIOBASE
	li s1, TIMERBASE
	
	li t0, 0x0000000F # leds 0-3 (botones rojos)
	li t1, 0x000000F0 # leds 4-7 (botones verdes)
	li t2, 0x00000F00 # leds 8-11 (botones azules)
	li t3, 0x00000FFF # todos los botones
	
	sw t3, GPFSEL(s0) # selecciona 1:os de t3 como bits de salida
	sw t3, GPSET(s0) # enciende todos los botones
	
	li a0, 1 # flag de rojos encendidos
	li a1, 1 # flag de verdes
	li a2, 1 # flag de azules
	
	lw t3, MTIME_LO(s1) #tiempo actual en t3
	addi t4, t3, 500    #tiempo de periodo rojos t4
	addi t5, t3, 700    #tiempo de periodo verdes t5
	addi t6, t3, 900    #tiempo de periodo azules t6

loop:	lw t3, MTIME_LO(s1)
	bgeu t3, t4, mR
	bgeu t3, t5, mV
	bgeu t3, t6, mA
	j loop
	
	

mR: # manejar Rojo
	beqz a0, eR # si estaban apagados, enciende
	j aR # si no, apaga
vR:	addi t4, t3, 500 #sumar para preparar para siguiente cambio
	j loop

eR: # encender Rojo
	sw t0, GPSET(s0) # activa leds de 1:os de t0
	li a0, 1 # flag = encendido
	j vR # volver Rojo
	
aR: # apagar Rojo
	sw t0, GPCLR(s0) # apaga leds de 1:os de t0
	li a0, 0 # flag = apagado
	j vR
	
	
mV: # Verde
	beqz a1, eV # si estaban apagados, enciende
	j aV # si no, apaga
vV:	addi t5, t3, 700
	j loop

eV: 
	sw t1, GPSET(s0) # activa leds de 1:os de t1
	li a1, 1 # flag
	j vV
	
aV:
	sw t1, GPCLR(s0) # apaga leds de 1:os de t1
	li a1, 0 # flag = apagado
	j vV

mA: # Azul
	beqz a2, eA # si estaban apagados, enciende
	j aA # si no, apaga
vA:	addi t6, t3, 900
	j loop
	
eA:
	sw t2, GPSET(s0) # activa leds de 1:os de t2
	li a2, 1
	j vA
	
aA:
	sw t2, GPCLR(s0) # apaga leds de 1:os de t2
	li a2, 0
	j vA

