
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/pages/WaterHeaterChoosing/water_heater_choice.dart';
import 'package:myapp2/pages/hunter-page/hunter.dart';
import 'package:myapp2/pages/wistort-page/wistort.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';
import 'exhaustive-enumeration/exhaustive_enumeration.dart';
import 'modified-wistort-page/modified_wistort.dart';

class ResultPage extends StatefulWidget{
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResultPage();
  }
}

class _ResultPage extends State<ResultPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(length: 4, child: 
      Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.five_g), child: Text("Exhaustive Enumeration")),
            Tab(icon: Icon(Icons.four_g_plus_mobiledata), child: Text("Modifed Wistort Method")),
            Tab(icon: Icon(Icons.four_g_mobiledata), child: Text("Wistort's Method")),
            Tab(icon: Icon(Icons.three_g_mobiledata), child: Text("Hunter's Method")),
          ],),
        title: Text('Hunter: ${Zscore.hunterNumber.toStringAsPrecision(3)} -- Stagnation: ${(Zscore.stagnation*100).toStringAsPrecision(3)}% --- Method: ${Zscore.methodReferred}'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              Expanded(child: TabBarView(
                children: [
                  Center(child: ExhaustiveEnumeration()),
                  ModifiedWistort(),
                  Wistort(),
                  Hunter()
                ])
              ),
              Container(
                child: Text("Hunter Point: ${Zscore.hunterNumber.toStringAsPrecision(2)}"),
                alignment: Alignment.centerLeft,
              ),
              Container(
                child: Text("Stagnation: ${(Zscore.stagnation*100).toStringAsPrecision(3)} %"),
                alignment: Alignment.centerLeft,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Method to be used: ${Zscore.methodReferred}"),
              )
            ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => WaterHeaterChoosing()));},
          child: const Icon(Icons.hot_tub),
          ),
      )
    );
  }
}