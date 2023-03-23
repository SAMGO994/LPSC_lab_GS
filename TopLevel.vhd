----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 16:54:56
-- Design Name: 
-- Module Name: TopLevel - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevel is
    Port ( clk_i    : in STD_LOGIC;
           rst_i    : in STD_LOGIC;
           c_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           c_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_new_o: out std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_new_o: out std_logic_vector(17 downto 0)
           );
end TopLevel;

architecture Behavioral of TopLevel is

component mandelbrot_calc
    Port ( clk_i    : in STD_LOGIC;
           rst_i    : in STD_LOGIC;
           c_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           c_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_i   : in std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_re_new_o: out std_logic_vector(17 downto 0);  --6bit signed integer, 12bit fractional
           z_im_new_o: out std_logic_vector(17 downto 0)  --6bit signed integer, 12bit fractional
           );
end component;

begin

    calc : mandelbrot_calc
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        c_re_i=>c_re_i,
        c_im_i=>c_im_i,
        z_re_i=>z_re_i,
        z_im_i=>z_im_i,
        z_re_new_o=>z_re_new_o,
        z_im_new_o=>z_im_new_o);

end Behavioral;
