## =============================================================================
## Project : FPGA Based Vending Machine
## Board   : Digilent Basys3 (Xilinx Artix-7 XC7A35T-1CPG236C)
## File    : basys3_vending_machine.xdc - pin and clock constraints for top.v
## =============================================================================

## ---------------- 100 MHz system clock ----------------
set_property -dict { PACKAGE_PIN W5  IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ---------------- Slide switches ----------------
## SW14 : btn   -> return to Reset / start new transaction
## SW13 : refnd -> cancel transaction and refund inserted money
set_property -dict { PACKAGE_PIN T1  IOSTANDARD LVCMOS33 } [get_ports btn]
set_property -dict { PACKAGE_PIN U1  IOSTANDARD LVCMOS33 } [get_ports refnd]

## ---------------- PMOD KYPD on header JA ----------------
## Columns (driven by FPGA) : JA1..JA4
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports {col[3]}]
set_property -dict { PACKAGE_PIN L2  IOSTANDARD LVCMOS33 } [get_ports {col[2]}]
set_property -dict { PACKAGE_PIN J2  IOSTANDARD LVCMOS33 } [get_ports {col[1]}]
set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports {col[0]}]
## Rows (read by FPGA) : JA7..JA10
set_property -dict { PACKAGE_PIN H1  IOSTANDARD LVCMOS33 } [get_ports {row[3]}]
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports {row[2]}]
set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports {row[1]}]
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports {row[0]}]

## ---------------- Seven-segment display ----------------
set_property -dict { PACKAGE_PIN W7  IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]
set_property -dict { PACKAGE_PIN W6  IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U5  IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]
set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33 } [get_ports dp]

set_property -dict { PACKAGE_PIN U2  IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4  IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4  IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4  IOSTANDARD LVCMOS33 } [get_ports {an[3]}]

## ---------------- Status LEDs ----------------
## LD0-LD2  : present FSM state (ps)
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {ps[0]}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {ps[1]}]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {ps[2]}]
## LD4-LD7  : money inserted (binary)
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {money[0]}]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {money[1]}]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {money[2]}]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {money[3]}]
## LD8-LD11 : remaining stock of product E
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports {E_quantity[0]}]
set_property -dict { PACKAGE_PIN V3  IOSTANDARD LVCMOS33 } [get_ports {E_quantity[1]}]
set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports {E_quantity[2]}]
set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports {E_quantity[3]}]
## LD13, LD14 : machine ready / heartbeat
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports led_reset]
set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports led_check]
## LD15 : product dispensed
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports dispense]

## ---------------- Configuration ----------------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
