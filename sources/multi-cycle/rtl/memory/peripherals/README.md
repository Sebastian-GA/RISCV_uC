# RISC-V uC Peripherals

## Overview

Welcome to the peripherals section of our RISC-V microcontroller documentation. This section provides detailed information about the various peripherals integrated into our RISC-V microcontroller.

## Table of Contents

1. [Digital Input](#peripheral-digital-input)
    1. [Digital Input Register (DIN_REG)](#digital-input-register-din_reg)
2. [Digital Output](#peripheral-digital-output)
    1. [Digital Output Register (DOUT_REG)](#digital-output-register-dout_reg)
    2. [Output Mode Register (OUTM_REG)](#output-mode-register-outm_reg)
3. [Timer0](#peripheral-timer0)
    1. [Timer0 Register (TIMER0_REG)](#timer0-register-timer0_reg)
4. [Timer1](#peripheral-timer1)
    1. [Timer1 Register (TIMER1_REG)](#timer1-register-timer1_reg)
5. [PWM0](#peripheral-pwm0)
    1. [PWM0 Register (PWM0_REG)](#pwm0-register-pwm0_reg)
6. [7-Segment Display](#peripheral-7-segment-display)
    1. [7-Segment Display Register (7SEG_REG)](#7-segment-display-register-7seg_reg)

## Peripheral Digital Input

The digital input peripheral is designed to seamlessly interface with digital sensors, buttons, switches, and other input devices. This section offers insights into its functionalities, use cases, and integration with the RISC-V microcontroller.

### Register Map

This peripheral can be accessed through the following register:

#### Digital Input Register (DIN_REG)

-   **Address:** 0x700
-   **Description:** This register is used to read the value of the digital input pins.
-   **Bits:**
    -   **[15:0]** _(R)_ - Switches: SW[15:0]
    -   **[19:16]** _(R)_ - Input Pins: [JA4, JA3, JA2, JA1]
    -   **[24:20]** _(R)_ - Buttons: [BTND, BTNR, BTNL, BTNU, BTNC]
    -   **[31:25]** _(U-0)_ - Not Implemented (Read as 0)

### Configuration

This peripheral does not require any configuration.

### Example Code

```
# Example: Read the value of the SW[3] switch and store it in register t0

lw t0, 0x700(x0) # Load the value of the DIN_REG into register t0
andi t0, t0, 0x8 # Mask the value of t0 to only keep the value of SW[3]
srli t0, t0, 3   # Shift the value of t0 to the right by 3 bits

# At this point, the value of t0 is the value of SW[3]
```

## Peripheral Digital Output

The digital output peripheral is designed to seamlessly interface with digital actuators, LEDs, and other output devices. This section offers insights into its functionalities, use cases, and integration with the RISC-V microcontroller.

### Register Map

This peripheral can be controlled through the following registers:

#### Digital Output Register (DOUT_REG)

-   **Address:** 0x704
-   **Description:** This register is used to write the digital value of the output pins.
-   **Bits:**
    -   **[15:0]** _(R/W-0)_ - LEDs: LED[15:0]
    -   **[19:16]** _(R/W-0)_ - Output Pins: [JA10, JA9, JA8, JA7]
    -   **[31:20]** _(U-0)_ - Not Implemented (Read as 0)

#### Output Mode Register (OUTM_REG)

-   **Address:** 0x714
-   **Description:** This register is used to configure the output pins. The output pins can be configured as either analog or digital pins. Analog output refers to the ability to output a PWM signal. See the [PWM peripheral](#peripheral-pwm0) for more information. **Setting a bit to 1 configures the corresponding pin as a PWM output pin. Setting a bit to 0 configures the corresponding pin as a digital output pin.**
-   **Bits:**
    -   **[15:0]** _(R/W-0)_ - LEDs: LED[15:0]
    -   **[19:16]** _(R/W-0)_ - Output Pins: [JA10, JA9, JA8, JA7]
    -   **[31:20]** _(U-0)_ - Not Implemented (Read as 0)

### Configuration

To configure the digital output peripheral, first write the desired mode to the OUTM_REG. See the [OUTM_REG](#output-mode-register-outm_reg) register for more information.

### Example Code

```
# Example: Turn on LED[0] and LED[15]

# By default, all pins are configured as digital output pins
# See the OUTM_REG register for more information
# See the PWM peripheral for information on how to configure the pins as PWM output pins

# Set output value of LED[0] to 1
addi t0, x0, 0x1 # Set the value of t0 to 0x1
# Set output value of LED[15] to 1
addi t1, x0, 0x1 # Set the value of t0 to 0x1
slli t1, t0, 15  # Shift the value of t0 to the left by 15 bits
# Concatenate output values of LED[0] and LED[15]
add t0, t0, t1   # Add the values of t0 and t1 and store the result in t0
# Write the value of t0 to the DOUT_REG register
sw t0, 0x704(x0) # Write the value of t0 to the DOUT_REG register
```

## Peripheral Timer0

This physical timer is designed to seamlessly interface with the RISC-V microcontroller. Timer0 is a 32-bit timer that operates at 1MHz, which means that it increments its value every 1us. This section offers insights into its functionalities, use cases, and integration with the RISC-V microcontroller.

### Register Map

This peripheral is accessed through the following register:

#### Timer0 Register (TIMER0_REG)

-   **Address:** 0x708
-   **Description:** This register is used to write or read the value of the timer.
-   **Bits:**
    -   **[31:0]** _(R/W-0)_ - Timer0: TIMER0[31:0]

### Configuration

This peripheral does not require any configuration.

### Example Code

```
# Example: Generate a 1ms delay

TODO: Add example code
```

## Peripheral Timer1

This physical timer is designed to seamlessly interface with the RISC-V microcontroller. Timer1 is a 32-bit timer that operates at 1kHz, which means that it increments its value every 1ms. This section offers insights into its functionalities, use cases, and integration with the RISC-V microcontroller.

### Register Map

This peripheral is accessed through the following register:

#### Timer1 Register (TIMER1_REG)

-   **Address:** 0x70C
-   **Description:** This register is used to write or read the value of the timer.
-   **Bits:**
    -   **[31:0]** _(R/W-0)_ - Timer1: TIMER1[31:0]

### Configuration

This peripheral does not require any configuration.

### Example Code

```
# Example: Generate a 1s delay

TODO: Add example code
```

## Peripheral PWM0

TODO: Add documentation

## Peripheral 7-Segment Display

TODO: Add documentation
