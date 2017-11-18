package Ppalabra is
   Max : constant := 30;  
   type Tlongitud is new Integer range 0 .. Max; 
   subtype Rangoletras is Tlongitud range 1..Tlongitud'Last;
   type Tablaletras is array (Rangoletras) of Character; 
   type Tpalabra is 
      record 
         Letras   : Tablaletras;  
         Longitud : Tlongitud;  
      end record; 
   procedure Get (
         P :    out Tpalabra; 
         C : in out Character ); 
   procedure Put (
         P : in     Tpalabra ); 
   function "=" (
         A,                  
         B : in     Tpalabra ) 
     return Boolean; 
   function Longitud (
         A : in     Tpalabra ) 
     return Tlongitud; 
   function Vacia (
         P : in     Tpalabra ) 
     return Boolean; 
end Ppalabra;