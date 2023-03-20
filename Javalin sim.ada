WITH Text_Io; USE Text_Io;
WITH Calendar; USE Calendar;
WITH Ada.Float_Text_IO; USE Ada.Float_Text_IO;
PROCEDURE Javelin2 IS
G : CONSTANT := 9.81; -- Acceleration due to gravity
Stop,
Start : Time;
Taken : Duration;
Char : Character;
Velocity, Distance, FlightTime : Float;
Runup : String(1..20);
length : integer;
BEGIN
Put_Line("hit any key to start, then any key 20 times, then Enter, to
time your runup");
Get_Immediate(Char); -- gets one character immediately it is struck
Start := Clock;
get_line(runup, length);
Stop := Clock;
Taken := Stop - Start;
New_Line;
IF (Taken > 10.0) THEN
Put_Line("This is not a valid throw - too slow");
ELSIF (length < 20) THEN
Put_Line("This is not a valid throw - short run-up");
ELSE
BEGIN
Put("You took ");
Put(Float(Taken), Fore => 1, Aft => 2, Exp => 0);
Put_Line(" seconds for your runup");
Put("You threw the javelin at ");
Velocity := (10.0 - Float(Taken)) * 2.0;
Put(Velocity, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" meters per second");
Distance := (Velocity ** 2) / G;
FlightTime := 2.0*Velocity*0.7071/G;
Put("You threw it ");
Put(Distance, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" meters.");
Put("It flew for ");
Put(FlightTime, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" seconds.");
END;
END IF;
END;
