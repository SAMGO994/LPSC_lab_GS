----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 16:54:56
-- Design Name: 
-- Module Name: Mandelbrot_calc - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--use work.fixed_generic_pkg_mod.all;

--library ieee;
--use ieee.fixed_pkg.all; --signed fixed precision numbers

Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;


entity Mandelbrot_calc is
    Port ( clk_i    : in STD_LOGIC;
           rst_i    : in STD_LOGIC;
           c_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           c_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_new_o: out std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_new_o: out std_logic_vector(17 downto 0)  --6bit signed integer, 12bit fractional
           );
end Mandelbrot_calc;

architecture Behavioral of Mandelbrot_calc is

signal int_02_s, int_23_S, int_12_s, int_56_s, int_45_s   : std_logic_vector(17 downto 0);
signal ce_s                             : std_logic;
signal dsp0_rslt_s,dsp1_rslt_s,dsp4_rslt_s,dsp5_rslt_s : std_logic_vector(35 downto 0);


begin

   DSP0 : MULT_MACRO
   generic map (
      DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,           -- Desired clock cycle latency, 0-4
      WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
      WIDTH_B => 18          -- Multiplier B-input bus width, 1-18
      )
   port map (
      P => dsp0_rslt_s,  -- Multiplier ouput bus, width determined by WIDTH_P generic 
      A => z_re_i,  -- Multiplier input A bus, width determined by WIDTH_A generic 
      B => z_re_i,  -- Multiplier input B bus, width determined by WIDTH_B generic 
      CE => ce_s,   -- 1-bit active high input clock enable
      CLK => clk_i, -- 1-bit positive edge clock input
      RST => rst_i  -- 1-bit input active high reset
   );
   
   int_02_s <= dsp0_rslt_s(29 downto 12);
   
   DSP1 : MULT_MACRO
   generic map (
      DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,           -- Desired clock cycle latency, 0-4
      WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
      WIDTH_B => 18          -- Multiplier B-input bus width, 1-18
      )
   port map (
      P => dsp1_rslt_s,  -- Multiplier ouput bus, width determined by WIDTH_P generic 
      A => z_im_i,  -- Multiplier input A bus, width determined by WIDTH_A generic 
      B => z_im_i,  -- Multiplier input B bus, width determined by WIDTH_B generic 
      CE => ce_s,   -- 1-bit active high input clock enable
      CLK => clk_i, -- 1-bit positive edge clock input
      RST => rst_i  -- 1-bit input active high reset
   );
   
   int_12_s <= dsp1_rslt_s(29 downto 12);
   
   DSP4 : MULT_MACRO
   generic map (
      DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,           -- Desired clock cycle latency, 0-4
      WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
      WIDTH_B => 18          -- Multiplier B-input bus width, 1-18
      )
   port map (
      P =>  dsp4_rslt_s,  -- Multiplier ouput bus, width determined by WIDTH_P generic 
      A => z_re_i,  -- Multiplier input A bus, width determined by WIDTH_A generic 
      B => std_logic_vector(to_unsigned(2,18)),  -- Multiplier input B bus = 2 constant
      CE => ce_s,   -- 1-bit active high input clock enable
      CLK => clk_i, -- 1-bit positive edge clock input
      RST => rst_i  -- 1-bit input active high reset
   );
   
   int_45_s <= dsp4_rslt_s(29 downto 12);
   
   DSP5 : MULT_MACRO
   generic map (
      DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,           -- Desired clock cycle latency, 0-4
      WIDTH_A => 18,          -- Multiplier A-input bus width, 1-25 
      WIDTH_B => 18          -- Multiplier B-input bus width, 1-18
      )
   port map (
      P => dsp4_rslt_s,  -- Multiplier ouput bus, width determined by WIDTH_P generic 
      A => z_im_i,  -- Multiplier input A bus, width determined by WIDTH_A generic 
      B => int_45_s,  -- Multiplier input B bus = 2 constant
      CE => ce_s,   -- 1-bit active high input clock enable
      CLK => clk_i, -- 1-bit positive edge clock input
      RST => rst_i  -- 1-bit input active high reset
   );

   int_45_s <= dsp4_rslt_s(29 downto 12);
   
   
   DSP2 : ADDSUB_MACRO
   generic map (
      DEVICE => "7SERIES",  -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,         -- Desired clock cycle latency, 0-2
      WIDTH => 18)          -- Input / Output bus width, 1-48
   port map (
      CARRYOUT => open,     -- 1-bit carry-out output signal
      RESULT => int_23_s,     -- Add/sub result output, width defined by WIDTH generic
      A => int_02_s,          -- Input A bus, width defined by WIDTH generic
      ADD_SUB => '0',       -- 1-bit add/sub input, high selects add, low selects subtract
      B => int_12_s,          -- Input B bus, width defined by WIDTH generic
      CARRYIN => '0',       -- 1-bit carry-in input
      CE =>  ce_s,          -- 1-bit clock enable input
      CLK => clk_i,         -- 1-bit clock input
      RST => rst_i          -- 1-bit active high synchronous reset
   );

   DSP3 : ADDSUB_MACRO
   generic map (
      DEVICE => "7SERIES",  -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,         -- Desired clock cycle latency, 0-2
      WIDTH => 18)          -- Input / Output bus width, 1-48
   port map (
      CARRYOUT => open,     -- 1-bit carry-out output signal
      RESULT => z_re_new_o, -- Add/sub result output, width defined by WIDTH generic
      A => int_02_s,          -- Input A bus, width defined by WIDTH generic
      ADD_SUB => '1',       -- 1-bit add/sub input, high selects add, low selects subtract
      B => int_12_s,          -- Input B bus, width defined by WIDTH generic
      CARRYIN => '0',       -- 1-bit carry-in input
      CE =>  ce_s,          -- 1-bit clock enable input
      CLK => clk_i,         -- 1-bit clock input
      RST => rst_i          -- 1-bit active high synchronous reset
   );

DSP6 : ADDSUB_MACRO
   generic map (
      DEVICE => "7SERIES",  -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 0,         -- Desired clock cycle latency, 0-2
      WIDTH => 18)          -- Input / Output bus width, 1-48
   port map (
      CARRYOUT => open,     -- 1-bit carry-out output signal
      RESULT => z_im_new_o, -- Add/sub result output, width defined by WIDTH generic
      A => int_56_s,          -- Input A bus, width defined by WIDTH generic
      ADD_SUB => '1',       -- 1-bit add/sub input, high selects add, low selects subtract
      B => c_im_i,          -- Input B bus, width defined by WIDTH generic
      CARRYIN => '0',       -- 1-bit carry-in input
      CE =>  ce_s,          -- 1-bit clock enable input
      CLK => clk_i,         -- 1-bit clock input
      RST => rst_i          -- 1-bit active high synchronous reset
   );

end Behavioral;
