separate (Formateador.Tratar_Argumentos)
procedure Copiar_Argumentos_A_String (
      O,                
      D :    out String ) is 


   procedure Copiar_Argumento (
         S   :    out String; 
         Arg : in     String  ) is 
      --Este programa copia el argumento a un string. Tiene dos argumentos, uno de entrada, que será el argumento
      --introducido al ejecutar el programa. El segundo es de salida, el cual será más tarde analizado.
   begin
      if Arg'Last < Max then
         --Si el argumento cabe en el string:
         for I in 1..Arg'Last loop
            S(I) := Arg(I);
         end loop;
         --Graba el contenido del argumento en el string.
      else
         Put_Line("El nombre del archivo '"&Arg&"'  es demasiado largo. Como maximo debe tener 30 caracteres de longitud.");
         --Si la longitud del string captado de la línea de comandos supera el máximo determinado por la constante Max
         --entonces no se procede a su copia, y se imprime un mensaje para el usuario.
      end if;
   end Copiar_Argumento;

begin
   if Argument_Count < 2 then
      --si no hay argumentos o son insuficientes:
      Put_Line("No ha introducido los argumentos necesarios.");
   else
      --si hay 2 o más argumentos:
      Copiar_Argumento(O,Argument(1));
      Copiar_Argumento(D, Argument(2));
      --copia los argumentos a strings para ser analizados.
   end if;
end Copiar_Argumentos_A_String;