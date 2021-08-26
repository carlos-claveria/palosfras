unit fsuper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinTheAsphaltWorld, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxCheckBox,
  cxTextEdit;

type
  TForm1 = class(TForm)
    lb21: TLabel;
    edpasswd: TcxTextEdit;
    cxCheckBox1: TcxCheckBox;
    btn1: TcxButton;
    btn2: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
