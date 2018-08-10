Lockbox Stack Erase Demo
========================

This repository contains code accompanying the blog post "Protecting secret data
with Stack Erase".

Note that this repository is something of a work-in-progress - some cleaning up
may be required to make the build and exploit process more user-friendly.


Contents
--------

This repository contains (amongst other things):

- `lockbox.cpp`: The lockbox application itself
- `include`, `arduinoCore`, and `insecureCore`: A subset of the Arduino library
  source code, both in its original form, and with the `printNumber` function
  protected with stack erase.
- `exploit.py`: A simple tool to retrieve the secret from the device.
- `changeSecurity.py`: A script for building either the stack-erase ("Secure")
  version of Lockbox, or the standard ("Insecure") version and flashing it to
  the board.


Running on HiFive1
------------------

To use the demo on a SiFive Hifive1, the following steps are required:

- Connect a 16x2 LCD display to the HiFive1 as in:
  https://www.arduino.cc/en/Tutorial/LiquidCrystalDisplay
- Connect a button to pin 6, such that pin 6 is low when the button is pressed.
- Connect the HiFive1 to a USB port.
- Build the RISC-V Stack Erase toolchain from:
  https://github.com/embecosm/riscv-toolchain/tree/stack-erase
- Install pySerial.
- Run `changeSecurity.py`. Select either the "Secure" or "Insecure" variant.
  This will build and flash the appropriate variant to the board.
- Run `exploit.py` and press the button to lock the device. Enter the command
  `exploit` to have the program extract the secret and unlock the device. This
  should work for the "Insecure" (no stack erase) variant, and fail for the
  "Secure" (stack erase) variant.

