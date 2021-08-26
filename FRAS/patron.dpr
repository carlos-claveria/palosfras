program patron;

uses
  MidasLib,
  Forms,
  iniform in '..\COMUN\iniform.pas' {zini},
  uGDM in '..\COMUN\uGDM.pas' {GDM: TDataModule},
  varent in '..\COMUN\varent.pas',
  smKernel in '..\COMUN\smKernel.pas',
  uDM in 'BD\uDM.pas' {DM: TDataModule},
  UHojaCalc in '..\COMUN\UHojaCalc.pas',
  main in 'main.pas' {fMain},
  RecError in '..\COMUN\RecError.pas' {ReconcileErrorForm},
  comun in '..\COMUN\comun.pas',
  SQL in '..\COMUN\SQL.pas',
  crono in '..\COMUN\crono.pas',
  errores in '..\COMUN\errores.pas' {_err},
  idioma in '..\COMUN\idioma.pas' {lan},
  uMsg in '..\COMUN\uMsg.pas' {fMsg},
  devloc in '..\COMUN\devloc.pas',
  uzcalc in '..\COMUN\uzcalc.pas' {zcalc},
  uActSoft in '..\COMUN\uActSoft.pas' {fActSoft},
  PassWord in '..\COMUN\PassWord.pas' {PasswordDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  zini := tzini.create(application);
  zini.Show;
  zini.Update;
  
  Application.CreateForm(TGDM, GDM);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(T_err, _err);
  Application.CreateForm(Tlan, lan);
  Application.CreateForm(TfMsg, fMsg);
  zini.hide;
  zini.free;
  Application.Run;
end.
