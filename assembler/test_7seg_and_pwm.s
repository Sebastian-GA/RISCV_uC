# test_7seg_and_pwm.s
# Test 7seg and PWM

# Using SW[6:0] as duty cycle
# Display current duty cycle on 7seg display
# Output PWM on all pins (leds and JA pins 7 to 10)

# Main loop
loop:   
	# Set duty cycle
	lw t0, 0x100(zero)
    andi s0, t0, 0b1111111
    sw s0, 0x110(zero)
    
    # Set analog out
    addi t0, zero, -1
    sw t0, 0x114(zero)
    
    # Print duty on display-7seg
    addi t0, zero, 0xFF
    slli t0, t0, 8
    addi t0, t0, 0xFF
    and t0, s0, t0  # Save duty on t0
    addi t1, zero, 0b0111  # Enable 7segs
    slli t1, t1, 16  # Put enables on right index
    addi t2, zero, 0b1010  # Enable dots
    slli t2, t2, 20  # Put enables on right index
    addi t3, zero, 1  # nums_format = 1 (Number is in binary)
    slli t3, t3, 24  # Put nums_format on right index
    # sum all
    add t0, t0, t1
    add t0, t0, t2
    add t0, t0, t3
    # write on peripheral
    sw t0, 0x118(zero)

	# Infinite loop
	j loop  # jump to loop