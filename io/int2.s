.include "dacio_def.s"
.include "task.s"

.data
#crear variable en .data de led status
ledstatus: .word 0

.text
	# Inicialización base GPIO
	li s0, GPIOBASE
	
	# encender rojos
	li t0, 0x0000000F # leds 0-3 (botones rojos)
	sw t0, GPFSEL(s0) # selecciona 1:os de t0 como bits de salida
	sw t0, GPSET(s0) # activa leds de 1:os de t0
	
	# 1) Configurar utvec para que apunte a la rutina de interrupción rti
	la t0, rti            # cargar dirección de rti
	csrw t0, utvec        # escribir en utvec

	# 2) Habilitar interrupción para GPIO29 (botón 1)
	li t1, 0x20000000      # máscara GPIO29
	sw t1, GPIEN(s0)       # habilitar en GPIO Interrupt Enable

	# 3) Habilitar interrupciones externas en modo usuario (ueie bit8)
	li t0, 0x00000100      # bit8
	csrs t0, uie           # set ueie

	# 4) Habilitar interrupciones global en usuario (uie bit0)
	li t0, 0x00000001      # uie bit0
	csrs t0, ustatus       # set ustatus.uie

	# 5) Arrancar la tarea principal (no retorna)
	jal task

# ---------------------------------------------------------------
# Rutina de Tratamiento de Interrupción de Usuario por GPIO29
# ---------------------------------------------------------------
rti:
	# --- Salvar registros temporales t0–t4 en la pila ---
	addi sp, sp, -24      # reservar espacio para 6 registros
	sw   t0,  0(sp)       # salvar t0
	sw   t1,  4(sp)       # salvar t1
	sw   t2,  8(sp)       # salvar t2
	sw   t3, 12(sp)       # salvar t3
	sw   t4, 16(sp)       # salvar t4
	sw   t5, 20(sp)       # salvar t5

	# --- Verificar causa de la interrupción ---
	# ucause[31]=1 indica interrupt; ucause[3:0]=8 indica ext user interrupt
	csrr t0, ucause       # leer registro ucause
	li   t1, 0x80000008   # máscara: bit31 (int) y código8 (ext user)
	and  t0, t0, t1       # aislar bits relevantes
	bne  t0, t1, rti_end  # si no coincide, no es nuestra IRQ

	# --- Comprobar evento pendiente en GPIO29 ---
	li   t0, GPIOBASE
	lw   t1, GPEDS(t0)    # leer GPIO Event Detect Status
	li   t2, 0x20000000   # máscara GPIO29
	and  t2, t1, t2       # ver si bit29 está activo
	beqz t2, rti_end      # si no, no es este botón

	# --- Determinar color actual leyendo var ledstatus (0: rojo, 1: verde, 2:azul) ---
	li   t0, GPIOBASE

	# máscaras de colores (bits 0-3: rojos, 4-7: verdes, 8-11: azules)
	li   t1, 0x0000000F   # rojos
	li   t2, 0x000000F0   # verdes
	li   t3, 0x00000F00   # azules

	li   t4, 0x00000FFF    # bits de leds de colores
	lw   t5, GPFSEL(t0)    # LEER estado GPFSEL
	or   t5, t4, t5        # añadir bits de leds, (OR: 1:os de estado actual + 1:os de leds de colores)
	sw   t5, GPFSEL(t0)    # ESCRIBIR, configurar como salida bits de t5
	
	la  t4, ledstatus      # cargar dir de mem de var en t4
	lw  t4, 0(t4)	       # cargar valor en dir de memoria de var en t4

	# si ledstatus (t4) = 0 (rojo)
	beqz  t4, was_red

	# si ledstatus (t4) = 1 (verde)
	li t5, 1
	beq t4, t5, was_green

	# Si no era rojo ni verde, asumimos que era azul → cambiar a rojo
	j    was_blue

was_red:
	# --- Apagar rojos, encender verdes ---
	li   t0, GPIOBASE
	sw   t1, GPCLR(t0)   # limpiar bits de rojos
	sw   t2, GPSET(t0)   # set bits de verdes
	
	addi t4, t4, 1       # ledstatus a 1
	la t5, ledstatus     # cargar dirección en t5
	sw t4, 0(t5)         # guardar valor en dir de mem de variable
	
	j    clear_event

was_green:
	# --- Apagar verdes, encender azules ---
	li   t0, GPIOBASE
	sw   t2, GPCLR(t0)   # limpiar bits de verdes
	sw   t3, GPSET(t0)   # set bits de azules
	
	addi t4, t4, 1       # ledstatus a 2
	la t5, ledstatus     # cargar dirección en t5
	sw t4, 0(t5)         # guardar valor en dir de mem de variable
	
	j    clear_event

was_blue:
	# --- Apagar azules, encender rojos ---
	li   t0, GPIOBASE
	sw   t3, GPCLR(t0)   # limpiar bits de azules
	sw   t1, GPSET(t0)   # set bits de rojos

	li t4, 0       	     # ledstatus a 0
	la t5, ledstatus     # cargar dirección en t5
	sw t4, 0(t5)         # guardar valor en dir de mem de variable
	
	j    clear_event

clear_event:
	# --- Limpiar la bandera de evento para GPIO29 ---
	li   t0, GPIOBASE
	li   t1, 0x20000000   # máscara GPIO29
	sw   t1, GPCEDS(t0)   # escribir para limpiar evento

rti_end:
	# --- Restaurar registros temporales t0–t5 ---
	lw   t0,  0(sp)       # restaurar t0
	lw   t1,  4(sp)       # restaurar t1
	lw   t2,  8(sp)       # restaurar t2
	lw   t3, 12(sp)       # restaurar t3
	lw   t4, 16(sp)       # restaurar t4
	lw   t5, 20(sp)       # restaurar t5
	addi sp, sp, 24       # liberar espacio de pila

	# --- Retornar de la interrupción ---
	uret                # volver a user_mode
