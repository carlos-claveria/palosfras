unit iniform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, dxGDIPlusClasses;

type
  {$REGION 'Documentation'}
  ///	<summary>Ventana de inicio de la aplicación.</summary>
  {$ENDREGION}
  Tzini = class(TForm)
    img: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure WMCopyData( var Msg: TWMCopyData ); message WM_COPYDATA;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    lVez : boolean;
  public
    OK   : boolean;
  end;

var
  zini: Tzini;
const
  _LOGIN   = 'ALBALOGIN.EXE';  /// Nombre de la aplicación de validación.
  _INILOGO = 'INILOGO.PNG';    /// inilogo.png debe ser de 250x520 px.
  

implementation
uses varent,strutils,smKernel;

resourcestring
  StrNoSePudoEjecutar  = 'No se pudo ejecutar %s : %s';
  StrNoSeEncuentra     = 'No se encuentra la aplicación %s';
  StrNoTienePermisos   = 'No tiene permisos para esta aplicación.';
  StrIdentificacion    = 'Identificación de usuario.';
  StrDebeIdentificarse = 'Debe de identificarse con ALBALOGIN.';


{$R *.dfm}


procedure Tzini.FormCreate(Sender: TObject);
var
   Sem  : THandle;
begin

  OK := TRUE;

  if ent.Lee('ValidarApl') <> 'N' then begin

   // DETECTO SI ALBALOGIN ESTÁ EN EJECUCION EN CASO CONTRARIO
   // FUERZO LA EJECUCIÓN DEL PROGRAMA

   OK := FALSE;
   
    Sem := CreateSemaphore(nil,0,1,'ALBALOGIN');
    
    if not ((Sem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)) then
    begin
      ReleaseSemaphore(Sem,1,nil);
      CloseHandle( Sem );

      ShowMessage(StrDebeIdentificarse);
         
    end
    else
      OK := TRUE;
  end;
       
    
  lVez := FALSE;
 
end;

procedure Tzini.WMCopyData( var Msg: TWMCopyData );
var
   cBuf : String;
   v    : String;
   z    : integer;
begin
  SetLength(cBuf,Msg.CopyDataStruct.cbData);
  cBuf := PChar( Msg.CopyDataStruct.lpData );
  Msg.Result := 10; // Mensaje de respuesta de que todo ha ido bien
  

  z := Pos('|',cBuf);
  v := '';

  if z > 0 then begin
    smKernel.Usuario := LeftStr(cBuf,z-1);
    v := Copy(cBuf,z+1,1);
  end;

  if (v = '') or (v = '0') then begin
     ShowMessage(StrNoTienePermisos);
     OK := False;
  end;
  
end;


procedure Tzini.FormHide(Sender: TObject);

begin

   Sleep(200);
end;

procedure Tzini.FormActivate(Sender: TObject);
var
 CopyDataStruct : TCopyDataStruct;
 hReceptor: THandle;
 msg      : string;
begin

   if NOT OK  then Exit;

   if not lVez then begin

       if fileexists(smKernel._Path+_INILOGO) then begin
          img.Picture.LoadFromFile(smKernel._Path+_INILOGO);
        end;

       label1.Caption := SMCR;
       label2.Caption := GetCompVersion;

       // ----------------------------------------------------
       // VALIDACIÓN DE LA APLICACIÓN
       // ----------------------------------------------------

       OK := True;
   
       if ent.Lee('ValidarApl') <> 'N' then begin

          msg := 'ACC'+_IDAPL;

          CopyDataStruct.dwData := 10; // use it to identify the message contents
          CopyDataStruct.cbData := length(msg)*SizeOf(char);
          CopyDataStruct.lpData := PChar( msg );

          // Comprobamos si existe el receptor

          hReceptor := FindWindow( PChar( 'TFLogin' ), PChar( StrIdentificacion ) );

          if hReceptor = 0 then
          begin
             ShowMessage( StrDebeIdentificarse );
             OK := FALSE;
             exit;
          end;

          SendMessage( hReceptor, WM_COPYDATA, Integer( Handle ), Integer( @CopyDataStruct ) ) ;
      
       end;      
   end;
end;

end.
