With Ada.Text_Io, Ppalabra, Ada_Fichero_Palabra;
Use Ada.Text_Io, Ada_Fichero_Palabra;
Procedure Formateador Is 

   Argumentos_Correctos :          Boolean := False;  
   Longitud_String      : Constant Integer := 30;  
   --Constante que define la longitud de los string, mediante los cuales se almacenan los nombres 
   --de fichero original y final.
   Origen,  
   Destino             : String (1 .. Longitud_String);  
   F_Origen,  
   F_Destino           : File_Type;  
   Palabra,  
   Palabra_Normalizada   : Tpalabra;
   Caracter            : Character;  

   Procedure Tratar_Argumentos (
         Argumentos_Correctos :    Out Boolean; 
         O,                                     
         D                    : In Out String   ) Is 
      separate;
      
Begin

   Put_Line("Bienvenido al programa Formateador de codigo fuente.");
   Tratar_Argumentos(Argumentos_Correctos, Origen, Destino);
   If Argumentos_Correctos Then
      Open(F_Origen,In_File,origen);
      Create(F_Destino,Out_File,destino);
      While Not End_Of_File(F_Origen) Loop
         Get(Palabra,Palabra_normalizada,Caracter,F_Origen);
         
         Analizar_Palabra(Palabra,Palabra_normalizada);
         Put(Palabra,F_Origen,F_Destino);
      End Loop;
      Put_Line("El formateador ha creado con exito el fichero "&Destino&"");
   Else
      Put_Line(
         "El formateador no puede trabajar con argumentos incorrectos, fin de la ejecucion");
   End If;
End Formateador;