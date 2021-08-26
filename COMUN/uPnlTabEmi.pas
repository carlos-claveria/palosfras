unit uPnlTabEmi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxGDIPlusClasses,
  cxImage, cxMaskEdit, cxSpinEdit, cxSpinButton, cxTextEdit, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TFrame2 = class(TFrame)
    pnlTabEmi: TPanel;
    txt1: TStaticText;
    edCPOBLA: TcxTextEdit;
    edANO: TcxTextEdit;
    btnANO: TcxSpinButton;
    edPERIODO: TcxTextEdit;
    btnPERIODO: TcxSpinButton;
    edBLOQUE: TcxTextEdit;
    btnBLOQUE: TcxSpinButton;
    cxImage2: TcxImage;
    edDESC: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
