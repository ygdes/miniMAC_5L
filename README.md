![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout : the miniMAC unit

- [Read the documentation for project](docs/info.md)

- [Read about its design on Hackaday](https://hackaday.io/project/198914)

## What is this miniMAC

This unit works on 16-bit data, which are scrambled with a 17th bit for data/control framing (C/D). The result is suitable for sending to a PHY for serialisation and line coding.

This unit combines two sophisticated systems:
- the gPEAC18 unit is an additive-based scrambler that combines the 17 bits and creates an extra check bit.
- the Hammer18 unit is a non-linear XOR-based scrambler that boosts the Hamming distance on the 18 bits.

This provides a very strong and early error detection, tailored for early retransmition.

And it should fit is less than a tile.

## What next?

This is a VHDL to Verilog port, let's hope it works.
