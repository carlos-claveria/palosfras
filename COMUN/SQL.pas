
(* -------------------------------------------------------------------------

   SQL
   
   CCD AGO-09
   
   Permite hacer llamadas SQL directamente desde la linea de código

   Ejemplo:

   q := Tsql.Create('SELECT * FROM TEST WHERE ID = :ID');
   q.AddParam('ID',ftInteger,13445);
   if q.Go then
      while not q.eof do begin
         c := q.d.FiedByName...
        {...}
        q.Next;
      end;

   d -> Representa el ClientDataSet

   Go       -> Abre la consulta
   Update   -> Actualiza cambios 
   Next     -> d.Nex;
   Eof      -> d.Eof    
   AddParam -> Permite trabajar con parámetros. 

   Todas las comillas dobles ["] se sustituirán por comillas simples [']

   {
   // CAMBIA EL * POR TODOS LOS CAMPOS
   nLectu.d.FieldDefs.Update;

   for i := 0 to nLectu.d.FieldDefs.Count - 1 do
   begin
      Field := nLectu.d.FieldDefs[i].CreateField(nLectu.d);
      cBuf  := cBuf + Field.FieldName +',';
   end;

   cBuf := LeftStr(cBuf,length(cBuf)-1);
   nLectu.d.CommandText := StringReplace(nLectu.d.CommandText,'*',cBuf,[]);
   }
    
         
   ------------------------------------------------------------------------- *)


unit SQL;

interface
uses classes,sysutils,dialogs,DBClient,windows,DB;

type
  Tsql        = class
  private
    _sql     : string;
    procedure AfterExecute(Sender: TObject; var OwnerData: OleVariant);  
  public

      ok : integer;
      d  : TClientDataSet;
      esSELECT : boolean;
      tiempo   : string;
      dbErr    : string;
      MosErr   : boolean;
      
   
      constructor Create; OVERLOAD;
      constructor Create(x : string); OVERLOAD;
      constructor Create(x : string; const Args: array of const); OVERLOAD;
      
      constructor Create(x : array of string); OVERLOAD;
      constructor Create(x : array of string; const Args: array of const); OVERLOAD;
      
      destructor  Destroy; override;
      
      procedure   AsignaSQL(x : string);   OVERLOAD;
      procedure   AsignaSQL(x : array of string); OVERLOAD;

      procedure   AddParam( campo : string; tipo : TFieldType; valor : variant); overload;
      
      procedure   AddParam( campo : string; tipo : TFieldType); overload;
      
      function    Go: boolean;
      procedure   Next;
      function    Eof : boolean;
      function    Update : boolean;
      procedure   ORE(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
      
  end;

var
   // RemServer  := br.lc;   
   RemServer : TCustomRemoteServer;

implementation
uses errores, idioma,crono;

// ---------------------------------------------------------------------------
// CLASE Tsql
// ---------------------------------------------------------------------------

constructor Tsql.Create;
begin
   d := TClientDataSet.Create(nil);   
   d.OnReconcileError := ORE;
   d.RemoteServer := RemServer;
   d.ProviderName := 'pSQL';
   d.AfterExecute := AfterExecute;
   d.Params.Clear;

   MosErr := true;
end;


// CADENA DE CARACTERES Y PARÁMETROS
constructor Tsql.Create(x : string; const Args: array of const); 
begin
   d := TClientDataSet.Create(nil);   
   d.OnReconcileError := ORE;
   d.RemoteServer := RemServer;
   d.ProviderName := 'pSQL';
   d.AfterExecute := AfterExecute;
   d.Params.Clear;
   
  
   AsignaSQL(Format(x,Args));

   MosErr := true;
   
end;

// ARRAY DE STRINGS Y PARÁMETROS
constructor Tsql.Create(x : array of string; const Args: array of const); 
var
   i    : integer;
   cBuf : string;
begin
   cBuf := '';
   for i  := low(x) to high(x) do cBuf := cBuf + trim(x[i])+' ';

   d := TClientDataSet.Create(nil);  
   d.OnReconcileError := ORE;
   d.RemoteServer := RemServer;
   d.ProviderName := 'pSQL';
   d.AfterExecute := AfterExecute;
   d.Params.Clear;

   AsignaSQL(Format(cBuf,Args));

   MosErr := true;
   
end;

// CADENA DE CARACTERES
constructor Tsql.Create(x : string);  
begin
   d := TClientDataSet.Create(nil);  
   d.OnReconcileError := ORE;
   d.RemoteServer := RemServer;
   d.ProviderName := 'pSQL';
   d.AfterExecute := AfterExecute;
   d.Params.Clear;
   
    AsignaSQL(x);

   MosErr := true;
    
end;   
// ARRAY DE STRINGS
constructor Tsql.Create(x : array of string);  
var
   i    : integer;
   cBuf : string;
begin

  cBuf := '';
  for i  := low(x) to high(x) do cBuf := cBuf + trim(x[i])+' ';
   
   d := TClientDataSet.Create(nil);   
   d.RemoteServer := RemServer;
   d.ProviderName := 'pSQL';
   d.AfterExecute := AfterExecute;
   d.Params.Clear;
   
   
   AsignaSQL(cBuf);

   MosErr := true;
   
end;   
// ---------------------------------------------------------------------------
destructor Tsql.Destroy;
begin
      if d.Active then d.Close;
      d.Free;
   
   inherited;
end;
// ---------------------------------------------------------------------------

procedure   TSQL.ORE(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  begin
     ApplicationShowException(E);
  end;

procedure   Tsql.AsignaSQL(x : array of string);
var
   i    : integer;
   cBuf : string;
begin
   cBuf := '';
   for i  := low(x) to high(x) do cBuf := cBuf + trim(x[i])+' ';
  AsignaSQL(cBuf);
end;

procedure Tsql.AsignaSQL(x : string);
begin
   if d.Active then d.Close;
   _sql := TRIM(StringReplace(x,'"','''',[rfReplaceAll]));
   esSELECT := UpperCase(copy(_sql,1,6)) = 'SELECT';
   d.CommandText := _sql;
   
end;
// ---------------------------------------------------------------------------
function Tsql.Update : boolean;
begin
   result := TRUE;
   ok     := 0;
   dbErr  := '';
   
   
   if assigned(d) and d.Active then begin
      if d.State in [dsEdit,dsInsert] then d.Post;
      try
         ok := d.ApplyUpdates(0);
      except    
         on e: Exception do begin
            dbErr := e.Message; 
            if MosErr then _err.Pon('SQL',_ACTERROR+#13+#10+_SQL,e,TRUE);
            ok := -2;
            result := FALSE;
         end;   
      end;
   end;
   
end;   
// ---------------------------------------------------------------------------
procedure Tsql.AddParam( campo : string; tipo : TFieldType; valor : variant);
begin

    if Assigned(d.Params.FindParam(campo)) then
      with d.Params.ParamByName(campo) do begin
         DataType := tipo;
         Value    := valor;
      end
    else
      d.Params.CreateParam(tipo,campo,ptInput).Value := valor;
end;

procedure Tsql.AddParam( campo : string; tipo : TFieldType); 
begin
    if Assigned(d.Params.FindParam(campo)) then
      with d.Params.ParamByName(campo) do begin
         DataType := tipo;
      end
    else  
      d.Params.CreateParam(tipo,campo,ptInput);
end;

// ---------------------------------------------------------------------------
procedure Tsql.Next;
begin
   d.Next;
end;
// ---------------------------------------------------------------------------
function Tsql.Eof : boolean;
begin
   result := d.eof;
end;   
// ---------------------------------------------------------------------------
function Tsql.Go: boolean;
var
   cron : TCron;
begin

  result := TRUE;
  ok     := 0;
  dbErr  := '';
    try
      cron.start;
      if esSELECT then begin
         d.Open; 
      end
      else
         d.Execute;
      cron.stop;
      tiempo := cron.dif;   
            
    except    
       on e: Exception do begin
          dbErr := e.Message; 
          if MosErr then _err.Pon('SQL','Error en sentencia SQL:'+#13+#10+_SQL,e,TRUE);
          ok := -1;
          result := FALSE;
       end;   
    end;
 
end;
// ---------------------------------------------------------------------------
procedure Tsql.AfterExecute(Sender: TObject; var OwnerData: OleVariant);
begin
//
end;
  
end.
