@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Tue Nov 10 13:44:50 +0100 2020
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 5ad20b16100945a0bc7b78d66c84a9fb --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot arbiter_tb_behav xil_defaultlib.arbiter_tb -log elaborate.log"
call xelab  -wto 5ad20b16100945a0bc7b78d66c84a9fb --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot arbiter_tb_behav xil_defaultlib.arbiter_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
