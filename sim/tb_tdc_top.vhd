----------------------------------------------------------------------------------
-- Project Name : RedPitaya-TDC
-- File Name    : tb_top.vhd
-- Module Name  : tb_top
--
-- Author       : Amar Dadel
----------------------------------------------------------------------------------
-- Description:
--   Simple asynchronous testbench for the top-level RedPitaya-TDC module.
--   TRIGGER_I launches/changes the delay-chain state.
--   PHOTON_I captures the current phase state asynchronously.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end entity tb_top;

architecture sim of tb_top is

    constant N_CARRY4_C : integer := 2;
    constant N_TAPS_C   : integer := 4 * N_CARRY4_C;

    signal TRIGGER_I : std_logic := '0';
    signal PHOTON_I  : std_logic := '0';

    signal PERIOD_O  : std_logic_vector(N_TAPS_C-1 downto 0);
    signal PHASE_O   : std_logic_vector(N_TAPS_C-1 downto 0);

    signal expected_phase : std_logic_vector(N_TAPS_C-1 downto 0);

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : entity work.top
        generic map (
            N_CARRY4 => N_CARRY4_C
        )
        port map (
            TRIGGER_I => TRIGGER_I,
            PHOTON_I  => PHOTON_I,
            PERIOD_O  => PERIOD_O,
            PHASE_O   => PHASE_O
        );

    --------------------------------------------------------------------
    -- Asynchronous trigger stimulus
    --------------------------------------------------------------------
    trigger_proc : process
    begin
        wait for 7 ns;
        TRIGGER_I <= '1';

        wait for 13 ns;
        TRIGGER_I <= '0';

        wait for 11 ns;
        TRIGGER_I <= '1';

        wait for 17 ns;
        TRIGGER_I <= '0';

        wait for 19 ns;
        TRIGGER_I <= '1';

        wait for 23 ns;
        TRIGGER_I <= '0';

        wait;
    end process;

    --------------------------------------------------------------------
    -- Asynchronous photon capture stimulus
    --------------------------------------------------------------------
    photon_proc : process
    begin
        wait for 10 ns;
        expected_phase <= PERIOD_O;
        PHOTON_I <= '1';
        wait for 2 ns;
        PHOTON_I <= '0';

        wait for 15 ns;
        expected_phase <= PERIOD_O;
        PHOTON_I <= '1';
        wait for 2 ns;
        PHOTON_I <= '0';

        wait for 21 ns;
        expected_phase <= PERIOD_O;
        PHOTON_I <= '1';
        wait for 2 ns;
        PHOTON_I <= '0';

        wait for 29 ns;
        expected_phase <= PERIOD_O;
        PHOTON_I <= '1';
        wait for 2 ns;
        PHOTON_I <= '0';

        wait for 20 ns;

        assert false
            report "Simulation finished."
            severity failure;
    end process;

    --------------------------------------------------------------------
    -- Capture checker
    --------------------------------------------------------------------
    checker_proc : process
    begin
        wait until rising_edge(PHOTON_I);

        wait for 1 ns;

        assert PHASE_O = expected_phase
            report "ERROR: PHASE_O did not capture PERIOD_O correctly."
            severity error;

        report "Capture OK. PERIOD_O = "
            & integer'image(to_integer(unsigned(PERIOD_O)))
            & ", PHASE_O = "
            & integer'image(to_integer(unsigned(PHASE_O)));
    end process;

end architecture sim;