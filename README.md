# Basys-3 FPGA Segment Display Counter Using Clash

Inspired by [this tutorial](https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html),
a simple second counter using the 7-segment display of the Basys-3 FPGA.

The source is written in [Clash](https://clash-lang.org/), an HDL based on
Haskell.

Source code is in `src/TopModule.hs`.

Vivado batch mode scripts adapted from [`usman1515/vivado_project_template`](https://github.com/usman1515/vivado_project_template).

## Compile and Program Device

Requirements:
  * [`stack`](https://docs.haskellstack.org/en/stable/)
  * Vivado
  * Basys-3 FPGA (plugged in via USB)

You can then program the device simply by running `make`:
```
$ make
```

This runs through a number of steps, including (1) using the Clash compiler
to generate `verilog/TopModule.topEntity/main.v`, (2) running the result through
Vivado to generate a bitstream `bitstream_run1.bit`, and finally (3) programming
the device.

Synthesis is slow. The whole process takes a minute or two.

After the device has been programmed, you can use switch 0 (`SW0`) to enable
the counter, which should count the number of seconds elapsed. You can reset
the counter with the center button (`BTNC`).

![IMG_0712](https://github.com/user-attachments/assets/31655b3e-750b-40cb-9c05-50b98c4d1e3b)

