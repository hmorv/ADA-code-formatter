with Ada.Text_Io;
use Ada.Text_Io;
package body Ppalabra is
   Fin_Texto : constant Character := '*';  
   Espacio   : constant Character := ' ';  
   procedure Saltar_Espacios (
         C : in out Character ) is 
   begin
      while C=Espacio loop
         Get(C);
      end loop;
   end Saltar_Espacios;

   procedure Get (
         P :    out Tpalabra; 
         C : in out Character ) is 
      I : Tlongitud := Tlongitud'First;  
   begin
      Saltar_Espacios(C);
      while C/=Fin_Texto and C/=Espacio and I<Tlongitud'Last loop
         I:=I+1;
         P.Letras(I):=C;
         Get(C);
      end loop;
      P.Longitud:=I;
   end Get;

   function Longitud (
         A : in     Tpalabra ) 
     return Tlongitud is 
   begin
      return A.Longitud;
   end Longitud;


   procedure Put (
         P : in     Tpalabra ) is 
      I : Tlongitud := Rangoletras'First;  
   begin
      while I<= P.Longitud loop
         Put(P.Letras(I));
         I:=I+1;
      end loop;
   end Put;

   function "=" (
         A,                  
         B : in     Tpalabra ) 
     return Boolean is 
      I         : Tlongitud;  
      Resultado : Boolean;  
   begin
      if A.Longitud/=B.Longitud then
         Resultado:=False;
      else
         I:=Rangoletras'First;
         while I<A.Longitud and A.Letras(I)=B.Letras(I) loop
            I:=I+1;
         end loop;
         Resultado:= A.Letras(I)=B.Letras(I);
      end if;
      return Resultado;
   end "=";

   function Vacia (
         P : in     Tpalabra ) 
     return Boolean is 
   begin
      return P.Longitud = 0;
   end Vacia;


end Ppalabra;