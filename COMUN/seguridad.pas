(* -------------------------------------------------------------------------
   UTILIDADES DE SEGURIDAD Y LICENCIA 
   
   CCD OCT-11
   Las funciones _ini,_enc,_dec quedan obsoletas ya que SMCONF.CONSTR hace las
   funciones de fichero de licencia.

   DEFINE V15 anula estas funciones

   NOTA El parámetro TForm sobra... basta con un create(rep.Owner)

   
   CCD AGO-09
   _ini, _enc, _dec ... son funciones para tratar la clave de la licencia y
   verificar si es un usuario registrado.
   
   INCLUSION DE DATOS DEL CLIENTE EN EL INFORME
   
   Estos procedimientos pone en los listado en modo 'hard code' los datos del usuario
   como medida de protección.

   Símplemente:

            sCabRep(self,rep);
            sPieRep(self,rep);
            
            rep.Print;
   
   ------------------------------------------------------------------------- *)

{$DEFINE V15}
   
unit seguridad;
 
interface
uses {$IFNDEF V15}LbCipher, LbString, nativexml,{$ENDIF}Forms,ppReport, ppPrnabl,
  ppCtrls, Graphics,sysutils;

type TPrestaciones = (PrSileco,PrPartes,PrFacturas,PrVoluntaria,PrEjecutiva,
                      PrContable,PrAudi,PrPlanif,PrExped,PrRemoto,PrSUMA,
                      PrCanonCV,PrAgrupadas,prSecHid);  
type TLicencia = record
  NumUsuarios : integer;
  UF          : integer;
  pr          : set of TPrestaciones;
end;

  
procedure sPieRep( f : Tform;  rep : TppReport);
procedure sCabRep( f : Tform;  rep : TppReport);
procedure sPonTit( x : string;  rep : TppReport);

procedure CargaLic;
  
{$IFNDEF V15}
procedure _ini;   

function _enc(st : string) : string;   // Encripta la cadena
function _dec(st : string) : string;   // Desencripta la cadena
function _val(st : string) : boolean;  // valida un fichero del tipos SERIE.XML
function _cpc(st : string) : string;   // Compone la cadena objeto de la clave;
function _seg              : boolean;  // Identifica si es usuario registrado;


   

const 
   k : array[0..20] of byte = (11,23,45,78,99,5,23,44,65,221,12,33,54,56,75,99,12,67,98,112,23);

{$ENDIF}

var
   rLicencia : TLicencia;
   {$IFNDEF V15}Key128  : TKey128; {$ENDIF}

implementation

uses varent,dialogs;

procedure CargaLic;
var
   cBuf : string;
begin
  cBuf := ent.Lee('MaxUF','1000');
  if cBuf = '<ilimitado>' then cBuf := '999999';
  
  rLicencia.UF := StrToInt(cBuf); 
  
  cBuf := ent.Lee('MaxUsr','1');
  if cBuf = '<ilimitado>' then cBuf := '9999';
  
  rLicencia.NumUsuarios := StrToInt(cBuf);
  
  rLicencia.pr := [];
  cBuf := ent.Lee('AplActivas');

  
  with rLicencia do begin
      if(cBuf[ 1] = '5') then pr := pr + [PrSileco];
      if(cBuf[ 2] = '5') then pr := pr + [PrPartes];
      if(cBuf[ 3] = '5') then pr := pr + [PrFacturas];
      if(cBuf[ 4] = '5') then pr := pr + [PrVoluntaria];
      if(cBuf[ 5] = '5') then pr := pr + [PrEjecutiva];
      if(cBuf[ 6] = '5') then pr := pr + [PrContable];
      if(cBuf[ 7] = '5') then pr := pr + [PrAudi];
      if(cBuf[ 8] = '5') then pr := pr + [PrPlanif];
      if(cBuf[ 9] = '5') then pr := pr + [PrExped];
      if(cBuf[10] = '5') then pr := pr + [PrRemoto];
      if(cBuf[11] = '5') then pr := pr + [PrSUMA];
      if(cBuf[12] = '5') then pr := pr + [PrCanonCV];
      if(cBuf[13] = '5') then pr := pr + [PrAgrupadas];
      if(cBuf[14] = '5') then pr := pr + [PrSecHid];
  end;
  
end;

procedure sPonTit( x : string;  rep : TppReport);
var
   a : TppLabel;   
begin
         a             := TppLabel.Create(rep.Owner);
         a.Band        := rep.HeaderBand;  
         a.Font.Size   := 14;
         a.Transparent := FALSE;
         a.spTop       := (rep.HeaderBand.spHeight-(rep.HeaderBand.spHeight-10))+80;
         a.Caption     := x;
         a.spLeft      := (rep.HeaderBand.spWidth -  a.spWidth) div 2
end;

procedure sCabRep( f : TForm; rep : TppReport);

var
   a : array[1..5] of TppLabel;
   i : integer;
begin

 // PUEDE LLEGAR UN INFORME SIN NINGUNA CONFIGURACIÓN Y DA ERROR
 try   
    for i := 1 to 5 do begin
         a[i]             := TppLabel.Create(f);
         a[i].Band        := rep.HeaderBand;
         a[i].spLeft      := 5;
         a[i].Font.Size   := 8;
         a[i].Transparent := FALSE;
         a[i].spTop       := (rep.HeaderBand.spHeight-(rep.HeaderBand.spHeight-10))+(i*13);
    end;
    
    a[1].Caption    := ent.lee('NomEmp');
    a[1].Font.Style := [fsBold];
    a[2].Caption    := ent.lee('NIFEmp');
    a[3].Caption    := ent.lee('DirEmp');
    a[4].Caption    := ent.lee('PosEmp')+' '+ent.lee('PobEmp');
    a[5].Caption    := ent.lee('ProEmp');
 except
 end;   
    
end;
// ---------------------------------------------------------------------------
procedure sPieRep( f : TForm; rep : TppReport);
var
   a : TppLabel;
begin

    a := TppLabel.Create(f);
    a.spTop    := rep.FooterBand.spHeight-10;
    
    a.Caption  := ent.lee('NomEmp') + ' - ' + ent.lee('NIFEmp') + ' - ' +
                  ent.lee('DirEmp') + ' - ' + ent.lee('PosEmp') + ' '   +
                  ent.lee('PobEmp') + '  '  + ent.lee('ProEmp');
    a.spLeft   := (rep.FooterBand.spWidth -  a.spWidth) div 2
                  
    
end;

// ---------------------------------------------------------------------------
// ANTES DE V15
// ---------------------------------------------------------------------------

{$IFNDEF V15}
function _seg : boolean;
var
   clau,c,
   cBuf : string;
begin
   _ini;

   result := FALSE;
   
   try
   cBuf    := ent.lee('TipoApl') +  ent.lee('NumTpl') + ent.lee('Nivel')  + 
              ent.lee('NIFEmp')  +  ent.lee('PosEmp') + ent.lee('DirEmp') +
              ent.lee('PobEmp')  +  ent.lee('ProEmp') + ent.lee('NomEmp');

   clau    := ent.lee('Clave');  
   except
      on e: Exception do begin
         ShowMessage(format('[seguridad] Error en la verificación de claves: %s.',[e.Message]));
         exit;
      end;   
   end;
 
   c := _dec(clau);
   
   result  := (c = cBuf);
            
end;   
// ---------------------------------------------------------------------------
procedure _ini; 
var
   c : string;  
   i : byte;
begin
   c := '';
   for i := 0 to 20 do c := c + chr(k[i]);
   GenerateLMDKey(Key128, SizeOf(Key128),c);
end;
// ---------------------------------------------------------------------------
function _cpc(st : string) : string;  
var
   serie  : TNativeXML;
begin

   result := '';

    serie := TNativeXML.Create;

    serie.LoadFromFile(st);
    
    try
     if assigned(serie.Root) then 
        with serie.Root do begin
        
           result    := TXMLNode(Nodes[0].NodeByName('aplicacion')).ValueAsString +
                        TXMLNode(Nodes[0].NodeByName('terminales')).ValueAsString +
                        TXMLNode(Nodes[0].NodeByName('volumen')).ValueAsString    +
                        TXMLNode(Nodes[0].NodeByName('nif')).ValueAsString        +
                        TXMLNode(Nodes[0].NodeByName('cpostal')).ValueAsString    +
                        TXMLNode(Nodes[0].NodeByName('direccion')).ValueAsString  +
                        TXMLNode(Nodes[0].NodeByName('poblacion')).ValueAsString  +
                        TXMLNode(Nodes[0].NodeByName('provincia')).ValueAsString  +
                        TXMLNode(Nodes[0].NodeByName('usuario')).ValueAsString;
                        
       end;
     finally
      serie.Free;
     end;   

end;
// ---------------------------------------------------------------------------
function _enc(st : string) : string;
begin
   result := TripleDESEncryptStringCBCEx(st, Key128, True);
end;
// ---------------------------------------------------------------------------
function _dec(st : string) : string;
begin
   result := TripleDESEncryptStringCBCEx(st, Key128, False);
end;
// ---------------------------------------------------------------------------
function _val(st : string)  : boolean;
var
   cBuf,
   numser : string;
   serie  : TNativeXML;
begin

    serie := TNativeXML.Create;

    serie.LoadFromFile(st);
    
    try
     if assigned(serie.Root) then 
        with serie.Root do begin
            numser   := _dec(TXMLNode(Nodes[0].NodeByName('numserie')).ValueAsString);
        end;
     finally
        serie.Free;
     end;   

     cBuf   := _cpc(st);
     
     result := (cBuf = numser);
end;
// ---------------------------------------------------------------------------
{$ENDIF}

end.
