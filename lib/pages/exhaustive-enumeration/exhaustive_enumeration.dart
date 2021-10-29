import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';

class ExhaustiveEnumeration extends StatelessWidget{
  const ExhaustiveEnumeration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String result = '';
    if(FixtureController.methods.exh.eResult.gpm == 0){
      return const Text("More than 30 Fixtures, can't calculate here");
    }

    if(FixtureController.methods.noneDefinedGpm != 0){
      result += '= ${FixtureController.methods.exh.eResult.gpm.toStringAsPrecision(3)} ';
      result += '+  ${FixtureController.methods.noneDefinedGpm.toStringAsPrecision(3)} ';
    }

    result += '= ${(FixtureController.methods.exh.eResult.gpm + FixtureController.methods.noneDefinedGpm).toStringAsPrecision(3)} (gpm)';
    
    return Text(result);
  }
  
}