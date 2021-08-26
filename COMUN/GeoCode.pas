unit GeoCode;

interface

uses
  Classes, Contnrs;

const
  CHAR_SPACE = ' ';
  CHAR_PLUS  = '+';
  STR_WEB    = 'http://maps.google.com/maps/api/geocode/json?address=';
  STR_SENSOR = '&sensor=false';
  STR_REGION = '&region=es';

type

  TCoordenadas = record
    Lat: Real;
    Lon: Real;
  end;

  TDireccion = record
    LongName: string;
    ShortName: string;
    AddrCompType: TStrings;
  end;

  TListaDireccion = array of TDireccion;



  // http://code.google.com/intl/es/apis/maps/documentation/geocoding/#GeocodingRequests

  
  // --------------------------------------------------------------------------
  TPlace = class
  private
    FListaDireccion     : TListaDireccion;
    FDireccionFormat : string;
    FGeoType         : TStrings;
    FCoordenadas     : TCoordenadas;
    
  public 
    constructor Create; virtual;
    destructor Destroy; override;

    property GeoType          : TStrings read FGeoType write FGeoType;
    property GeoFormatedAddr  : string read FDireccionFormat write FDireccionFormat;
    property GeoAddrComp      : TListaDireccion read FListaDireccion write FListaDireccion;
    property GeoGeometry      : TCoordenadas read FCoordenadas write FCoordenadas;
  end;

  TAfterGetData   = procedure (Sender: TObject; AllData: string)     of object;
  TAfterGetValues = procedure (Sender: TObject; AllValues: TStrings) of object;
  // --------------------------------------------------------------------------

  TGeoCode = class
  private
    FDireccion      : string;
    FGeoStatus      : string;
    FBeforeProcess  : TNotifyEvent;
    FAfterProcess   : TNotifyEvent;
    FAfterGetData   : TAfterGetData;
    FAfterGetValues : TAfterGetValues;
    FGeoList        : TObjectList;
    
    FData           : TStrings;

    function GetCount: Integer;
  protected
    procedure Parse;
    function FBusGeoDir( i : integer) : string;
    function FBusGeoLat( i : integer) : string;
    function FBusGeoLon( i : integer) : string;
    
  public

 
     
  
    constructor Create(Dir: string = ''); virtual;
    destructor Destroy; override;

    
    
    // realiza la carga del JSON
    procedure Execute;
    
    // inicializa la estructura
    procedure Clear;

    // dirección que queremos GeoLocalizar
    property Direccion: string read FDireccion write FDireccion;
    
    // cantidad de GeoLocalizaciones devueltas por el API de Google Maps
    property Count: Integer read GetCount;
    
    // JSON devuelto por el API de Google Maps
    property Data: TStrings read FData write FData;
    
    // *********** propiedades devueltas por la geolocalización ***************
    // estado de la consulta
    // http://code.google.com/intl/es/apis/maps/documentation/geocoding/#StatusCodes
    
    property GeoStatus: string read FGeoStatus write FGeoStatus;     // lista de objetos de la clase TPlace, es decir, cada una de las GeoLocalizaciones
    
    //    JSON ya formateado
    property GeoList : TObjectList read FGeoList write FGeoList;
    property MapDir[i : integer]  : string      read FBusGeoDir;
    property MapLat[i : integer]  : string      read FBusGeoLat;
    property MapLon[i : integer]  : string      read FBusGeoLon;

    
    // eventos
    property BeforeProcess  : TNotifyEvent    read FBeforeProcess  write FBeforeProcess;
    property AfterProcess   : TNotifyEvent    read FAfterProcess   write FAfterProcess;
    property AfterGetData   : TAfterGetData   read FAfterGetData   write FAfterGetData;
    property AfterGetValues : TAfterGetValues read FAfterGetValues write FAfterGetValues;

    
  end;

implementation

uses
  IdHTTP, SysUtils,
  uLkJSON;

{ TGeoCode }

function TGeoCode.FBusGeoDir(i: Integer) : string;
begin
  result := TPlace(GeoList[i]).GeoFormatedAddr;
end;
function TGeoCode.FBusGeoLat(i: Integer) : string;
begin
  result := stringreplace(FormatFloat('0.00000', TPlace(GeoList[i]).GeoGeometry.Lat),',','.',[]);
end;  
function TGeoCode.FBusGeoLon(i: Integer) : string;
begin
  result := stringreplace(FormatFloat('0.00000', TPlace(GeoList[i]).GeoGeometry.Lon),',','.',[]);
end;

procedure TGeoCode.Clear;
begin
  FDireccion := '';
  FGeoStatus := '';
  FGeoList.Clear;
  FData.Clear;
end;

constructor TGeoCode.Create(Dir: string);
begin
  FData := TStringList.Create;
  FGeoList := TObjectList.Create;
  
  FGeoStatus := '';
  FDireccion := Dir;

  if FDireccion <> '' then Execute;
end;

destructor TGeoCode.Destroy;
begin
  if Assigned(FGeoList) then FreeAndNil(FGeoList);
  if Assigned(FData) then FreeAndNil(FData);

  inherited;
end;

procedure TGeoCode.Execute;
var
  IdHTTP    : TIdHTTP;
  Str       : string;
  Respuesta : TStringStream;
begin
  if FDireccion = '' then Exit;

  // EVENTO BEFORE PROCESS
  if Assigned(FBeforeProcess) then FBeforeProcess(Self);


  
  IdHTTP := TIdHTTP.Create(nil);
  Respuesta := TStringStream.Create('');
  
  try
    // sustituimos blancos por signo +
    Str := StringReplace(FDireccion, CHAR_SPACE, CHAR_PLUS, [rfReplaceAll]);
    Str := StringReplace(Str, #10, CHAR_PLUS, [rfReplaceAll]);
    Str := StringReplace(Str, #13, '', [rfReplaceAll]);
                                 
    
    // generamos url con parámetros
    Str := STR_WEB + Str + STR_SENSOR + STR_REGION;
    
    // hacemos petición a la API de Google
    IdHTTP.Get(Str, Respuesta);
    
    FData.Text := Respuesta.DataString;
    
  // EVENTO AFTER GETDATA
    if Assigned(FAfterGetData) then FAfterGetData(Self, FData.Text);
    
    // realizamos PARSE
    Parse;
    
    // cargamos los valores básicos
   // CargaValores;
  finally
    if Assigned(Respuesta) then FreeAndNil(Respuesta);
    if Assigned(IdHTTP) then FreeAndNil(IdHTTP);
  end;

  // EVENTO AFTER PROCESS
  if Assigned(FAfterProcess) then FAfterProcess(Self);
end;

function TGeoCode.GetCount: Integer;
begin
  Result := 0;
  if Assigned(FGeoList) then Result := FGeoList.Count;
end;

procedure TGeoCode.Parse;
var
  JSON    : TlkJSONobject;
  JSONL   : TlkJSONlist;
  i, j, k : Integer;
  Place   : TPlace;
  Arr     : TListaDireccion;
  Geo     : TCoordenadas;
begin
  JSON := TlkJSONobject.Create;
  try
    // parseamos el JSON
    JSON := TlkJSON.ParseText(FData.Text) as TlkJSONobject;

    // cogemos el único valor "simple"
    FGeoStatus := UpperCase(JSON.Field['status'].Value);

    // recorremos lista de resultados devueltos
    JSONL := JSON.Field['results'] as TlkJSONlist;
    
    for i := 0 to JSONL.Count - 1 do
    begin
      // por cada resultado, creamos un objeto de TPlace
      Place := TPlace.Create;

      // único valor "simple" del resultado
      Place.GeoFormatedAddr := JSONL.Child[i].Field['formatted_address'].Value;
      
      // lista de tipos (valores "simple" en un array)
      for j := 0 to JSONL.Child[i].Field['types'].Count - 1 do
        Place.GeoType.Add(JSONL.Child[i].Field['types'].Child[j].Value);
        
      // componentes de la dirección
      SetLength(Arr, JSONL.Child[i].Field['address_components'].Count);
      Place.GeoAddrComp := Arr;

      
      for j := 0 to JSONL.Child[i].Field['address_components'].Count - 1 do
      begin
        Place.GeoAddrComp[j].LongName := JSONL.Child[i].Field['address_components'].Child[j].Field['long_name'].Value;
        Place.GeoAddrComp[j].ShortName := JSONL.Child[i].Field['address_components'].Child[j].Field['short_name'].Value;
        Place.GeoAddrComp[j].AddrCompType := TStringList.Create;
        for k := 0 to JSONL.Child[i].Field['address_components'].Child[j].Field['types'].Count - 1 do
          Place.GeoAddrComp[j].AddrCompType.Add(JSONL.Child[i].Field['address_components'].Child[j].Field['types'].Child[k].Value);
      end;
      
      // coordenadas
      Geo.Lat := JSONL.Child[i].Field['geometry'].Field['location'].Field['lat'].Value;
      Geo.Lon := JSONL.Child[i].Field['geometry'].Field['location'].Field['lng'].Value;
      Place.GeoGeometry := Geo;

      FGeoList.Add(Place);
    end;
  finally
    if Assigned(JSON) then FreeAndNil(JSON);
  end;
end;

{ TPlace }

constructor TPlace.Create;
begin
  FGeoType := TStringList.Create;
end;

destructor TPlace.Destroy;
begin
  if Assigned(FGeoType) then FreeAndNil(FGeoType);

  inherited;
end;

end.
