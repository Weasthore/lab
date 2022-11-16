Compilation order:
1. pc.vhd: Judge whether the pc changes according to the control signal PCWre and whether it is reset according to the reset signal.

2. imem_p1.vhd: Read the instruction corresponding to the address in the instruction register according to the current pc.

3. add.vhd: Add 4 to the address of the PC for the next address selection.

4. cpucontrol.vhd: The control unit outputs ALUOp, ALUSrc and other control signals according to the op.

5. mux5.vhd: 5-bit multiplexer, select the input signal of the register according to the Reg2Loc signal in cpucontrol.

6. registers.vhd: Carry out corresponding read or write operations through the control signal output by the control unit.

7. signextend.vhd: Different signal are extended to 64-bit signals for different types of 32-bit instructions.

8. shiftleft2.vhd: Move the received signal logically to the left.

9. mux64.vhd: 64-bit multiplexer, select the input signal of the ALU according to the ALUSrc signal in cpucontrol.

10. alu.vhd: Arithmetic logic unit, which performs corresponding operation on two input bases ALUcontrol output.

11. alucontrol.vhd: Select the instructions to be executed for outputting ALU according to Opcode and ALUOp signals in cpucontrol.

12. and2.vhd: Execute and operate ALU zero output and branch signal in cpucontrol.

13. or.vhd: Perform or operate on AND gate output and UBranch signal.

14. deme_le.vhd: The data memory reads or writes the data register through the control signal, and here the module additionally incorporates the data selector of the output DB, and this module simultaneously outputs the data DB written back to the register set.

15. singlecyclecpu.vhd: After implementing all other modules, connect all other modules through this module.

16. cpu_tb.vhd: I set the clock cycle to 200ns. The rst signal is 1 for the first 75ns, and 0 for the rest.