separate (Formateador.Tratar_Argumentos)
procedure Copiar_Teclado_A_String (
      O,                
      D :    out String ) is 

   P_Origen,  
   P_Destino : ppalabra.Tpalabra;  
   C         : Character := ' ';  
   --Creamos dos tablas para ir almacenando los nombres introducidos desde el teclado. La variable caracter se encarga de
   --captar el texto.
   procedure Pasar_String (
         P : in     ppalabra.Tpalabra; 
         S :    out String    ) is 
      --Procedimiento encargado de pasar la informacion de la tabla al string.
   begin
      if not ppalabra.Vacia(P) then
         --Si el usuario ha escrito algo:
         for I in 1..integer(P.Longitud) loop--Cambiamos el tipo para evitar problemas.
            S(I) := P.Letras((ppalabra.Tlongitud(I)));
            --Grabamos toda la palabra (delimitada en la tabla por p.longitud) en el string.
         end loop;
      end if;
   end Pasar_String;

begin

   Put_Line("Introduzca el nombre del fichero de origen y el de destino");
   Put_Line("Seguido de '*'");
   Ppalabra.Get(P_Origen, C);
   Ppalabra.Get(P_Destino, C);
   --Coge los dos nombres.
   if Integer(P_Origen.Longitud) > Max or Integer(P_Destino.Longitud) > Max then
      --Si alguno de los dos nombres es demasiado largo:
      Put_Line("El nombre del archivo es demasiado largo. Como maximo debe tener 30 caracteres de longitud.");
      Skip_Line;
   else
      Pasar_String(P_Origen, O);
      Pasar_String(P_Destino, D);
   end if;
end Copiar_Teclado_A_String;