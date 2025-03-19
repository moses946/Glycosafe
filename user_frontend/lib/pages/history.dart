import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime startDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endDate = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  List<_ChartData> chartData = [
    _ChartData('Mon', 363, 0, 0, 149),
    _ChartData('Tue', 0, 0, 0, 0),
    _ChartData('Wed', 0, 0, 0, 0),
    _ChartData('Thu', 0, 0, 0, 0),
    _ChartData('Fri', 0, 0, 0, 0),
    _ChartData('Sat', 0, 0, 0, 0),
    _ChartData('Sun', 0, 0, 0, 0),
  ];

  void _previousWeek() {
    setState(() {
      startDate = startDate.subtract(const Duration(days: 7));
      endDate = endDate.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      startDate = startDate.add(const Duration(days: 7));
      endDate = endDate.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/home2");
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22)),

        title: const Text('History', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
            color:  Colors.white.withOpacity(0.1),
            boxShadow: const [
            BoxShadow(
            color: Color.fromARGB(42, 14, 14, 14),
            blurRadius: 3,
            offset: Offset(0, 2)),
            ]),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white.withAlpha(200)),
                    onPressed: _previousWeek,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${DateFormat('dd MMMM').format(startDate)} - ${DateFormat('dd MMMM').format(endDate)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(200)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.white.withAlpha(200)),
                    onPressed: _nextWeek,
                  ),
                ],
              )

            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color:  Colors.white.withAlpha(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(42, 14, 14, 14),
                        blurRadius: 3,
                        offset: Offset(0, 2)),
                  ]),
              width: MediaQuery.of(context).size.width ,
              child: SfCartesianChart(
                plotAreaBorderColor: Colors.transparent,
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 800,
                  interval: 200,
                ),
                legend: const Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_ChartData, String>>[
                  StackedColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.day,
                    yValueMapper: (_ChartData data, _) => data.breakfast,
                    name: 'Breakfast',
                    color: Colors.lightBlue[300],
                  ),
                  StackedColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.day,
                    yValueMapper: (_ChartData data, _) => data.lunch,
                    name: 'Lunch',
                    color: Colors.lightBlue[100],
                  ),
                  StackedColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.day,
                    yValueMapper: (_ChartData data, _) => data.dinner,
                    name: 'Dinner',
                    color: Colors.blue[900],
                  ),
                  StackedColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.day,
                    yValueMapper: (_ChartData data, _) => data.snacks,
                    name: 'Snacks',
                    color: Colors.blue[500],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color:  Colors.white.withOpacity(0.1),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(42, 14, 14, 14),
                      blurRadius: 3,
                      offset: Offset(0, 2)),
                  
                ]),
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 10.0, ),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2.0,style: BorderStyle.solid, color: Colors.white.withAlpha(100)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Total Calories", style: TextStyle(color: Colors.white.withAlpha(100)),),
                      Text("1250", style: TextStyle(color: Colors.white.withAlpha(150)),),
                    ],),
                  ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 10.0, ),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2.0,style: BorderStyle.solid, color: Colors.white.withAlpha(100)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  Text("Net Calories",style: TextStyle(color: Colors.white.withAlpha(100)),),
                  Text("150",style:TextStyle(color: Colors.white.withAlpha(150))),
                ],),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 10.0, ),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2.0,style: BorderStyle.solid, color: Colors.white.withAlpha(100)))),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  Text("Goal", style: TextStyle(color: Colors.white.withAlpha(100)),),
                  Text("1400", style: TextStyle(color: Colors.white.withAlpha(150))),
                ],),
              )
            ],),)
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.day, this.breakfast, this.lunch, this.dinner, this.snacks);

  final String day;
  final double breakfast;
  final double lunch;
  final double dinner;
  final double snacks;
}
