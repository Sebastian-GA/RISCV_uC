# Memory Architecture

Welcome to the memory architecture section of the multi-cycle version of our RISC-V microcontroller repository!

## Overview

The memory architecture in the multi-cycle version of our RISC-V microcontroller is build as a single memory block, oposed to the multi-block architecture used in the single-cycle version. This is a more realistic approach, as it is more common to have a single memory block in a microcontroller.

## Memory Map

The memory map for the multi-cycle version of our RISC-V microcontroller is shown below:

![Memory Map](../../../../images/memory_map.png)

The memory map is divided into 3 sections:

-   **Text**: This section is used to store the instructions of the program. It starts at address `0x000` and ends at address `0x1FF`. The size of this section is 512B.

-   **Data**: This section is used to store the data of the program. It starts at address `0x200` and ends at address `0x2FF`. The size of this section is 256B.

-   **Peripheral**: This section is reserved for the memory mapped registers that control the peripherals. It starts at address `0x700` and ends at address `0x71B`. The size of this section is 28B. The peripherals are described in the [peripherals](peripherals/README.md) section.
