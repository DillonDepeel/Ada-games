with Ada.Text_Io;
use Ada.Text_Io;
with Ada.Command_Line;
use Ada.Command_Line;


procedure Bf is

   -- Data structures for memory
   Bottom   : constant Integer := - 1;
   subtype T_Data is Integer range Bottom..Integer'Last;        -- value range
   Mem_Last : constant Integer := 30000;                        -- memory size
   M        : array (0 .. Mem_Last) of T_Data := (others => 0); -- memory cells
   Mp       : Integer;                                          -- memory pointer

   -- Data structures for program text
   Prog_Name   : String := Argument (1);               -- program file name
   Prog_Suffix : constant String := ".bf";             -- standard program filename extension
   Program     : File_Type;                            -- program file
   Prog_Last   : constant Integer := 30000;            -- program storage size
   P           : array (0 .. Prog_Last) of Character;  -- program
   Pp          : Integer;                              -- program pointer
   Prog_Len    : Integer;                              -- program length

   -- Data structures for program execution control
   Level      : Integer;          -- nested loops level
   Data       : Character;        -- input datum
   Ok         : Boolean;          -- program execution switch
   End_Input  : Boolean := False; -- input EOF condition
   End_Output : Boolean := False; -- output EOF condition

   -- Compose and print an error message
   procedure Msgerr (
         Msg : in     String ) is
   begin
      New_Line;
      Put_Line( Standard_Error, "** error: " & Msg );
      Ok := False;
   end;

begin

   --get and open the program file
   declare
   begin
      Open( Program, In_File, Prog_Name);
   exception
      when others =>
         Open( Program, In_File, Prog_Name & Prog_Suffix);
   end;

   -- first, read the whole program file
   Prog_Len := 0;
   while not End_Of_File( Program ) loop
      Get_Immediate(Program, P(Prog_Len));
      Prog_Len := Prog_Len+1;
   end loop;
   Close( Program );

   -- then, interpret the program
   Pp := 0;
   Mp := 0;
   Ok := True;
   End_Input := False;
   End_Output := False;
   while Ok and (Pp < Prog_Len) loop -- while interpreting
      case P(Pp) is
         when '+' =>               -- (+) increment memory location
            M(Mp) := M(Mp)+1;

         when '-' =>               -- (-) decrement memory location
            if M(Mp) <= Bottom then
               Msgerr( "arithmetic underflow" );
            else
               M(Mp) := M(Mp)-1;
            end if;

         when '.' =>               -- (.) output data (print char)
            if End_Output then
               Msgerr("attempt to write past EOF");
            elsif M(Mp) < 0 then
               End_Output := True;
            else
               Put( Character'Val(M(Mp)) );
            end if;

         when ',' =>               -- (,) input data (read char)
            if End_Input then
               Msgerr("attempt to read past EOF");
            else
               loop
                  if End_Of_File(Standard_Input) then
                     M(Mp) := Bottom;
                     End_Input := True;
                     exit;
                  else
                     Get( Data );
                     M(Mp) := Character'Pos(Data);
                     -- ignore control chars
                     exit when Data >= ' ';
                  end if;
               end loop;
            end if;

         when '>' =>               -- (>) increment memory pointer (use next cell)
            Mp := Mp+1;
            if Mp >= Mem_Last then
               Msgerr("memory pointer overflow");
            end if;

         when '<' =>               -- (<) decrement memory pointer (use previous cell)
            Mp := Mp - 1;
            if Mp < 0 then
               Msgerr("memory pointer underflow");
            end if;

         when '[' =>               -- ([) begin of loop structure
            if M(Mp) = 0 then
               -- terminate loop, goto matching ']'
               Pp := Pp+1;
               Level := 0;
               while Pp < Prog_Len and then (Level > 0 or else P(Pp) /= ']') loop
                  if P(Pp) = '[' then
                     Level := Level+1;
                  end if;
                  if P(Pp) = ']' then
                     Level := Level-1;
                  end if;
                  Pp := Pp+1;
               end loop;
               if Pp >= Prog_Len then
                  Msgerr("no matching ']'");
               end if;
            end if;

         when ']' =>               -- (]) end of loop structure
            if M(Mp) /= 0 then
               -- repeat loop, goto matching '['
               Pp := Pp-1;
               Level := 0;
               while Pp >= 0 and then (Level > 0 or else P(Pp) /= '[') loop
                  if P(Pp) = ']' then
                     Level := Level+1;
                  end if;
                  if P(Pp) = '[' then
                     Level := Level-1;
                  end if;
                  Pp := Pp-1;
               end loop;
               if Pp < 0 then
                  Msgerr("no matching '['");
               end if;
            end if;

         when others =>
            null;                  -- (?) ignore unrecognized command
      end case;
      Pp := Pp+1;
   end loop; -- while interpreting
   New_Line;

end Bf;
