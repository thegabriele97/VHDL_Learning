@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Sun Oct 04 13:36:27 +0200 2020
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 99c838b24a4e4262b24e9ae9b56210f5 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot adder8x8_behav xil_defaultlib.adder8x8 -log elaborate.log"
call xelab  -wto 99c838b24a4e4262b24e9ae9b56210f5 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot adder8x8_behav xil_defaultlib.adder8x8 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
