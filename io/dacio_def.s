# Memory mapped I/O addresses of GPIO registers

#GPIO Base Address
.eqv GPIOBASE, 0xFFFF0100   # GPIO base address

# Offset from GPIO base address of GPIO registers
.eqv GPFSEL, 0x00           # GPIO Function Select: 0 input (default), 1 output
.eqv GPSET, 0x10            # GPIO Pin Output Set: 1 output high
.eqv GPCLR, 0x20            # GPIO Pin Output Clear: 1 output low
.eqv GPLEV, 0x30            # GPIO Pin Input Level: 1 high, 0 low
.eqv GPIEN, 0x40            # GPIO Interrupt Enable: 1 enable, 0 disable
.eqv GPEDS, 0x50            # GPIO Event Detect Status: 1 event detected
.eqv GPCEDS, 0x60           # GPIO Clear Event Detect Status: 1 clear event

# Memory mapped I/O addresses of Timer registers
.eqv TIMERBASE, 0xFFFF0200   # Timer base address
.eqv MTIME_LO, 0x00c        # Low order Timer register
.eqv MTIME_HI, 0x010        # High order Timer register
.eqv MTIMECMP_LO, 0x000     # Low order Timer Compare register
.eqv MTIMECMP_HI, 0x004     # High order Timer Compare register

# Bits associated with the devices connected to the GPIO pins

# Red LEDs row (top)
.eqv RLED0, 0x00000001     	# pin 0: Red LED 0 (left most)
.eqv RLED1, 0x00000002      # pin 1: Red LED 1
.eqv RLED2, 0x00000004      # pin 2: Red LED 2
.eqv RLED3, 0x00000008      # pin 3: Red LED 3 (right most)

# Green LEDs row (middle)
.eqv GLED0, 0x00000010      # pin 4: Green LED 0 (left most)
.eqv GLED1, 0x00000020      # pin 5: Green LED 1
.eqv GLED2, 0x00000040      # pin 6: Green LED 2
.eqv GLED3, 0x00000080      # pin 7: Green LED 3 (right most)

# Blue LEDs row (bottom)
.eqv BLED0, 0x00000100      # pin 8: Blue LED 0 (left most)
.eqv BLED1, 0x00000200      # pin 9: Blue LED 1
.eqv BLED2, 0x00000400      # pin 10: Blue LED 2
.eqv BLED3, 0x00000800      # pin 11: Blue LED 3 (right most)

# Seven segment display 0 (left)
.eqv SEG0A, 0x00001000      # pin 12: Segment A (top)
.eqv SEG0B, 0x00002000      # pin 13: Segment B (top right)
.eqv SEG0C, 0x00004000      # pin 14: Segment C (bottom right)
.eqv SEG0D, 0x00008000      # pin 15: Segment D (bottom)
.eqv SEG0E, 0x00010000      # pin 16: Segment E (bottom left)
.eqv SEG0F, 0x00020000      # pin 17: Segment F (top left)
.eqv SEG0G, 0x00040000      # pin 18: Segment G (middle)
.eqv SEG0DP, 0x00080000     # pin 19: Segment DP (decimal point)

# Seven segment display 1 (right)
.eqv SEG1A, 0x00100000      # pin 20: Segment A (top)
.eqv SEG1B, 0x00200000      # pin 21: Segment B (top right)
.eqv SEG1C, 0x00400000      # pin 22: Segment C (bottom right)
.eqv SEG1D, 0x00800000      # pin 23: Segment D (bottom)
.eqv SEG1E, 0x01000000      # pin 24: Segment E (bottom left)
.eqv SEG1F, 0x02000000      # pin 25: Segment F (top left)
.eqv SEG1G, 0x04000000      # pin 26: Segment G (middle)
.eqv SEG1DP, 0x08000000     # pin 27: Segment DP (decimal point)

# Push buttons
.eqv PB0, 0x10000000        # pin 28: Push button 0 (left)
.eqv PB1, 0x20000000        # pin 29: Push button 1 (middle)
.eqv PB2, 0x40000000        # pin 30: Push button 2 (right)

