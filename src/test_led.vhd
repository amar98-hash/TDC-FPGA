library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_blinker is
    port (
        clk_i    : in  std_logic;
        rst_i    : in  std_logic;

        reg_i    : in  std_logic_vector(31 downto 0);

        led_o    : out std_logic
    );
end entity led_blinker;

architecture rtl of led_blinker is

    signal counter      : natural  := 0;

    -- Signal to indicate when the register has changed
    signal reg_prev     : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_changed  : std_logic := '0';

    signal period       : unsigned(15 downto 0) := (others => '1'); -- Default to maximum period (65535 cycles)
    signal pulse_width  : unsigned(15 downto 0)  := (others => '1'); -- Default to maximum pulse width (65535 cycles)

begin

    pRegRead: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '0' then
                reg_prev    <= (others => '0');
                reg_changed <= '0';
            else
                if reg_i /= reg_prev then
                    reg_changed <= '1';  -- pulse for one clock cycle
                else
                    reg_changed <= '0';
                end if;

                reg_prev <= reg_i;
            end if;
        end if;
    end process;



    pBlinker: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '0' then
                counter <= 0;
                led_o   <= '0';
            else
                
                -- the register has changed, update the period and pulse width.
                if(reg_changed = '1') then
                    -- Update period and pulse width from register
                    period      <= unsigned(reg_i(31 downto 16));
                    pulse_width <= unsigned(reg_i(15 downto 0));
                end if;


                -- Counter rollover
                if counter = to_integer(period) - 1 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;

                -- LED pulse-width control
                if counter < to_integer(pulse_width) then
                    led_o <= '1';
                else
                    led_o <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture rtl;