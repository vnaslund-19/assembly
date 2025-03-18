.data

string: .ascii "Follow the white rabbit." #t0
checksum: .word 1869902693, 560950816

.text
main:
    la t0, string    # cargamos en r0 dir comienzo string
    li t2, 'a'       # cargamos el código del carácter 'a' en t2 para comparar luego
    li t3, 'z'       # cargamos el código del carácter 'z' en t3 para comparar luego
loop:
    lb t1, 0(t0)     # cargamos en r1 siguiente carácter (1 byte)
    addi t0, t0, 1   # incrementamos r0 para ir al siguiente carácter
    beqz t1, exit    # si el carácter es 0 (fin cadena) saltamos a exit
    blt t1, t2, loop # si es menor que 'a' volvemos al comienzo (sig. carác.)
    bgt t1, t3, loop # si es mayor que 'z' volvemos al comienzo (sig. carác.)
    addi t1, t1, -32 # convertimos carácter en mayúscula
    sb t1, -1(t0)    # almacenamos el nuevo carácter (1 byte) en pos. anterior (-1)
    j loop           # volvemos al comienzo del bucle

exit:
    li a7, 10        # cargamos en a7 el servicio 10 (exit) del S.O.
    ecall            # hacemos la llamada al S.O. para terminar

