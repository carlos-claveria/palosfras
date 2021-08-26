object DM: TDM
  OldCreateOrder = False
  Height = 578
  Width = 1082
  object LC: TLocalConnection
    Left = 8
    Top = 8
  end
  object q: TUniQuery
    Connection = GDM.adb
    AutoCalcFields = False
    Left = 48
    Top = 8
  end
  object i: TUniSQL
    Connection = GDM.adb
    Left = 88
    Top = 8
  end
  object xAbonados: TUniQuery
    KeyFields = 'CCONTRI'
    Connection = GDM.adb
    SQL.Strings = (
      'SELECT * FROM TCONTRI')
    FetchRows = 65000
    ReadOnly = True
    AutoCalcFields = False
    IndexFieldNames = 'CCONTRI'
    Left = 128
    Top = 8
  end
  object xOT: TUniQuery
    KeyFields = 'IDCO'
    Connection = GDM.adb
    SQL.Strings = (
      'SELECT C.IDCO,U.OT FROM TCONTAD C, TUF U WHERE C.IDOT = U.IDOT')
    FetchRows = 65000
    ReadOnly = True
    AutoCalcFields = False
    Left = 184
    Top = 8
    object xOTIDCO: TLargeintField
      FieldName = 'IDCO'
      KeyFields = 'IDCO'
      Required = True
    end
    object xOTOT: TStringField
      FieldName = 'OT'
      ReadOnly = True
      Required = True
      Size = 50
    end
  end
  object qCabecera: TUniQuery
    UpdatingTable = 'cabecera'
    KeyFields = 'suma;numrec;fecha;serie'
    SQLInsert.Strings = (
      'INSERT INTO cabecera'
      
        '  (IDREC, SERIE, NUMREC, TASA, CPOBLA, ANO, PERIODO, BLOQUE, IDC' +
        'O, CCONTRI, FECHA, PERSONA, NIF, DIRECCION, POBLACION, PAIS, OT,' +
        ' BONIFICACION, TOTAL, DOMICILIACION, TITULARCCC, ESTADO, SUBESTA' +
        'DO, IDREMESA, MOMENTO, MOMENTOBLQ, FPAGO, EFECHA, ETASAS, EFNOTI' +
        'F, GFECHA, GTASAS, GFNOTIF, IFECHA, ITASAS, IFNOTIF, ABONO, RECT' +
        'IF, AUDI, GASTOS, IDPAGO, TPCRECARGO, NUEVOMOM, FNUEVOMOM, CFECH' +
        'A, CTASAS, PROVIDENCIA, FPROVIDENCIA, IDEXP, REMESA63, POLIZA, C' +
        'ONTADOR, LECANTE, FLECANTE, LECACTU, FLECACTU, M3, INCACTU, CBON' +
        'IF, DOTACIONES, SINCANON, CANONLIQ, NEWTOTAL, CANON, APAGAR, SUM' +
        'A, REFEXTERNA, IDPP)'
      'VALUES'
      
        '  (:IDREC, :SERIE, :NUMREC, :TASA, :CPOBLA, :ANO, :PERIODO, :BLO' +
        'QUE, :IDCO, :CCONTRI, :FECHA, :PERSONA, :NIF, :DIRECCION, :POBLA' +
        'CION, :PAIS, :OT, :BONIFICACION, :TOTAL, :DOMICILIACION, :TITULA' +
        'RCCC, :ESTADO, :SUBESTADO, :IDREMESA, :MOMENTO, :MOMENTOBLQ, :FP' +
        'AGO, :EFECHA, :ETASAS, :EFNOTIF, :GFECHA, :GTASAS, :GFNOTIF, :IF' +
        'ECHA, :ITASAS, :IFNOTIF, :ABONO, :RECTIF, :AUDI, :GASTOS, :IDPAG' +
        'O, :TPCRECARGO, :NUEVOMOM, :FNUEVOMOM, :CFECHA, :CTASAS, :PROVID' +
        'ENCIA, :FPROVIDENCIA, :IDEXP, :REMESA63, :POLIZA, :CONTADOR, :LE' +
        'CANTE, :FLECANTE, :LECACTU, :FLECACTU, :M3, :INCACTU, :CBONIF, :' +
        'DOTACIONES, :SINCANON, :CANONLIQ, :NEWTOTAL, :CANON, :APAGAR, :S' +
        'UMA, :REFEXTERNA, :IDPP)')
    SQLDelete.Strings = (
      'DELETE FROM cabecera'
      'WHERE'
      
        '  SERIE = :Old_SERIE AND NUMREC = :Old_NUMREC AND ANO = :Old_ANO' +
        ' AND FECHA = :Old_FECHA')
    SQLUpdate.Strings = (
      'UPDATE cabecera'
      'SET'
      
        '  IDREC = :IDREC, SERIE = :SERIE, NUMREC = :NUMREC, TASA = :TASA' +
        ', CPOBLA = :CPOBLA, ANO = :ANO, PERIODO = :PERIODO, BLOQUE = :BL' +
        'OQUE, IDCO = :IDCO, CCONTRI = :CCONTRI, FECHA = :FECHA, PERSONA ' +
        '= :PERSONA, NIF = :NIF, DIRECCION = :DIRECCION, POBLACION = :POB' +
        'LACION, PAIS = :PAIS, OT = :OT, BONIFICACION = :BONIFICACION, TO' +
        'TAL = :TOTAL, DOMICILIACION = :DOMICILIACION, TITULARCCC = :TITU' +
        'LARCCC, ESTADO = :ESTADO, SUBESTADO = :SUBESTADO, IDREMESA = :ID' +
        'REMESA, MOMENTO = :MOMENTO, MOMENTOBLQ = :MOMENTOBLQ, FPAGO = :F' +
        'PAGO, EFECHA = :EFECHA, ETASAS = :ETASAS, EFNOTIF = :EFNOTIF, GF' +
        'ECHA = :GFECHA, GTASAS = :GTASAS, GFNOTIF = :GFNOTIF, IFECHA = :' +
        'IFECHA, ITASAS = :ITASAS, IFNOTIF = :IFNOTIF, ABONO = :ABONO, RE' +
        'CTIF = :RECTIF, AUDI = :AUDI, GASTOS = :GASTOS, IDPAGO = :IDPAGO' +
        ', TPCRECARGO = :TPCRECARGO, NUEVOMOM = :NUEVOMOM, FNUEVOMOM = :F' +
        'NUEVOMOM, CFECHA = :CFECHA, CTASAS = :CTASAS, PROVIDENCIA = :PRO' +
        'VIDENCIA, FPROVIDENCIA = :FPROVIDENCIA, IDEXP = :IDEXP, REMESA63' +
        ' = :REMESA63, POLIZA = :POLIZA, CONTADOR = :CONTADOR, LECANTE = ' +
        ':LECANTE, FLECANTE = :FLECANTE, LECACTU = :LECACTU, FLECACTU = :' +
        'FLECACTU, M3 = :M3, INCACTU = :INCACTU, CBONIF = :CBONIF, DOTACI' +
        'ONES = :DOTACIONES, SINCANON = :SINCANON, CANONLIQ = :CANONLIQ, ' +
        'NEWTOTAL = :NEWTOTAL, CANON = :CANON, APAGAR = :APAGAR, SUMA = :' +
        'SUMA, REFEXTERNA = :REFEXTERNA, IDPP = :IDPP'
      'WHERE'
      
        '  SERIE = :Old_SERIE AND NUMREC = :Old_NUMREC AND ANO = :Old_ANO' +
        ' AND FECHA = :Old_FECHA')
    SQLLock.Strings = (
      'SELECT * FROM cabecera'
      'WHERE'
      
        '  SERIE = :Old_SERIE AND NUMREC = :Old_NUMREC AND ANO = :Old_ANO' +
        ' AND FECHA = :Old_FECHA'
      'FOR UPDATE')
    SQLRefresh.Strings = (
      
        'SELECT IDREC, SERIE, NUMREC, TASA, CPOBLA, ANO, PERIODO, BLOQUE,' +
        ' IDCO, CCONTRI, FECHA, PERSONA, NIF, DIRECCION, POBLACION, PAIS,' +
        ' OT, BONIFICACION, TOTAL, DOMICILIACION, TITULARCCC, ESTADO, SUB' +
        'ESTADO, IDREMESA, MOMENTO, MOMENTOBLQ, FPAGO, EFECHA, ETASAS, EF' +
        'NOTIF, GFECHA, GTASAS, GFNOTIF, IFECHA, ITASAS, IFNOTIF, ABONO, ' +
        'RECTIF, AUDI, GASTOS, IDPAGO, TPCRECARGO, NUEVOMOM, FNUEVOMOM, C' +
        'FECHA, CTASAS, PROVIDENCIA, FPROVIDENCIA, IDEXP, REMESA63, POLIZ' +
        'A, CONTADOR, LECANTE, FLECANTE, LECACTU, FLECACTU, M3, INCACTU, ' +
        'CBONIF, DOTACIONES, SINCANON, CANONLIQ, NEWTOTAL, CANON, APAGAR,' +
        ' SUMA, REFEXTERNA, IDPP FROM cabecera'
      'WHERE'
      
        '  SERIE = :SERIE AND NUMREC = :NUMREC AND ANO = :ANO AND FECHA =' +
        ' :FECHA')
    SQLRecCount.Strings = (
      'SELECT COUNT(*) FROM cabecera')
    Connection = GDM.adb
    SQL.Strings = (
      'SELECT * FROM CABECERA')
    AutoCalcFields = False
    Left = 248
    Top = 8
    object qCabeceraIDREC: TLargeintField
      FieldName = 'IDREC'
      Required = True
    end
    object qCabeceraSERIE: TStringField
      FieldName = 'SERIE'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qCabeceraNUMREC: TLargeintField
      FieldName = 'NUMREC'
      Required = True
    end
    object qCabeceraTASA: TStringField
      FieldName = 'TASA'
      Required = True
      FixedChar = True
      Size = 2
    end
    object qCabeceraCPOBLA: TLargeintField
      FieldName = 'CPOBLA'
      Required = True
    end
    object qCabeceraANO: TLargeintField
      FieldName = 'ANO'
      Required = True
    end
    object qCabeceraPERIODO: TLargeintField
      FieldName = 'PERIODO'
      Required = True
    end
    object qCabeceraBLOQUE: TLargeintField
      FieldName = 'BLOQUE'
      Required = True
    end
    object qCabeceraIDCO: TLargeintField
      FieldName = 'IDCO'
    end
    object qCabeceraCCONTRI: TStringField
      FieldName = 'CCONTRI'
      Required = True
      Size = 22
    end
    object qCabeceraFECHA: TDateTimeField
      FieldName = 'FECHA'
      Required = True
    end
    object qCabeceraPERSONA: TStringField
      FieldName = 'PERSONA'
      Required = True
      Size = 60
    end
    object qCabeceraNIF: TStringField
      FieldName = 'NIF'
      Required = True
      Size = 15
    end
    object qCabeceraDIRECCION: TStringField
      FieldName = 'DIRECCION'
      Required = True
      Size = 60
    end
    object qCabeceraPOBLACION: TStringField
      FieldName = 'POBLACION'
      Size = 70
    end
    object qCabeceraPAIS: TStringField
      FieldName = 'PAIS'
    end
    object qCabeceraOT: TStringField
      FieldName = 'OT'
      Size = 60
    end
    object qCabeceraBONIFICACION: TFloatField
      FieldName = 'BONIFICACION'
      Required = True
    end
    object qCabeceraTOTAL: TFloatField
      FieldName = 'TOTAL'
      Required = True
    end
    object qCabeceraDOMICILIACION: TStringField
      FieldName = 'DOMICILIACION'
      Size = 35
    end
    object qCabeceraTITULARCCC: TStringField
      FieldName = 'TITULARCCC'
      Size = 40
    end
    object qCabeceraESTADO: TStringField
      FieldName = 'ESTADO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qCabeceraSUBESTADO: TStringField
      FieldName = 'SUBESTADO'
      FixedChar = True
      Size = 3
    end
    object qCabeceraIDREMESA: TStringField
      FieldName = 'IDREMESA'
      Size = 35
    end
    object qCabeceraMOMENTO: TStringField
      FieldName = 'MOMENTO'
      Required = True
      FixedChar = True
      Size = 3
    end
    object qCabeceraMOMENTOBLQ: TStringField
      FieldName = 'MOMENTOBLQ'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qCabeceraFPAGO: TDateTimeField
      FieldName = 'FPAGO'
    end
    object qCabeceraEFECHA: TDateTimeField
      FieldName = 'EFECHA'
    end
    object qCabeceraETASAS: TFloatField
      FieldName = 'ETASAS'
    end
    object qCabeceraEFNOTIF: TDateTimeField
      FieldName = 'EFNOTIF'
    end
    object qCabeceraGFECHA: TDateTimeField
      FieldName = 'GFECHA'
    end
    object qCabeceraGTASAS: TFloatField
      FieldName = 'GTASAS'
    end
    object qCabeceraGFNOTIF: TDateTimeField
      FieldName = 'GFNOTIF'
    end
    object qCabeceraIFECHA: TDateTimeField
      FieldName = 'IFECHA'
    end
    object qCabeceraITASAS: TFloatField
      FieldName = 'ITASAS'
    end
    object qCabeceraIFNOTIF: TDateTimeField
      FieldName = 'IFNOTIF'
    end
    object qCabeceraABONO: TLargeintField
      FieldName = 'ABONO'
    end
    object qCabeceraRECTIF: TLargeintField
      FieldName = 'RECTIF'
    end
    object qCabeceraAUDI: TStringField
      FieldName = 'AUDI'
      Required = True
      Size = 15
    end
    object qCabeceraGASTOS: TFloatField
      FieldName = 'GASTOS'
    end
    object qCabeceraIDPAGO: TLargeintField
      FieldName = 'IDPAGO'
    end
    object qCabeceraTPCRECARGO: TFloatField
      FieldName = 'TPCRECARGO'
    end
    object qCabeceraNUEVOMOM: TStringField
      FieldName = 'NUEVOMOM'
      FixedChar = True
      Size = 3
    end
    object qCabeceraFNUEVOMOM: TDateTimeField
      FieldName = 'FNUEVOMOM'
    end
    object qCabeceraCFECHA: TDateTimeField
      FieldName = 'CFECHA'
    end
    object qCabeceraCTASAS: TLargeintField
      FieldName = 'CTASAS'
    end
    object qCabeceraPROVIDENCIA: TStringField
      FieldName = 'PROVIDENCIA'
      FixedChar = True
      Size = 1
    end
    object qCabeceraFPROVIDENCIA: TDateTimeField
      FieldName = 'FPROVIDENCIA'
    end
    object qCabeceraIDEXP: TLargeintField
      FieldName = 'IDEXP'
    end
    object qCabeceraREMESA63: TStringField
      FieldName = 'REMESA63'
    end
    object qCabeceraPOLIZA: TStringField
      FieldName = 'POLIZA'
      Size = 15
    end
    object qCabeceraCONTADOR: TStringField
      FieldName = 'CONTADOR'
    end
    object qCabeceraLECANTE: TLargeintField
      FieldName = 'LECANTE'
    end
    object qCabeceraFLECANTE: TDateTimeField
      FieldName = 'FLECANTE'
    end
    object qCabeceraLECACTU: TLargeintField
      FieldName = 'LECACTU'
    end
    object qCabeceraFLECACTU: TDateTimeField
      FieldName = 'FLECACTU'
    end
    object qCabeceraM3: TLargeintField
      FieldName = 'M3'
    end
    object qCabeceraINCACTU: TLargeintField
      FieldName = 'INCACTU'
    end
    object qCabeceraCBONIF: TLargeintField
      FieldName = 'CBONIF'
    end
    object qCabeceraDOTACIONES: TLargeintField
      FieldName = 'DOTACIONES'
    end
    object qCabeceraSINCANON: TFloatField
      FieldName = 'SINCANON'
    end
    object qCabeceraCANONLIQ: TStringField
      FieldName = 'CANONLIQ'
      FixedChar = True
      Size = 1
    end
    object qCabeceraNEWTOTAL: TFloatField
      FieldName = 'NEWTOTAL'
    end
    object qCabeceraCANON: TFloatField
      FieldName = 'CANON'
    end
    object qCabeceraAPAGAR: TFloatField
      FieldName = 'APAGAR'
    end
    object qCabeceraSUMA: TLargeintField
      FieldName = 'SUMA'
    end
    object qCabeceraREFEXTERNA: TStringField
      FieldName = 'REFEXTERNA'
      Size = 45
    end
    object qCabeceraIDPP: TLargeintField
      FieldName = 'IDPP'
    end
  end
  object pAbonados: TDataSetProvider
    DataSet = xAbonados
    Left = 120
    Top = 72
  end
  object pOT: TDataSetProvider
    DataSet = xOT
    Left = 184
    Top = 72
  end
  object qAbonados: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CCONTRI'
        Attributes = [faRequired]
        DataType = ftString
        Size = 22
      end
      item
        Name = 'CPOBLA'
        DataType = ftLargeint
      end
      item
        Name = 'CCALLE'
        DataType = ftLargeint
      end
      item
        Name = 'TIPO'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'APELLIDOS'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'NOMBRE'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'NIF'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'SIG'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'CALLE'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'ADIC'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'NUM'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'BIS'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ESCALERA'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'PISO'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'PUERTA'
        Attributes = [faFixed]
        DataType = ftString
        Size = 15
      end
      item
        Name = 'NUMLOCAL'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'CPOSTAL'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'POBLACION'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'PROVINCIA'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'CODPAIS'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'REPRES'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RNIF'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'DIRREPRES'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'POBREPRES'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'TELEFONO1'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'TELEFONO2'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'EMAIL'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'FALTA'
        DataType = ftDateTime
      end
      item
        Name = 'FACTURAR'
        Attributes = [faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'IDEX01'
        DataType = ftString
        Size = 22
      end
      item
        Name = 'IDEX02'
        DataType = ftString
        Size = 22
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'TEXTO'
        DataType = ftMemo
      end
      item
        Name = 'INE'
        Attributes = [faFixed]
        DataType = ftString
        Size = 6
      end
      item
        Name = 'CONTABLE'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CONTAPRO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SALDO'
        DataType = ftFloat
      end
      item
        Name = 'xxpersona'
        DataType = ftInteger
      end
      item
        Name = 'xxpercontacto'
        DataType = ftInteger
      end
      item
        Name = 'xxdomicilio'
        DataType = ftInteger
      end>
    IndexDefs = <
      item
        Name = 'CCONTRI'
        Fields = 'CCONTRI'
        Options = [ixPrimary, ixUnique]
      end>
    IndexName = 'CCONTRI'
    Params = <>
    ProviderName = 'pAbonados'
    ReadOnly = True
    StoreDefs = True
    Left = 120
    Top = 128
    object qAbonadosCCONTRI: TStringField
      FieldName = 'CCONTRI'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 22
    end
    object qAbonadosCPOBLA: TLargeintField
      FieldName = 'CPOBLA'
    end
    object qAbonadosCCALLE: TLargeintField
      FieldName = 'CCALLE'
    end
    object qAbonadosTIPO: TStringField
      FieldName = 'TIPO'
      FixedChar = True
      Size = 1
    end
    object qAbonadosAPELLIDOS: TStringField
      FieldName = 'APELLIDOS'
      Size = 60
    end
    object qAbonadosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 60
    end
    object qAbonadosNIF: TStringField
      FieldName = 'NIF'
      Size = 15
    end
    object qAbonadosSIG: TStringField
      FieldName = 'SIG'
      Size = 5
    end
    object qAbonadosCALLE: TStringField
      FieldName = 'CALLE'
      Size = 40
    end
    object qAbonadosADIC: TStringField
      FieldName = 'ADIC'
      Size = 40
    end
    object qAbonadosNUM: TStringField
      FieldName = 'NUM'
      Size = 6
    end
    object qAbonadosBIS: TStringField
      FieldName = 'BIS'
      Size = 10
    end
    object qAbonadosESCALERA: TStringField
      FieldName = 'ESCALERA'
      Size = 5
    end
    object qAbonadosPISO: TStringField
      FieldName = 'PISO'
      Size = 5
    end
    object qAbonadosPUERTA: TStringField
      FieldName = 'PUERTA'
      FixedChar = True
      Size = 15
    end
    object qAbonadosNUMLOCAL: TStringField
      FieldName = 'NUMLOCAL'
      Size = 5
    end
    object qAbonadosCPOSTAL: TStringField
      FieldName = 'CPOSTAL'
      Size = 5
    end
    object qAbonadosPOBLACION: TStringField
      FieldName = 'POBLACION'
      Size = 40
    end
    object qAbonadosPROVINCIA: TStringField
      FieldName = 'PROVINCIA'
      Size = 30
    end
    object qAbonadosCODPAIS: TStringField
      FieldName = 'CODPAIS'
      Size = 30
    end
    object qAbonadosREPRES: TStringField
      FieldName = 'REPRES'
      Size = 40
    end
    object qAbonadosRNIF: TStringField
      FieldName = 'RNIF'
      Size = 15
    end
    object qAbonadosDIRREPRES: TStringField
      FieldName = 'DIRREPRES'
      Size = 50
    end
    object qAbonadosPOBREPRES: TStringField
      FieldName = 'POBREPRES'
      Size = 50
    end
    object qAbonadosTELEFONO1: TStringField
      FieldName = 'TELEFONO1'
      Size = 30
    end
    object qAbonadosTELEFONO2: TStringField
      FieldName = 'TELEFONO2'
      Size = 30
    end
    object qAbonadosEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 60
    end
    object qAbonadosFALTA: TDateTimeField
      FieldName = 'FALTA'
    end
    object qAbonadosFACTURAR: TStringField
      FieldName = 'FACTURAR'
      FixedChar = True
      Size = 1
    end
    object qAbonadosIDEX01: TStringField
      FieldName = 'IDEX01'
      Size = 22
    end
    object qAbonadosIDEX02: TStringField
      FieldName = 'IDEX02'
      Size = 22
    end
    object qAbonadosFAX: TStringField
      FieldName = 'FAX'
      Size = 30
    end
    object qAbonadosTEXTO: TMemoField
      FieldName = 'TEXTO'
      BlobType = ftMemo
    end
    object qAbonadosINE: TStringField
      FieldName = 'INE'
      FixedChar = True
      Size = 6
    end
    object qAbonadosCONTABLE: TStringField
      FieldName = 'CONTABLE'
    end
    object qAbonadosCONTAPRO: TStringField
      FieldName = 'CONTAPRO'
    end
    object qAbonadosSALDO: TFloatField
      FieldName = 'SALDO'
    end
    object qAbonadosxxpersona: TIntegerField
      FieldName = 'xxpersona'
    end
    object qAbonadosxxpercontacto: TIntegerField
      FieldName = 'xxpercontacto'
    end
    object qAbonadosxxdomicilio: TIntegerField
      FieldName = 'xxdomicilio'
    end
  end
  object qOT: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'IDCO'
        Attributes = [faRequired]
        DataType = ftLargeint
      end
      item
        Name = 'OT'
        Attributes = [faReadonly, faRequired]
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <
      item
        Name = 'IDCO'
        Fields = 'IDCO'
        Options = [ixPrimary, ixUnique]
      end>
    IndexName = 'IDCO'
    Params = <>
    ProviderName = 'pOT'
    ReadOnly = True
    StoreDefs = True
    Left = 192
    Top = 128
    object qOTIDCO: TLargeintField
      FieldName = 'IDCO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qOTOT: TStringField
      FieldName = 'OT'
      ReadOnly = True
      Required = True
      Size = 50
    end
  end
end
