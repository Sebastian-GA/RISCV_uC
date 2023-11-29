# RISC-V uC Peripherals

## Overview

Welcome to the peripherals section of our RISC-V microcontroller documentation. This section provides detailed information about the various peripherals integrated into our RISC-V microcontroller.

## Table of Contents

1. [Digital Input](#peripheral-digital-input)
    1. [Digital Input Register (DIN_REG)](#digital-input-register-din_reg)
2. [Digital Output](#peripheral-digital-output)
3. [Timer0](#peripheral-timer0)
4. [Timer1](#peripheral-timer1)
5. [PWM0](#peripheral-pwm0)
6. [7-Segment Display](#peripheral-7-segment-display)
7. [How to Use](#how-to-use)
8. [Example Code](#example-code)
9. [License](#license)

## Peripheral Digital Input

The digital input peripheral is designed to seamlessly interface with digital sensors, buttons, switches, and other input devices. This section offers insights into its functionalities, use cases, and integration with the RISC-V microcontroller.

### Register Map

This peripheral can be accessed through the following register:

#### Digital Input Register (DIN_REG)

-   **Address:** 0x800
-   **Description:** This register is used to read the value of the digital input pins.
-   **Bits:**
    -   [15:0] - Switches
    -   [19:16] - Input Pins
    -   [24:20] - Buttons
    -   [31:25] - Not Implemented

### Configuration

Explain how to configure Peripheral A for different use cases and scenarios.

## How to Use

This section offers general guidelines on how to use and interface with the peripherals collectively. It may include information on initializing peripherals, managing interrupts, and ensuring proper communication between peripherals and the RISC-V core.

## Example Code

Offer sample code snippets demonstrating how to use each peripheral individually and in combination. This can serve as a helpful reference for developers looking to implement specific functionalities.

## License

This documentation is licensed under the [license name/version]. Refer to the [LICENSE](LICENSE) file for more details.
