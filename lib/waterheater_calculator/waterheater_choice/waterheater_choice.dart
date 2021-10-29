import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';

class WaterHeaterChoice extends ChangeNotifier{
  final String all = "All";
  final double any = -1;
  List<WaterHeater1> wHeaters = [];
  Set<String> brandsS = {"All"}; 
  Set<double> maxCapS = {-1};
  Set<double> capAt45S = {-1};
  Set<double> btuS = {-1};
  Set<double> eFactorS = {-1};
  Set<String> pumpTypeS = {"All"};
  //Set<String> ventTypeS = {"All"};

  List<String> brandsL = [];
  List<double> maxCapL = [];
  List<double> capAt45L = [];
  List<double> btuL = [];
  List<double> eFactorL = [];
  List<String> pumpTypeL = [];
  //List<String> ventTypeL = [];

  String btu = 'btu';
  String brand = 'brand';
  String eFNs = 'eFN';
  String maxCap = 'maxCap';
  String maxCap45 = 'maxCap45';
  String pumpType = 'pumpType';

  Map<String, dynamic> requestPara = {};

  List<WaterHeater1> chosenWeaterHeaters = [];

  WaterHeater1 choosenOne = WaterHeater1(); 
  final _choosenOne = "choosneOne";

  WaterHeaterChoice(){
    requestPara = {
      brand : all,
      btu : -1.0,
      eFNs : -1.0,
      maxCap : -1.0,
      maxCap45: -1.0,
      pumpType: all,
    };
  }

  void reset(){
    requestPara = {
      brand : all,
      btu : -1.0,
      eFNs : -1.0,
      maxCap : -1.0,
      maxCap45: -1.0,
      pumpType: all,
    };
    choosenOne = WaterHeater1();
    notifyListeners();
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> result = {...requestPara};
    result.addAll({_choosenOne: choosenOne.toMap()});
    return result;
  }

  void fromMap(Map<String, dynamic> map){
    requestPara = {
      brand : map[brand],
      btu : map[btu],
      eFNs : map[eFNs],
      maxCap : map[maxCap],
      maxCap45: map[maxCap45],
      pumpType: map[pumpType],
    };
    choosenOne.fromMap(map[_choosenOne] as Map<String, dynamic>);
  }

  Future<double> readFile() async{
    return await  rootBundle.loadString('assets/data/DATABASE_PLUMBING_WATER_HEATER.txt').then((value) {
      List<String> lines = value.split('\n');
      for (int i = 1; i < lines.length; i++) {
        List<String> items = lines[i].toLowerCase().split('\t');
        if(items.isNotEmpty && items.length == 21){
            WaterHeater1 wh = _createGetWaterHeater(items);
          if(wh.brand == "rinnai"){
            List<WaterHeater1> rinnais = wh.copyRinnai();
            wHeaters.addAll(rinnais);
            _initializeList(rinnais[0]);
            _initializeList(rinnais[1]);
          }else{
            wHeaters.add(wh);
            _initializeList(wh);
          }
        }

      }
      maxCapL =  maxCapS.toList(); maxCapL.sort();
      capAt45L = capAt45S.toList(); capAt45L.sort(); 
      brandsL = brandsS.toList(); brandsL.sort();
      btuL = btuS.toList(); btuL.sort();
      eFactorL = eFactorS.toList(); eFactorL.sort();
      pumpTypeL = pumpTypeS.toList(); pumpTypeL.sort();
      //ventTypeL = ventTypeS.toList(); ventTypeL.sort();

      return -1;
    });
  }

  void _initializeList(WaterHeater1 wh){
    brandsS.add(wh.brand);
    maxCapS.add(wh.maxCap);
    capAt45S.add(wh.capAt45);
    btuS.add(wh.btu);
    eFactorS.add(wh.eFactor);
    //ventTypeS.add(wh.ventType);
    pumpTypeS.add(wh.pumpType);
  }

  List<WaterHeater1> choose(){
    chosenWeaterHeaters = wHeaters.where((element)=>
      (requestPara[brand] == all ? true : element.brand == requestPara[brand]) &&
      (requestPara[btu] == any ? true : element.btu >= requestPara[btu]) &&
      (requestPara[maxCap] == any ? true : element.maxCap >= requestPara[maxCap]) &&
      (requestPara[maxCap45] == any ? true : element.capAt45 >= requestPara[maxCap]) &&
      (requestPara[eFNs] == any ? true : element.eFactor >= requestPara[eFNs]) &&
      (requestPara[pumpType] == all ? true : element.pumpType == requestPara[pumpType])
    ).toList();
    
    notifyListeners();

    return chosenWeaterHeaters;
  }

  void setChoosenFalse(){
    for(WaterHeater1 h in chosenWeaterHeaters) {
      h.check = false;
    }
    notifyListeners();
  }

  void chooseAnother(WaterHeater1 wh){
    String la = choosenOne.label;
    String numb = choosenOne.numb;
    String location = choosenOne.location;
    choosenOne = wh;
    choosenOne.label = la;
    choosenOne.numb = numb;
    choosenOne.location = location;
    notifyListeners();
  }



  WaterHeater1 _createGetWaterHeater(List<String> items){
    WaterHeater1 wh        = WaterHeater1();
    wh.brand                        = items[0];
    wh.model                        = items[1];
    wh.pumpType                     = items[2];
    wh.ventType                     = items[3];
    wh.minCap                       = _getDoubleValue(items[4]);
    wh.maxCap                       = _getDoubleValue(items[5]);
    wh.capAt45                      = _getDoubleValue(items[6]);
    wh.btu                          = _getDoubleValue(items[7]);
    wh.eFactor                      = _getDoubleValue(items[8]);
    if(wh.eFactor == -1) wh.eFactor = _getDoubleValue(items[9]);
    wh.width                        = _getDoubleValue(items[10]);
    wh.height                       = _getDoubleValue(items[11]);
    wh.depth                        = _getDoubleValue(items[12]);
    wh.operatingWeight              = _getDoubleValue(items[13]);
    wh.waterConnection              = _getDoubleValue(items[14]);
    wh.gasConnection                = _getDoubleValue(items[15]);
    wh.combustionAir                = items[16];
    wh.exhaustAir                   = items[17];
    wh.electricSupply               = items[18];
    wh.electricPower               =  _getDoubleValue(items[19]);
    wh.link                         = items[20];
    return wh;
  }

  double _getDoubleValue(String item){
    return double.tryParse(item) == null ? -1 : double.tryParse(item)!;
  }
}

class WaterHeater1{
  String uuid = '';
  bool check = false;
  String brand = '';
  String model = '';
  String pumpType = '';
  String ventType = '';
  double minCap = -1;
  double maxCap = -1;
  double capAt45 = -1;
  double btu = -1;
  double eFactor = -1; // EnergyFactor OR Thermal Efficiency.
  double width = -1;
  double height = -1;
  double depth = -1;
  double operatingWeight = -1;
  double waterConnection = -1;
  double gasConnection = -1;
  String combustionAir = '';
  String exhaustAir = '';
  String electricSupply = '';
  double electricPower = -1; //wattage
  String link = '';
  String label = "TWH";
  String numb = "1";
  String location = 'input location';


  final _uuid = 'uuid';
  final _brand = 'brand';
  final _model = 'model';
  final _pumpType = 'pumpType';
  final _ventType = 'ventType';
  final _minCap = 'minCap';
  final _maxCap = 'maxCap';
  final _capAt45 = 'capAt45';
  final _btu = 'btu';
  final _eFactor = 'eFactor';
  final _width = 'width';
  final _height = 'height';
  final _depth = 'depth';
  final _operatingWeight = 'operatingWeight';
  final _waterConnection = 'waterConnection';
  final _gasConnection = 'gasConnection';
  final _combustionAir = 'combustionAir';
  final _exhaustAir = 'exhaustAir';
  final _electricSupply = 'electricSupply';
  final _electricPower = 'electricPower';
  final _link = 'link';
  final _label = "label";
  final _numb = "numb";
  final _location = "location";



  List<WaterHeater1> copyRinnai(){
    WaterHeater1 nwh1 = copy(this);
    WaterHeater1 nwh2 = copy(this);

    nwh1.model += "N";
    nwh2.model += "P";
    return [nwh1, nwh2];
  }

  WaterHeater1 copy(WaterHeater1 wh){
    WaterHeater1 nwh = WaterHeater1();
    nwh.uuid = wh.uuid;
    nwh.brand = wh.brand;
    nwh.model = wh.model;
    nwh.pumpType = wh.pumpType;
    nwh.ventType = wh.ventType;
    nwh.minCap = wh.minCap;
    nwh.maxCap = wh.maxCap;
    nwh.capAt45 = wh.capAt45;
    nwh.btu = wh.btu;
    nwh.eFactor = wh.eFactor;
    nwh.width = wh.width;
    nwh.height = wh.height;
    nwh.depth = wh.depth;
    nwh.operatingWeight = wh.operatingWeight;
    nwh.waterConnection = wh.waterConnection;
    nwh.gasConnection = wh.gasConnection;
    nwh.combustionAir = wh.combustionAir;
    nwh.exhaustAir = wh.exhaustAir;
    nwh.electricSupply = wh.electricSupply;
    nwh.electricPower = wh.electricPower;
    nwh.link = wh.link;
    nwh.label = wh.label;
    nwh.numb = wh.numb;
    nwh.location = wh.location;

    return nwh;
  }

  Map<String, dynamic> toMap(){
    uuid = FixtureController.uuid;
    return {
      _uuid : uuid,
      _brand : brand,
      _model: model,
      _pumpType : pumpType,
      _ventType : ventType,
      _minCap : minCap,
      _maxCap : maxCap,
      _capAt45 : capAt45,
      _btu : btu,
      _eFactor : eFactor,
      _width : width,
      _height : height,
      _depth : depth,
      _operatingWeight : operatingWeight,
      _waterConnection : waterConnection,
      _gasConnection : gasConnection,
      _combustionAir : combustionAir,
      _exhaustAir : exhaustAir,
      _electricSupply : electricSupply,
      _electricPower : electricPower,
      _link : link,
      _label : label,
      _numb : numb,
      _location : location,
    };
  }

  void fromMap(Map<String, dynamic> map){
      uuid = map[_uuid];
      brand = map[_brand];
      model = map[_model];
      pumpType = map[_pumpType]; 
      ventType = map[_ventType];
      minCap = map[_minCap]; 
      maxCap= map[_maxCap];
      capAt45= map[_capAt45];
      btu= map[_btu];
      eFactor = map[_eFactor];
      width  = map[_width];
      height = map[_height];
      depth = map[_depth];
      operatingWeight = map[_operatingWeight];
      waterConnection = map[_waterConnection];
      gasConnection = map[_gasConnection];
      combustionAir = map[_combustionAir];
      exhaustAir = map[_exhaustAir];
      electricSupply = map[_electricSupply];
      electricPower = map[_electricPower];
      link = map[_link];
      label = map[_label];
      numb = map[_numb];
      location = map[_location];
  }

  String toJson(){
    return jsonEncode(toMap());
  }

  String getDimensions(){
    String widthS = '#', heightS = '#', depthS = '#'; 
    if(width != -1)  widthS  = width.toStringAsFixed(2);
    if(height != -1) heightS = height.toStringAsFixed(2);
    if(depth != -1)  depthS  = depth.toStringAsFixed(2);
    return widthS + ' x ' + heightS + ' x ' + depthS + "\"";
  }

  String getOperationWeight(){
    String opWeight = "N/A";
    if(operatingWeight != -1) return operatingWeight.toStringAsFixed(2) + " lbs";
    return opWeight;
  }

  String getWaterConnection(){
    return _covertToEngNote(waterConnection) + "\"";
  }

  String getGasConnection(){
    return _covertToEngNote(gasConnection) + "\"";
  }

  String getElectricPow(){
    return _covertToEngNote(electricPower) + " watts";
  }

  String _covertToEngNote(double number){
    if(number == -1) {
      return "_";
    } else if(number == 0.75) {
      return "3/4";
    } else if(number == 0.5) {
      return "1/2";
    } else if(number == 1) {
      return "1";
    } else {
      return number.toStringAsFixed(2);
    }
  }
}

/**
 * preventDefault: Useful for client-side form handling.
 * stopPropagation: prevent the event reaching the next element.
 * 
 * //-----------
 * Create Dispatch events;
 * 
 * 
 */