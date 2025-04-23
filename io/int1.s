.include "dacio_def.s"
.include "task.s"

.text
	# Inicialización base GPIO
	li s0, GPIOBASE

	# 1) Configurar utvec para que apunte a la rutina de interrupción rti
	la t0, rti            # cargar dirección de rti
	csrw t0, utvec        # escribir en utvec

	# 2) Habilitar interrupción para GPIO28 (botón 0)
	li t1, 0x10000000      # máscara GPIO28
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
# Rutina de Tratamiento de Interrupción de Usuario por GPIO28
# ---------------------------------------------------------------
rti:
	# --- Salvar registros temporales ---
	addi sp, sp, -12
	sw   t0, 0(sp)
	sw   t1, 4(sp)
	sw   t2, 8(sp)

	# --- Verificar causa: interrupción externa usuario ---
	csrr t0, ucause        # leer cause
	li   t1, 0x80000008    # máscara: bit31 (interrupt) + code8 (ext user)
	and  t0, t0, t1
	bne  t0, t1, rti_end   # si no coincide, no es GPIO28

	# --- Comprobar GPEDS GPIO28 ---
	li   t0, GPIOBASE
	lw   t1, GPEDS(t0)     # leer eventos pendientes
	li   t0, 0x10000000    # máscara GPIO28
	and  t0, t1, t0
	beqz t0, rti_end       # si bit28=0, no es esta interrupción

	# --- Acción: encender LEDs azules (bits 8-11) ---
	li   t0, GPIOBASE
	li   t1, 0x00000F00    # máscara leds azules (8-11)
	lw   t2, GPFSEL(t0)    # LEER estado GPFSEL
	or   t2, t1, t2        # añadir bits de azules, (OR: 1:os de estado actual + 1:os de leds azules)
	sw   t2, GPFSEL(t0)    # ESCRIBIR, configurar como salida bits de t2
	sw   t1, GPSET(t0)     # encender bits de t1 (leds azules)

	# --- Limpiar evento GPEDS para GPIO28 ---
	li   t1, 0x10000000    # máscara GPIO28
	sw   t1, GPCEDS(s0)    # escribir para limpiar

rti_end:
	# --- Restaurar registros temporales ---
	lw   t0, 0(sp)
	lw   t1, 4(sp)
	lw   t2, 8(sp)
	addi sp, sp, 12

	# --- Retornar de interrupción ---
	uret                 
