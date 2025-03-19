import 'package:glycosafe_v1/components/individual_bar.dart';

class BarData {
  final int sunAmt;
  final int monAmt;
  final int tueAmt;
  final int wedAmt;
  final int thurAmt;
  final int friAmt;
  final int satAmt;

  BarData({required this.sunAmt, required this.monAmt, required this.tueAmt, required this.wedAmt, required this.thurAmt, required this.friAmt, required this.satAmt});

  List<IndividualBar> barData = [];

  void initializeBars(){
    barData = [
      IndividualBar(x: 0, y: sunAmt),
      IndividualBar(x: 1, y: monAmt),
      IndividualBar(x: 2, y: tueAmt),
      IndividualBar(x: 3, y: wedAmt),
      IndividualBar(x: 4, y: thurAmt),
      IndividualBar(x: 5, y: friAmt),
      IndividualBar(x: 6, y: satAmt),
    ];
  }
}
