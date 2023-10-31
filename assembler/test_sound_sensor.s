# sound_sensor.s
# Program: Sound Sensor
# Authors: Sebastian Garcia
#          Juliana Pineda
# Date: 24/10/2023
#
# Test the RISC-V processor with sound sensor

# s1: $sound_sensor
# s2: $reset
# s3: $led
# s4: $MAX_WINDOW_TIME
# s5: $initial_window_time
# s6: $pulses_counter
# s7: $level_led

# Reset $led, $level_led and $pulses_counter
addi s3, zero, 0
addi s7, zero, 0
addi s6, zero, 0

# Set $MAX_WINDOW_TIME equal to half a second
addi s4, zero, 500

# Main loop
loop:   
	# Read input peripheral
	lw t0, 0x100(zero)
    srli s1, t0, 16
    andi s1, s1, 1  # Read $sound_sensor
    srli s2, t0, 20
    andi s2, s2, 1  # Read $reset
    
    # if($sound_sensor == HIGH)
    beq s1, zero, omit_set_led
    	# if($pulses_counter != 0)
        beq s6, zero, init_window
        	j omit_init_window
        #else
        init_window:
        	lw s5, 0x10C(zero)  # $initial_window_time = timer_1 : millis()
         omit_init_window:
        addi s3, zero, 1  # $led = HIGH
		addi s6, s6, 1  # $pulses_counter += 1
    omit_set_led:
    
    # if($reset == HIGH)
    beq s2, zero, omit_reset
    	addi s3, zero, 0  # $led = LOW
        addi s7, zero, 0  # $level_led = LOW
    omit_reset:
    
    # if($pulses_counter != 0)
    beq s6, zero, omit_measure_window
    	# if((current_time - $initial_window_time) > $MAX_WINDOW_TIME)
        lw t0, 0x10C(zero)  # t0 = current_time: timer_1: millis()
        sub t1, t0, s5  # t1 = current_time - $initial_window_time        
        slt t0, s4, t1  # t0 = $MAX_WINDOW_TIME < t1
        beq t0, zero, omit_finish_window
        	
            ###
        	# Print on 7seg display $pulses_counter
            addi t0, zero, 0xFF
            slli t0, t0, 8
            addi t0, t0, 0xFF
            and t0, s6, t0  # Save $pulses_counter on t0
            addi t1, zero, 0b1111  # Enable 7segs
            slli t1, t1, 16  # Put enables on right index
            addi t2, zero, 0b0000  # Enable dots
            slli t2, t2, 20  # Put enables on right index
            addi t3, zero, 1  # nums_format = 1 (Number is in binary)
            slli t3, t3, 24  # Put nums_format on right index
            # sum all
            add t0, t0, t1
            add t0, t0, t2
            add t0, t0, t3
            # write on peripheral
            sw t0, 0x118(zero)
            
            ###
            # Depending on $pulses_counter put $level_led output
            
            # Amplitude Level 3
            addi t0, zero, 50  # Level Pulses
            slt t0, t0, s6  # t0 = Level_Pulses < $pulses_counter
            beq t0, zero, omit_level_3
            	addi s7, zero, 0b100  # $level_led
            	j finish_level_led
            omit_level_3:
            
            # Amplitude Level 2
            addi t0, zero, 20  # Level Pulses
            slt t0, t0, s6  # t0 = Level_Pulses < $pulses_counter
            beq t0, zero, omit_level_2
            	addi s7, zero, 0b010  # $level_led
                j finish_level_led
            omit_level_2:
            
            # Amplitude Level 1 (Default)
            addi s7, zero, 0b001  # $level_led
            
            finish_level_led:
            # Reset $pulses_counter
        	addi s6, zero, 0  # $pulses_counter = 0
        omit_finish_window:
    omit_measure_window:
    
	# Write output peripheral
    slli t0, s7, 13  # $level_led
    add t0, s3, t0  # concatenate outputs
	sw t0, 0x104(zero)  # set the output


	# Delay 100us
    addi t0, zero, 100
    lw t1, 0x108(zero)  # t1 = init_delay : micros()
   	repeat_delay:
    lw t2, 0x108(zero)  # t2 = current_time
    sub t3, t2, t1  # t3 = current_time - init_delay
    slt t2, t0, t3  # t2 = $100us < t3
    beq t2, zero, repeat_delay

	# Infinite loop
	j loop  # jump to loop