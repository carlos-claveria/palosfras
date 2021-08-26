unit _map;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, XPMan, ComCtrls,MSHTML,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxMemo, cxCheckBox, uLkJSON, GeoCode,
  cxListBox, cxLabel, Menus, cxButtons, dxGDIPlusClasses, dxSkinsCore,
  dxSkinTheAsphaltWorld;

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
  
  Tmap = class(TForm)
    pan01: TPanel;
    memoAddress: TcxMemo;
    resp: TcxListBox;
    mapaweb: TWebBrowser;
    l2: TcxLabel;
    Image1: TImage;
    btnSalir: TcxButton;
    btnVista: TcxButton;
    btnTrafico: TcxButton;
    btnPrint: TcxButton;
    btnPorta: TcxButton;
    btnNoHay: TcxButton;
    btnNueva: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure respClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnVistaClick(Sender: TObject);
    procedure btnTraficoClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnPortaClick(Sender: TObject);
    procedure mapawebDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure btnNoHayClick(Sender: TObject);
    procedure btnNuevaClick(Sender: TObject);
  private
    { Private declarations }
    HTMLprin,
    HTMLdoc    : IHTMLWindow2;
    MapaStream : TMemoryStream;
    GC         : TGeoCode;
    TextoPun   : string;
    
    procedure WebBrowserScreenShot(const wb: TWebBrowser) ;
    
    
    
  public
    GSM_Lat,
    GSM_Lon : string;

    LocOK   : boolean;
  
    function  conpunto( x : extended) : string; overload;
    function  conpunto( x : string) : string; overload;
    
    procedure coordenadas( lat,lon : string ) ;
    procedure quitaMarcas;
    procedure irMapa(Dir : Tstrings );
    procedure Mos( Dir : TStrings; Texto : string; limpia : boolean = true );
    
  end;

var
  map: Tmap;

implementation

uses
   ActiveX, {jpeg} clipbrd;
   


{$R *.dfm}

const
HTMLStr: AnsiString =
'<html> '+
'<head> '+
'<TITLE>Albatros v.14</TITLE> '+
'<meta name="viewport" content="initial-scale=1.0, user-scalable=yes" /> '+
'<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> '+
'<script type="text/javascript"> '+
''+
''+
'  var geocoder; '+
'  var map;  '+
'  var trafficLayer;'+
'  var bikeLayer;'+
'  var markersArray = [];'+
'  var htmlinfo = "[_TXT_]";   '+
''+
''+
'  function initialize() { '+

'    geocoder = new google.maps.Geocoder();'+

'    var latlng = new google.maps.LatLng([_LAT_],[_LON_]); '+
'    var myOptions = { '+
'      zoom: 17, '+
'      center: latlng, '+
'      mapTypeId: google.maps.MapTypeId.ROADMAP '+
'    }; '+
'    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions); '+
'    var marker = new google.maps.Marker({position:latlng,map:map,title:htmlinfo}); '+

'    markersArray.push(marker); '+

'    trafficLayer = new google.maps.TrafficLayer();'+
'    map.set("streetViewControl", false);'+
'  } '+
''+
''+
'  function codeAddress(address) { '+
'    if (geocoder) {'+
'      geocoder.geocode( { address: address}, function(results, status) { '+
'        if (status == google.maps.GeocoderStatus.OK) {'+
'          map.setCenter(results[0].geometry.location);'+
'          PutMarker(results[0].geometry.location.lat(), results[0].geometry.location.lng(), results[0].geometry.location.lat()+","+results[0].geometry.location.lng());'+
'        } else {'+
'          alert("Geocode no se completó: " + status);'+
'        }'+
'      });'+
'    }'+
'  }'+
''+
''+
'  function GotoLatLng(Lat, Lang) { '+
'   var latlng = new google.maps.LatLng(Lat,Lang);'+
'   map.setCenter(latlng);'+
'   PutMarker(Lat, Lang, Lat+","+Lang);'+
'  }'+
''+
''+
'function ClearMarkers() {  '+
'  if (markersArray) {        '+
'    for (i in markersArray) {  '+
'      markersArray[i].setMap(null); '+
'    } '+
'  } '+
'}  '+
''+
'  function PutMarker(Lat, Lang, Msg) { '+
'   var latlng = new google.maps.LatLng(Lat,Lang);'+
'   var marker = new google.maps.Marker({'+
'      position: latlng, '+
'      map: map,'+
'      title: htmlinfo});'+
' markersArray.push(marker); '+
'  }'+
''+
''+
'  function TrafficOn()   { trafficLayer.setMap(map); }'+
''+
'  function TrafficOff()  { trafficLayer.setMap(null); }'+
''+''+
'  function StreetViewOn() { map.set("streetViewControl", true); }'+
''+
'  function StreetViewOff() { map.set("streetViewControl", false); }'+
''+
''+'</script> '+
'</head> '+
'<body onload="initialize()"> '+
'  <div id="map_canvas" style="width:100%; height:100%"></div> '+
'</body> '+
'</html> ';


function  Tmap.conpunto( x : string) : string;
begin
     result := StringReplace(x,',','.',[]);
end;

function  Tmap.conpunto( x : extended) : string;
begin
     result := FloatToStr(x);
     result := StringReplace(result,',','.',[]);
end;

procedure Tmap.coordenadas( lat,lon : string ) ;
begin
   lat := conpunto(lat);
   lon := conpunto(lon);
   
   
   HTMLdoc.execScript(Format('GotoLatLng(%s,%s)',[lat,lon]), 'JavaScript');
end;

procedure Tmap.btnTraficoClick(Sender: TObject);
begin
    if btnTrafico.Down then
     HTMLdoc.execScript('TrafficOn()', 'JavaScript')
    else
     HTMLdoc.execScript('TrafficOff()', 'JavaScript');
end;

procedure Tmap.btnVistaClick(Sender: TObject);
begin
   if btnVista.Down then
     HTMLdoc.execScript('StreetViewOn()', 'JavaScript')
    else
     HTMLdoc.execScript('StreetViewOff()', 'JavaScript');
end;

procedure Tmap.quitaMarcas;
begin
  HTMLdoc.execScript('ClearMarkers()', 'JavaScript')
end;

procedure Tmap.respClick(Sender: TObject);
begin
   if resp.ItemIndex  = -1 then exit;

   quitaMarcas;
   coordenadas(gc.MapLat[resp.ItemIndex],gc.MapLon[resp.ItemIndex]);
  
    GSM_lat := gc.MapLat[resp.ItemIndex];
    GSM_lon := gc.MapLon[resp.ItemIndex];
     
end;

procedure Tmap.irMapa( Dir : Tstrings );
var
   address    : string;
begin
   address := Dir.Text;
   address := StringReplace(StringReplace(Trim(address), #13, ' ', [rfReplaceAll]), #10, ' ', [rfReplaceAll]);
   HTMLdoc.execScript(Format('codeAddress(%s)',[QuotedStr(address)]), 'JavaScript');
end;

procedure Tmap.mapawebDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
begin
   mapaweb.OleObject.Document.Body.Style.OverflowX := 'hidden';
   mapaweb.OleObject.Document.Body.Style.OverflowY := 'hidden'; 
 
end;

procedure Tmap.Mos( Dir : TStrings; Texto : string; limpia : boolean = true );
var                                                             
  mapstr      : AnsiString;
  i           : integer;
begin
  if limpia then memoAddress.Lines := Dir;
  TextoPun          := Texto;
  
  resp.Items.Clear;
  
  gc.Clear;
  gc.Direccion := Dir.Text;
  gc.Direccion := memoAddress.Lines.Text;




  gc.Execute;



  if GC.GeoStatus = 'OK' then  begin
    for i := 0 to GC.Count-1 do begin
      resp.Items.Add(gc.MapDir[i]);
    end;

    LocOK := true;
    
    
    // ADAPTO EL MAPA A LA PRIMERA OPCIÓN
    
    mapstr := StringReplace(HTMLStr,'[_LAT_]',gc.MapLat[0],[]);
    mapstr := StringReplace(mapstr ,'[_LON_]',gc.MapLon[0],[]);
    mapstr := StringReplace(mapstr ,'[_TXT_]',Texto,[]);
    
    GSM_lat := gc.MapLat[0];
    GSM_lon := gc.MapLon[0];
    
    
    MapaStream.Clear;
    MapaStream.Seek(0, soFromBeginning);
    MapaStream.WriteBuffer(Pointer(mapstr)^, Length(mapstr));
    MapaStream.Seek(0, soFromBeginning);   

        
    (mapaweb.Document as IPersistStreamInit).Load(TStreamAdapter.Create(MapaStream));  
                                     
    // LO LO ASIGNO A HTMLDOC PARA MANEJAR LAS FUNCIONES
    HTMLDoc := (mapaweb.Document as IHTMLDocument2).parentWindow;

    try
      ShowModal;
    except

    end;
  end
  else begin
    ShowMessage(format('No se pudo acceder a la dirección. Estado devuelto por Google Maps : %s',[GC.GeoStatus]));
    LocOK := false;
    
  end;
 
end;

procedure Tmap.FormCreate(Sender: TObject);
begin
   mapaweb.Navigate('about:Silicon Media, S.L.');

   locOK := true;

   MapaStream  := TMemoryStream.Create; 
   GC := TGeocode.Create('');
end;


procedure Tmap.FormDestroy(Sender: TObject);
begin
    if assigned(mapaStream) then FreeAndNil(MapaStream);
    if assigned(GC)         then FreeAndNil(GC);
end;

procedure Tmap.btnNoHayClick(Sender: TObject);
begin
   locOk := false;
   Close;
end;

procedure Tmap.btnNuevaClick(Sender: TObject);
begin
   Mos(MemoAddress.Lines,TextoPun,false);
end;

procedure Tmap.btnPortaClick(Sender: TObject);
begin
   WebBrowserScreenShot(mapaweb) ;
end;

procedure Tmap.btnPrintClick(Sender: TObject);
var
   vIn, vOut: OleVariant;
begin
   mapaweb.ControlInterface.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut) ;
end;

procedure Tmap.btnSalirClick(Sender: TObject);
begin
   Close;
end;

procedure Tmap.WebBrowserScreenShot(const wb: TWebBrowser) ;
 var
   viewObject : IViewObject;
   r : TRect;
   bitmap : TBitmap;
   w : word;
   h : THandle;
   p : HPALETTE;
 begin
   if wb.Document <> nil then
   begin
     wb.Document.QueryInterface(IViewObject, viewObject) ;
     if Assigned(viewObject) then
     try
       bitmap := TBitmap.Create;
       try
         r := Rect(0, 0, wb.Width, wb.Height) ;
 
         bitmap.Height := wb.Height;
         bitmap.Width := wb.Width;
 
         viewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, Application.Handle, bitmap.Canvas.Handle, @r, nil, nil, 0) ;
         
           
         bitmap.SaveToClipboardFormat(w,h,p);
         ClipBoard.SetAsHandle(w,h);
         {
         with TJPEGImage.Create do
         try
           Assign(bitmap) ;
           SaveToClipboardFormat(w,h,p);
           //SaveToFile(fileName) ;
         finally
           Free;
         end;
         }
         
       finally
         bitmap.Free;
       end;
     finally
       viewObject._Release;
     end;
   end;
 end; 

end.
