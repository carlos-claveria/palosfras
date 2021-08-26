unit smKernel;

interface
uses classes,DB,controls,system.Types,sysutils;

type
    TCharSet = SET OF CHAR;


// Envía un objeto JSON a un url
function JSONPHP(url : string; par : string) : string;
    
// Byte a binario    
function IntToBin(Value: byte): string;     
function BinToInt(Value: string): Integer;

procedure EnabledAsParent(container: TWinControl) ;

 // Implemento el iif de toda la vida
 function iif(Test: boolean; TrueR, FalseR: string)  : string; overload;
 function iif(Test: boolean; TrueR, FalseR: integer) : integer; overload;
 function iif(Test: boolean; TrueR, FalseR: extended): extended; overload;
 function iif(Test: boolean; TrueR, FalseR: boolean) : boolean; overload;
    

 // Convierte un entero en string con ceros por la izquierda
 function strzero( valor : integer; lon : integer ) : string;
 function strzerof(const n : Real; const l,d : byte) : string;
 

 // pasa la string [st] a un TStringlist [a] separado por [cSep]
 procedure aElem(var a : TStringList; st,cSep : string);

// Determina si la string sólo contiene os caracteres del set;
function stInSet(st : string; t : TCharSet) : Boolean;

// Muestra El Copy Right desde 1994
function SMCR : string;

{: Devuelve una lista de nombres de fichero encontrados a partir de la
     carpeta inicial StartDir, que cumplen el patrón especificado por
     FileMask.Mediante recursively se indica si se desea hacer la busqueda 
     en los subdirectorios.
     
 StartDir     Carpeta desde la que empezar a buscar.
 FileMask    Patrón que han de cumplir los ficheros.
 Recursively Si hay que continuar la búsqueda en los subdirectorios.
 FilesList    Lista con los nombres de fichero encontrados.
}
procedure FindFiles(StartDir, FileMask: string; recursively: boolean; var FilesList: TStringList);


{ Añade la barra al final de la ruta
  de moento solo válido para windows.
}
function ponBarra(st : string) : string;

{
   Obtiene la fecha de la última modificación de un fichero
}
function GetFileDate(Nombre: string): TDateTime;

{
Devuelve el usuario de windows
}

function WinUser : string;

{
 Puntos por pulgada de la resolución de pantalla
}

procedure GetSystemDPI(var HorizDPI, VertDPI: Integer);


/// Tamaño del fichero
function FileSize(const aFilename: String): Int64;

/// formato SQLite en select: datetime(julianday(FECHA))
function litefecha( f : string) : TdateTime;

 // Obtiene la versión de la compilación
 function getCompVersion : string;

 function Desencripta(const S2: String; _md5 : boolean = FALSE): String;
 function Encripta(const S: String; _md5 : boolean = FALSE): String;
 
 function MD5(const cad : string) : string;
 function fMD5(const fileName : string) : string;

  // FUERZA LA CONVERISON DE UNA CADENA A NUMERICO ELIMINANDO 
 // CARACTERES NO NUMÉRICOS
 function smval(c : string)  : Int64;

function FieldChanged(DataSet: TDataSet; FieldName: string): Boolean; overload;
function FieldChanged(DataSet: TDataSet; FNs: array of string): Boolean; overload;
 
 // No es muy estricta pero vale
 function IsIP(st : string) : Boolean;

// Devuelve la zona horaria
function GetTimeZone: integer; 

// En España horario de verano se combina con la anterior
function IncrementoHora : Integer;

// Devuuelve el incremento horario en España teniendo en ceunta el verano
function GMT2SP : integer; overload;

// Pasa un float Anglosajón [.] a un float español.
// uso para rutinas MAP/GIS
function UK2SPFloat( x : string   ) : extended; overload;
function UK2SPFloat( x : extended ) : extended; overload;

// Pone a la fecha hora, minuto y segundo a cero
function fechaDesde(f : TDateTime ) :TDateTime; 
  
// Pone a la fecha hora, minuto y segundo a final del día
function fechaHasta(f : TDateTime ) :TDateTime; 


function UltimaFechaSemana(x : TDateTime) : TDateTime;
function PrimeraFechaSemana(x : TDateTime) : TDateTime;
 
function DateTimeToUnix(dtDate: TDateTime): Longint;
function UnixToDateTime(USec: Longint): TDateTime;


//Redondea una fecha a la hora en punto
function RoundHora(f : TDateTime) : TDateTime;
function RoundMinuto(f : TDateTime) : TDateTime;

function PauseFunc(delay: DWORD) : Boolean; overload;
function PauseFunc(delay: DWORD; key : word) : Boolean; overload;
function PauseFunc(delay: DWORD; key : array of word) : word; overload;




/// SM - CCD Adaptado para ficheros UTF-8
function LoadFileToStr(const FileName: TFileName): string;
function SaveStrToFile(const s : string; const FileName: TFileName): string;



procedure EmptyKeyQueue;

function LeftPad(PadString : string ; HowMany : integer ; PadValue : string): string;


var
 _IDAPL    : string;    /// Identificador de la aplicación



  fProceso : TDateTime; /// Fecha de proceso
  fCompi   : TDateTime; /// Fecha de la última compilación
  usuario  : string;    /// Nombre del usuario
  audi     : string;    /// Nombre del usuario (procesos de auditacion)
  _Path    : string;    /// Ruta de almacenamiento de ficheros temporales
  nDB      : integer;   /// Tipo de base de datos [0] MySQL [2] Oracle
  ACTDPI_H : integer;   /// Resolución Horizontal ppp
  ACTDPI_V : integer;   /// Resolución Vertical ppp

const
   _TODAS = '<todas>';
   c1        = 44345;
   c2        = 22433;  
   CR        = #10+#13;
   DEFDPI    = 96;       // Pixels por pulgada;
  __MySQL   = 0;
  __Oracle  = 2;
  
  ThousandSeparator = '.';
  UnixStartDate: TDateTime = 25569.0; // 01/01/1970  

  __DIPUALC = TRUE;
   

implementation
uses DateUtils,windows,messages, IdHashMessageDigest,strutils,system.Variants,forms,idHttp;




function JSONPHP(url : string; par : string) : string;
var
   http: TIdHttp;
   i        : integer;
   RequestBody: TStream;
   ResponseBody: string;
begin
   http := TIdHTTP.Create(nil);
   http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)';

   http.ReadTimeout := 15000; 

   RequestBody := TStringStream.Create(par, TEncoding.UTF8);

        HTTP.Request.Accept := 'application/json';
        HTTP.Request.ContentType := 'application/json';

      result := Trim(http.Post(url,RequestBody));
      http.Free;
end;

function LeftPad(PadString : string ; HowMany : integer ; PadValue : string): string;
var
   Counter : integer;
   x : integer;
   NewString : string;
begin
   Counter := HowMany - Length(PadString);
   for x := 1 to Counter do
   begin
      NewString := NewString + PadValue;
   end;
   Result := NewString + PadString;
end;

procedure EmptyKeyQueue;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do;
end;

function RoundHora(f : TDateTime) : TDateTime;
var
   y,m,d,h,n,s,ms : Word;
begin
   DecodeDateTime(f,y,m,d,h,n,s,ms);
   Result := EncodeDateTime(y,m,d,h,0,0,0);
end;
function RoundMinuto(f : TDateTime) : TDateTime;
var
   y,m,d,h,n,s,ms : Word;
begin
   DecodeDateTime(f,y,m,d,h,n,s,ms);
   Result := EncodeDateTime(y,m,d,h,n,0,0);
end;


function PauseFunc(delay: DWORD) : Boolean;
var
  lTicks: DWORD;
begin
  lTicks := GetTickCount + delay;
  Result := False;
  repeat
    Sleep(100);
    Application.ProcessMessages;
  until (lTicks <= GetTickCount);
  EmptyKeyQueue;
end;

function PauseFunc(delay: DWORD; key : word) : Boolean;
var
  lTicks: DWORD;
begin

  lTicks := GetTickCount + delay;
  Result := False;
  
  repeat
    Sleep(100);
    result := (Windows.GetKeyState(key) < 0);
    Application.ProcessMessages;
  until (lTicks <= GetTickCount) or Application.Terminated or result;
  EmptyKeyQueue;
end;



function PauseFunc(delay: DWORD; key : array of word) : word;
var
  lTicks: DWORD;
  i     : byte;
  
begin
  lTicks := GetTickCount + delay;
  Result := 0;
  
  repeat
  
    Sleep(100);
    Application.ProcessMessages;
    
    for i := low(key) to high(key) do begin
    
      if (GetKeyState(key[i]) < 0) then begin
        result := key[i];
        break;
      end;
      
    end;
    
    
  until (lTicks <= GetTickCount) or Application.Terminated or (result <> 0);
  
//  EmptyKeyQueue; 
  Application.ProcessMessages;
  
end;



function LoadFileToStr(const FileName: TFileName): String;
var
  FileStream : TFileStream;
  Bytes: TBytes;

begin
  Result:= '';
  FileStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    if FileStream.Size>0 then begin
      SetLength(Bytes, FileStream.Size);
      FileStream.Read(Bytes[0], FileStream.Size);
    end;
    Result:= TEncoding.UTF8.GetString(Bytes);
  finally
    FileStream.Free;
  end;
end;

  
function SaveStrToFile(const s : string; const FileName: TFileName): string;
var
  FileStream : TFileStream;
  Bytes: TBytes;
  i    : integer;
begin
  Result := '';

  try
  
      FileStream := TFileStream.Create(FileName,fmCreate);
      try
         for i := 1 to length(s) do FileStream.Write( byte(s[i]),1 );
      finally
         FileStream.Free;
      end;    

  except
     on e: exception do begin
        result := e.Message;
     end;
  end;
 
end;







function DateTimeToUnix(dtDate: TDateTime): Longint;
begin
  Result := Round((dtDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime;
begin
  Result := (Usec / 86400) + UnixStartDate;
end;




function UltimaFechaSemana(x : TDateTime) : TDateTime;
begin
   result := IncDay(x, 7-DayOfTheWeek(x));
end;  

function PrimeraFechaSemana(x : TDateTime) : TDateTime;
begin
   result := IncDay(x, (DayOfTheWeek(x)-1)*-1);
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
   result := EncodeDateTime(a,m,d,23,59,59,999);
end; 


function UK2SPFloat( x : string ) : Extended; overload;
var
   cBuf : string;
begin
   if Trim(x) = '' then 
      Result := 0.0
   else begin   
      cBuf := StringReplace(x,'.',',',[]);
      Result := StrToFloat(cBuf);
   end;
end;
function UK2SPFloat( x : Extended    ) : Extended; overload;
begin
   Result := UK2SPFloat(FloatToStr(x));
end;



function GetTimeZone: integer; 
var 
  TimeZone: TTimeZoneInformation; 
begin 
  GetTimeZoneInformation(TimeZone); 
  Result := TimeZone.Bias div -60; 
end; 

function IncrementoHora : Integer;
var
   y  : Word;
   i,f : TDateTime;
begin
   y := YearOf(now);
   i := EncodeDateTime(y,3,29,2,0,0,0);   // Inicio verano +1
   f := EncodeDateTime(y,10,25,3,0,0,0);  // Fin verano -1

   Result := 0;
   if (Now > i) and (Now < f) then Result := 1;
end;

function GMT2SP : integer; overload;
begin
   result := GetTimeZone + IncrementoHora;
end;


function BinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  for i := iValueSize downto 1 do
    if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
end;


function IntToBin(Value: byte): string;
var
  i: Integer;
begin
  Result := '';
  for i := 7 downto 0 do
    if Value and (1 shl i) <> 0 then
      Result := Result + '1'
  else
    Result := Result + '0';
end;

function IsIP(st : string) : Boolean;
var
   i,j : Byte;
const
   dd = ['0'..'9','.'];
begin
   result := False;
   j := 0;
   for i := 1 to Length(st) do begin
      if not (st[i] in dd) then Exit;
      if (st[i] = '.') then inc(j);
   end;
   
   if j = 3 then result := True;
end;


function FieldChanged(DataSet: TDataSet; FieldName: string): Boolean;
var
  fld: TField;
begin
  fld := DataSet.FieldByName(FieldName);

  if fld.IsBlob then
    Exit((fld as TBlobField).Modified);

  if (fld.OldValue = Null) and (fld.NewValue = Unassigned) then // This happens when a NULL field does not change
    Exit(False)
  else
    Exit(fld.OldValue <> fld.NewValue);
end;

function FieldChanged(DataSet: TDataSet; FNs: array of string): Boolean;
var
   i : Byte;
begin
   Result := false;
   for i := Low(FNs) to High(FNs) do begin
     Result := FieldChanged(DataSet,FNs[i]);
     if Result then Break;
   end;
end;







function litefecha( f : string) : TdateTime;
var
   a,m,d,h,n,s,ms : word;
   kk : string;
begin   

kk := f;  

   a  := strtoint( copy(f, 1,4) );
   m  := strtoint( copy(f, 6,2) );
   d  := strtoint( copy(f, 9,2) );
   h  := strtoint( copy(f,12,2) );
   n  := strtoint( copy(f,15,2) );
   s  := strtoint( copy(f,18,2) );
   ms := 0;                        

   
   result := EncodeDateTime(a,m,d,h,n,s,ms);
  
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


 function strzero( valor : integer; lon : integer ) : string;
 begin
    result := SysUtils.Format('%.*d', [lon,valor]) ;
 end;
 
function strzerof(const n : Real; const l,d : byte) : string;
var S : string;
begin
     S := format('%'+inttostr(l+d+1)+'.'+inttostr(d)+'f',[n]);
     while Pos(' ', S) > 0 do S[Pos(' ', S)] := '0';
     strzerof := S;
end;

 
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

function stInSet(st : string; t : TCharSet) : Boolean;
var
   i : Integer;
begin
    Result := Length(st) > 0;
    i := 1;
    while Result and (i <= Length(st)) do
    begin
      Result := Result AND (st[i] in t);
      inc(i);
    end;
    if  Length(st) = 0 then Result := true;
  end;

function SMCR : string;
begin
//10C    result := '(c) Silicon Media, S.L. 1994 - ' + YearOf(now).ToString; 
         result := '(c) Silicon Media, S.L. 1994 - ' + IntToStr(YearOf(now));

end;

{: Devuelve una lista de nombres de fichero encontrados a partir de la
     carpeta inicial StartDir, que cumplen el patrón especificado por
     FileMask.Mediante recursively se indica si se desea hacer la busqueda 
     en los subdirectorios.
 StartDir     Carpeta desde la que empezar a buscar.
 FileMask    Patrón que han de cumplir los ficheros.
 Recursively Si hay que continuar la búsqueda en los subdirectorios.
    FilesList    Lista con los nombres de fichero encontrados.
  }
  procedure FindFiles(StartDir, FileMask: string; recursively: boolean; var FilesList: TStringList);
  const
    MASK_ALL_FILES = '*.*';
    CHAR_POINT = '.';
  var
    SR: SysUtils.TSearchRec;
    DirList: TStringList;
    IsFound: Boolean;
    i: integer;
  begin
    if (StartDir[length(StartDir)] <> '\') then begin
      StartDir := StartDir + '\';
    end;
  
    // Crear la lista de ficheos en el directorio StartDir (no directorios!)
    IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
    // MIentras encuentre
    while IsFound do  begin
      FilesList.Add(StartDir + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
  
    SysUtils.FindClose(SR);
  
    // Recursivo?
    if (recursively) then begin
      // Build a list of subdirectories
      DirList := TStringList.Create;
      // proteccion
      try
        IsFound := FindFirst(StartDir + MASK_ALL_FILES, faAnyFile, SR) = 0;
        while IsFound do
        begin
          if ((SR.Attr and faDirectory) <> 0) and
            (SR.Name[1] <> CHAR_POINT) then
            DirList.Add(StartDir + SR.Name);
          IsFound := FindNext(SR) = 0;
        end;
        SysUtils.FindClose(SR);
  
        // Scan the list of subdirectories
        for i := 0 to DirList.Count - 1 do
          FindFiles(DirList[i], FileMask, recursively, FilesList);
      finally
        DirList.Free;
      end;
    end;
  end;

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

function FileSize(const aFilename: String): Int64;
  var
    info: TWin32FileAttributeData;
  begin
    result := -1;

    if NOT GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @info) then
      EXIT;

    result := Int64(info.nFileSizeLow) or Int64(info.nFileSizeHigh shl 32);
  end;
 

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

function MD5(const cad : string) : string;
 var
   idmd5 : TIdHashMessageDigest5;
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

function smval(c : string) : Int64;
var
   cVal,
   cBuf : string;
   i    : Integer;
begin
   cBuf := trim(c);
   for i := 1 to length(cBuf) do if cBuf[i] in ['0'..'9'] then cval := cval + cBuf[i];

   if cVal = '' then cVal := '0';

   result :=  strtoint64(cVal);
end;


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
  usuario  := audi;

  GetSystemDPI(ACTDPI_H,ACTDPI_V);
  

end.
