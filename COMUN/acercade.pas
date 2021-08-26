{*------------------------------------------------------------------------------
  Form que muestra la ventana Acerca de...
  Lee de la instancia ent   TVarEnt                                                                             
  @param Sender   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
unit acercade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, dxGDIPlusClasses, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxMemo;

type
  Tfacercade = class(TForm)
    lepoca: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lNom: TLabel;
    lNIF: TLabel;
    lDir: TLabel;
    lPob: TLabel;
    lVers: TLabel;
    lPro: TLabel;
    L1: TLabel;
    L2: TLabel;
    img1: TImage;
    L3: TLabel;
    L4: TLabel;
    L5: TLabel;
    L6: TLabel;
    L7: TLabel;
    L8: TLabel;
    procedure img1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  public
    { Public declarations }
  end;

implementation
uses DateUtils, ShellApi, varent, comun;


{$R *.dfm}

procedure Tfacercade.img1Click(Sender: TObject);
begin
   Close;
end;

procedure Tfacercade.Label2Click(Sender: TObject);
begin
   ShellExecute(self.Handle, 'open', PChar('http://www.sileco.com'), '', '', SW_NORMAL);
end;

procedure Tfacercade.FormCreate(Sender: TObject);
begin
 
  lVers.Caption := SMCR;
  lepoca.Caption := 'Albatros v.15 ['+ getCompVersion+']';
  
  lNom.Caption := ent.lee('NomEmp');
  lNIF.Caption := ent.lee('NIFEmp');
  lDir.Caption := ent.lee('DirEmp');
  lPob.Caption := ent.lee('PosEmp')+' '+ent.lee('PobEmp');
  lPro.Caption := ent.lee('ProEmp');




                                                    
 
end;

procedure Tfacercade.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;
end;

end.
