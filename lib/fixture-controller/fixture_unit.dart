import 'dart:math';

import 'package:myapp2/fixture-controller/fl_controller.dart';

class Fixture{
  String name = "";
  double? amount = 0;
  double? p1 = 1.0;
  double? gpm = 0;

  double? factorx = 1;
  double? exponential = 0;
  double? p20 = 0;
  double? fixtureUnit = 0;
  double? coldWaterFixtureUnit = 0;
  double? hotWaterFixtureUnit = 0;

  double? curP = -9999;

  //==========================
  final _nameN = "name";
  final _amountN = "amountN";
  final _p1N = "p1";
  final _gpmN = "gpm";

  final _factorxN = "factorX";
  final _exponentialN = "exponential";
  final _p20N = "p20";
  final _fixtureUnitN = "fixtureUnit";
  final _coldWaterFixtureUnitN = "coldWaterFixtureUnit";
  final _hotWaterFixtureUnitN = "hotWaterFixtureUnit";

  Fixture(this.name, 
          this.p1,
          this.gpm,
          this.exponential,
          this.factorx,
          this.p20,

          this.fixtureUnit,
          this.coldWaterFixtureUnit,
          this.hotWaterFixtureUnit
          );

  Fixture.newBlank(){}

  Map<String, dynamic> toMap(){
    return {
      _nameN : name,
      _amountN: amount,
      _p1N : p1,
      _gpmN : gpm,
      _factorxN : factorx,
      _exponentialN : exponential,
      _p20N : p20,
      _fixtureUnitN : fixtureUnit,
      _coldWaterFixtureUnitN : coldWaterFixtureUnit,
      _hotWaterFixtureUnitN : hotWaterFixtureUnit
    };
  }

  void fromMap(Map<String, dynamic> map){
    name = map[_nameN] as String;
    amount = map[_amountN] as double?;
    p1 = map[_p1N] as double?;
    gpm = map[_gpmN] as double?;
    factorx = map[_factorxN] as double?;
    exponential = map[_exponentialN] as double?;
    p20 = map[_p20N] as double?;
    fixtureUnit = map[_fixtureUnitN] as double?;
    coldWaterFixtureUnit = map[_coldWaterFixtureUnitN] as double?;
    hotWaterFixtureUnit = map[_hotWaterFixtureUnitN] as double?;

    getProbability(FixtureController.fl.numberOfApartment);
  }

  Fixture.copy(Fixture fixture){
    copy(fixture);
  }

  void copy(Fixture fixture){
    name = fixture.name;
    amount = fixture.amount;
    p1 = fixture.p1;
    gpm = fixture.gpm;

    factorx = fixture.factorx;
    exponential = fixture.exponential;
    p20 = fixture.p20;  

    fixtureUnit = fixture.fixtureUnit;  
    hotWaterFixtureUnit = fixture.hotWaterFixtureUnit;
    coldWaterFixtureUnit = fixture.coldWaterFixtureUnit;
  }

  void getProbability(int numOfApartment){
    if(numOfApartment == 1){
      curP = p1;
    }else if(numOfApartment > 1 && numOfApartment < 20){
      curP = factorx!*p1!*pow(numOfApartment, exponential!);
    }else if(numOfApartment >= 20){
      curP = p20;
    }else{
      curP = -9999;
    }
  }
}


//Life cycle hook sequence:

/**
 * ngOnChange()
 * ngOnInit()  is a good place for a component to fetch its initial data.
 * Constructors should do no more than set the initial local variables to simple values.
 * directive's data-bound input properties are not set until after construction.
 * If you need to initialize the directive based on those properties, set them when ngOnInit() runs.
 * ngDoCheck() 
 * ngAfterContentInit()
 * ngAfterContentChecked()
 * ngAfterViewInit()
 * ngAfterViewChecked()
 * ngOnDestroy()
 * 
 * 
 */