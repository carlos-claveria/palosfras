/// fActSoft rev. 06/2016
/// Actualización de aplicaciones desde el servidor de SILICON MEDIA
/// TODO: Verificar el usuario que pide la lactualización faltaría un REST?
///       para ver si tiene derecho a actuallizaciones.
/// ------------------------------------------------------------------------

/// ejemplo desde aplicación:

///   // LanzaUpdate : private boolean respecto al form;


///   //  OnClick ------------------------------------------------------------
///   act := TfActSoft.Create(self);
///   try
///      LanzaUpdate := act.Trae('smabo');
///      if LanzaUpdate then Close;
///   finally
///     act.Free;
///   end;
///   
///   //  OnCreate ----------------------------------------------------------
///     LanzaUpdate := false;
///   
///   //  OnClose ----------------------------------------------------------
///     if LanzaUpdate then
///      ShellExecute(fMain.Handle,nil,PChar('update.vbs'),'','',SW_SHOWNORMAL);

///   //  OnKeyDown ---------------------------------------------------------

///   if (Shift = [ssalt,ssctrl]) and (Key = VK_F1) then begin
///   
///      act := TfActSoft.Create(self);
///      try
///         LanzaUpdate := act.Pon('smabo');
///      finally
///        act.Free;
///      end;
///   end;
///      



unit uActSoft;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdComponent, IdTCPConnection, 
  IdFTP, ComCtrls, StdCtrls, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, cxButtons,idFTPCommon, PassWord,
  uMsg, IdBaseComponent, IdTCPClient, IdExplicitTLSClientServerBase;

type
  TfActSoft = class(TForm)
    updFTP: TIdFTP;
    pb: TProgressBar;
    m: TMemo;
    btnSi: TcxButton;
    btnNo: TcxButton;
    procedure updFTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure updFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure updFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure btnSiClick(Sender: TObject);
  private
    lSM  : boolean; // indica quien está usuando la actualización true = Pon(...)
    lCan : boolean; // Cancela el proceso;
    
    lOk,
    lVez : boolean;

    fs   : integer;
    
    apl  : string;
    procedure EmptyKeyQueue;
    
  public
    version : string;
  
    function Trae(const nomapl : string) : boolean;
    function Pon(const nomapl : string) : boolean;
  end;

implementation

uses comun{, paszip};

{$R *.dfm}

procedure TfActSoft.EmptyKeyQueue;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do;
end;

function TfActSoft.Pon(const nomapl : string) : boolean;
var
   ps : TPasswordDLg;
begin
   lSM := TRUE;
   m.ReadOnly := false;
   

   if Application.MessageBox('Si accedió a esta ventana por equivocación pulse [Cancelar]' 
     + #13#10 + '¿Continuar?', 'ACCESO EN MODO ADMINISTRADOR', MB_OKCANCEL +
     MB_ICONWARNING + MB_DEFBUTTON2) = IDCANCEL then
   begin
     exit;
   end;
     
   ps := TPasswordDlg.Create(self);
   try  
       ps.ShowModal;
       
       if ps.cancela then exit;
       if ps.Password.Text <> 'silene@9092' then exit;
       
   finally
     ps.Free;
   end;

   result := false;
   apl    := lowercase(trim(nomapl)); 

   m.Lines.Clear;
   m.Lines.Add(GetCompVersion);
   m.Lines.Add( formatdatetime('DD/MM/YYYY HH:NN',now) );
   m.Lines.Add('-----------------------------------------------------');
   m.Lines.Add('');
   m.Lines.Add('-----------------------------------------------------');
   Caption := 'Actualización modo ADMINISTRADOR';
   ShowModal;
end;

function TfActSoft.Trae(const nomapl : string) : boolean;
var
   nVer,
   oVer,
   cv : string;
begin
   lSM        := FALSE;  
   m.ReadOnly := true;
   result     := false;
   apl        := lowercase(trim(nomapl)); 
   lOk        := false;

   btnSi.Enabled := true;
   btnNo.Enabled := true;

 
   
   try

      fmsg.Muestra('Un momento...');
      application.ProcessMessages;

   
      updFTP.Connect();
      
      try
         m.Lines.Clear;
         
       //  updFTP.ChangeDir('/updapl'+version+'/');
         fs := updFTP.Size(apl+'.sminfo');
         
         if fs > 0 then begin
              pb.Position := 0;
              pb.Max := fs;
              updFTP.Get(apl+'.sminfo',apl+'.sminfo',true,false);
              m.Lines.LoadFromFile(apl+'.sminfo');

              try
                 nVer := m.Lines[0];
              except
                 nVer := '';
              end;
              
              oVer := comun.GetCompVersion;

              if (m.Lines.Count > 0) and (nVer <= oVer) then begin
              
                 m.Lines.Clear;

                 Caption := 'Actualizando software '+nVer;
                 
                 m.Lines.Add( format('Versión actual     : %s',[oVer]) );
                 
                 m.Lines.Add('');
                 m.Lines.Add('ATENCIÓN :');
                 m.Lines.Add('Ya dispone de la última versión, no precisa actualizar.');
                 
                 btnSi.Enabled := false;
              end;
         end
         else begin
              m.Lines.Add('No encuentro en el servidor     ');
              m.Lines.Add('el fichero de información:      ');
              m.Lines.Add('');
              m.Lines.Add(apl+'.sminfo');
              m.Lines.Add('');
              m.Lines.Add('Comunique esta incdencia a su   ');
              m.Lines.Add('proveedor de servicios ALBATROS.');

              btnSi.Enabled := false;
         end;
         
      finally
         updFTP.Disconnect;     
         fMsg.Cierra;
         pb.Position := 0;
         application.ProcessMessages;
      end;
   except
         on e : Exception do begin
            if not lCan then ShowMessage(format('No se pudo conectar con el servidor de actualizaciones. [%s]',[e.Message]));
            exit;
         end;
   end;

   
   
   ShowModal;

   result := lOk;
   
   Close;
   


end;
procedure TfActSoft.updFTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
   if pb.Max > 0 then pb.Position := AWorkCount;
   
  // lMax.Caption := format('%d / %d',[pb.Max,AWorkCount]);
   
   Update;
   application.ProcessMessages;
end;

procedure TfActSoft.updFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
   if AworkMode = wmWrite then
      pb.Max := AWorkCountMax
   else
      pb.Max := fs;
      
   pb.Position := 0;
   application.ProcessMessages;
end;

procedure TfActSoft.updFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
   pb.Position := pb.Max;
   application.ProcessMessages;
end;

procedure TfActSoft.btnNoClick(Sender: TObject);
begin
     lOk := false;
     
     if updFTP.Connected then 
     try
        lCan := true;
        updFTP.Quit;
     except
        ShowMessage('Proceso cancelado.');
     end;
     
     Close;
end;

procedure TfActSoft.btnSiClick(Sender: TObject);
begin
      case lSM of

       true:  begin
                 try
                    screen.Cursor := crHourGlass;
                    application.ProcessMessages;
                    
                    updFTP.Connect();
                    btnSi.Enabled := false;
                    try
                       m.Lines.SaveToFile(apl+'.sminfo');
                       m.Lines.Clear;

                     //  updFTP.ChangeDir('/updapl'+version+'/');
                       
                       m.Lines.Add(format('Enviando %s...',[apl+'.sminfo']));
                       application.ProcessMessages;
                       updFTP.Put(apl+'.sminfo',apl+'.sminfo',false);
                       
                       m.Lines.Add(format('Enviando %s...',[apl+'.exe']));
                       application.ProcessMessages;                       
                       updFTP.Put(apl+'.exe'   ,apl+'.e_e',false);
                       
                    finally
                       updFTP.Disconnect;     
                       screen.Cursor := crDefault;
                       application.ProcessMessages;
                       btnSi.Enabled := true;
                       
                    end;
                 except
                    on e : Exception do begin
                       if not lCan then ShowMessage(format('No se pudo conectar con el servidor de actualizaciones. [%s]',[e.Message]));
                       exit;
                    end;
                 end;
              end;


       false: begin

                 try
                    screen.Cursor := crHourGlass;
                    application.ProcessMessages;
                    
                    updFTP.Connect();
                    btnSi.Enabled := false;
                    
                    try
                       m.Lines.Clear;
         
                     //  updFTP.ChangeDir('/updapl'+version+'/');
                       
                       fs := updFTP.Size(apl+'.e_e');
         
                       if fs > 0 then begin
                            
                            m.Lines.Add('');
                            
                            m.Lines.Add('Actualizando aplicación...');
                            application.ProcessMessages;
                            
                            updFTP.Get(apl+'.e_e',apl+'.e_e',true,false);
                            
                            m.Lines.Add('Actualizada.');
                            application.ProcessMessages;
                                                                       
                            EmptyKeyQueue;
      
                            // ----------------------------------------------------------------------
                            m.Lines.Clear;

                            m.Lines.Add('DIM WshShell                                                   ');
                            m.Lines.Add('Set WshShell = WScript.CreateObject("WScript.Shell")           ');
                            
                            //m.Lines.Add('WshShell.PopUp "Actualizando", 3                               ');
                            
                            m.Lines.Add(format('WshShell.Run "cmd.exe /C del /Q %s.old ",0,true ',[apl]) );
                            m.Lines.Add(format('WshShell.Run "cmd.exe /C move %s.exe %s.old",0,true ',[apl,apl]));
             
                            m.Lines.Add(format('WshShell.Run "cmd.exe /C move %s.e_e %s.exe",0,true ',[apl,apl]));
                            m.Lines.Add('WshShell.PopUp "Reinicie la aplicación", 3                     ');
                            m.Lines.Add('WScript.Quit()                                                 ');
                            m.Lines.SaveToFile('update.vbs');              
              
                       end
                       else begin
                            m.Lines.Add('No encuentro en el servidor     ');
                            m.Lines.Add('el fichero ejecutable:          ');
                            m.Lines.Add('');
                            m.Lines.Add(apl+'.exe');
                            m.Lines.Add('');
                            m.Lines.Add('Comunique esta incidencia a su   ');
                            m.Lines.Add('proveedor de servicios ALBATROS.');
                            sleep(3000);
                            btnSi.Enabled := false;
                       end;
         
                    finally
                      updFTP.Disconnect;     
                      btnSi.Enabled := false;
                      screen.Cursor := crDefault;
                      application.ProcessMessages;
                    end;
                 except
                       on e : Exception do begin
                          if not lCan then ShowMessage(format('No se pudo conectar con el servidor de actualizaciones. [%s]',[e.Message]));
                          exit;
                       end;
                 end;
       
              end;
   end;
   
   lOk := true;
   Close;
end;

procedure TfActSoft.FormCreate(Sender: TObject);
begin
     lVez := false;
     lCan := false;

     updFTP.Passive      := true;
     updFTP.TransferType := ftBinary;
   
     updFTP.Host     := 'sileco.com';
     updFTP.Username := 'smftp';
     updFTP.Password := 'silenesilene';
     version         := '';
     
end;


   
end.
