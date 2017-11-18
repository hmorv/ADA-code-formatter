with Ada.Text_Io;
use Ada.Text_Io;

package Ada_Fichero_Palabra is

   --Este package sirve para tratar palabras tal y como se definieron en el diseño: todos los caracteres que se encuentran
   --encerrados entre dos espacios en blanco.
   --Es un package al estilo ppalabra visto en clase, pero un poco más reducido y modificado para manejar palabras
   --como si fueran instrucciones de Ada.
   --   Max : Constant Integer := 101;  
   --   Type Tlongitud Is New Integer Range 0 .. Max; 
   --   Subtype Rangoletras Is Tlongitud Range 1..Tlongitud'Last;
   --   Type Tablaletras Is Array (Rangoletras) Of Character; 
   --   Type Tpalabra Is 
   --      Record 
   --         Letra    : Tablaletras;  
   --         Longitud : Tlongitud;  
   --      End Record; 

   type Tpalabra is private; 
   type Tlongitud is private; 

   procedure Get (
         P,                    
         Q :    out Tpalabra;  
         C : in out Character; 
         F : in     File_Type  ); 

   procedure Put (
         P : in     Tpalabra;  
         F : in     File_Type; 
         G : in out File_Type  ); 

   --   procedure Normalizar (
   --         P,                  
   --         Q : in out Tpalabra ); 

   procedure Analizar_Palabra (
         P : in out Tpalabra; 
         Q : in     Tpalabra  ); 

private

   --Aquí está la especificación del tipo tpalabra, creada como un registro de dos campos: La tabla y la longitud
   --de la palabra almacenada en ésta.
   Max : constant Integer := 131;  
   type Tlongitud is new Integer range 0 .. Max; 
   subtype Rangoletras is Tlongitud range 1..Tlongitud'Last;
   type Tablaletras is array (Rangoletras) of Character; 
   type Tpalabra is 
      record 
         Letra    : Tablaletras;  
         Longitud : Tlongitud;  
      end record; 

   subtype Rango_Letras is Character range 'A'..'Z';
   --Las tres tablas a siguientes definen el sistema explicado en el diseño para construir una tabla de palabras reservadas.
   --Para indicar la posición de la tabla3, utilizaremos un caracter, que nos devuelva un valor numérico de la tabla1,
   --el cual nos llevará a la tabla2, y ésta a la posición requerida en la tabla3.
   Tabla1 : constant
   array (Rango_Letras) of Tlongitud := (1, 2, 3, 4, 5, 6, 7, 0, 8, 0, 0, 9, 10,
      11, 12, 13, 0, 14, 15, 16, 17, 0, 18, 19, 0, 0);
   Tabla2 : constant
   array (Tlongitud'First+1..Tlongitud'First+19) of Tlongitud := (1,11,13,
      15,20,26,28,30,33,35,36,39,43,
      48,56,59,64,66,69);
   Tabla3 : constant
   array (Tlongitud'First+1..Tlongitud'First+69) of Tpalabra := (
      (('A', 'B', 'O', 'R', 'T', others => ' '),  5),
      (('A', 'B', 'S', others => ' '),  3),
      (('A', 'B', 'S', 'T', 'R', 'A', 'C', 'T', others => ' '),  8),
      (('A', 'C', 'C', 'E', 'P', 'T', others => ' '),  6),
      (('A', 'C', 'C', 'E', 'S', 'S', others => ' '),  6),
      (('A', 'L', 'I', 'A', 'S', 'E', 'D', others => ' '),  7),
      (('A', 'L', 'L', others => ' '),  3),
      (('A', 'N', 'D', others => ' '),  3),
      (('A', 'R', 'R', 'A', 'Y', others => ' '),  5),
      (('A', 'T', others => ' '),  2),
      (('B', 'E', 'G', 'I', 'N', others => ' '),  5),
      (('B', 'O', 'D', 'Y', others => ' '),  4),
      (('C', 'A', 'S', 'E', others => ' '),  4),
      (('C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', others => ' '),  8),
      (('D', 'E', 'C', 'L', 'A', 'R', 'E', others => ' '),  7),
      (('D', 'E', 'L', 'A', 'Y', others => ' '),  5),
      (('D', 'E', 'L', 'T', 'A', others => ' '),  5),
      (('D', 'I', 'G', 'I', 'T', 'S', others => ' '),  6),
      (('D', 'O', others => ' '),  2),
      (('E', 'L', 'S', 'E', others => ' '),  4),
      (('E', 'L', 'S', 'I', 'F', others => ' '),  5),
      (('E', 'N', 'D', others => ' '),  3),
      (('E', 'N', 'T', 'R', 'Y', others => ' '),  5),
      (('E', 'X', 'C', 'E', 'P', 'T', 'I', 'O', 'N', others => ' '),  9),
      (('E', 'X', 'I', 'T', others => ' '),  4),
      (('F', 'O', 'R', others => ' '),  3),
      (('F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', others => ' '),  8),
      (('G', 'E', 'N', 'E', 'R', 'I', 'C', others => ' '),  7),
      (('G', 'O', 'T', 'O', others => ' '),  4),
      (('I', 'F', others => ' '),  2),
      (('I', 'N', others => ' '),  2),
      (('I', 'S', others => ' '),  2),
      (('L', 'I', 'M', 'I', 'T', 'E', 'D', others => ' '),  7),
      (('L', 'O', 'O', 'P', others => ' '),  4),
      (('M', 'O', 'D', others => ' '),  3),
      (('N', 'E', 'W', others => ' '),  3),
      (('N', 'O', 'T', others => ' '),  3),
      (('N', 'U', 'L', 'L', others => ' '),  4),
      (('O', 'F', others => ' '),  2),
      (('O', 'R', others => ' '),  2),
      (('O', 'T', 'H', 'E', 'R', 'S', others => ' '),  6),
      (('O', 'U', 'T', others => ' '),  3),
      (('P', 'A', 'C', 'K', 'A', 'G', 'E', others => ' '),  7),
      (('P', 'R', 'A', 'G', 'M', 'A', others => ' '),  6),
      (('P', 'R', 'I', 'V', 'A', 'T', 'E', others => ' '),  7),
      (('P', 'R', 'O', 'C', 'E', 'D', 'U', 'R', 'E', others => ' '),  9),
      (('P', 'R', 'O', 'T', 'E', 'C', 'T', 'E', 'D', others => ' '),  9),
      (('R', 'A', 'I', 'S', 'E', others => ' '),  5),
      (('R', 'A', 'N', 'G', 'E', others => ' '),  5),
      (('R', 'E', 'C', 'O', 'R', 'D', others => ' '),  6),
      (('R', 'E', 'M', others => ' '),  3),
      (('R', 'E', 'N', 'A', 'M', 'E', 'S', others => ' '),  7),
      (('R', 'E', 'Q', 'U', 'E', 'U', 'E', others => ' '),  7),
      (('R', 'E', 'T', 'U', 'R', 'N', others => ' '),  6),
      (('R', 'E', 'V', 'E', 'R', 'S', 'E', others => ' '),  7),
      (('S', 'E', 'L', 'E', 'C', 'T', others => ' '),  6),
      (('S', 'E', 'P', 'A', 'R', 'A', 'T', 'E', others => ' '),  8),
      (('S', 'U', 'B', 'T', 'Y', 'P', 'E', others => ' '),  7),
      (('T', 'A', 'G', 'G', 'E', 'D', others => ' '),  6),
      (('T', 'A', 'S', 'K', others => ' '),  4),
      (('T', 'E', 'R', 'M', 'I', 'N', 'A', 'T', 'E', others => ' '),  9),
      (('T', 'H', 'E', 'N', others => ' '),  4),
      (('T', 'Y', 'P', 'E', others => ' '),  4),
      (('U', 'N', 'T', 'I', 'L', others => ' '),  5),
      (('U', 'S', 'E', others => ' '),  3),
      (('W', 'H', 'E', 'N', others => ' '),  4),
      (('W', 'H', 'I', 'L', 'E', others => ' '),  5),
      (('W', 'I', 'T', 'H', others => ' '),  4),
      (('X', 'O', 'R', others => ' '),  3),
      others=>((others=>' '),0)
      );
end Ada_Fichero_Palabra;