Separate (Formateador.Tratar_Argumentos)

Function Arg_Correctos (
      O,                
      D : In     String ) 
  Return Boolean Is 

Begin
   If O = Vacio Then
      --Esta condición analiza si el usuario ha escrito algo.
      Put_Line ("No has introducido ningun nombre.");
      Return False;
   Else
      If D = Vacio Then
         --Esta otra mira si aparte del primer nmbre, existe un segundo.
         Put_Line("Se necesitan 2 nombres.");
         Return False;
      Else
         If O = D Then
            --Si hay dos, ahora comprueba que no sean iguales.
            Put_Line("Los ficheros no pueden tener el mismo nombre.");
            Return False;
         Else
            --Llegados aquí, los nombres son correctos.
            put_line("Los nombres de fichero han sido introducidos correctamente.");
            Return True;
         End If;
      End If;
   End If;
End Arg_Correctos;