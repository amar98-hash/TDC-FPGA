----------------------------------------------------------------------------------
-- Project Name : RedPitaya-TDC
-- File Name    : delay_chain.vhd
-- Module Name  : delay_chain
--
-- Author       : Amar Dadel
----------------------------------------------------------------------------------
-- Description:
--   Parameterizable FPGA carry-chain delay module intended for use in a
--   high-resolution Time-to-Digital Converter (TDC) architecture.
--
-- Revision History:
--   -------------------------------------------------------------------
--   Version    Date          Description
--   -------------------------------------------------------------------
--   0.1        14-Jun-2026   Initial implementation of a parameterized
--                             carry-chain delay module.
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity delay_chain is
    generic (
        N_CARRY4 : INTEGER := 2
    );
    port (
        TRIGGER_I       : in  STD_LOGIC;
        PHOTON_I        : in  STD_LOGIC;
        PERIOD_REG_O    : out STD_LOGIC_VECTOR(4*N_CARRY4-1 downto 0);
        PHASE_REG_O     : out STD_LOGIC_VECTOR(4*N_CARRY4-1 downto 0)
    );
end entity delay_chain;

architecture rtl of delay_chain is

    signal hit_buf  : std_logic;
    signal carry_co : std_logic_vector(4*N_CARRY4-1 downto 0);
    signal carry_ci : std_logic_vector(N_CARRY4 downto 0);
    signal phase_reg : std_logic_vector(4*N_CARRY4-1 downto 0);

    --------------------------------------------------------------------
    SIGNAL TRIGGER_BUF : std_logic;
    SIGNAL PHOTON_BUF  : std_logic;




begin

    --------------------------------------------------------------------
    -- Input buffer --infers input buffer for trigger signal
    --------------------------------------------------------------------
    IBUF_trig : IBUF
        port map (
            I => TRIGGER_I,
            O => TRIGGER_BUF
        );

    IBUF_photon : IBUF
        port map (
            I => PHOTON_I,
            O => PHOTON_BUF
        );

    --------------------------------------------------------------------
    -- Carry-chain input
    --------------------------------------------------------------------
    carry_ci(0) <= TRIGGER_BUF;

    --------------------------------------------------------------------
    -- Carry-chain delay units
    -- Each CARRY4 gives 4 carry taps.
    --------------------------------------------------------------------
    gen_carry : for i in 0 to N_CARRY4-1 generate

        CARRY4_inst : CARRY4
            port map (
                CI     => carry_ci(i),
                CYINIT => '0',
                DI     => "0000",
                S      => "1111",
                CO     => carry_co(4*i+3 downto 4*i),
                O      => open
            );

        carry_ci(i+1) <= carry_co(4*i+3);

    end generate;


    --------------------------------------------------------------------
    -- Continuous period/tap output
    --------------------------------------------------------------------
    PERIOD_REG_O <= carry_co;

    --------------------------------------------------------------------
    -- Capture phase only when photon signal arrives
    --------------------------------------------------------------------
    process(PHOTON_BUF)
    begin
        if rising_edge(PHOTON_BUF) then
            phase_reg <= carry_co;
        end if;
    end process;

    PHASE_REG_O <= phase_reg;

end architecture rtl;