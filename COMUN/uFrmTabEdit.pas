unit uFrmTabEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxGDIPlusClasses,
  cxImage, cxMaskEdit, cxSpinEdit, cxSpinButton, cxTextEdit, Vcl.StdCtrls,
  Vcl.ExtCtrls,smKernel, silKernel, varent;


type


  {* -----------------------------------------------------------------------
      Acción adicional tras pulsar procesar
  }
  TEmiProcEvent = procedure(Sender: TObject) of object;   
  
  TfrmTabEdit = class(TFrame)
    txt1: TStaticText;
    
    btnPERIODO: TcxSpinButton;
    btnBLOQUE: TcxSpinButton;
    btnANO: TcxSpinButton;
    
    imgProc: TcxImage;
    edDESC: TcxTextEdit;
    edCPOBLA: TcxMaskEdit;
    edANO: TcxMaskEdit;
    edPERIODO: TcxMaskEdit;
    edBLOQUE: TcxMaskEdit;
    procedure cambiavalor(Sender: TObject);
    procedure imgProcClick(Sender: TObject);
  private
    { Private declarations }
  public
    EmisOk : Boolean;
    EM : TEmis;
    FOnProc : TEmiProcEvent;  
    procedure Inicia;
    procedure Guarda;
    procedure Carga;
    procedure emitoframe;
    
  end;

implementation

{$R *.dfm}

uses _BRSIL,dateutils;

procedure TfrmTabEdit.emitoframe;
begin

   edCPOBLA.Text  :=  EM.CPOBLA.ToString;
   edANO.Text     :=  EM.ANO.ToString;    
   edPERIODO.Text :=  EM.PERIODO.ToString;
   edBLOQUE.Text  :=  EM.BLOQUE.ToString;
   edDESC.Text    :=  EM.DESC; 
end;

procedure TfrmTabEdit.Guarda;
var
   x : TextFile;
   cBuf : string;
begin
   AssignFile(x,smKernel._Path+parent.Name+'.CNF');
   Rewrite(x);
   
   cBuf := EM.ToString;
   WriteLN(x,EM.ToString);
   WriteLN(x,EM.DESC);
   CloseFile(x);
   
end;

procedure TfrmTabEdit.imgProcClick(Sender: TObject);
begin
   if edCPOBLA.Text = '' then edCPOBLA.Text := ent.Lee('PobDef','1');
  
   EM.CPOBLA  := StrToInt(edCPOBLA.Text);
   EM.ANO     := StrToInt(edANO.Text);
   EM.PERIODO := StrToInt(edPERIODO.Text);
   EM.BLOQUE  := StrToInt(edBLOQUE.Text);
   
   EmisOk     := BRSIL.BuscaEmis(EM);
   
   if EmisOK then 
      edDESC.Text := EM.DESC
   else
      edDESC.Text := '<?>';   
   
   if assigned(FOnProc) then  FOnProc(Self);
   
end;

procedure TfrmTabEdit.Carga;
var
   x : TextFile;
   cBuf : string;
begin
   if FileExists(smKernel._Path+parent.Name+'.CNF') then begin
      AssignFile(x,smKernel._Path+parent.Name+'.CNF');
      Reset(x);
      Readln(x,cBuf);
      EM.Completa(cBuf);
      Readln(x,cBuf);
      EM.DESC := cBuf;
      CloseFile(x);
      emitoframe;
   end;
end;

procedure TfrmTabEdit.Inicia;
begin
  edCPOBLA.Text    := ent.Lee('PobDef','1');
  btnANO.Value     := YearOf(Now);
  btnPeriodo.Value := 1;
end;



procedure TfrmTabEdit.cambiavalor(Sender: TObject);
begin

  if edCPOBLA.Text = '' then edCPOBLA.Text := ent.Lee('PobDef','1');
  
   EM.CPOBLA  := StrToInt(edCPOBLA.Text);
   EM.ANO     := StrToInt(edANO.Text);
   EM.PERIODO := StrToInt(edPERIODO.Text);
   EM.BLOQUE  := StrToInt(edBLOQUE.Text);
   
   EmisOk     := BRSIL.BuscaEmis(EM);

   if EmisOK then 
      edDESC.Text := EM.DESC
   else
      edDESC.Text := '<?>';      

   
end;

end.  
