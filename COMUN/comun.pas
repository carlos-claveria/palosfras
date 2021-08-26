{
 Funciones de propósito general que se utilizadas por Silicon Media en 
 sus porductos Albatros y Sileco.
 
 @version 8.0 Adaptada a Delphi XE7, MAYO 2013  MARZO 2015
 @author Carlos Clavería y otros
}
unit comun;

interface
uses db,shellapi,math,forms,Windows,DateUtils,classes,idhttp,UNI,SHDocVw,CONTROLS,DBGRIDS ;

type

  /// Tipo de búsqueda seleccionada por el usuario.
  TModoBus = (esContad,esContri,esFactura,esProforma,esCalle);
  
  /// En la función Pad indica la alineación del texto.
  TPadMode = (xLeft,xRight,xCenter);
  
   /// Usado para la comunicación entre procesos.
   TCopyDataStruct = packed record
      dwData: DWORD;   /// de uso libre: para indicar por ejemplo el tipo de información a transmitir
      cbData: DWORD;   /// el tamaño en bytes de los datos que se van a enviar
      lpData: Pointer; /// puntero a los datos que se van a enviar
   end;

   /// Estructura de una emisión en aguas.
   TEmis    = record
               CPOBLA   : integer;
               ANO      : integer;
               PERIODO  : integer;
               BLOQUE   : integer;
   end;
   /// Estructura de los diferentes tipos de IVA en una factuta Albatros.
   TLinIVA  = record
               tpc,
               importe,
               bonificacion,
               base,
               impiva,
               total : real;
               end;
   /// Estructura del pie de una factura Albatros.
   TPieFra  = record
               cuota,
               tramos,
               importe,
               bonificacion,
               base,
               impiva,
               total   : real;
               nl      : integer; /// indica las lineas de IVA generadas
               tiva    : array[1..5] of TLinIVA;
               end;
  


  function limpiaNIF(s : string) : string;

  function IsDateNull(f : Tfield) : boolean;
    
  /// Pone a la fecha hora, minuto y segundo a cero
  function fechaDesde(f : TDateTime ) :TDateTime; 
  
  /// Pone a la fecha hora, minuto y segundo a final del día

  function fechaHasta(f : TDateTime ) :TDateTime; 
      


   {*
   Es un showmessage + un format
   }
   procedure sf( Const Formatting : string; Const Data : array of const );
  

   {*
    Indica si un contrato está activo.
    Chequea que el valor ESTADO es null, '' ó 'ALTA'
    @param q   DataSet que contiene el campo TCONTAD.ESTADO
    @result TRUE si el contrato está activo
   } 
   function ConEnAlta(q : TDataSet) : boolean;

  {* 
    Llamada a una página en PHP
    @param url URL de la página.
    @param par lista con los parámetros esperados en el PHP
   } 
   function PostPHP(url : string; par : array of string) : string; 

  {*
   Completa una emision introducida parcialmente devolviendo el formato:
      - CCCCC.AAAA.PP.BB Donde:

       CCCCC   Código de la población.
       AAAA    Año
       PP      Periodo
       BB      Bloque
      
   
   @param s Emisión introducida 
   @param p Población activa en la aplicación
   @result String con la emisión formateada
  } 
  function validaEmi(s : string; p : integer) : string;
  { Interroga sobre la bondad de la emsión tras un ValidaEmi }
  procedure EmiError;
  

  
  {*
  Devuelve una emisión en formato string dentro de un record del tipo TEmis

  @param e Emisión en formato string (CCCCC.AAAA.PP.BB)
  @result Record de tipo TEmis con los datos de la emisión.
  @see TEmis
  }
  function StToEmis( e : string) : TEmis;


    
  {*
  Devuelve una amisión almacenada en una record TEMis como una string formateada.

  @params q Record TEmis con los valores
  @see TEmis
  @result String con la emisión formateada
  
  }
  function formatemi(q : TEmis) : shortstring;
  
  {*
  Devuelve una amisión almacenada en una tabla con los campos CPOBLA, ANO,
  PERIODO y BLOQUE como una string formateada.

   @params q DataSet activo que contiene los campos antes mencionados.
   @result String con la emisión formateada
  
  }
  function formatemiDB(q : TDataSet) : string;

  
  {* 
  Devuelve una emisión almacenada en una tabla en un record TEmis
  
   @params q DataSet activo que contiene los campos antes mencionados.
   @result Record de tipo TEmis con los datos de la emisión.
  } 
  function DB2Emi(q : TDataSet) : TEmis;

  {*
  Actualiza los campos de una fila de una tabla con el contenido del record TEmis
  
   @params q DataSet activo que contiene los campos de emisión.
   @params r Record TEmis con los valores
   @see TEmis
  } 
  procedure ponemiDB(r : TEmis; q : TDataSet);

  {*
  Pasa una dirección de la BD a un formato texto.

   @params q DataSet activo que contiene los campos de dirección.
   @params x Instancia de la Clase TStrings;

   ejemplo : Dir2Text(cAbonados, memo.Lines);
  }
  procedure Dir2Texto(c : TDataSet; x :  TStrings);

  {*
   Formatea una cadena con espacios en blanco alineados a la izquierda,
   derecha o centro (xLeft, xRight, xCenter)

   @params s  Cadena a formatear
   @params n  longitud del la daena resultante
   @params nMode  Tipo de alineación.
   @result Cadena formateada

   @see TPadMode
  }
  function Pad(s:string;n : integer; nMode : TPadMode) : string;
  
  {*
  Divide una cadena en un array almacenado en una instancia TStringList
  separando las mismas por un separador.

  @params a Instancia de TStringList
  @params st Cadena a dividir
  @params cSep Caracter separador
  }
  procedure aElem(var a : TStringList;st,cSep : string);

  
 //-------------------------------------------------------------------------
 // Indica si una cadena es numérica (valida * como numérico para CCC)
 //-------------------------------------------------------------------------
 function EsNumerico(Value: string): boolean; 
 function IsInteger(c : string) : boolean;
    
 //-------------------------------------------------------------------------
 // round que funciona (para euros)
 //-------------------------------------------------------------------------
 function eround(x: real) : real; 

 //-------------------------------------------------------------------------
 // Implemento el iif de toda la vida
 //-------------------------------------------------------------------------
 function iif(Test: boolean; TrueR, FalseR: string)  : string; overload;
 function iif(Test: boolean; TrueR, FalseR: integer) : integer; overload;
 function iif(Test: boolean; TrueR, FalseR: extended): extended; overload;
 function iif(Test: boolean; TrueR, FalseR: boolean) : boolean; overload;

 function WinUser : string;


 
 // FUERZA LA CONVERISON DE UNA CADENA A NUMERICO ELIMINANDO 
 // CARACTERES NO NUMÉRICOS
 function smval(c : string)  : Int64;

 // CONCATENA LOS CAMPOS DE DIRECCION
 function Direc(q : TDataSet) : string;   
 function Nombre(q : TDataSet) : string;

 // EJECUTA UNA APLICACIÓN
 function ExecNewProcess(ProgramName : string; esperar : boolean = TRUE) : boolean;
  
 // CALCULA EL CONSUMO ENTRE DOS LECTURAS
 function _m3(anterior,actual : integer) : integer;
 function cm3(ant,act : integer; numd : integer; var nErr : byte) : integer;
 procedure Mosm3Err(nErr : byte);
 
 

 // DETERMINA POSIBLES INCIDENCIAS
 function PonIncidencia(anterior,actual : integer) : integer;
  
 // COMPRUEBA SI YA EXISTE UNA ISNTANCIA DEL FORMULARIO
 function Instancia(AClass: TFormClass): TForm;
 
 // EJECUTA UN FORMULARIO
 function Lanzar(AClass: TFormClass): TForm;
  
 // VARIANTE DEL ANTERIOR
 function lForm(AClass: TFormClass; modal : boolean = TRUE) : TForm;
  
 // VALIDA LA ENTRADA COMO SI/NO
 function ValidaSN( sn : string ) : string;
  
 // PASA SN a booleano ( en varios idiomas);
 function SNToBool( sn : string ) : boolean;

 // booleano a SN
 function SN( b : boolean ) : string;

 // Convierte un entero en string con ceros por la izquierda
 function strzero( valor : integer; lon : integer ) : string;

 // DETERMINA SI UNA CADENA ES NUMERICA (ENTERO)
 function IsNumber(const S: string): Boolean;

 // GARANTIZA QUE LA CADENA TERMINA CON '\'
 function ponBarra(st : string) : string;

 //QUITA EL SEPARADOR DE MILES
 function QuitaSeparador( s: string ) : string;

 // Descompone un caracter en 2 partes y retorna solo el caracter, quitando acentos y otros posibles agregados.
 function extractSimbolFromMultiByteChar(Text: PAnsiChar): Char;
 //Recorre una cadena caracter a caracter, descomponiendolo y retornando solo el caracter limpio.
 function clearMultiByteChar(Text: String; Upper : boolean = TRUE): String;

 // SE COMPORTA COMO UN LOCATE y LOCATENEXT IGNORA MAYUSCULAS, MINUSCULAS Y ACENTOS
 // PRINCIPIO = FALSE PARA EL LOCATENEXT
 procedure BusRec(c : TDataSet; campo,valor : string; principio : boolean = TRUE);

 // Obtiene la versión de la compilación
 function getCompVersion : string;

 function Desencripta(const S2: String; _md5 : boolean = FALSE): String;
 function Encripta(const S: String; _md5 : boolean = FALSE): String;
 
 function MD5(const cad : string) : string;
 function fMD5(const fileName : string) : string;
 
  
 // Pone el CopyRigth
 function SMCR : string;

 // Para usarlo en format %9.0n y sacar enteros con separación de millares
 function inttofloat(i : integer) : real;

function IsValidEmail(email : string): Boolean;

procedure AsignaColores;

function LetraNIF(NIF : shortstring) : shortstring;

function formatsh(cBuf : string) : string;


// Copia una linea de tabla en otra
procedure ClonaReg(ori : TDataSet; var des : TDataSet); overload;

function EjecutarYEsperar( sPrograma: String; Visibilidad: Integer ): Integer;




{*
  Devuelve los valores recogidos en ParamStr. que deben tener el formato:
  variable=valor
  @param valor Nombre de la variable
  @defecto Valor a devolver si no encuentra el parámetro
  @result Valor del parámetro
}
function GetParam(nomParam : string = '';defecto : string = '') : string;
{*
 Clasifica un clave string que contiene números o letras pero respetando el orden numérico
}


function OrdStNum(x : string; pos : integer) : string;


procedure AppendToWB(WB: TWebBrowser; const html: widestring) ;


procedure EnabledAsParent(container: TWinControl) ;

(*
   Obtiene la fecha de compilación si lo usamos como :
   Caption := 'Compilado el '+(DateToStr(GetFileDate(ParamStr(0))));

 *)

function GetFileDate(Nombre: string): TDateTime;


procedure ScaleDBGridText(AGrid: TDBGrid; M, D: Integer);
procedure GetSystemDPI(var HorizDPI, VertDPI: Integer);



 var
 // Colores definidos por el usuario para marcar los browses
 _CBAJA,
 _CBAJAT,
 _CCORTE,
 _OBRA,                            
 _CPEND,
 _CEJE,
 _CBLO,
 _SS,
 _PP,
 nDB,
 ACTDPI_H,
 ACTDPI_V, 
 _EMBARGO : Integer;

 nErr  : integer;
 audi,
 LastSQL,
 
 _Path : string;
 rEmi  : TEmis;
 fCompi,
 fProceso : TDateTime;
 
 

 _IDAPL : STRING;

 // FICHERO LOCAL DE CONFIGURACION
 fic_conf      : string = 'smconf.constr';

 solocons : boolean;
 
 Usuario,
 loginPassword : string;

const 
  c1        = 44345;
  c2        = 22433;  
  CR        = #10+#13;
  DEFDPI    = 96;       // Pixels por pulgada;
  __MySQL   = 0;
  __Oracle  = 2;
  ThousandSeparator = '.';

  __DIPUALC = TRUE;
  


implementation
uses sysutils,dialogs,inifiles,Graphics,strutils,
IdHashMessageDigest, idHash,pngimage{,_DM}, SQL,MSHTML;

function limpiaNIF(s : string) : string;
var
   i    : byte;
begin
   s := UpperCase(s);
   result := '';
   
   for i := 1  to length(s) do
      if CharInSet(s[i],['0'..'9','A'..'Z']) then result := result + s[i];

end;




function IsDateNull(f : TField) : boolean;
var
   y,m,d,h,n,s,ms : word;
begin
   decodedatetime(f.AsDateTime,y,m,d,h,n,s,ms);
   result := (y = 1899) and (m = 12) and (d = 30) and (h = 0) and (n = 0) and (s = 0) and (ms = 0);
end;

function GetFileDate(Nombre: string): TDateTime;
var
  SR: TSearchRec;
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  if FindFirst(Nombre, $FF, SR) = 0 then
  begin
      FileTimeToLocalFileTime(SR.FindData.ftLastWriteTime, LocalFileTime);    
      FileTimeToSystemTime(LocalFileTime, SystemTime) ;
      Result := SystemTimeToDateTime(SystemTime);
  end
  else
      Result := 0.0;
  
end;

















// ----------------------------------------------------------------------------

 procedure EnabledAsParent(container: TWinControl) ;
 var
   index : integer;
   aControl : TControl;
   isContainer : boolean;
 begin
   for index := 0 to -1 + container.ControlCount do
   begin
     aControl := container.Controls[index];
 
     aControl.Enabled := container.Enabled;
 
     isContainer := (csAcceptsControls in container.Controls[index].ControlStyle) ;
 
     if (isContainer) AND (aControl is TWinControl) then
     begin
       //recursive for child controls
       EnabledAsParent(TWinControl(container.Controls[index])) ;
     end;
   end;
 end;


// ----------------------------------------------------------------------------
function IsInteger(c : string) : boolean;
var
   cBuf : string;
   i    : LongInt;
begin
   result := TRUE;
   for i := 1 to length(cBuf) do

      
       if not ( SysUtils.CharInSet(cBuf[i],['0'..'9'])      ) then begin
          result := FALSE;
          exit;
       end;
end;

// Pone a la fecha hora, minuto y segundo a cero
function fechaDesde(f : TDateTime ) :TDateTime; 
var
   a,m,d,h,n,s,ms : word;
begin
   DecodeDateTime(f,a,m,d,h,n,s,ms);
   result := EncodeDateTime(a,m,d,0,0,0,0);
end;
  
// Pone a la fecha hora, minuto y segundo a final del día
function fechaHasta(f : TDateTime ) :TDateTime; 
var
   a,m,d,h,n,s,ms : word;
begin
   DecodeDateTime(f,a,m,d,h,n,s,ms);
   result := EncodeDateTime(a,m,d,23,59,59,0);
end; 

procedure sf( Const Formatting : string; Const Data : array of const );
begin
  ShowMessage(format(Formatting,Data));
end;


procedure AppendToWB(WB: TWebBrowser; const html: widestring) ;
var
   Range: IHTMLTxtRange;
begin
   Range := ((WB.Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
   Range.Collapse(False) ;
   Range.PasteHTML(html) ;
end;



procedure Dir2Texto(c : TDataSet; x : TStrings);
var
   cBuf      : string;
   CPOSTAL,
   POBLACION,
   PROVINCIA,
   PAIS      : string;
   
   HayPostal : boolean;

   q         : TSQL;
   
begin
   x.Clear;
  
   if Trim(c.FieldByName('CALLE').AsString) = '' then
     cBuf := ''
   else begin   
     cBuf := Trim(c.FieldByName('SIG').AsString) + ' ';
     cBuf := cBuf +  Trim(c.FieldByName('CALLE').AsString);
   
     if (c.FieldByName('NUM').AsString = '') then
        cBuf := cBuf + ',s/n '
     else   
        cBuf := cBuf + ', '+trim(c.FieldByName('NUM').AsString)+' ';

      
     cBuf := cBuf + trim(c.FieldByName('BIS').AsString)+' ';
     cBuf := cBuf + trim(c.FieldByName('ESCALERA').AsString)+' ';    
     cBuf := cBuf + trim(c.FieldByName('PISO').AsString)+' ';    
     cBuf := cBuf + trim(c.FieldByName('PUERTA').AsString)+' ';    
     cBuf := cBuf + trim(c.FieldByName('NUMLOCAL').AsString);
   end;
   

   x.Add(cBuf);

   CPOSTAL   := '';
   POBLACION := '';
   PROVINCIA := '';
   PAIS      := '';



   HayPostal := TRUE;
      
   if c.FindField('CPOSTAL') <> nil then begin
       CPOSTAL    := c.FieldByName('CPOSTAL').AsString;
   end;

   if c.FindField('POBLACION') <> nil then
       POBLACION  := c.FieldByName('POBLACION').AsString;
       
   if c.FindField('PROVINCIA') <> nil then
       PROVINCIA  := c.FieldByName('PROVINCIA').AsString;

   if c.FindField('CODPAIS') <> nil then
       PAIS       := c.FieldByName('CODPAIS').AsString;


   if (CPOSTAL = '') and (POBLACION = '') and (PROVINCIA = '') then HayPostal := FALSE;
       

  

  if not HayPostal and (c.FindField('CPOBLA') <> nil  ) then begin
        q := TSQL.Create('SELECT CPOSTAL,POBLACION,PROVINCIA FROM TPOBLA WHERE CPOBLA = %d',[c.FieldByName('CPOBLA').AsInteger]);
        try
          q.Go;
          if not q.eof then begin
              CPOSTAL   := q.d.FieldByName('CPOSTAL').AsString;
              POBLACION := q.d.FieldByName('POBLACION').AsString;
              PROVINCIA := q.d.FieldByName('PROVINCIA').AsString;
              PAIS      := 'ESPAÑA';
              end;
        finally
          q.Free;
        end;
  end;

  x.Add(trim(POBLACION));
  x.Add(trim(CPOSTAL+' '+PROVINCIA));
  x.Add(trim(PAIS));

end;


function OrdStNum(x : string; pos : integer) : string;
begin
  x := trim(x);
  while length(x) < pos do x := '0' + x;
  result := copy(x,1,15);
end;

function formatsh(cBuf : string) : string;
var
   aL   : TStringList;
   i    : integer;
begin

   result := '';
  
  if cBuf = '' then exit;

  
  if cBuf[length(cBuf)] = '.' then cBuf := copy(cBuf,1,length(cBuf)-1);
  al := TStringList.Create;
  TRY
   al.Delimiter := '.';
   al.DelimitedText := cBuf;
   cBuf := '';
   for i := 0 to al.Count-1 do begin
      if i = 0 then
         al[i] := format('%.2d',[strtoint(al[i])])
      else
         al[i] := format('%.3d',[strtoint(al[i])]);

   cBuf := cBuf + al[i] + '.';
   end;
   if cBuf[length(cBuf)] = '.' then cBuf := copy(cBuf,1,length(cBuf)-1);
   
   result := cBuf;      
         
   FINALLY
   al.Free;
   END;  

end; 
procedure LoadPNGFromResource(Picture: TPicture; const ResName: string); overload;
var
  Png: TPngImage;
begin
  Png := TPngImage.Create;
  try
    Png.LoadFromResourceName(HInstance, ResName);
    Picture.Assign(Png);
  finally
    if Assigned(Png) then  FreeAndNil(Png);
  end;
end;
 
procedure LoadPNGFromResource(Bitmap: TBitmap; const ResName: string); overload;
var
  Png: TPngImage;
begin
  Png := TPngImage.Create;
  try
    Png.LoadFromResourceName(HInstance, ResName);
    Bitmap.Assign(Png);
  finally
    if Assigned(Png) then  FreeAndNil(Png);
  end;
end;


function GetParam(nomParam : string = '';defecto : string = '') : string;

procedure splt(const cadena : string;var variable,valor : string);
var
   n : integer;
begin
   n := Pos('=',cadena);
   variable := '';
   valor := '';
   if n > 0 then begin
     variable := Copy(cadena,1,n-1);
     valor    := Copy(cadena,n+1,1024);
   end;
end;

var
   i    : integer;
   _var,
   _val : string;
   
begin 
  nomParam := LowerCase(nomParam);  
  result := defecto;
  for i := 1 to ParamCount do begin
      splt(LowerCase(ParamStr(i)),_var,_val);
      if (_var = nomParam) then begin
         result := _val;
         exit;
      end;
  end;
end;


function EjecutarYEsperar( sPrograma: String; Visibilidad: Integer ): Integer;
var
  sAplicacion: array[0..512] of char;
  DirectorioActual: array[0..255] of char;
  DirectorioTrabajo: String;
  InformacionInicial: TStartupInfo;
  InformacionProceso: TProcessInformation;
  iResultado, iCodigoSalida: DWord;
begin
  StrPCopy( sAplicacion, sPrograma );
  GetDir( 0, DirectorioTrabajo );
  StrPCopy( DirectorioActual, DirectorioTrabajo );
  FillChar( InformacionInicial, Sizeof( InformacionInicial ), #0 );
  InformacionInicial.cb := Sizeof( InformacionInicial );

  InformacionInicial.dwFlags := STARTF_USESHOWWINDOW;
  InformacionInicial.wShowWindow := Visibilidad;
  CreateProcess( nil, sAplicacion, nil, nil, False,
                 CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
                 nil, nil, InformacionInicial, InformacionProceso );

  // Espera hasta que termina la ejecución
  repeat
    iCodigoSalida := WaitForSingleObject( InformacionProceso.hProcess, 1000 );
    Application.ProcessMessages;
  until ( iCodigoSalida <> WAIT_TIMEOUT );

  GetExitCodeProcess( InformacionProceso.hProcess, iResultado );
  MessageBeep( 0 );
  CloseHandle( InformacionProceso.hProcess );
  Result := iResultado;
end;


// ----------------------------------------------------------------------------
function LetraNIF(NIF : shortstring) : shortstring;
const
     s : shortstring = 'TRWAGMYFPDXBNJZSQVHLCKET';
var
   i    : byte;
   cc   : ansichar;
   ch   : ansichar;     
   cBuf : shortstring;
begin

     cBuf := trim(NIF);

     // Ignorar valores Nulos
     if (cBuf = '') then begin
        result := '';
        exit;
     end;   

     // Detectar si hay alguna letra en el NIF que no sea la última
     for i := 1 to length(cBuf)-1 do
         if (cBuf[i] >= 'A') and (cBuf[i] <= 'Z') then begin
            result := NIF;
            exit;
         end;
     
     // Controlo si hay una letra en la última posición
     cc := copy(cbuf,length(cbuf),1)[1];

     if (cc >= 'A') and (cc <= 'Z') then
        cBuf := copy(cBuf,1,length(cBuf)-1);
     
     try
        ch := s[ (SMVAL(cBuf) mod 23) + 1 ];
     except
        ch := ' ';
     end;      

     if (cc >= 'A') and (cc <= 'Z') and (cc <> ch) then begin
        ShowMessage('Letra incorrecta o no es NIF : '+cBuf+' ['+ch+']');
        result := NIF;
     end
     else
        result := cBuf+ch;
     
end;     
// ----------------------------------------------------------------------------
function ConEnAlta(q : TDataSet) : boolean;
begin
   result := FALSE;
   if (q.FieldByName('ESTADO').AsString = 'ALTA') or
      (trim(q.FieldByName('ESTADO').AsString) = '') then result := TRUE;

end;
// ----------------------------------------------------------------------------
procedure ClonaReg(ori : TDataSet; var des : TDataSet);
var
   i : integer;
begin
      for i := 0 to ori.Fields.Count-1 do begin
         if (des.FindField(ori.Fields[i].FieldName) <> nil) then
            des.FieldByName(ori.Fields[i].FieldName).Value :=  ori.FieldByName(ori.Fields[i].FieldName).Value;
      end;
end;
// ----------------------------------------------------------------------------
function formatemi(q : TEmis) : shortstring;
begin
   result := inttostr(q.CPOBLA)+'.'+
             inttostr(q.ANO)+'.'+
             inttostr(q.PERIODO)+'.'+
             inttostr(q.BLOQUE);
end; 
// ----------------------------------------------------------------------------
procedure ponemiDB(r : TEmis; q : TDataSet);
begin
   q.fieldbyname('CPOBLA').AsInteger   := r.CPOBLA;
   q.fieldbyname('ANO').AsInteger      := r.ANO;
   q.fieldbyname('PERIODO').AsInteger  := r.PERIODO;
   q.fieldbyname('BLOQUE').AsInteger   := r.BLOQUE;
end;
function DB2Emi(q : TDataSet) : TEmis;
begin
   result.CPOBLA  := q.fieldbyname('CPOBLA').AsInteger;
   result.ANO     := q.fieldbyname('ANO').AsInteger;
   result.PERIODO := q.fieldbyname('PERIODO').AsInteger;
   result.BLOQUE  := q.fieldbyname('BLOQUE').AsInteger;
end;


function formatemiDB(q : TDataSet) : string;
begin
   result := q.fieldbyname('CPOBLA').AsString+'.'+
             q.fieldbyname('ANO').AsString+'.'+
             q.fieldbyname('PERIODO').AsString+'.'+
             q.fieldbyname('BLOQUE').AsString;
end;  
// ----------------------------------------------------------------------------

function StToEmis( e : string) : TEmis;
var
   _elementos : TStringList;
begin
    _elementos := TStringList.Create;
    try
    aElem(_elementos,e,'.');
    try
    result.CPOBLA  := smval(_elementos[0]);
    result.ANO     := smval(_elementos[1]);
    result.PERIODO := smval(_elementos[2]);
    result.BLOQUE  := smval(_elementos[3]);
    except
    result.CPOBLA  := 0;
    result.ANO     := 0;
    result.PERIODO := 0;
    result.BLOQUE  := 0;
    end;
    finally
      _elementos.Free;
    end;
end;

function PostPHP(url : string; par : array of string) : string; 
var
   http: TIdHttp;
   respuesta: string;
   params   : TStringList;
   i        : integer;
begin
   http := TIdHTTP.Create(nil);
   http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)';
   params := TStringList.Create;
   try
      for i := 0 to High(par) do  params.Add(par[i]);
 
      result := Trim(http.Post(url, params));
   finally
      http.Free;
      params.Free;
   end;
end;

function inttofloat(i : integer) : real;
begin
   result := i;
end;


function IsValidEmail(email: string): boolean;
   // Devuelve True si la dirección de email es válida
   const
     // Caracteres válidos en un "átomo"
     atom_chars = [#33..#255] - ['(', ')', '<', '>', '@', ',', ';', 
     ':', '\', '/', '"', '.', '[', ']', #127];
     // Caracteres válidos en una "cadena-entrecomillada"
     quoted_string_chars = [#0..#255] - ['"', #13, '\'];
     // Caracteres válidos en un subdominio
     letters = ['A'..'Z', 'a'..'z'];
     letters_digits = ['0'..'9', 'A'..'Z', 'a'..'z'];
     subdomain_chars = ['-', '0'..'9', 'A'..'Z', 'a'..'z'];
   type
     States = (STATE_BEGIN, STATE_ATOM, STATE_QTEXT,
     STATE_QCHAR, STATE_QUOTE, STATE_LOCAL_PERIOD,
     STATE_EXPECTING_SUBDOMAIN, STATE_SUBDOMAIN, STATE_HYPHEN);
   var
     State: States;
     i, n, subdomains: integer;
     c: char;
begin 
  State := STATE_BEGIN;
  n := Length(email); 
  i := 1;
  subdomains := 1; 
  while (i <= n) do 
    begin
      c := email[i];
      case State of 
         STATE_BEGIN: 
                  if c in atom_chars then
                  State := STATE_ATOM 
                  else if c = '"' then 
                  State := STATE_QTEXT
                  else break;
         STATE_ATOM:
                  if c = '@' then
                  State := STATE_EXPECTING_SUBDOMAIN
                  else if c = '.' then 
                  State := STATE_LOCAL_PERIOD
                  else if not (c in atom_chars) then 
                  break; 
         STATE_QTEXT:
                  if c = '\' then
                  State := STATE_QCHAR 
                  else if c = '"' then
                  State := STATE_QUOTE 
                  else if not (c in quoted_string_chars) then 
                  break; 
         STATE_QCHAR:   
                  State := STATE_QTEXT; 
         STATE_QUOTE:
                  if c = '@' then 
                  State := STATE_EXPECTING_SUBDOMAIN
                  else if c = '.' then
                  State := STATE_LOCAL_PERIOD 
                  else break; 
         STATE_LOCAL_PERIOD:
                  if c in atom_chars then
                  State := STATE_ATOM 
                  else if c = '"' then 
                  State := STATE_QTEXT
                              else break; 
         STATE_EXPECTING_SUBDOMAIN: 
                  if c in letters then
                  State := STATE_SUBDOMAIN 
                  else break;
         STATE_SUBDOMAIN:
                  if c = '.' then
                  begin 
                      inc(subdomains);
                      State := STATE_EXPECTING_SUBDOMAIN
                  end
                  else if c = '-' then 
                  State := STATE_HYPHEN
                  else if not (c in letters_digits) then 
                  break;
         STATE_HYPHEN:
                  if c in letters_digits then
                  State := STATE_SUBDOMAIN
                  else if c <> '-' then break;
      end;
      inc(i);
    end;
  if i <= n then
  Result := False
  else
  Result := (State = STATE_SUBDOMAIN) and (subdomains >= 2);
end;

//returns MD5 has for a file
 function MD5(const cad : string) : string;
 var
   idmd5 : TIdHashMessageDigest5;
   hash : T4x4LongWordRecord;
 begin
   idmd5 := TIdHashMessageDigest5.Create;
   try
     result := idmd5.HashStringAsHex(cad);
   finally
     idmd5.Free;
   end;
 end;

function fMD5(const fileName : string) : string;
var
   idmd5 : TIdHashMessageDigest5;
   fs : TFileStream;
begin
   idmd5 := TIdHashMessageDigest5.Create;
   fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
   try
      result := LowerCase(idmd5.HashStreamAsHex(fs));
   finally
      fs.Free;
      idmd5.Free;
   end;
end;


function Desencripta(const S2: String; _md5 : boolean = FALSE): String;
var
I,
Key: Word;
md5v : string;
s,
ls : string;
begin
   if s2 = '' then begin
      result := '';
      exit;
   end;
   
   s  := LeftStr(s2,2)+RightStr(s2,2);
   Key := StrToInt('$'+s);
   s   := copy(s2,3,length(s2)-4);

   if _md5 then begin
      md5v := RightStr(s,32);
      s := LeftStr(s,length(s)-32);
      if MD5(s) <> md5v then begin
         Result := '--CM--';
         exit;
      end;
   end;


   SetLength(ls,Length(S) div 2);

   SetLength(Result,Length(ls));

   for I := 1 to Length(ls) do begin
      ls[I] := char(StrToInt('$'+ Copy(S, (I*2)-1 , 2)));
   end;

   for I := 1 to Length(ls) do begin
      Result[I] := char(byte(ls[I]) xor (Key shr 8));
      Key := (byte(ls[I]) + Key) * C1 + C2;
   end;
end;


function Encripta(const S: String; _md5 : boolean = FALSE): String;
var
I,
Key: Word;
q  : word;
ls : string;
begin

randomize;
Key := 1+random(65000);
q := key;


SetLength(ls,Length(S));
Result := '';
for I := 1 to Length(S) do begin
ls[I] := char(byte(S[I]) xor (Key shr 8));
Result := Result + IntToHex(byte(ls[I]),2);
Key := (byte(ls[I]) + Key) * C1 + C2;
end;
// Meto la clave en el valor

ls := IntToHex(q,4);
result := LeftStr(ls,2)+result+iif(_md5,md5(result),'')+RightStr(ls,2);

end;

// ----------------------------------------------------------------------------
procedure BusRec(c : TDataSet; campo,valor : string; principio : boolean = TRUE);
var
   BM : TBookMark;
   vField  : string;
begin
   BM := c.GetBookmark;
   TRY
   
      c.DisableControls;
   
      if principio then
         c.First
      else 
         c.Next;
         
      valor := Trim(clearMultiByteChar(valor));
      vfield := Trim(clearMultiByteChar(c.FieldByName(campo).AsString));   
      
      while (not c.Eof) and ( (Pos(valor,vfield) = 0) and (valor <> vfield) ) do begin
         c.Next;
         vfield := Trim(clearMultiByteChar(c.FieldByName(campo).AsString));   
      end;
         
      if c.eof then c.GotoBookmark(BM);
     
   FINALLY
      c.EnableControls;
   END;      
end;
// ----------------------------------------------------------------------------
function extractSimbolFromMultiByteChar(Text: PAnsiChar): Char;
var
  Buffer: Char;
  Size: Integer;
begin

  Size := MultiByteToWideChar(0,0,Text,-1,nil,0);
  if (Size > 0) then
  begin
    MultiByteToWideChar(0 ,MB_COMPOSITE , Text,-1, @Buffer, Size);
    result := Buffer;
  end
  else
    result := ' ';
      
end;   
// ----------------------------------------------------------------------------
function clearMultiByteChar(Text: String; Upper : boolean = TRUE): String;
var
  i: Integer;
begin
  result:='';
  for I := 1 to Length(Text) do
    Result:=Result+extractSimbolFromMultiByteChar(PAnsiChar(AnsiString(text[i])));
    
  if Upper then result := UpperCase(result);  
end;
// ----------------------------------------------------------------------------
function smval(c : string) : Int64;
var
   cVal,
   cBuf : string;
   n    : Int64;
   i    : Integer;
begin
   cBuf := trim(c);
   for i := 1 to length(cBuf) do if cBuf[i] in ['0'..'9'] then cval := cval + cBuf[i];

   if cVal = '' then cVal := '0';

   result :=  strtoint64(cVal);
end;

// ----------------------------------------------------------------------------
function Direc(q : TDataSet) : string;  
var
   sig,calle, numero,bis,escalera, piso, puerta,local : string; 
begin
     try
     sig := Trim(q.fieldbyname('SIG').AsString);
     except
     sig := '';
     end;


     try
     calle := Trim(q.fieldbyname('CALLE').AsString);
     except
     calle := '';
     end;

     try
     numero := Trim(q.fieldbyname('NUMERO').AsString);
     except
         try
         numero := Trim(q.fieldbyname('NUM').AsString);
         except
            numero := '';
         end;   
     end;
     
     try
     bis := Trim(q.fieldbyname('BIS').AsString);
     except
     bis := '';
     end;
     
     try
     escalera := Trim(q.fieldbyname('ESCALERA').AsString);
     except
     escalera := '';
     end;
     
     try
     piso := Trim(q.fieldbyname('PISO').AsString);
     except
     piso := '';
     end;

     try
     puerta := Trim(q.fieldbyname('PUERTA').AsString);
     except
     puerta := '';
     end;

     try
     local := Trim(q.fieldbyname('LOCAL').AsString);
     except
     local := '';
     end;
      
     result := iif(sig <> '',sig+' ','')            +
               calle                                +
               iif(numero    <> '',', '+numero,'')  + 
               iif(bis       <> '',' '+bis,'')      +
               iif(escalera  <> '',' '+escalera,'') +
               iif(piso      <> '',' '+ piso ,'')   +
               iif(puerta    <> '',' '+puerta,'')   +
               iif(local     <> '',' '+local,'');
end; 
// ----------------------------------------------------------------------------
function Nombre(q : TDataSet) : string;
var
   ape,nom : string;
begin
      ape := Trim(q.FieldByName('APELLIDOS').AsString);
      nom := Trim(q.FieldByName('NOMBRE').AsString);

   if (ape  = '') and  (nom <> '') then begin
      result := nom;
   end
   else begin
      result := ape;
  
      if nom <> '' then 
         result := result + ', ' + nom;
         
   end;
end;
// ----------------------------------------------------------------------------
function ExecNewProcess(ProgramName : String; esperar : boolean = TRUE) : boolean;
var
  StartInfo  : TStartupInfo;
  ProcInfo   : TProcessInformation;
  CreateOK   : Boolean;
begin

  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);

  CreateOK := CreateProcess(PChar(ProgramName),nil, nil, nil,False,
              CREATE_SHARED_WOW_VDM, 
              nil, nil, StartInfo, ProcInfo);

  if CreateOK then begin
    if esperar then WaitForSingleObject(ProcInfo.hProcess, INFINITE);
  end  
  else begin
    ShowMessage('Error : '+programname);
  end;  

  result := CreateOk;

end;
// ----------------------------------------------------------------------------
function cm3(ant,act : integer; numd : integer; var nErr : byte) : integer;
var
   lant,lact : byte;
   londigit  : extended;
   anterior  : string;
begin

      anterior := inttostr(ant);
      lant := length(anterior);
      lact := length(inttostr(act));

     
     if ant > act then begin

       if numd = 0 then numd := 4;      // El número de dígitos más común

      

        londigit := power(10, numd);
        
        {
        if ((numd > 0) and (lant >= numd) and (anterior[1] = '9')) or
           ((numd = 0) and (lant > lact)  and (anterior[1] = '9')) then
           nErr := 0
        else 
           nErr := 3;
        }  
        
        act := trunc(act + londigit);
        
     end; 
     
     result := act - ant;


end;
// ----------------------------------------------------------------------------
function _m3(anterior,actual : integer) : integer;
begin
     

     if anterior > actual then
         if anterior < 10000 then     // CONTADOR HABITUAL DE 4 DIGITOS
            actual   := actual+10000
         else
            actual   := actual + trunc(power(10,length(inttostr(anterior))));

     result := actual - anterior;
     
end;   
// ----------------------------------------------------------------------------
procedure Mosm3Err(nErr : byte);
begin
   case nErr of
      1 : ShowMessage('No se introdujo ninguna lectura actual.');
      2 : ShowMessage('No se introdujo ninguna lectura anterior.');
      3 : ShowMessage('Posiblemente falsa vuelta de contador.');
   end;
end; 
// ----------------------------------------------------------------------------
function PonIncidencia(anterior,actual : integer) : integer;
begin
   if anterior < actual then 
      result := 0
   else   
   if anterior > actual then
      result := 1
   else   
      result := 2;
end;
// ----------------------------------------------------------------------------
function Instancia(AClass: TFormClass): TForm;
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
  begin
    Result := Screen.Forms[I];
    if Result.ClassType = AClass then Exit;
  end;
  Result := nil;
end;
// ----------------------------------------------------------------------------
function Lanzar(AClass: TFormClass): TForm;
begin
  Result := Instancia(AClass);
  if Assigned(Result) then
  begin
    if Result.WindowState = wsMinimized then
      Result.WindowState := wsNormal;
    Result.BringToFront;
  end
  else
    Result := AClass.Create(Application);
end;
// ----------------------------------------------------------------------------
function LForm(AClass: TFormClass; modal : boolean = TRUE): TForm;
begin
  Result := Instancia(AClass);
  if Assigned(Result) then
  begin
    if Result.WindowState = wsMinimized then Result.WindowState := wsNormal;
       Result.BringToFront;
  end
  else begin
    Result := AClass.Create(Application);
    if modal then
      result.ShowModal
    else  
      result.Show;
  end;  

    
end;
// ----------------------------------------------------------------------------
function ValidaSN( sn : string ) : string;
begin
   sn := UpperCase(sn);
   case sn[1] of
      // Español, Inglés, Francés, Alemán, Euskera
      'S','Y','O','J','B' : result := 'S';
   else
      result := 'N';
   end;
end;         
// ----------------------------------------------------------------------------
function SNToBool( sn : string ) : boolean;
begin
   result := ValidaSN(sn) = 'S';
end; 
// ----------------------------------------------------------------------------
function SN( b : boolean ) : string;
begin
    result := 'N';
    if b then result := 'S';
end;
// ----------------------------------------------------------------------------
function strzero( valor : integer; lon : integer ) : string;
begin
  // no va ¿? result := format('%.'+inttostr(lon),[valor]);
     
     result := stringreplace(format('%'+inttostr(lon)+'d',[valor]),' ','0',[rfReplaceAll])
  
end;   
// ----------------------------------------------------------------------------
function IsNumber(const S: string): Boolean;
var
  P: PChar;
begin

  P      := PChar(S);
  Result := False;
  if s = '' then exit;
  while P^ <> #0 do
  begin
    if not (P^ in ['0'..'9']) then Exit;
    Inc(P);
  end;
  Result := True;
end;
// ----------------------------------------------------------------------------
function ponBarra(st : string) : string;
begin
     if (st = '') then
        result := '.\'
     else
        if st[length(st)] = '\' then
           result := st
        else
           result := st + '\';
end; 




function QuitaSeparador( s: string ) : string;
begin
      result := stringreplace(s,ThousandSeparator,'',[rfReplaceAll]);
      // Quitar el % de los porcentajes;
      result := stringreplace(result,'%','',[rfReplaceAll]);
end;
// ----------------------------------------------------------------------------
function iif(Test: boolean; TrueR, FalseR: string): string;
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;
// ----------------------------------------------------------------------------
function iif(Test: boolean; TrueR, FalseR: integer): integer; 
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;
// ----------------------------------------------------------------------------
function iif(Test: boolean; TrueR, FalseR: extended): extended; 
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;   
// ----------------------------------------------------------------------------
function iif(Test: boolean; TrueR, FalseR: boolean): boolean; 
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end; 


procedure AsignaColores;
var
   inif : TIniFile;
begin
   inif := TIniFile.Create(_Path+'cnf_estilo.ini');
   try
      _CBAJA   := inif.ReadInteger('BrowCol','baja' ,clWhite);
      _CBAJAT  := inif.ReadInteger('BrowCol','bajat',clWhite);
      _CCORTE  := inif.ReadInteger('BrowCol','corte',clWhite);
      _OBRA    := inif.ReadInteger('BrowCol','bonif',clWhite);
      _CPEND   := inif.ReadInteger('BrowCol','pend' ,clWhite);
      _CEJE    := inif.ReadInteger('BrowCol','eje'  ,clWhite);
      _CBLO    := inif.ReadInteger('BrowCol','blq'  ,clWhite);
      _EMBARGO := inif.ReadInteger('BrowCol','emb'  ,clWhite);
      _SS      := inif.ReadInteger('BrowCol','SS'   ,clWhite);
      _PP      := inif.ReadInteger('BrowCol','PP'   ,clWhite);
         
   finally
      inif.Free;   
   end;

end;
// ----------------------------------------------------------------------------
function getCompVersion : string;
{ ---------------------------------------------------------
   Extracts the FileVersion element of the VERSIONINFO
   structure that Delphi maintains as part of a project's
   options.

   Results are returned as a standard string.  Failure
   is reported as "".

   Note that this implementation was derived from similar
   code used by Delphi to validate ComCtl32.dll.  For
   details, see COMCTRLS.PAS, line 3541.
  -------------------------------------------------------- }
const
   NOVIDATA = '';

var
  dwInfoSize,           // Size of VERSIONINFO structure
  dwVerSize,            // Size of Version Info Data
  dwWnd: DWORD;         // Handle for the size call.
  FI: PVSFixedFileInfo; // Delphi structure; see WINDOWS.PAS
  ptrVerBuf: Pointer;   // pointer to a version buffer
  strFileName,          // Name of the file to check
  strVersion : string;  // Holds parsed version number
begin

   strFileName := paramStr( 0 );
   dwInfoSize :=
      getFileVersionInfoSize( pChar( strFileName ), dwWnd);

   if ( dwInfoSize = 0 ) then
      result := NOVIDATA
   else
   begin

      getMem( ptrVerBuf, dwInfoSize );
      try

         if getFileVersionInfo( pChar( strFileName ),
            dwWnd, dwInfoSize, ptrVerBuf ) then

            if verQueryValue( ptrVerBuf, '\',
                              pointer(FI), dwVerSize ) then

            strVersion :=
               format( '%d.%d.%d.%d',
                       [ hiWord( FI.dwFileVersionMS ),
                         loWord( FI.dwFileVersionMS ),
                         hiWord( FI.dwFileVersionLS ),
                         loWord( FI.dwFileVersionLS ) ] );

      finally
        freeMem( ptrVerBuf );
      end;
    end;
  Result := strVersion;
end;

function SMCR : string;
begin
    result := '(c) Silicon Media, S.L. 1994 - '+IntToStr( YearOf(now) ); 
end;

function validaEmi(s : string; p : integer) : string;
var
   _elementos : TStringList;
begin
   result := '';

   _elementos := TStringList.Create;
   try
   _elementos.Clear;
   aElem(_elementos,s,'.');
   case _elementos.Count of
      0: result := '';
      // SOLO EL PERIODO
      1: result := inttostr(p)+'.'+inttostr(yearof(now))+'.'+s+'.0';
      // AÑO Y PERIODO      
      2: result := inttostr(p)+'.'+s+'.0';
      // AÑO, PERIODO Y BLOQUE     
      3: result := inttostr(p)+'.'+s;
      // COMPLETO
      4: result := s;
   end;   
   
   _elementos.Clear;
   aElem(_elementos,result,'.');
   //
   try
     rEmi.CPOBLA  := strtoint(_elementos[0]);
     rEmi.ANO     := strtoint(_elementos[1]);
     rEmi.PERIODO := strtoint(_elementos[2]);
     rEmi.BLOQUE  := strtoint(_elementos[3]);
   except
     rEmi.CPOBLA  := 0;
     rEmi.ANO     := 0;
     rEmi.PERIODO := 0;
     rEmi.BLOQUE  := 0;
   end;
   finally
     _elementos.Free;
   end;
   
end;

procedure EmiError;
begin
   if (rEmi.ANO < 1950) or (rEmi.ANO > 2100) then begin
      sf('Revise el año de la emisión : %d',[rEmi.ANO]);
      exit;
   end;

   if (rEmi.PERIODO < 1) or (rEmi.ANO > 12) then begin
      sf('Revise el periodo de la emisión : %d',[rEmi.PERIODO]);
      exit;
   end;

   
end;



// ----------------------------------------------------------------------------
procedure aElem(var a : TStringList; st,cSep : string);
var
   nPos : integer;
   
begin
     a.Clear;
     nPos := Pos(cSep,st);
     while (nPos <> 0) do begin

     a.Add(copy(st,1,nPos-1));
     st := copy(st,nPos+1,500);
     nPos := Pos(cSep,st);
     end;
     a.Add(copy(st,nPos+1,500));
end;

// ----------------------------------------------------------------------------
function EsNumerico(Value: string): boolean;
var
  i          : integer;
  s          : string;
  hasNumbers : boolean;
begin
  Result := True;
  hasNumbers := False;
  s := Trim(Value);
  if Length(s) = 0 then
  begin
    Result := False;
    Exit;
  end;
  for i := 1 to Length(s) do
  begin
    case Ord(s[i]) of
      ord('*')        : { Validación bancaria };
      45              : {- for negative numbers};
      40,41           : {() for negative specified by brackets};
      48..57 : hasNumbers := True; {0 to 9}
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  end;
  if not hasNumbers then
    Result := False;
end;
// ----------------------------------------------------------------------------
function eround(x: real) : real;
var
   m,
   z  : real;
begin
  {
     z  := x;
     m  := round((z-trunc(z))*100);
     m  := trunc(m)/100;
     result := trunc(z)+m;
  }
//showmessage(floattostr(result));

RESULT := ROUNDTO(X,-2);
                            
     
end;



// ---------------------------------------------------------------------------
function WinUser : string;
var
   UserName : PChar;
   Count    : Cardinal;
begin
   result := '';
   Count := 0;
   GetUserName(nil,Count);
   UserName := strAlloc(count);
   if GetUsername(UserName,count) then 
      result := strpas(userName);
   StrDispose(UserName);
end;
// ----------------------------------------------------------------------------
function Pad(s:string;n : integer; nMode : TPadMode) : string;
var nBlancos,i : integer;
var cBuf       : string;
begin
     nBlancos := n - length(s);
     cBuf     := '';

     case nMode of
     xLeft   : begin
                  cBuf := s;
                  for i := 1 to nBlancos do cBuf := cBuf + ' ';
               end;

     xRight  : begin
                  for i := 1 to nBlancos do cBuf := cBuf + ' ';
                  cBuf := cBuf + s;
               end;

     xCenter : begin
                  for i := 1 to (nBlancos div 2) do 
                      cBuf := cBuf + ' ';
                  cBuf := cBuf + s;
                  for i := 1 to (nBlancos - nBlancos div 2) 
                      do cBuf := cBuf + ' ';
               end;
    end;

    Pad := Copy(cBuf,1,n);
end;















procedure ScaleDBGridText(AGrid: TDBGrid; M, D: Integer);
var
  i : Integer;
  AColumn : TColumn;
 
  procedure ScaleFont(AFont: TFont);
  begin
  // La comparación de los Handles sirve para verificar que la
  // fuente no es la misma que la del Control, la cual ya habrá sido escalada
    if AFont.Handle <> AGrid.Font.Handle then
      AFont.Size := MulDiv(AFont.Size, M, D)
  end;
 
begin
  if M = D then EXIT;
  for i:=0 to AGrid.Columns.Count - 1 do
  begin
    AColumn := AGrid.Columns[i];
    ScaleFont(AColumn.Font);
    ScaleFont(AColumn.Title.Font);
    AColumn.Width := MulDiv(AColumn.Width, M, D);
  end;
  ScaleFont(AGrid.TitleFont);
end;
 
 
procedure GetSystemDPI(var HorizDPI, VertDPI: Integer);
var
  DC: HDC;
begin
  DC := GetDC(0);
  try
    HorizDPI := GetDeviceCaps(DC, LOGPIXELSX);
    VertDPI := GetDeviceCaps(DC, LOGPIXELSY);
  finally
    ReleaseDC(0, DC);
  end;
end;
 


initialization
  if (ParamStr(1) <> '') and DirectoryExists(ParamStr(1)) then begin
      _Path    := PonBarra(ParamStr(1));
  end
  else begin
      _Path    := ExtractFilePath(ParamStr(0));
  end;
  
  fProceso := now;
  fCompi   := GetFileDate( ParamStr(0) );
  audi     := WinUser;

  GetSystemDPI(ACTDPI_H,ACTDPI_V);
  


end.
