package body Ada_Fichero_Palabra is

   Espacio               : constant Character := ' ';  
   Nueva_Linea,  
   Comentario_Encontrado,  
   Is_Encontrado,  
   Final_Palabra_Linea   :          Boolean   := False;  
   type Rango_Identacion is new Integer range 0 .. 30; 
   Contador : Rango_Identacion := 0;  
   --Variables de tipo lógicas, para controlar algunas tareas: 
   --   Control de nueva línea en el fichero final
   --   Control de comentario encontrado.
   --   Control de final de palabra.
   --#######################################################################--
   --###############################--=--###################################--
   --#######################################################################--
   function "=" (
         F,                  
         G : in     Tpalabra ) 
     return Boolean is 
      I         : Tlongitud;  
      Resultado : Boolean;  
   begin
      if F.Longitud/=G.Longitud then
         Resultado:=False;
      else
         I:=Rangoletras'First;
         while I<F.Longitud and F.Letra(I)=G.Letra(I) loop
            I:=I+1;
         end loop;
         Resultado:= F.Letra(I)=G.Letra(I);
      end if;
      return Resultado;
   end "=";

   --#######################################################################--
   --#############################--IDENTAR--###############################--
   --#######################################################################--
   procedure Identar (
         G : in out File_Type ) is 
   begin
      for I in 0..Contador loop
         if I /= 0 then
            Put(G,Espacio);
         end if;
      end loop;
   end Identar;

   --#######################################################################--
   --#########################--SALTAR ESPACIOS--###########################--
   --#######################################################################--
   procedure Saltar_Espacios (
         F : in     File_Type; 
         C : in out Character  ) is 
      --Este programa se encarga de saltar los espacios en blanco que hay en el fichero origen.

   begin

      Get(F,C);
      while C = Espacio and not (End_Of_File(F)) loop
         Get(F,C);
      end loop;
   end Saltar_Espacios;

   --#######################################################################--
   --#####################--COMPROBAR_CAR_ESPECIALES--######################--
   --#######################################################################--

   procedure Comprobar_Car_Especiales (
         I : in out Tlongitud; 
         P : in     Tpalabra;  
         F : in     File_Type; 
         G : in out File_Type  ) is 

      --Este procedimiento se encarga de buscar caracteres especiales:
      --El punto y coma ';', que genera un salto de línea.
      --La comilla ''' y la doble comilla '"': Es posible que se utilice un string o una variable con el valor ';', de este
      --modo, si el programa encuentra un ' o " , seguido de ; y un nuevo " o ', entonces omite el salto de línea.
      --Así evitamos romper instrucciones.
      --El guion '-': Si encuentra dos guiones consecutivos, entonces el fichero original contiene un comentario,
      --con lo que omite todo el texto introducido a partir de él, hasta el final de línea.

      type Caracter_Especial is 
            (Punto_Coma,    
             Comilla,       
             Doble_Comilla, 
             Guion,         
             Otros); 
      Posicion_Tabla : Caracter_Especial;  
      --Creamos un nuevo tipo para luego utilizar la sentencia Case, que será mucho más efectiva que If, ya que
      --se contemplan múltiples casos, dependiendo del valor de la posición de la tabla.
   begin

      if Comentario_Encontrado then
         --Esta condición evalúa si ha sido encontrado previamente una pareja de guiones, indicando el inicio 
         --de un comentario. Si es así, el texto hasta el final de la palabra se omite.
         while I <= P.Longitud loop
            Put(G,P.Letra(I));
            I := I + 1;
         end loop;
      else
         --Si no hay un comentario entonces tenemos que analizar el carácter:
         if P.Letra(I) =';' then
            Posicion_Tabla := Punto_Coma;
         elsif P.Letra(I) =''' then
            Posicion_Tabla := Comilla;
         elsif P.Letra(I) ='"' then
            Posicion_Tabla := Doble_Comilla;
         elsif P.Letra(I) ='-' then
            Posicion_Tabla := Guion;
         else
            Posicion_Tabla := Otros;
         end if;
         --En este punto, analizamos el caracter actual. 
         case Posicion_Tabla is
            --Aquí se tratan por separado los distintos valores que puede tener la posición actual de la tabla.
            when Punto_Coma =>
               --Si el carácter introducido es un punto y coma, entonces se salta una nueva línea en el fichero destino.
               Put(G,P.Letra(I));
               if not End_Of_Line(F) then
                  New_Line(G);
                  Identar(G);
                  Final_Palabra_Linea := True;
               end if;
            when  Comilla =>
               Put(G,P.Letra(I));
               --Si el caracter encontrado es una comilla, tenemos que mirar qué hay después (si hay algo):
               if I < P.Longitud then
                  I := I + 1;
                  if  P.Letra(I) = ';' then
                     Put(G,P.Letra(I));
                     if I < P.Longitud then
                        I := I + 1;
                        if P.Letra(I) = ''' then
                           --Si el siguiente carácter tras el punto y coma, vuelve a ser una comilla,
                           -- entonces no saltamos línea.
                           Put(G,P.Letra(I));
                        else
                           New_Line(G);
                           Identar(G);
                           Put(G,P.Letra(I));
                        end if;
                     else
                        New_Line(G);
                        Identar(G);
                        Final_Palabra_Linea := True;
                        Nueva_Linea := False;
                        --Evitamos dos saltos de línea.
                        --Activando esta variable evitamos que el procedimiento put nos introduzca un espacio de más. 
                     end if;
                  else
                     --En caso de haber encontrado una comilla pero no un punto y coma, entonces escribimos
                     --el caracter en el fichero destino, y no hacemos nada más.
                     Put(G,P.Letra(I));
                  end if;
               end if;
            when  Doble_Comilla =>
               --Este caso es completamente idéntico al anterior, la única diferencia es que ahora buscamos doble comilla.
               Put(G,P.Letra(I));
               if I < P.Longitud then
                  I := I + 1;
                  if  P.Letra(I) = ';' then
                     Put(G,';');
                     if I < P.Longitud then
                        I := I + 1;
                        if P.Letra(I) = '"' then
                           Put(G,P.Letra(I));
                        else
                           New_Line(G);         Identar(G);
                           Put(G,P.Letra(I));
                        end if;
                     else
                        New_Line(G);         Identar(G);
                        Final_Palabra_Linea := True;
                        Nueva_Linea := False;
                     end if;
                  else
                     Put(G,P.Letra(I));
                  end if;
               end if;
            when Guion =>
               Put(G,P.Letra(I));
               --En caso de encontrar un guion, tenemos que mirar el siguiente carácter.
               if I < P.Longitud then
                  I := I + 1;
                  if P.Letra(I) = '-' then
                     Comentario_Encontrado := True;
                     --Esta booleana nos indica que hay un comentario, hasta que llegue al fin de línea.
                     Put(G,P.Letra(I));
                     --Si encontramos otro guion, entonces podemos escribir el resto de la palabra sin miedo a encontrar 
                     --un ; u otro caracter especial, ya que al estar dentro de un comentario,
                     --no debe tratarse como especial.
                     while I < P.Longitud loop
                        I := I + 1;
                        Put(G,P.Letra(I));
                     end loop;
                  else
                     Put(G,P.Letra(I));
                  end if;
               end if;
            when Otros =>
               --Si el carácter no es especial, lo tratamos como tal, es decir, lo escribimos al fichero final.
               Put(G,P.Letra(I));
         end case;
      end if;
   end Comprobar_Car_Especiales;


   --#######################################################################--
   --#########################--ANALIZAR PALABRA--##########################--
   --#######################################################################--

   procedure Analizar_Palabra (
         P : in out Tpalabra; 
         Q : in     Tpalabra  ) is 
      --Este programa se encarga de analizar el contenido de la tabla captada por el procedimiento Get. Busca en
      --su interior caracteres alfabeticos, y si los encuentra, busca entre ellos las posibles palabras reservadas.

      Itabla_Palabra,  
      Iinterno_Tpalabra : Tlongitud := Tlongitud'First + 1;  
      Itabla_Reservada  : Tlongitud := Tlongitud'First;  
      --Estas variables sirven de índices en las dos tablas (reservadas y palabra).
      Reservada_Encontrada : Boolean := False;  
      --Esta booleana controla si se ha encontrado una reservada.  
      --###################################--INICIO DE SUBPROGRAMAS--######################################--
      function Caracter_Alfabetico (
            Indice : in     Tlongitud ) 
        return Boolean is 
         --Esta función devuelve un valor lógico verdadero o falso, dependiendo de si el caracter tratado es inicial
         --de una posible palabra reservada o no.

         subtype Rango_Alf is Tlongitud range Tlongitud'First+1..
            Tlongitud'First+19;
         Alfabeto_Reservadas : constant
         array (Rango_Alf) of Character:=
            "ABCDEFGILMNOPRSTUWX";
         L : Tlongitud := Tlongitud'First + 1;  
         --Esta tabla contiene las posibles iniciales de una palabra reservada.
      begin
         while  Q.Letra(Indice) /= Alfabeto_Reservadas(L) and
               L < Rango_Alf'Last loop
            --Mientras no coincida el caracter de la tabla de palabras con la de posibles iniciales:
            L := L + 1;
         end loop;
         return Q.Letra(Indice) = Alfabeto_Reservadas(L);
      end Caracter_Alfabetico;

      --###################################################################################################--

      function Quedan_Tablas_Por_Mirar (
            Indice : in     Tlongitud ) 
        return Boolean is 
         --Determina mediante un valor lógico si todavía quedan tablas en la tabla de palabras reservadas
         --con la misma inicial que el caracter actualmente tratado.

      begin
         if Tabla2(Tabla1(Q.Letra(Indice)))+Itabla_Reservada <= Tlongitud'
               First+69 then
            return Tabla3(Tabla2(Tabla1(Q.Letra(Indice)))+
               Itabla_Reservada).Letra(Tlongitud'First+1) = Q.Letra(
               Indice);
         else
            return False;
         end if;
      end Quedan_Tablas_Por_Mirar;

      --###################################################################################################--

      procedure Convertir_A_Mayusculas (
            Indice         : in out Tlongitud; 
            Indice_Interno : in     Tlongitud  ) is 
         --Este programa se encarga de convertir a mayúsculas la palabra reservada encontrada, es decir
         --si encuentra una, la copia de la tabla Q a la tabla P. 

      begin
         for K in Indice .. Indice_Interno loop
            P.Letra(K) := Q.Letra(K);
         end loop;
         Indice := Indice_Interno;
      end Convertir_A_Mayusculas;

      --###################################################################################################--

      procedure Busqueda_En_Tabla_Reservadas (
            Indice           : in out Tlongitud; 
            Indice_Interno,                      
            Itabla_Reservada : in out Tlongitud; 
            Reservada        :    out Boolean    ) is 
         --Este procedimiento, algo complejo, realiza una búsqueda sobre la tabla Q. Si encuentra una palabra
         --reservada, activa una variable booleana.

         Indice_Interno_Reservadas : Tlongitud := Tlongitud'First + 1;  
         --Índice para movernos dentro de una determinada tabla perteneciente a la tabla3 (de palabras reservadas).  
         function Caracter_No_Alfabetico (
               Indice_Interno : in     Tlongitud ) 
           return Boolean is 
            --Esta funcion determina si el carácter es alfabético. En el diseño se definió como caracter no 
            --alfabetico todo aquel que no perteneciera al alfabeto inglés, exceptuando '-' y '_'.
            Max      : constant Tlongitud := 38;  
            Simbolos : constant
            array (1..Max) of Character :=
               "ºª\!|@·#$%&¬/()=?'¿¡^`[*+]¨´{}çñ.:,;<>";
            --Tabla de caracteres no alfabeticos.
            I : Tlongitud := Tlongitud'First + 1;  

         begin
            while I < Max and then Simbolos(I)/= Q.Letra(Indice_Interno) loop
               I := I + 1;
            end loop;
            return Simbolos(I)=Q.Letra(Indice_Interno);
         end Caracter_No_Alfabetico;

      begin

         Indice_Interno := Itabla_Palabra;
         Indice_Interno_Reservadas := 1;
         while Tabla3(Tabla2(Tabla1(Q.Letra(Indice)))+Itabla_Reservada).
               Letra(Indice_Interno_Reservadas) = Q.Letra(Indice_Interno)
               and Indice_Interno < Q.Longitud
               and Indice_Interno_Reservadas < Tabla3(Tabla2(Tabla1(
                     Q.Letra(Indice)))+Itabla_Reservada).Longitud loop
            --Mientras las tabla de palabras reservadas en la posicion indicada por el caracter de la tabla Q
            --sea igual a la posición de la tabla Q, y mientras no se haya llegado al final de la tabla de reservadas
            --y la tabla Q:
            Indice_Interno_Reservadas := Indice_Interno_Reservadas + 1;
            Indice_Interno := Indice_Interno + 1;
         end loop;
         if Tabla3(Tabla2(Tabla1(Q.Letra(Indice)))+Itabla_Reservada).
               Letra(Indice_Interno_Reservadas) = Q.Letra(Indice_Interno)
               and Tabla3(Tabla2(Tabla1(Q.Letra(Indice)))+
               Itabla_Reservada).Longitud = (Indice_Interno) then
            --Si las ultimas posiciones comparadas son iguales y además la longitud de la palabra reservada
            --coincide con la longitud comparada de la tabla Q:
            if (Indice_Interno-(Indice_Interno_Reservadas) = Tlongitud'
                  First+1) and ((Indice_Interno=Q.Longitud)
                  or ((Indice_Interno+1<=Q.Longitud)and then
                     Caracter_No_Alfabetico(Indice_Interno+1))) then
               --Si el fragmento de la tabla Q tiene la misma longitud que la palabra reservada y el fragmento llega
               --al final de la tabla q o el siguiente caracter al último comparado es no alfabetico se habrá encontrado
               --una palabra reservada.
               Reservada := True;
            else
               if ((Indice_Interno=Q.Longitud) or ((Indice_Interno+1<=
                           Q.Longitud)and then
                        Caracter_No_Alfabetico(Indice_Interno+1))) then
                  --En caso contrario, si el fragmento analizado llega al final de la tabla o el caracter posterior
                  --al último caracter comparado es no alfabetico, habremos encontrado una palabra reservada.
                  Reservada := True;
               else
                  --En caso contrario no hemos encontrado nada especial.
                  Reservada := False;
                  Itabla_Reservada := Itabla_Reservada + 1;
                  --Aumentamos el índice, que luego será evaluado por la función quedan_tablas_por_mirar para averiguar
                  --si aún quedan tablas (pertenecientes a la tabla3) con iniciales iguales 
                  --al caracter del recorrido general.
               end if;
            end if;
         else
            Reservada := False;
            Itabla_Reservada := Itabla_Reservada + 1;
         end if;
      end Busqueda_En_Tabla_Reservadas;

      --###################################################################################################--
   begin
      if not Comentario_Encontrado then
         --Si no se ha encontrado un comentario previamente, entonces se trata el texto de manera normal.
         --De este modo los comentarios son saltados, ya que no forman parte efectiva para el compilador.
         while Itabla_Palabra < Q.Longitud loop
            --Como no hay ninguna palabra reservada de una sola letra, podemos olvidarnos de todas las palabras
            -- con q.longitud = 1.
            if Caracter_Alfabetico(Itabla_Palabra) then
               --            Si el caracter es alfabético se realiza la búsqueda.
               while Quedan_Tablas_Por_Mirar(Itabla_Palabra) and not
                     Reservada_Encontrada loop
                  --Mientras quedan tablas por mirar con la misma inicial.
                  Busqueda_En_Tabla_Reservadas(Itabla_Palabra,
                     Iinterno_Tpalabra,Itabla_Reservada,
                     Reservada_Encontrada);
               end loop;
            end if;
            if Reservada_Encontrada then
               --Si hay una palabra reservada, averiguamos cual es:
               if "="(Tabla3(Tabla2(Tabla1(Q.Letra(Itabla_Palabra)))+
                        Itabla_Reservada),Tabla3(22)) then
                  if Contador > 0 then
                     Contador := Contador-6;
                  end if;
                  --Si la palabra es END, entonces quitamos identación, si se puede.
               end if;
               if "="(Tabla3(Tabla2(Tabla1(Q.Letra(Itabla_Palabra)))+
                        Itabla_Reservada),Tabla3(32)) then
                  Is_Encontrado := True;
                  Contador := Contador+3;
               end if;
               if Is_Encontrado then
                  if ("="(Tabla3(Tabla2(Tabla1(Q.Letra(Itabla_Palabra)))+
                              Itabla_Reservada),Tabla3(57))) then
                     Contador := Contador-3;
                  end if;
                  --Si la palabra es IS, añadimos identación, si posteriormente se encuentra SEPARATE, entonces quitamos
                  --el doble de identación.
               end if;
               if "="(Tabla3(Tabla2(Tabla1(Q.Letra(Itabla_Palabra)))+
                        Itabla_Reservada),Tabla3(34)) or "="(Tabla3(
                        Tabla2(Tabla1(Q.Letra(Itabla_Palabra)))+
                        Itabla_Reservada),Tabla3(62))then
                  Contador := Contador+3;
               end if;
               --Aqui se ha comparado la palabra con LOOP y THEN, las cuales tambien abren bloque.
               Convertir_A_Mayusculas(Itabla_Palabra,Iinterno_Tpalabra);
            else
               --
               Itabla_Palabra := Itabla_Palabra + 1;
            end if;
            --Actualizamos el índice de la tabla.
            Itabla_Reservada := Tlongitud'First;
            Itabla_Palabra := Itabla_Palabra + 1;
            Reservada_Encontrada := False;
            --Reiniciamos las variables Itabla_Reservada y reservada_encontrada a falso, por si hay más palabras
            --reservadas en la tabla.

         end loop;
      end if;
   end Analizar_Palabra;

   --#######################################################################--
   --############################--NORMALIZAR--#############################--
   --#######################################################################--

   procedure Normalizar (
         P,                  
         Q : in out Tpalabra ) is 
      --Este procedimiento convierte a mayúsculas los caracteres alfabéticos de la tabla P a la tabla Q.

      type Mayusculas is array (Tlongitud'First + 1 .. Tlongitud'First + 26) of Character; 
      May : constant Mayusculas := "ABCDEFGHIJKLMNOPQRSTUVWXYZ";  
      type Minusculas is array (Tlongitud'First + 1 .. Tlongitud'First + 26) of Character; 
      Min : constant Minusculas := "abcdefghijklmnopqrstuvwxyz";  
      --Tablas de mayúsculas y minúsculas.
      I,  
      J : Tlongitud := Tlongitud'First + 1;  

   begin
      Q := P;
      --Copia el contenido de P a la tabla Q.
      while J <= Q.Longitud loop
         --Mientras queden caracteres por tratar:
         while I < 26 and Q.Letra(J) /= Min(I) loop
            I := I + 1;
         end loop;
         if Q.Letra(J) = Min(I) then
            Q.Letra(J) := May(I);
            --Si encuentra una minúsucula, la convierte a mayúscula.
         end if;
         J := J + 1;
         I := Tlongitud'First+1;
      end loop;
   end Normalizar;


   --#######################################################################--
   --###############################--GET--#################################--
   --#######################################################################--

   procedure Get (
         P,                    
         Q :    out Tpalabra;  
         C : in out Character; 
         F : in     File_Type  ) is 

      --Este procedimiento almacena una palabra desde el fichero origen, (parámetro F) y lo guarda en una tabla 
      --(parámetro P). Tiene las modificaciones para que lea adecuadamente desde un fichero.

      I : Tlongitud := Tlongitud'First;  
   begin
      for X in Tlongitud'First+1..Tlongitud'Last loop
         P.Letra(X) := ' ';
      end  loop;
      Final_Palabra_Linea := False;
      Nueva_Linea :=False;
      --Inicializamos la variable Final_Palabra_Linea, ya que es seguro que no estamos al final de la palabra.
      Saltar_Espacios(F,C);
      --Salta espacios en blanco, si los hay.           
      while not (C = Espacio or End_Of_Line(F) or End_Of_File(F)) loop
         --En este bucle se almacena la palabra en la tabla.
         --         if C = ';' then
         --            Punto_Coma := True; end if;

         I := I + 1;
         P.Letra(I) := C;
         Get(F,C);
      end loop;
      if End_Of_Line(F) or End_Of_File(F) then
         --Si se ha encontrado un final de línea o final de fichero, el bucle no ha tratado el último elemento
         --por lo que aquí se analiza esta posibilidad.
         --Esta condicion cierra el comentario, por lo que el texto si la variable es falsa, se tratará de manera normal.
         I := I + 1;
         P.Letra(I) := C;
         Nueva_Linea := True;
         --Aquí es seguro que estamos en una nueva línea del fichero original.
         if End_Of_Line(F) then
            Comentario_Encontrado := False;
            --Si se cumple la condición entonces ya no hay que tratar el texto como si fuera un comentario.
         end if;
      else
         --Si no estamos a final de línea, entonces la variable nueva_linea no ha de ser verdadera.
         Nueva_Linea := False;
      end if;
      P.Longitud := I;
      --Se guarda la longitud de la palabra.
      Normalizar(P,Q);
   end Get;


   --#######################################################################--
   --###############################--PUT--#################################--
   --#######################################################################--

   procedure Put (
         P : in     Tpalabra;  
         F : in     File_Type; 
         G : in out File_Type  ) is 
      --Este procedimiento ahce un recorrido sobre la tabla de palabras. Va escribiendo caracter a caracter
      --el contenido de la palabra.
      I : Tlongitud := Tlongitud'First;  --Variable que sirve de índice para movernos dentro de la tabla.
      --Variable que sirve de índice para movernos dentro de la tabla.                                                                                                                                          

      begin
      while I < P.Longitud loop
         I := I + 1;
         Comprobar_Car_Especiales(I,P,F,G);
      end loop;
      if not Final_Palabra_Linea then
         --Si no hemos llegado al final de la línea:
         Put(G,Espacio);
      end if;
      if Nueva_Linea then
         --Si get nos ha indicado que era fin de línea entonces la saltamos en el fichero final.
         New_Line(G);
         Identar(G);
         Is_Encontrado := False;

      end if;
   end Put;
end Ada_Fichero_Palabra;