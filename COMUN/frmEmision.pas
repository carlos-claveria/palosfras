unit frmEmision;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxLabel,comun, Menus, StdCtrls, cxButtons;

type
  TfEmision = class(TFrame)
    cEmis: TcxTextEdit;
    t01: TcxLabel;
    NomEmis: TcxTextEdit;
    btnC: TcxButton;
    procedure cEmisExit(Sender: TObject);
    procedure NomEmisExit(Sender: TObject);
    procedure btnCClick(Sender: TObject);
    procedure cEmisKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    existe : boolean;
  public
    rEmi : TEmis;
    ok   : boolean ;
    Crea : boolean;
    procedure Graba;
    procedure Carga;
  end;

implementation

uses varent, SQL;

{$R *.dfm}
procedure TfEmision.Graba;
var
   f : TextFile;
begin
   AssignFile(f,'UltEmis.txt');
   Rewrite(f);
   TRY
      WriteLN(f,cEmis.Text);
      WriteLN(f,NomEmis.Text);
   FINALLY
      CloseFile(f);
   END;
end;

procedure TfEmision.NomEmisExit(Sender: TObject);
var
   InsEmi : TSQL;
begin
   if not existe then begin

      if Application.MessageBox('¿Crear emisión?', 'Nueva Emisión', MB_YESNO + 
        MB_ICONQUESTION) = IDYES then
      begin
         InsEmi := TSQL.Create('INSERT INTO TEMISION (CPOBLA,ANO,PERIODO,BLOQUE,EMISION) VALUES(%d,%d,%d,%d,"%s")',
         [rEmi.CPOBLA,rEmi.ANO,rEmi.PERIODO,rEmi.BLOQUE,NomEmis.Text]);
         try
            try
               InsEmi.Go;
            except
               on e:Exception do begin
                  ShowMessage('No se pudo crear la emisión. Posíblemente ya exista.'+comun.CR+e.Message);
               end;
            end;
         finally
            InsEmi.Free;
         end;      
      end;
   end;
end;

procedure TfEmision.btnCClick(Sender: TObject);
begin
   cEmis.Text := '';
   cEmis.SetFocus;
end;

procedure TfEmision.Carga;
var
   em,no  : string;
  
   f : TextFile;
begin
   if fileexists('UltEmis.txt') then begin
      AssignFile(f,'UltEmis.txt');
      Reset(f);
      TRY
         ReadLN(f,em{cEmis.Text});
         ReadLN(f,no{NomEmis.Caption});

         if Trim(em) = '' then Exit;

         cEmis.Text      := ValidaEmi(em,strtoint(ent.Lee('PobDef','1')));
         rEmi := comun.rEmi;
         
         NomEmis.Text := no;

         if no <> '...'  then ok := TRUE;
      
      FINALLY
      CloseFile(f);
      END;
   end;
end;


procedure TfEmision.cEmisExit(Sender: TObject);
var
   q : TSql;
begin
     if not (cEmis.text = '') then begin

        cEmis.Text := ValidaEmi(cEmis.Text,strtoint(ent.Lee('PobDef','1')));
        rEmi := comun.rEmi;

        q := TSQL.Create(format('SELECT EMISION FROM TEMISION WHERE CPOBLA = %d AND ANO = %d AND PERIODO = %d AND BLOQUE  = %d',
            [rEmi.CPOBLA,rEmi.ANO,rEmi.PERIODO,rEmi.BLOQUE]));
        TRY
        q.Go;
        if q.eof then begin
            existe := false;
            if Crea then begin
               NomEmis.Enabled := true;
               NomEmis.Text    := '';
               NomEmis.SetFocus;
            end
            else begin
               NomEmis.Text := ' No existe la emisión.';
               ok := FALSE;
            end;
        end
        else begin
            existe := true;
            NomEmis.Text := ' '+q.d.fieldbyname('EMISION').AsString;            
            ok := TRUE;
        end;   
        FINALLY
          q.Free;
        END;

     end;
end;

procedure TfEmision.cEmisKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (chr(key) = 'c') or (chr(key) = 'C') then begin
      key := 0;
      btnCClick(self);
   end;

end;

end.
