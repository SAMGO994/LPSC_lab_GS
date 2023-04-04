----------------------------------------------------------------------------------
--                                 _             _
--                                | |_  ___ _ __(_)__ _
--                                | ' \/ -_) '_ \ / _` |
--                                |_||_\___| .__/_\__,_|
--                                         |_|
--
----------------------------------------------------------------------------------
--
-- Company: hepia
-- Author: Joachim Schmidt <joachim.schmidt@hesge.ch
--
-- Module Name: lpsc_edge_detector - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: lpsc_edge_detector
--
-- Last update: 2022-03-07
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity lpsc_edge_detector is

    port (
        ClkxCI   : in  std_ulogic;
        RstxRI   : in  std_ulogic;
        ProbexSI : in  std_ulogic;
        PulsexSO : out std_ulogic);

end lpsc_edge_detector;

architecture arch of lpsc_edge_detector is

    signal SInt0xS : std_ulogic := '0';
    signal SInt1xS : std_ulogic := '0';

begin

    EdgeDetectorxB : block is
    begin  -- block EdgeDetectorxB

        Fdre1xI : FDRE
            generic map (
                INIT => '0')
            port map (
                Q  => SInt0xS,
                C  => ClkxCI,
                CE => '1',
                R  => RstxRI,
                D  => ProbexSI);

        Fdre2xI : FDRE
            generic map (
                INIT => '0')
            port map (
                Q  => SInt1xS,
                C  => ClkxCI,
                CE => '1',
                R  => RstxRI,
                D  => SInt0xS);

        PulsexAS : PulsexSO <= SInt0xS and not SInt1xS;

    end block EdgeDetectorxB;

end arch;
