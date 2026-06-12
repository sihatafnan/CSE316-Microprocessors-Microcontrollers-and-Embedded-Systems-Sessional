# CSE 316 - Microprocessors, Microcontrollers and Embedded Systems (Sessional)

Coursework for the CSE 316 sessional (lab) course. The repository collects the
8086 assembly programming assignments and the microcontroller simulation
experiments completed during the course.

## Course Scope

Introduction to 8-bit, 16-bit and 32-bit microprocessors: architecture,
addressing modes, instruction set, interrupts, multi-tasking and virtual memory;
memory and bus interfacing; arithmetic co-processor; microcontrollers;
programmable peripheral interfacing chips with interfaces to A/D and D/A
converters; keyboard/display interfaces; programmable timer, interrupt
controller and DMA controller; and an introduction to embedded systems design
flow, hardware platforms, peripherals, sensors and actuators.

## Contents

The work is split into four 8086 assembly assignments and two microcontroller
simulation experiments.

| Path | Description |
| ---- | ----------- |
| `Assembly/Offline1` – `Assembly/offline4` | Four 8086 assembly language assignments. |
| `LED_Matrix/` | Microcontroller experiment driving an LED dot-matrix display (`main.c`), with a Proteus simulation project (`assignment_1.pdsprj`) and the experiment handout. |
| `LCD Display_ADC/` | Microcontroller experiment reading an ADC and showing the result on an LCD, with the AVR/GCC source under `GccApplication2/`, the Proteus project (`adc_lcd.pdsprj`) and the experiment handout. |
| `cse-316-quiz.pdf` | Course quiz material. |

## Tools

- **8086 assembly** assignments – assembled and run with an 8086 emulator/assembler (e.g. emu8086).
- **C for AVR microcontrollers** – the simulation experiments were written in C and compiled to HEX using Atmel Studio (AVR-GCC).
- **Proteus** (`.pdsprj` files) – used to simulate the microcontroller circuits and load the generated HEX.

## Usage

- Assembly: open the `.asm` files from each `Assembly/offlineN` folder in your 8086 assembler/emulator, then assemble and run.
- Simulation experiments: build the C source in Atmel Studio to produce a HEX
  file, open the matching `.pdsprj` in Proteus, point the microcontroller at the
  HEX file and start the simulation.
