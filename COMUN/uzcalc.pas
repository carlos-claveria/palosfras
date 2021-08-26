/// MAR-2018 CCD - MODIFICACIÓN PARA ODULTAR CAMOIS CON TAG = -1


unit uzcalc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, StdCtrls;

type
  Tzcalc = class(TForm)
    PB: TProgressBar;
    Label1: TLabel;
    lMod: TLabel;
    btnCancelar: TButton;
    procedure eeExportRecords(Sender: TObject; IntRecordNumber: Integer);
    procedure btnCancelarClick(Sender: TObject);
  private
    Cancelar : boolean;
  public
    procedure Go(q : TDataSet;nomc : string = 'SILECO');
  end;

implementation
uses uHojaCalc,varent,dateutils;

{$R *.dfm}

procedure Tzcalc.btnCancelarClick(Sender: TObject);
begin
     Cancelar := true;
end;

procedure Tzcalc.eeExportRecords(Sender: TObject; IntRecordNumber: Integer);
begin
     PB.Position := IntRecordNumber;
end;

procedure Tzcalc.Go(q : TDataSet; nomc : string = 'SILECO');
var
   x : THojaCalc;
   l,p,campos,
   iValue,iCode,
   i : Integer;

   BM : TBookmark;   
   IsExcel,
   IsOpenO : boolean;
   a,m,d,h,n,s,ms : Word;
begin
          
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
    
    try
         try
            ooCalc(q,nomc, (ent.Lee('HojaCalc','oo') <> 'oo'));
         except
         end;
    finally
          SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
          Close;
    end; 

end;

end.
