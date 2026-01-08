# AssemblyCLIApplication
The following application was built as an interactive user-friendly Assembly app to exemplify what basic x8086 command can accomplish. It mimics layered architecture design patterns with the multi-module style and it was built chiefly with jumps, int 21h functions, shifts and rotations, and move operations.

# Hexadecimal Sequence Operations Manager (x86 Assembly)

## 📖 Overview

This is a 16-bit x86 Assembly application designed to run in a DOS environment. The program accepts a string of hexadecimal characters from the user, validates it against a dictionary file, converts it into a binary byte sequence, and performs various mathematical and bitwise operations via an interactive text-based menu.

## ✨ Features

The application offers the following core functionalities:

1.  **Sequence Visualization**: Print the currently stored sequence in either **Hexadecimal** or **Binary** format.
2.  **Sequence Sorting**: Sorts the byte sequence in ascending order.
3.  **"Word C" Calculation**: Computes a specific 16-bit checksum/hash word (Word C) derived from the byte sequence using three distinct algorithms:
    * High-nibble XOR operations.
    * Masking and processing bits 4-7.
    * Summation of bytes modulo 256.
4.  **Bitwise Rotation**: Rotates the bits within every byte of the sequence. The number of positions to rotate is determined dynamically based on the bit content of the byte itself.
5.  **Bit Analysis**: Finds the byte with the highest number of set bits (1s).
    * *Constraint*: The byte must have at least 4 bits set to '1' to be considered valid; otherwise, the user is prompted with options to handle the result.
6.  **Input Reset**: Clears the current data and allows the introduction of a new sequence.

## 🛠️ Technical Specifications

* **Architecture**: x86 (16-bit Real Mode).
* **Assembler**: TASM (Turbo Assembler).
* **Memory Model**: Segmented (`ASSUME DS:data, CS:code`).
* **Validation**: Uses external file I/O to validate allowed characters.

## 📋 Input Constraints

To successfully run the program, the input string must meet the following criteria:
* **Allowed Characters**: Hexadecimal digits (`0-9`, `A-F`, `a-f`) and spaces.
* **Length**: Minimum **16** characters, Maximum **32** characters.
* **Parity**: The number of valid hex characters must be **even** (since 2 hex chars = 1 byte).

## 📂 Project Structure

| File Name | Description |
| :--- | :--- |
| **`main.asm`** | Entry point of the program. Initializes data segments and hands off control to the UI. |
| **`ui.asm`** | The main controller. Handles user input, menu display, and orchestrates calls to other modules. |
| **`converter.asm`** | Converts the ASCII Hex input string into raw binary byte values. |
| **`validator.asm`** | Validates input against length constraints and checks characters against `hexa.txt`. |
| **`sorter.asm`** | Implements the sorting algorithm for the byte sequence. |
| **`rotator.asm`** | Logical implementation for rotating bits within the bytes. |
| **`word_maker.asm`** | Logic for calculating the complex "Word C" based on bitwise operations. |
| **`byte_searcher.asm`** | Scans the sequence to find the byte with the most population count (set bits). |
| **`printer.asm`** | Utilities for printing bytes in Hex, Binary, and Decimal formats to the console. |
| **`exception.asm`** | Defines error message strings (e.g., Invalid Length, Empty String). |
| **`hexa.txt`** | **(Required External File)** Contains valid characters used by `validator.asm` for comparison. |
| **`BUILD.BAT`** | Batch script to compile and link the project. |

## 🚀 How to Build and Run

You will need a DOS environment (like DOSBox) and the TASM/TLINK toolchain installed.

### 1. Prerequisites
Ensure `hexa.txt` exists in the same directory and contains the valid hexadecimal characters used for validation (content: `0123456789ABCDEFabcdef`).

### 2. Automated Build
A batch file is included to streamline the compilation and linking process.
1.  Open your DOS environment.
2.  Navigate to the project directory.
3.  Run the build script:
    ```bash
    BUILD.BAT
    ```
    This will generate the `MAIN.EXE` executable.

### 3. Execution
Run the resulting executable:
```bash
MAIN.EXE
