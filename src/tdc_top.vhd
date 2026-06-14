----------------------------------------------------------------------------------
-- Project Name : RedPitaya-TDC
-- File Name    : top.vhd
-- Module Name  : top
--
-- Author       : Amar Dadel
----------------------------------------------------------------------------------
-- Description:
--   Top-level module for the RedPitaya-TDC project.
--
--   This initial implementation instantiates a parameterizable
--   carry-chain delay line. The trigger signal launches a transition
--   into the delay chain, while the photon signal asynchronously
--   captures the instantaneous phase state of the delay taps.
--
-- Revision History:
--   -------------------------------------------------------------------
--   Version    Date          Description
--   -------------------------------------------------------------------
--   0.1        14-Jun-2026   Initial top-level implementation.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity top is
    generic (
        N_CARRY4 : integer := 2
    );
    port (
        ----------------------------------------------------------------
        -- Inputs
        ----------------------------------------------------------------
        TRIGGER_I : in  std_logic;
        PHOTON_I  : in  std_logic;

        ----------------------------------------------------------------
        -- Outputs
        ----------------------------------------------------------------
        PERIOD_O  : out std_logic_vector(4*N_CARRY4-1 downto 0);
        PHASE_O   : out std_logic_vector(4*N_CARRY4-1 downto 0)
    );
end entity top;

architecture rtl of top is

begin

    --------------------------------------------------------------------
    -- Delay Chain
    --------------------------------------------------------------------
    U_DELAY_CHAIN : entity work.delay_chain
        generic map (
            N_CARRY4 => N_CARRY4
        )
        port map (
            TRIGGER_I    => TRIGGER_I,
            PHOTON_I     => PHOTON_I,
            PERIOD_REG_O => PERIOD_O,
            PHASE_REG_O  => PHASE_O
        );

end architecture rtl;