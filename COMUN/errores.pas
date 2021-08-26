unit errores;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxLabel, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMemo, StdCtrls, cxButtons, pngimage, ExtCtrls,
  cxGraphics, cxLookAndFeels, dxGDIPlusClasses, Menus;

type
  T_err = class(TForm)
    btnSalir: TcxButton;
    usrMsg: TcxMemo;
    SysMsg: TcxMemo;
    ico_img: TImage;
    procedure btnSalirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   cont : boolean;   
   modu : string; 
  public
    procedure Pon(modulo,msg : string; e : Exception; continuar : boolean = FALSE); overload; 
    procedure Pon(modulo,msg : string; e : string; continuar : boolean = FALSE); overload;
    
    procedure GuardaError(modulo,usrm,sysm : string);
  end;

var
  _err: T_err;

implementation
uses idioma,varent{,NativeXML,NativeXMLAppend};

{$R *.dfm}
//{$R img.res}

procedure T_err.Pon(modulo,msg : string; e : Exception; continuar : boolean = FALSE); 
begin
   
   cont := continuar;
   modu := modulo;
   Caption := _EXMANAGER+' ['+modulo+']';
   usrMsg.Text     := msg;
   
   if assigned(e) then
      sysMsg.Text     := e.ClassName + ' : ' +e.Message
   else
      sysMsg.Text     := '';
      
   ShowModal;
end;   
procedure T_err.Pon(modulo,msg : string; e : string; continuar : boolean = FALSE); 
begin
   cont := continuar;
   modu := modulo;
   Caption := _EXMANAGER+' ['+modulo+']';
   usrMsg.Text     := msg;
   sysMsg.Text     := e;
      
   ShowModal;
end;   






procedure T_err.btnSalirClick(Sender: TObject);
begin
   Close;
end;

procedure T_err.GuardaError(modulo,usrm,sysm : string);
//var
//   serie : TNativeXML;
//   g     : string;
begin
{
       g := ent.lee('path')+'SMERR.XML';

       if not fileexists(g) then begin
          serie := TNativeXML.CreateName('ERRORES');
          serie.SaveToFile(g);
          serie.Free;
       end;
          
        serie := TNativeXML.CreateName('ERR');

        with serie.Root do begin
                WriteString('APLICACION' ,UTF8String(ent.lee('aplicacion')));
                WriteString('MODULO'     ,UTF8String(modulo));
                WriteString('VERSION'    ,UTF8String(ent.lee('version')));
                WriteDateTime('MOMENTO'  , now);
                WriteString('USRMSG', UTF8String(usrM));
                WriteString('SYSMSG', UTF8String(sysM));
                WriteString('USUARIO', UTF8String(ent.lee('usuario')));
       end;       


       XmlAppendToExistingFile(g,SERIE.Root,0);

}
end;


procedure T_err.FormClose(Sender: TObject; var Action: TCloseAction);

begin

    //   GuardaError(modu,usrMsg.Text,sysMsg.Text);
     

       if cont = FALSE then Application.Terminate; // HALT;

     
      
end;

end.
