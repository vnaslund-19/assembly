.include "dacio_def.s"
.include "task.s"

.data
#crear variable en .data de led status
led_on: .word -1

.text
	# Inicialización base GPIO
	li s0, GPIOBASE
	
	li   t0, GPIOBASE
	li   t1, 0x00000FFF    # bits de leds de colores
	sw   t1, GPFSEL(t0)    # ESCRIBIR, configurar como salida bits de t1

	# 1) Configurar utvec para que apunte a la rutina de interrupción rti
	la t0, rti            # cargar dirección de rti
	csrw t0, utvec        # escribir en utvec

	# 2) Habilitar interrupción para GPIO29 (botón 1)
	li t1, 0x70000000      # máscara GPIO30 + GPIO29 + GPIO28
	sw t1, GPIEN(s0)       # habilitar en GPIO Interrupt Enable

	# 3) Habilitar interrupciones externas en modo usuario (ueie bit8)
	li t0, 0x00000100      # bit8
	csrs t0, uie           # set ueie (user interrupt enable)

	# 4) Habilitar interrupciones global en usuario (uie bit0)
	li t0, 0x00000001      # uie bit0
	csrs t0, ustatus       # set ustatus.uie

	# 5) Arrancar la tarea principal (no retorna)
	jal task

# ---------------------------------------------------------------
# Rutina de Tratamiento de Interrupción de Usuario por GPIO29
# ---------------------------------------------------------------
rti:
	# --- Salvar registros temporales t0–t3 en la pila ---
	addi sp, sp, -16     # reservar espacio para 4 registros
	sw   t0,  0(sp)       # salvar t0
	sw   t1,  4(sp)       # salvar t1
	sw   t2,  8(sp)       # salvar t2
	sw   t3, 12(sp)       # salvar t3

	# comprobar que es una interrupción externa
 	csrr t0, ucause     # leemos registro ucause
 	li t1, 0x80000008   # máscara para interrupción externa en modo usuario
 	and t0, t0, t1 	    # aplicamos máscara
 	bne t0, t1, rti_end # si no son iguales, no es interrupción externa y terminamos

	# --- Comprobar evento pendiente (leer que boton fue) ---
	li   t0, GPIOBASE
	lw   t1, GPEDS(t0)    # leer GPIO Event Detect Status
	
	# ¿GPIO28?
	li   t2, 0x10000000   # máscara GPIO28
	and  t3, t1, t2       # ver si bit28 está activo
	bnez t3, btn0         # si no =0, es este botón
	
	# ¿GPIO29?
	li   t2, 0x20000000   # máscara GPIO29
	and  t3, t1, t2       # ver si bit29 está activo
	bnez t3, btn1         # si no =0, es este botón
	
	# ¿GPIO30?
	li   t2, 0x40000000   # máscara GPIO30
	and  t3, t1, t2       # ver si bit30 está activo
	bnez t3, btn2         # si no =0, es este botón

	j rti_end
	

btn0:
	li t0, GPIOBASE
	li t1, 0x00000FFF  # mascara de todos los leds (0-11)
	sw t1, GPCLR(t0)   # limpiar bits de todos los leds
	li t1, 0x00000001  # led 1
	sw t1, GPSET(t0)   # encender led 1
	
	la t2, led_on     # cargar dirección en t2
	sw t1, 0(t2)      # guardar valor (1) en dir de mem de variable
	
	j rti_end
	
btn1:
	li t0, GPIOBASE

	la  t1, led_on         # cargar dir de mem de var en t1
	lw  t1, 0(t1)	       # cargar valor en dir de memoria de var en t1

	# si estan todos apagados, ignora
	li t2, -1     
	beq t2, t1, rti_end
	
	# cargar valor de led_on, apagar ese led y encender siguiente, y actualizar led_on, si ya es el ultimo led, saltar al primero
	sw t1, GPCLR(t0)  # apagar
	
	li   t2, 0x00000800  # ultimo led (si esta en ultimo -> enciende primer led)
	beq t1, t2, first
	
	slli t1, t1, 1    # mover un bit a la izquierda (siguiente led)
	
v1:	sw t1, GPSET(t0)  # encender siguiente
	
	la t2, led_on     # cargar dirección en t2
	sw t1, 0(t2)      # guardar valor de boton en dir de mem de variable
	
	j rti_end

first:
	li t1, 1
	j v1


btn2:
	li t0, GPIOBASE

	la  t1, led_on         # cargar dir de mem de var en t1
	lw  t1, 0(t1)	       # cargar valor en dir de memoria de var en t1

	# si estan todos apagados, ignora (-1 es el valor base)
	li t2, -1     
	beq t2, t1, rti_end

	# cargar valor de led_on, apagar ese led y encender anterior, y actualizar led_on, si ya es el primer led, saltar al ultimo
	sw t1, GPCLR(t0) # apagar
	
	li   t2, 1       # primer led (si esta en primero -> enciende ultimo led)
	beq t1, t2, last

	srli t1, t1, 1   # mover un bit a la derecha (led anterior)

v2:	sw t1, GPSET(t0) # encender siguiente
	
	la t2, led_on     # cargar dirección en t2
	sw t1, 0(t2)      # guardar valor de boton en dir de mem de variable
	
	j rti_end

last:
	li t1, 0x00000800
	j v2	

rti_end:
	# --- Limpiar la bandera de evento para todos los botones --- #
	li   t0, GPIOBASE
	li   t1, 0x70000000
	sw   t1, GPCEDS(t0)   # escribir para limpiar todos los eventos de los botones (mascara en t2)

	# --- Restaurar registros temporales t0–t3 ---
	lw   t0,  0(sp)       # restaurar t0
	lw   t1,  4(sp)       # restaurar t1
	lw   t2,  8(sp)       # restaurar t2
	lw   t3, 12(sp)       # restaurar t3
	addi sp, sp, 16       # liberar espacio de pila

	# --- Retornar de la interrupción ---
	uret                # volver a user_mode
