With Ada.Command_Line;
Use Ada.Command_Line;


Separate (Formateador)
Procedure Tratar_Argumentos (
      Argumentos_Correctos :    Out Boolean; 
      O,                                     
      D                    : In Out String   ) Is 
   --Este procedimiento se encarga de captar los dos argumentos de ejecución necesarios para que el programa funcione.
   --Los argumentos pueden ser introducidos desde la línea de comandos (mediante la librería ada.command_line),
   --o en caso contrario, en el tiempo de ejecución.
   --Los argumentos serán los nombres del fichero origen y del fichero final. Si ambos nombres son iguales, el programa 
   --notificará un error y los volverá a pedir. Si se introduce sólo uno o ningún nombre, también se notificará otro error
   --y se volverán a pedir. 
   --El usuario dispone de 4 oportunidades. Agotadas éstas, el programa finaliza.

   Max               : Constant Integer  := 30;  
   Max_Oportunidades : Constant Positive := 4;  
   --Constante positiva que indica las oportunidades que tendrá el usuario para introducir los nombres de forma correcta.
   Contador : Positive := 1;  
   --Almacena las veces que el usuario ha intentado introducir los nombres.
   Vacio : Constant String (1 .. Longitud_String) := (Others => ' ');  
   --Define un string cuyo contenido seran espacios en blanco. De este modo, si el usuario no introduce nada, 
   --lo podremos por comparación con este string.
   Procedure Copiar_Argumentos_A_String (
         O,                
         D :    Out String ) Is 
   Separate;
   --Este procedimiento copia los strings introducidos en la línea de comandos a los strings finales, O y D.


   Procedure Copiar_Teclado_A_String (
         O,                
         D :    Out String ) Is 
   Separate;
   --Este otro procedimiento copia del teclado los nombres introducidos y los convierte a string.


   Function Arg_Correctos (
         O,                
         D : In     String ) 
     Return Boolean Is 
   Separate;
   --Esta función determina si los nombres introducidos (desde línea de comandos o posteriormente) son correctos
   --devolviendo un valor booleano.


Begin
   --Inicializamos los strings:
   O := Vacio;
   D := Vacio;
   --El haberlos inicializado como el string vacio nos sirve para cuando tengamos que captar el contenido
   --del nombre de fichero. De este modo captaremos todo el texto del string hasta llegar al primer espacio en blanco.
   If Argument_Count /= 0 Then
      Copiar_Argumentos_A_String(O,D);
      --Si hay algún argumento, lo analiza.
   Else
      Put_Line("Los argumentos de ejecucion no han sido introducidos.");
      Copiar_Teclado_A_String(O,D);
      --Si no hay ningún argumento, lo intenta captar desde el teclado. 
   End If;
   While Contador < Max_Oportunidades And Not Arg_Correctos(O,D) Loop
      Put_Line("Le quedan"&Integer(Max_Oportunidades-Contador)'Img&
         " oportunidades para introducir los nombres correctamente.");
      O := Vacio;
      D := Vacio;
      Copiar_Teclado_A_String(O,D);
      Contador := Contador + 1;
      --Si el número de intentos es menor al de oportunidades y no hemos introducido bien los nombres de fichero 
      --el bucle vuelve a intentar captar los nombres y aumenta el contador.
   End Loop;
         if contador <= max_oportunidades then argumentos_correctos := true; end if;

End Tratar_Argumentos;