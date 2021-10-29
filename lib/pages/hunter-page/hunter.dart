import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';

class Hunter extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
          Column(
            children: [
              DataTable(
                columnSpacing: wid*0.03,
                columns: const<DataColumn>[
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Amount")),
                  DataColumn(label: Text("FU")),
                  DataColumn(label: Text("Hot FU")),
                  DataColumn(label: Text("Cold FU")),
                  DataColumn(label: Text("Total FU")),
                  DataColumn(label: Text("Total Hot")),
                  DataColumn(label: Text("Total Cold")),
                  DataColumn(label: Text("Total H/C"))
                ], rows: FixtureController.methods.hunter.fixtures.map((fixture) => (
                  DataRow(cells:
                    [
                      DataCell(Text(fixture.name)),
                      DataCell(Text(fixture.amount!.toStringAsPrecision(2))),
                      DataCell(Text(fixture.fixtureUnit!.toStringAsPrecision(2))),
                      DataCell(Text(fixture.hotWaterFixtureUnit!.toStringAsPrecision(2))),
                      DataCell(Text(fixture.coldWaterFixtureUnit!.toStringAsPrecision(2))),
                      DataCell(Text((fixture.amount! * fixture.fixtureUnit!).toStringAsPrecision(2))),
                      DataCell(Text((fixture.amount! * fixture.hotWaterFixtureUnit!).toStringAsPrecision(2))),
                      DataCell(Text((fixture.amount! * fixture.coldWaterFixtureUnit!).toStringAsPrecision(2))),
                      DataCell(Text((fixture.amount! * fixture.coldWaterFixtureUnit! + fixture.amount! * fixture.hotWaterFixtureUnit!).toStringAsPrecision(2)))
                    ]
                  )
                )).toList()
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          Text("Total Fixture Units    : ${FixtureController.methods.hunter.sum.toStringAsPrecision(2)} (Unit)",),
                          Text("Total Hot Fixture Units: ${FixtureController.methods.hunter.hotSum.toStringAsPrecision(2)} (Unit)"),
                          Text("Total Cold Units       : ${FixtureController.methods.hunter.coldSum.toStringAsPrecision(2)} (Unit)"),
                          Container(padding: const EdgeInsets.only(top: 10),),
                          const Text("Flush Valve: ", style: TextStyle(color: Colors.red)),
                          Text("Water Supply           : ${FixtureController.methods.hunter.valveTank.second.toStringAsPrecision(2)} gpm"),
                          Text("Hot Water              : ${FixtureController.methods.hunter.hotValveTank.second.toStringAsPrecision(2)} gpm"),
                          Text("Cold Water             : ${FixtureController.methods.hunter.coldValveTank.second.toStringAsPrecision(2)} gpm"),
                          Container(padding: const EdgeInsets.only(top: 10),),
                          const Text("Tank: ", style: TextStyle(color: Colors.blue)),
                          Text("Water Supply           : ${FixtureController.methods.hunter.flushTank.second.toStringAsPrecision(2)} gpm"),
                          Text("Hot Water              : ${FixtureController.methods.hunter.hotFlushTank.second.toStringAsPrecision(2)} gpm"),
                          Text("Cold Water             : ${FixtureController.methods.hunter.coldFlushTank.second.toStringAsPrecision(2)} gpm"),
                  ],
                ),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 30)
              ),
            ],
          ),
      ),
    );
  }

}