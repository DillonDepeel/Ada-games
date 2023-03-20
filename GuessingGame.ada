begin
   reset(gen);
   num := random(gen);
   while incorrect loop
       Put_Line ("Guess a number between 1 and 100");
       declare
          guess_str : String := Get_Line (Current_Input);
       begin
          guess := randRange'Value (guess_str);
       end;
       if guess < num then
           Put_line("Too low");
       elsif guess > num then
           Put_line("Too high");
       else
           incorrect := False;
       end if;
   end loop;
   Put_line("That's right");
end Game;
