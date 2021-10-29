import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';
import 'package:myapp2/waterheater_calculator/wistort_method.dart';

class Wistort extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _wistort();
  }

}

class _wistort extends State<Wistort>{


  @override
  Widget build(BuildContext context) {
   String res = '';
   if(FixtureController.methods.noneDefinedGpm != 0){
      res  += "= ${WistortMethod.result.toStringAsPrecision(3)} ";
      res += "+ ${FixtureController.methods.noneDefinedGpm.toStringAsPrecision(3)} "; 
   }
    
    res += "= ${(WistortMethod.result + FixtureController.methods.noneDefinedGpm).toStringAsPrecision(3)} (gpm)";    

    return  Container(
      child: Column(
      children: [
        Container(
          child: const Text("Wistort's method"),
          padding: const EdgeInsets.only(top: 50, bottom: 50),
        ),
        Container(
          child: const Image(image: AssetImage('assets/images/wistort_Equation.png')),
          padding: const EdgeInsets.only(bottom: 50),
        ),
        Container(
          child: Text("= ${WistortMethod.mean.toStringAsPrecision(3)} + ${WistortMethod.standardDev.toStringAsPrecision(3)}"),
          alignment: Alignment.centerLeft,
          width: 200
        ,),
        Container(
          child: Text(res),
          alignment: Alignment.centerLeft,
          width: 200          
        )
      ],
    )
    );
  }
}