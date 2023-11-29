# test_counter_with_millis.s
# Test counter with millis

# This program counts the number of times that the delay is done
# and shows it on the display-7seg

# s0 = $counter
# s1 = $initial_time
# s2 = 1000ms

# Main
main:
	# Reset $counter and $initial_time
	addi s0, zero, 0
    addi s1, zero, 0
    
    # Delay = 1000ms
    addi s2, zero, 1000 

loop:
    
    # if((current_time - $initial_time) > 1000ms)
    lw t0, 0x70C(zero)
    sub t1, t0, s1
    slt t1, s2, t1
    beq t1, zero, omit_done_delay
        add s1, zero, t0  # update $initial_time
        addi s0, s0, 1  # increment $counter
        
        # Print $counter on display-7seg
        # addi t0, zero, 0xFF
        # slli t0, t0, 8
        # addi t0, t0, 0xFF
        and t0, zero, s0  # Save $counter on t0
        addi t1, zero, 0b1111  # Enable 7segs
        slli t1, t1, 16  # Put enables on right index
        addi t2, zero, 0b0000  # Disable dots
        slli t2, t2, 20  # Put enables on right index
        addi t3, zero, 1  # nums_format = 1 (Number is in binary)
        slli t3, t3, 24  # Put nums_format on right index
        # sum all
        add t0, t0, t1
        add t0, t0, t2
        add t0, t0, t3
        # write on peripheral
        sw t0, 0x718(zero)
	omit_done_delay:

	# Infinite loop
	j loop  # jump to loop