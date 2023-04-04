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
-- Module Name: lpsc_sync - arch
-- Target Device: digilentinc.com:nexys_video:part0:1.1 xc7a200tsbg484-1
-- Tool version: 2021.2
-- Description: lpsc_sync
--
-- Last update: 2022-04-05
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity lpsc_sync is

    port (
        ClkAxCI : in std_ulogic;
        SigAxSI : in std_ulogic;
        ClkBxCI : in std_ulogic;
        SigBxSI : in std_ulogic);

end lpsc_sync;

architecture arch of lpsc_sync is

    -- Attributes declarations
    -- tig="true"         - Specifies a timing ignore for the asynchronous input.
    attribute tig           : string;
    -- iob="false"        - Specifies to not place the register into the IOB allowing
    --                      both synchronization registers to exist in the same slice
    --                      allowing for the shortest propagation time between them.
    attribute iob           : string;
    -- async_reg="true"   - Specifies registers will be receiving asynchronous
    --                      data input to allow for better timing simulation
    --                      characteristics.
    attribute async_reg     : string;
    -- shift_extract="no" - Specifies to the synthesis tool to not infer an SRL.
    attribute shift_extract : string;
    -- hblknm="sync_reg"  - Specifies to pack both registers into the same slice,
    --                      called sync_reg.
    -- attribute hblknm                      : string;

    -- Signals declarations
    signal SigAIntxS : std_ulogic := '0';
    signal SigInt0xS : std_ulogic := '0';
    signal SigInt1xS : std_ulogic := '0';
    signal SigBIntxS : std_ulogic := '0';

    -- Attributes specifications
    attribute async_reg of SigAIntxS     : signal is "false";
    attribute shift_extract of SigAIntxS : signal is "false";
    attribute async_reg of SigInt0xS     : signal is "true";
    attribute shift_extract of SigInt0xS : signal is "false";
    attribute async_reg of SigInt1xS     : signal is "false";
    attribute shift_extract of SigInt0xS : signal is "false";
    attribute async_reg of SigBIntxS     : signal is "false";
    attribute shift_extract of SigBIntxS : signal is "false";

begin

    IOxB : block is
    begin  -- block IOxB

        SigAxAS : SigAIntxS <= SigAxSI;
        SigBxAS : SigBxSI   <= SigBIntxS;

    end block IOxB;

    CDAxP : process (ClkAxCI) is
    begin  -- process CDAxP
        if rising_edge(ClkAxCI) then
            SigInt0xS <= SigAIntxS;
        end if;
    end process CDAxP;

    CDBxP : process (ClkBxCI) is
    begin  -- process CDBxP
        if rising_edge(ClkBxCI) then
            SigInt1xS <= SigInt0xS;
            SigBIntxS <= SigInt1xS;
        end if;
    end process CDBxP;

end arch;
