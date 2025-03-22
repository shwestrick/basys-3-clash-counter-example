# Basys-3 FPGA Segment Display Counter Using Clash

Inspired by [this tutorial](https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html),
a simple second counter using the 7-segment display of the Basys-3 FPGA.

The source is written in [Clash](https://clash-lang.org/), an HDL based on
Haskell.

Clash source code is in `src/TopModule.hs`. Input and output ports are mapped
to physical pins by `constraints/basys-3.xdc`; note that the names used
here need to match those specified in the [`Synthesize` annotation](https://github.com/shwestrick/basys-3-clash-counter-example/blob/9c7633f9601362a7a3daba5c6bf01a70f721914c/src/TopModule.hs#L87-L98)
in the Clash source.

This repo uses Vivado batch mode scripts adapted from [`usman1515/vivado_project_template`](https://github.com/usman1515/vivado_project_template).

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

![IMG_0712](https://github.com/user-attachments/assets/8e540cbf-4ccb-4524-9a89-632e6c50bd22)
