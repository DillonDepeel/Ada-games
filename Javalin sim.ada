WITH Text_Io; USE Text_Io;
WITH Calendar; USE Calendar;
WITH Ada.Float_Text_IO; USE Ada.Float_Text_IO;
PROCEDURE Javelin IS
G : CONSTANT := 9.81; -- Acceleration due to gravity
Stop, Start : Time;
Taken : Duration;
Char : Character;
Length : Integer;
Runup : String (1 .. 20);
Velocity, Distance, FlightTime, TimeStep, ThisStep : Float;
BEGIN
Put_Line("hit any key 20 times to time your runup");
Get_Immediate(Char); -- gets one character immediately it is
struck
Start := Clock;
Get_Line(Runup, Length);
Stop := Clock;
Taken := Stop - Start; -- runup time
New_Line;
IF (Taken > 10.0) THEN
Put_Line("This is not a valid throw - too slow");
ELSIF (Length < 20) THEN
Put_Line("This is not a valid throw - short runup");
ELSE
Put("You took ");
Put(Float(Taken), Fore => 1, Aft => 2, Exp => 0);
Put_Line(" seconds for your runup");
Put("You threw the javelin at ");
Velocity := (10.0 - Float(Taken)) * 2.0; -- set throw velocity
-- using any formula you like based on runup time
Put(Velocity, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" meters per second");
Distance := (Velocity ** 2) / G; -- from physics, based on
FlightTime := 2.0*Velocity*0.7071/G; -- throw at 45 degrees
Put_Line("You threw it ");
Put(Distance, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" meters.");
Put_Line("It flew for ");
Put(FlightTime, Fore => 1, Aft => 2, Exp => 0);
Put_Line(" seconds.");
-- now draw the curve for the throw
Put_Line("Its flight (plotted vertically) is:");
Put_Line("x");
TimeStep := FlightTime / Distance;
FOR I IN 1..Integer(Distance) LOOP
ThisStep := TimeStep * Float(I);
FOR J IN 1..Integer(5.0*(Velocity*ThisStep*0.7071-
(ThisStep**2)*G/2.0)) LOOP
Put(" "); -- 5.0 above sets vertical scale
END LOOP;
Put_Line("x"); -- marks position of javelin
END LOOP;
END IF;
END;
