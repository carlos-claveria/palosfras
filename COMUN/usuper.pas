unit usuper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinTheAsphaltWorld, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxCheckBox,
  cxTextEdit;

type
  TfSuper = class(TForm)
    lb21: TLabel;
    edpasswd: TcxTextEdit;
    chNoClave: TcxCheckBox;
    btn1: TcxButton;
    btn2: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    EsOk,     
    SinClave : Boolean;
    Cualquiera : Boolean;
    function Go : boolean;
  end;

var
  fSuper: TfSuper;

implementation

{$R *.dfm}

function TfSuper.Go : boolean;
begin
  if SinClave  then begin
     Result := True;
     Exit;
  end;

  edpasswd.Text := '';
  ShowModal;

  result := EsOk;
  
end;

procedure TfSuper.btn1Click(Sender: TObject);
begin
   if (LowerCase(edpasswd.Text) = 'smedia@2015') or Cualquiera then  begin
   
      if chNoClave.Checked then
         SinClave := True
      else 
         SinClave := False;

     EsOk := True;       
   
   end
   else begin
      ShowMessage('La clave no es correcta.');
      EsOk     := False;
      SinClave := False;
   end;

  Close; 
end;

procedure TfSuper.btn2Click(Sender: TObject);
begin
      EsOk := False;
      SinClave := False;
      Close;
end;

procedure TfSuper.FormCreate(Sender: TObject);
begin
   EsOk       := False;
   SinClave   := False;
   Cualquiera := False;
end;

end.
