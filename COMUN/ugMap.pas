unit ugMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, xmldom, XMLIntf, msxmldom, XMLDoc,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer, Menus,
  cxLookAndFeelPainters, cxButtons, pngimage, ExtCtrls,DB,GIFimg, cxGraphics,
  cxLookAndFeels;

type

   //TLatLon   = (esLat,esLon);
   
   TGSMcoord = record
      lati, long : string[10];
   end;

   TGSMdir   = record
      calle     : string[50];
      numero    : string[10];
      cpostal   : string[6];
      poblacion : string[40];
      pais      : string[20];
   end;
      
  TgMap = class(TForm)
    cte: TIdHTTP;
    cxButton1: TcxButton;
    llat: TLabel;
    Image1: TImage;
    img: TImage;
    llon: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxButton1Click(Sender: TObject);
  private
    procedure ponCoord;
  public
    Ok : boolean;
    GoogleAPIKey : string;
    latitud : string;
    longitud : string;
    dimension : string;
    zoom : string;

    function  GetCoord(rDir : TGSMdir; var tCoord : TGSMCoord) : boolean;
    
    procedure Mos(rDir : TGSMDir); overload;
    procedure Mos(lat,lon : string); overload;
    procedure Mos(c : TDataSet); overload;
    function  TraeImg(dir : string;pob : string = '';pais : string = '') : TGIFImage;
    
    function  DownloadToStream(Url: string; Stream: TStream): Boolean;
    
  end;

//const GoogleAPIKey = 'ABQIAAAAFtmFPBnITF7ACsIWmudZwRTe3t3b6wGTQKWXGKMOetssKE9KGRRVZAB0CzYHfwaLKEIZdV4dG3PqrA';
 
  
var
  gMap: TgMap;

implementation

uses  uGIS,iduri,IdMultipartFormData,math,WININET,varent, _DM,
  idioma;



{$R *.dfm}

procedure tGMap.ponCoord;
begin
   llat.Caption := aDMS(strtofloat(stringreplace(latitud,'.',',',[])),esLat);
   llon.Caption := aDMS(strtofloat(stringreplace(longitud,'.',',',[])),esLon);
end;


function tGmAP.DownloadToStream(Url: string; Stream: TStream): Boolean;
var
  hNet: HINTERNET;
  hUrl: HINTERNET;
  Buffer: array[0..10240] of Char;
  BytesRead: DWORD;
begin
  Result := FALSE;
  hNet := InternetOpen('agent', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hNet <> nil) then
  begin
    hUrl := InternetOpenUrl(hNet, PChar(Url), nil, 0,
      INTERNET_FLAG_RELOAD, 0);
    if (hUrl <> nil) then
    begin
      while (InternetReadFile(hUrl, @Buffer, sizeof(Buffer), BytesRead)) do
      begin
        if (BytesRead = 0) then
        begin
          Result := TRUE;
          break;
        end;
        Stream.WriteBuffer(Buffer,BytesRead);
      end;
      InternetCloseHandle(hUrl);
    end;
    InternetCloseHandle(hNet);
  end;
end;

function TgMap.GetCoord(rDir : TGSMdir; var tCoord : TGSMCoord) : boolean;
var
   cDir,
   cBuf  : string;
   sList : TStringList;
   dp    : TIdMultiPartFormDataStream;
begin

   rDir.calle     := Trim(rDir.calle);
   rDir.numero    := Trim(rDir.numero);
   rDir.cpostal   := Trim(rDir.cpostal);
   rDir.poblacion := Trim(rDir.poblacion);
   rDir.pais      := Trim(rDir.pais);

   if rDir.numero <> '' then begin
      rDir.numero := ','+rDir.Numero;
      cDir := rDir.calle+ ' ' +rDir.numero;
   end
   else
      cDir := rDir.calle;

   if rDir.cpostal <> '' then
      cDir := cDir + ' ' + rDir.cpostal;

   if rDir.poblacion <> '' then
      cDir := cDir + ' ' + rDir.poblacion;

   if rDir.pais <> '' then
      cDir := cDir + ' ' + rDir.pais
   else   
      cDir := cDir + ' Spain';
       

   caption := cDir;

      
   cDir := StringReplace(cDir,' ','+',[rfReplaceAll]);
            


   
   sList := TStringList.Create;
   dp    := TIdMultiPartFormDataStream.Create;
   try

      dp.AddFormField('sensor', 'false');
      dp.AddFormField('key', GoogleAPIKey);
       
      cBuf := cte.Post('http://maps.google.com/maps/geo?q='+cDir+'&output=csv',dp);
      
      sList.Clear;
      sList.Delimiter      := ',';
      sList.DelimitedText  := cBuf;
      
      if sList[0] = '200'  then begin
         result := TRUE;
         tCoord.lati := sList[2];
         tCoord.long := sList[3];
      end
      else
         result := FALSE;
            
   finally
      sList.Free;
      dp.Free;
   end;      

end;



function  TgMap.TraeImg(dir : string;pob : string = '';pais : string = '') : TGIFImage;
var
   c : TGSMcoord;
   cURL : string;
   st   : tMemoryStream;
   rDir : TGSMDir;
begin
   Ok := TRUE;
   st := TMemoryStream.Create;
   result  := TGIFImage.Create;

   try

      rDir.calle     := dir;
      rDir.poblacion := pob;
      rDir.pais      := pais;

      if rDir.Pais = '' then rDir.Pais := ent.lee('dirpais','Spain');
      if TRIM(Uppercase(rDir.pais)) = 'ESPAÑA' then rDir.Pais := 'SPAIN';
      if rDir.poblacion = '' then rDir.poblacion := ent.lee('dirpob','Spain');



      if GetCoord(rDir,c) then begin

         latitud  := c.lati;
         longitud := c.long;
         cURL :=  format('http://maps.google.com/staticmap?center=%s,%s&zoom='+zoom+'&size='+dimension+'&maptype=mobile\&markers=%s,%s,blues&key='+GoogleAPIKey+'&sensor=false',
            [c.lati,c.long,c.lati,c.long]);  

         PonCoord;   

         if DownloadToStream(cURL,st) then begin
            st.Position := 0;
            result.LoadFromStream(st);
         end;


      end
      else begin
         OK := FALSE;
      end;   
   finally
      st.Free;
   end;
end;

procedure TgMap.Mos(rDir : TGSMDir);
var
   c : TGSMcoord;
   cURL : string;
   st   : tMemoryStream;
   i    : TGIFImage;
begin
Ok := TRUE;
st := TMemoryStream.Create;
i  := TGIFImage.Create;
try

if GetCoord(rDir,c) then begin

latitud  := c.lati;
longitud := c.long;
cURL :=  format('http://maps.google.com/staticmap?center=%s,%s&zoom='+zoom+'&size='+dimension+'&maptype=mobile\&markers=%s,%s,blues&key='+GoogleAPIKey+'&sensor=false',
   [c.lati,c.long,c.lati,c.long]);  

PonCoord;   

if DownloadToStream(cURL,st) then begin
   st.Position := 0;
   i.LoadFromStream(st);
   img.Picture.Assign(i);
end;

ShowModal;
end
else begin
   ShowMessage(_NOMAP);
   OK := FALSE;
end;   
finally
st.Free;
i.Free;
end;   

end;

procedure TgMap.Mos(c : TDataSet);
var
   i    : TGIFImage;
begin
   OK := TRUE;
   if c.FieldByName('MAPA').IsNull then begin
      Mos(c.FieldByName('LAT').AsString,c.FieldByName('LON').AsString);
   end   
   else begin
      i := TGifImage.Create;
      TRY
      llat.Caption  := c.FieldByName('LATDMS').AsString;
      llon.Caption  := c.FieldByName('LONDMS').AsString;
      i.Assign(c.FieldByName('MAPA'));
      img.Picture.Assign(i);
      ShowModal;
      FINALLY
      i.Free;
      END;
      
   end;
end;      

procedure TgMap.Mos(lat,lon : string);
var
   cURL : string;
   st   : tMemoryStream;
   i    : TGIFImage;
begin
OK := TRUE;
st := TMemoryStream.Create;
i  := TGIFImage.Create;
try

latitud  := lat;
longitud := lon;

cURL :=  format('http://maps.google.com/staticmap?center=%s,%s&zoom='+zoom+'&size='+dimension+'&maptype=mobile\&markers=%s,%s,blues&key='+GoogleAPIKey+'&sensor=false',
   [latitud,longitud,latitud,longitud]);  

PonCoord;
   
try
if DownloadToStream(cURL,st) then begin
   st.Position := 0;
   i.LoadFromStream(st);
   img.Picture.Assign(i);
end;
except
   ShowMessage(_NOMAP);
   OK := FALSE;
   exit;
end; 

ShowModal;


finally
st.Free;
i.Free;
end;   

end;




procedure TgMap.FormCreate(Sender: TObject);
begin
   dimension := '640x480';
   zoom      := '17';
   GoogleAPIKey := ent.lee('GoogleAPIKey');
end;

procedure TgMap.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = VK_ESCAPE then Close;
end;

procedure TgMap.cxButton1Click(Sender: TObject);
begin
   if fileexists(FICMAP) then DeleteFile(FICMAP);
   Img.Picture.SaveToFile(FICMAP);
   Close;
end;

end.
