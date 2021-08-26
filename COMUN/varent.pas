unit varent;

interface
uses classes,db;

type
   TVarEnt = class
     private
        function  TraeFic( var xFic: string ) : boolean;
        
        
     public
        dv,
        av : TStringList;

        Ok          : boolean; 
        Manipulado  : boolean;
        errorleevar : boolean;
        errorstr    : string;

        constructor Create; 
        destructor  Destroy; override;
     
        function  Carga    : boolean;
        function  CargaBD(t : TDataSet) : boolean;
        
        function  Lee(x : string) : string; overload;
        
        function  Lee(x,defecto : string) : string; overload;
        
        procedure Pon(et,x : string; db : boolean = FALSE );
        

   end;
var
   ent    : TVarEnt;

const
   smGlob          = 'SMCONF.LOCAL';
   smConf          = 'SMCONF.CONSTR';
   esta_manipulado = '--CM--';



(*
  Devuelve el path con la variable de entorno DirInformes
  o _Path si no la encuentra.
*)  

function DirDoc : string;   
   
implementation
uses sysutils,strutils, smKernel;


function DirDoc : string;   
var
   di : string;
begin
   di := ent.Lee('DirInformes','');

   if (di = '') or (not DirectoryExists(di)) then di := smKernel._Path;
   
   result := PonBarra(di);
end;

constructor TVarEnt.Create; 
begin
   inherited;

   av := TStringList.Create;
   av.CaseSensitive := FALSE;
   
   dv := TStringList.Create;
   dv.CaseSensitive := FALSE;
   
   Ok := FALSE;
   Manipulado := FALSE;
        
end;   

destructor TVarEnt.Destroy;
begin
   av.Free;
   dv.Free;
   
   inherited;
end;

function TVarEnt.Carga : boolean;
var
   bf  : TStringList;
   i   : integer;
   gl,
   ubi,
   cn  : string;
   
   cBuf : string;
  
begin
   Result := FALSE;

   
   gl := smGlob;
   cn := smConf;


   // ANALIZO SI SE PASA COMO PARÁMETRO LA UBICACION DEL FICHERO DE CONFIGURACIÓN
   ubi := ParamStr(1);
   if ubi <> '' then begin
   
         // %PATH% = ParamStr(0) : %PATH%\benissa = d:\v16\benissa (ejemplo)
         ubi := stringreplace(ubi,'%PATH%',smKernel.ponBarra(_path),[rfIgnoreCase]);
         ubi := smKernel.ponBarra(ubi);
         
         if FileExists(ubi+gl) then gl := ubi+gl;
         
         if FileExists(ubi+cn) then begin
            cn := ubi+cn;
            smKernel._Path := ubi;
         end
         else begin
            errorstr := format('No se encontró SMCONF.CONSTR en %s.',[ubi]);
            exit;
         end;
           
   end;
   
   if av.Count > 0 then av.Clear;

   bf := TStringList.Create;
   try
      // CARGO VARIABLES GLOBALES   
      if TraeFic(gl) then begin
         bf.LoadFromFile(gl);
         av.Text := bf.Text;
      end;

      bf.Clear;
      
     // CARGO VARIABLES LOCALES   
      if TraeFic(cn) then begin
         try
            bf.LoadFromFile(cn);
            // QUITO EL CR+LF
            cBuf := LeftStr(bf.Text,length(bf.Text)-2);

            bf.Text := Desencripta(cBuf,TRUE);
            
            Manipulado := (bf.Text = esta_manipulado);
            Ok         := not Manipulado;
            
            if not ok  then begin
               errorstr := 'El formato de SMCONF.CONSTR no es válido.';
               exit;
            end; 
           
            for i := 0 to bf.Count - 1 do begin
               Pon(bf.Names[i],bf.ValueFromIndex[i])
            end;
            
         except
            on e : exception do begin
                errorstr := e.Message;
            end;
         end;
         
      end
      else begin
         errorstr := 'No se encontró SMCONF.CONSTR';
         exit;
      end;
      
   finally
     av.Sort;
     FreeAndNil(bf);
   end; 

   result := TRUE;
end;

function  TVarEnt.CargaBD(t : TDataSet) : boolean;
var
   Cerrar : boolean;
begin

    if not t.Active then begin
       Cerrar := TRUE;
       t.Active := TRUE;  
    end
    else begin
      Cerrar := FALSE;
    end;

    t.DisableControls;
    TRY
    t.First; 
    while not t.eof do begin
      if t.FieldByName('TIPO').AsString = 'M' then
         Pon(t.FieldByName('ID').AsString,t.FieldByName('TEXTO').AsString,TRUE)
      else
         Pon(t.FieldByName('ID').AsString,t.FieldByName('VALOR').AsString,TRUE);
      t.Next;
    end;
    FINALLY
      t.EnableControls;
    END;

    dv.Sort;

    if Cerrar then t.Active := FALSE;

    result := TRUE
    
end;


procedure TVarEnt.Pon(et,x : string; db : boolean = FALSE);
var
   z : integer;
begin

if db then begin 
   if trim(x) <> ''  then begin
      z := dv.IndexOfName(et);

      if z > -1 then 
         dv.ValueFromIndex[z] := x
      else
         dv.Add(et+'='+x);
   end;  
end
else begin
   if trim(x) <> ''  then begin
      z := av.IndexOfName(et);

      if z > -1 then 
         av.ValueFromIndex[z] := x
      else
         av.Add(et+'='+x);
   end;  
end;

end;

function  TVarEnt.Lee(x : string) : string;
var 
   z : integer;
begin
 errorleevar := TRUE;
 result      := '';
 z := av.IndexOfName(x);

 if z > -1 then begin
   Result := av.ValueFromIndex[z];
   errorleevar := FALSE;
 end;

 // SI NO ESTÁ EN FICHEROS BUSCAR EN BD
 if errorleevar then begin
 
   z := dv.IndexOfName(x);

   if z > -1 then begin
       Result := dv.ValueFromIndex[z];
       errorleevar := FALSE;
   end;
 
 end;
end;

function  TVarEnt.Lee(x,defecto : string) : string; 
begin
   result := Lee(x);
   
   if result = '' then begin
      result := defecto;
   end;
end;

function TVarEnt.TraeFic( var xFic : string ) : boolean;
var
   gp : string;
begin
   result := FALSE;
   
   if fileexists(xFic) then begin
     result := TRUE;
     exit;
   end;

   gp := Lee('GlobalPath','');
   
   if (gp <> '') and (fileexists( smKernel.PonBarra(gp) + xFic)) then begin
      xFic := smKernel.PonBarra(gp) + xFic;
      result := TRUE;
      exit;
   end;
   
end;

initialization
ent    := TVarEnt.Create;
ent.ok := ent.Carga;



finalization
if assigned(ent) then 
try
   ent.Free;
except
end;   

end.        
