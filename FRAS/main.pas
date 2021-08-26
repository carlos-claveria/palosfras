unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, 
  Vcl.ExtCtrls, cxContainer, cxEdit, dxGDIPlusClasses, cxImage, 
  cxTextEdit, cxMaskEdit, cxSpinEdit, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls;

type
  TfMain = class(TForm)
    stat1: TStatusBar;
    Panel2: TPanel;
    btnSal: TButton;
    m: TMemo;
    btnCab: TButton;
    btnAbos: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSalClick(Sender: TObject);
    procedure btnCabClick(Sender: TObject);
    procedure btnAbosClick(Sender: TObject);
  private
    function esPadron(fecha : TDateTime ) : string;
  public
  end;

var
  fMain: TfMain;

const
  afec : TArray<String> = [
'1998-10-08','1999-01-21','1999-04-14','1999-07-08','1999-10-13','2000-01-17','2000-04-17','2000-07-12','2000-09-26',
'2001-01-09','2001-04-17','2001-07-27','2001-10-22','2002-01-31','2002-04-26','2002-07-09','2002-10-23','2003-01-23',
'2003-04-22','2003-07-18','2003-10-21','2004-01-28','2004-04-22','2004-07-26','2004-10-28','2005-01-27','2005-04-29',
'2005-08-03','2005-10-28','2006-01-20','2006-05-10','2006-08-10','2006-11-17','2007-01-12','2007-04-25','2007-08-09',
'2007-11-22','2008-02-14','2008-05-22','2008-08-20','2008-11-14','2009-02-26','2009-05-13','2009-08-05','2009-11-05',
'2010-02-17','2010-05-06','2010-07-27','2010-11-04','2011-02-17','2011-05-13','2011-08-04','2011-11-15','2012-02-27',
'2012-05-22','2012-08-24','2012-11-28','2013-02-27','2013-05-08','2013-08-05','2013-10-28','2014-02-10','2014-05-21',
'2014-08-22','2014-11-18','2015-02-13','2015-05-25','2015-08-25','2015-11-23','2016-03-01','2016-05-30','2016-08-10',
'2016-11-24','2017-02-27','2017-05-23','2017-08-08','2017-10-27','2018-02-19','2018-05-17','2018-08-10','2018-11-12',
'2019-02-14','2019-05-13','2019-08-08','2019-10-31','2020-02-20','2020-05-08','2020-08-19','2020-11-30','2021-02-22'
];

                                                                                                        
implementation

{$R *.dfm}

uses smKernel, dateutils,uDM,strutils,comun, varent;

procedure TfMain.btnAbosClick(Sender: TObject);
var
   z : longword;
begin
  m.Lines.Clear;

   m.Lines.Add('');
   m.Lines.Add('');
   m.Lines.Add('');
   m.Lines.Add('');

   btnAbos.Enabled := false;
   application.ProcessMessages;
   DM.qCabecera.FetchRows := 10000;
   DM.qCabecera.Open;  
   
   DM.qAbonados.Open;
   DM.qOT.Open; 

   z := 1;
   

    while not DM.qCabecera.eof do begin

      dm.qCabecera.Edit; 

      if DM.qAbonados.FindKey([DM.qCabecera.FieldByName('CCONTRI').AsString]) then begin
         DM.qCabecera.FieldByName('PERSONA').AsString   := comun.Nombre(DM.qAbonados);
         DM.qCabecera.FieldByName('DIRECCION').AsString := comun.Direc(DM.qAbonados);
         DM.qCabecera.FieldByName('POBLACION').AsString := trim(DM.qAbonados.FieldByName('CPOSTAL').AsString+' '+DM.qAbonados.FieldByName('POBLACION').AsString);
         DM.qCabecera.FieldByName('PAIS').AsString      := DM.qAbonados.FieldByName('CODPAIS').AsString;
         DM.qCabecera.FieldByName('NIF').AsString       := DM.qAbonados.FieldByName('NIF').AsString;
      end;
            

      if DM.qOT.FindKey([DM.qCabecera.FieldByName('IDCO').AsInteger]) then begin
         DM.qCabecera.FieldByName('OT').AsString        := DM.qOT.FieldByName('OT').AsString;
      end;
            
      dm.qCabecera.Post;
      
      inc(z);

      if z mod 1000 = 0 then begin
         m.lines[3] := z.ToString;
         application.ProcessMessages;
      
      end;

      DM.qCabecera.Next;      
    end;

       
   DM.qAbonados.Close;
   DM.qOT.Close; 

    

end;

procedure TfMain.btnCabClick(Sender: TObject);
var
   z : longword;
const
   todoproc = true;   
begin

   m.Lines.Clear;

   m.Lines.Add('');
   m.Lines.Add('');
   m.Lines.Add('');
   m.Lines.Add('');
   m.lines[0] := FormatDateTime('HH:mm:ss',now);
   

   btnCab.Enabled := false;
   application.ProcessMessages;
   DM.qCabecera.FetchRows := 10000;
   DM.qCabecera.KeyFields := 'serie;ano;numrec;fecha';
   DM.qCabecera.Open;

   DM.qAbonados.Open;
   DM.qOT.Open; 
   
   try
   z := 1;
   
   m.lines[2] := 'Actualizando...';
   
   while not DM.qCabecera.eof do begin

      dm.qCabecera.Edit; 

      if todoproc then begin

          dm.qCabecera.FieldByName('IDREC').AsInteger := z;

          if DM.qAbonados.FindKey([DM.qCabecera.FieldByName('CCONTRI').AsString]) then begin
             DM.qCabecera.FieldByName('PERSONA').AsString   := comun.Nombre(DM.qAbonados);
             DM.qCabecera.FieldByName('DIRECCION').AsString := comun.Direc(DM.qAbonados);
             DM.qCabecera.FieldByName('POBLACION').AsString := trim(DM.qAbonados.FieldByName('CPOSTAL').AsString+' '+DM.qAbonados.FieldByName('POBLACION').AsString);
             DM.qCabecera.FieldByName('PAIS').AsString      := DM.qAbonados.FieldByName('CODPAIS').AsString;
             DM.qCabecera.FieldByName('NIF').AsString       := DM.qAbonados.FieldByName('NIF').AsString;
          end;
            

          if DM.qOT.FindKey([DM.qCabecera.FieldByName('IDCO').AsInteger]) then begin
             DM.qCabecera.FieldByName('OT').AsString        := DM.qOT.FieldByName('OT').AsString;
          end;

          dm.qCabecera.FieldByName('SERIE').AsString := esPadron(dm.qCabecera.FieldByName('FECHA').AsDateTime);     

          if True then

          if dm.qCabecera.FieldByName('BLOQUE').AsInteger = 5 then begin
      
             dm.qCabecera.FieldByName('SERIE').AsString := 'M';
      
          end;

          if dm.qCabecera.FieldByName('TOTAL').AsCurrency < 0 then begin
      
             dm.qCabecera.FieldByName('SERIE').AsString   := 'A';
             dm.qCabecera.FieldByName('BLOQUE').AsInteger := 6;
      
          end;

          if (dm.qCabecera.FieldByName('ANO').AsInteger = 2017)  and 
             (dm.qCabecera.FieldByName('PERIODO').AsInteger = 4) and 
             (formatDateTime('YYYY-MM-DD',dm.qCabecera.FieldByName('FECHA').AsDateTime) = '2018-05-17') then begin      
             dm.qCabecera.FieldByName('SERIE').AsString := 'M';
      
           end;


           if dm.qCabecera.FieldByName('SERIE').AsString  = 'G' then
              dm.qCabecera.FieldByName('SERIE').AsString  := 'R';

      end;

      dm.qCabecera.Post;
      
      inc(z);

      if z mod 1000 = 0 then begin
         m.lines[3] := z.ToString;
         application.ProcessMessages;
         m.lines[1] := FormatDateTime('HH:mm:ss',now);
         
      end;

      DM.qCabecera.Next;
   end;
   finally
     m.lines[2] := 'Cerrando tablas...';
     application.ProcessMessages;
   
     DM.qCabecera.Close;
     DM.qAbonados.Close;
     DM.qOT.Close; 
   
     m.lines[2] := format('FIN DE PROCESO %5d',[z]);
     btnCab.Enabled := true;
     m.lines[3] := FormatDateTime('HH:mm:ss',now);
     
     application.ProcessMessages;
   end;


   
end;

procedure TfMain.btnSalClick(Sender: TObject);
begin
   close;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin

   stat1.Panels[0].Text :=smKernel.SMCR+' '+FormatDateTime('YYMM.DD.HH.NN',smKernel.fCompi);
   stat1.Panels[1].Text := ' '+format('%s@%s : %s',[comun.Usuario,ent.Lee('Servidor'),ent.Lee('DataBase')]);
   
   
end;

// --------------------------------------------------------------------------------------------------------------
function TfMain.esPadron(fecha : TDateTime ) : string;
var
   sf : string;
begin
   sf := formatDateTime('YYYY-MM-DD',fecha);

   result := IfThen(AnsiMatchStr(sf,afec),'R','M'); 
   
end;

end.
