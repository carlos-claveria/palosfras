unit uGDM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, Provider, ADODB,
  DBAccess, Uni, MemDS, UniProvider,MySQLUniProvider, DADump,
  UniDump, DASQLMonitor, UniSQLMonitor, VirtualTable, OracleUniProvider,
  MemData, cxClasses, cxLocalization ;

type
  TGDM = class(TDataModule)
    MySQLp: TMySQLUniProvider;
    adb: TUniConnection;
    dbTran: TUniTransaction;
    umon: TUniSQLMonitor;

    qConfig: TUniQuery;
    devexploc: TcxLocalizer;
    procedure DataModuleDestroy(Sender: TObject);
    procedure adbBeforeConnect(Sender: TObject);
    procedure adbAfterConnect(Sender: TObject);
    procedure adbError(Sender: TObject; E: EDAError; var Fail: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure adbConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);

  private
        EnConexion : boolean;
  public
        ConexionOk : boolean;
  end;

var
  GDM: TGDM;

implementation

uses  varent, strutils, devloc, smKernel;

{$R *.DFM}

// ----------------------------------------------------------------------------
procedure TGDM.DataModuleCreate(Sender: TObject);
begin

   if adb.Connected then adb.Disconnect;

   if not fileexists(_Path+devloc_file) then devloc.creadevloc;
   
   devexploc.LoadFromFile(_Path+devloc_file);

   devexploc.LanguageIndex := 308;
      

end;

procedure TGDM.DataModuleDestroy(Sender: TObject);
begin
   adb.Close;
end;

// ----------------------------------------------------------------------------
procedure TGDM.adbBeforeConnect(Sender: TObject);
var
   numDB    : integer;
begin

   ConexionOK := FALSE;
   
   EnConexion := TRUE;
   TRY
   
       TRY
         numDB := StrToInt(ent.Lee('MotorBD','0'));

         case numDB of

            0: begin
     
                 TRY
                    adb.Connected    := FALSE;
                    adb.ProviderName := 'MySQL';
                    adb.server       := ent.Lee('servidor');
                    adb.port         := strtoint(ent.lee('puerto'));
                    adb.userName     := ent.lee('login');
                    adb.password     := ent.lee('password');
                    adb.database     := ent.Lee('database');
                    ConexionOk       := True;
                 EXCEPT
                     on e: exception do begin
                       ShowMessage('DM MySQL'+#10+#13+'Asignando valores de conexión.'+#10+#13+e.Message);
                       Application.Terminate;
                     end;
                 END;
            end;

            2: begin
     
                 TRY
                    adb.Connected    := FALSE;
                    adb.ProviderName := 'Oracle';
                    adb.server       := ent.Lee('servidor');
                    adb.port         := strtoint(ent.lee('puerto'));
                    adb.userName     := ent.lee('login');
                    adb.password     := ent.lee('password');
                    adb.database     := ent.Lee('database');
                    ConexionOk       := True;
                 EXCEPT
                     on e: exception do begin
                       ShowMessage('DM Oracle'+#10+#13+'Asignando valores de conexión.'+#10+#13+e.Message);
                       Application.Terminate;
                     end;
                 END;
            end;

        
   
         end; {del case }

       EXCEPT
         on e: Exception do ShowMessage('DM BeforeConnect'+#10+#13+'Asignando valores de conexión.'+#10+#13+e.Message);
       END;
   FINALLY
       EnConexion := FALSE;
   END;
   


end;
procedure TGDM.adbConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
   RetryMode := rmReconnectExecute;
end;

procedure TGDM.adbError(Sender: TObject; E: EDAError; var Fail: Boolean);
begin
   if enConexion then begin
      ShowMessage('Error abriendo la base de datos : '+e.Message+CR+'Revise si el servidor de datos está encendido.'+CR+'La aplicación se cerrará.');
      Application.Terminate;
      Halt;
   end;
end;

// ----------------------------------------------------------------------------
procedure TGDM.adbAfterConnect(Sender: TObject);
begin
   ConexionOk := TRUE;
   EnConexion := false;
   
   if qConfig.SQL.Text <> '' then ent.CargaBD(qConfig);
   
end;

end.



      
