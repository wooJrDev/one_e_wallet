// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:one_e_sample/models/chartModel.dart';
// import 'package:one_e_sample/shared_objects/const_values.dart';

// class CustomMonthlyLineChart extends StatefulWidget {

//   List<MonthlyChart> ?mthTrx = [];

//   CustomMonthlyLineChart({this.mthTrx});

//   @override
//   _CustomMonthlyLineChartState createState() => _CustomMonthlyLineChartState();
// }

// class _CustomMonthlyLineChartState extends State<CustomMonthlyLineChart> {
//   List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];

//   List<LineBarSpot> ?linebarspotTestList;


//   //Weekly Data: 0: Monday, 3:Thursday, 6:Sunday
//   //Bigdata: RM100 unit = 1
//   List<MonthlyChart> sample1OriMonthlyData = [ MonthlyChart(week: 0, trxAmount: 900), MonthlyChart(week: 1, trxAmount: 20), MonthlyChart(week: 2, trxAmount: 160), MonthlyChart(week: 3, trxAmount: 250) ];
//   // List<MonthlyChart> sample2OriWeeklyData = [ MonthlyChart(day: 0, trxAmount: 50), MonthlyChart(day: 1, trxAmount: 0), MonthlyChart(day: 2, trxAmount: 22.50), MonthlyChart(day: 3, trxAmount: 65.90), MonthlyChart(day: 4, trxAmount: 12.50), MonthlyChart(day: 5, trxAmount: 210.00), MonthlyChart(day: 6, trxAmount: 130.40)];
  
//   List<FlSpot> sampleConvertedWeeklyBigData = [ FlSpot(0, 2.5), FlSpot(1, 2), FlSpot(2, 0), FlSpot(3, 4)];
//   List<FlSpot> testBigScale = [];

//   convertOriToMonthlyBigScale(List<MonthlyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 3; i++) {
//       tempData.add( FlSpot( dataLst[i].week?.toDouble(), dataLst[i].trxAmount! / 150  ) );
//     }
//     return tempData;
//   }

//   convertOriToMonthlySmallScale(List<MonthlyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 3; i++) {
//       tempData.add( FlSpot( dataLst[i].week?.toDouble(), dataLst[i].trxAmount! / 100  ) );
//     }
//     return tempData;
//   }

//   List<MonthlyChart> getEmptyWeeklyTrx() {
//     List<MonthlyChart> emptyTrx = [];

//     for (var i = 0; i <= 3; i++) {
//       emptyTrx.add( MonthlyChart( week: i, trxAmount: 0.00 ) );
//     }
//     return emptyTrx;
//   }

//   Color ?bgColour;
//   Color ?gridColour;
//   Color ?labelColour;
//   Color ?axisLabelColour;
//   Color ?subtitleColour;
//   Color ?titleColour;

//   orangeTheme() {
//     bgColour = ColourTheme.orange;
//     gridColour = ColourTheme.graphBgColour_darkBlackBlue;
//     labelColour = ColourTheme.graphBgColour_darkBlackBlue;
//     axisLabelColour = Colors.black;
//     subtitleColour = Colors.black;
//     titleColour = Colors.black;
//   }

//   darkBlueTheme() {
//     bgColour = ColourTheme.graphBgColour_darkBlackBlue;
//     gridColour = ColourTheme.graphGridColour;
//     labelColour = ColourTheme.graphLabelColour;
//     axisLabelColour = Colors.white;
//     subtitleColour = Colors.white;
//     titleColour = Colors.white;
//   }

//   // getToolTipData()

//   bool showSmall = false;

//   @override
//   Widget build(BuildContext context) {
//     darkBlueTheme();
//     return Container(
//       decoration: BoxDecoration(
//           color: bgColour, //*Graph Background Colour
//           borderRadius: BorderRadius.all(
//             Radius.circular(18),
//           ),
//       ),
//       child: Stack(
//         children: <Widget>[
//           Column(
//             children: [
//               const SizedBox(
//                 height: 37,
//               ),
//               Text(
//                 'Monthly E-wallet Expenses',
//                 style: TextFontStyle.customFontStyle(16, color: subtitleColour!),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 17,
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 14.0),
//                   child: Text(
//                     'RM',
//                     style: TextFontStyle.customFontStyle( 15, color: axisLabelColour!),
//                   ),
//                 ),
//               ),
//               AspectRatio(
//                 aspectRatio: 1.70,
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 30.0, left: 14.0, top: 24, bottom: 12),
//                     child: LineChart(
//                       showSmall ? bigScaleData(trxDataResult: widget.mthTrx!) : smallScaleDataV2(trxDataResult: widget.mthTrx!),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             width: 40,
//             height: 34,
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   showSmall = !showSmall;
//                 });
//               },
//               child: FaIcon(showSmall ? FontAwesomeIcons.arrowCircleDown : FontAwesomeIcons.arrowCircleUp , color: Colors.white, size: 20,),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   LineChartData smallScaleData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xff37434d), //* Graph horizontal grid line colour
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: const Color(0xff37434d), //* Graph vertical grid line colour
//             strokeWidth: 1,
//           );
//         },
//       ),
//       // lineTouchData: LineTouchData(
//       //   enabled: true,
//       //   touchTooltipData: LineTouchTooltipData(
//       //     getTooltipItems: (value) {
//       //       List<LineTooltipItem> toolTipData = [LineTooltipItem( sample1OriMonthlyData[value[0].spotIndex].trxAmount.toStringAsFixed(2) , TextStyle(fontSize: 16, color: ColourTheme.fontBlue, fontWeight: FontWeight.bold)) ];
            
//       //       return toolTipData;
//       //     },
//       //   ),
//       // ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles( //* Graph bottom label
//           showTitles: true,
//           reservedSize: 22, //* Space of the labels
//           getTextStyles: (value) =>
//               const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Wk 1';
//               case 1:
//                 return 'Wk 2';
//               case 2:
//                 return 'Wk 3';
//               case 3:
//                 return 'Wk 4';
//             }
//             return '';
//           },
//           margin: 10,
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           interval: 2,
//           checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) {
//             // print('Applied Interval: $appliedInterval');
//             return true;
//           },
//           getTextStyles: (value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//           ),
//           getTitles: (value) {
//             print('Axis value: $value');
//             switch (value.toInt()) {

//               // case 0:
//               //   return '5lol0';
//               // case 2:
//               //   return '50';
//               // case 4:
//               //   return '150';
//               // case 5:
//               //   return '250';
//               // case 6:
//               //   return '350';
//             }
//             return '${value.toInt()}';
//           },
//           reservedSize: 22,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)), //* Style the border of the graph
//       //* Number of grids
//       // minX: 0,
//       // maxX: 3,
//       // minY: 0,
//       maxY: 6,
//       clipData: FlClipData(top: true, bottom: false, left: true, right: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: sampleConvertedWeeklyBigData,
//           //convertOriToWeeklySmallScale(sample1OriMonthlyData),
//           isCurved: true, //* Makes the curve of the graph smooth, true: smooth, false: sharp
//           preventCurveOverShooting: true,
//           colors: gradientColors,
//           barWidth: 5, //* Changes how thick the line of the graph is
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             // checkToShowDot: (dataValue, linechartData) {linechartData.},
//             show: true, //* Changes whether to show the turning points of the graph
//           ),
//           belowBarData: BarAreaData(
//             applyCutOffY: true,
//             cutOffY: 0,
//             show: true, //* Changes whether to paint the graph below charted points
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   LineChartData smallScaleDataV2({List<MonthlyChart> ?trxDataResult}) {
//     List<MonthlyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();

//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: gridColour, //* Graph horizontal grid line colour
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: gridColour, //* Graph vertical grid line colour
//             strokeWidth: 1,
//           );
//         },
//       ),
//       lineTouchData: LineTouchData(
//         enabled: true,
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBottomMargin: 30,
//           fitInsideVertically: true,
//           getTooltipItems: (touchedSpots) {
//             List<LineTooltipItem> toolTipData = [ LineTooltipItem( trxData[ touchedSpots[0].spotIndex ].trxAmount?.toStringAsFixed(2) , TextStyle(fontSize: 16, color: ColourTheme.fontBlue, fontWeight: FontWeight.bold)) ];
//             return toolTipData;
//           },
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles( //* Graph bottom label
//           showTitles: true,
//           reservedSize: 22, //* Space of the labels
//           getTextStyles: (value) =>
//             TextFontStyle.customFontStyle(16, color: labelColour!),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Wk 1';
//               case 1:
//                 return 'Wk 2';
//               case 2:
//                 return 'Wk 3';
//               case 3:
//                 return 'Wk 4';
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           // interval: 2,
//           checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) {
//             // print('Applied Interval: $appliedInterval');
//             return true;
//           },
//           getTextStyles: (value) => TextFontStyle.customFontStyle(15, color: labelColour!),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '100';
//               case 3:
//                 return '300';
//               case 5:
//                 return '500';
//             }
//             return ''; //${value.toInt() == 0 ? 0: value.toInt() * 50}
//           },
//           reservedSize: 22,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)), //* Style the border of the graph
//       //* Number of grids
//       minX: 0,
//       maxX: 3,
//       minY: 0,
//       maxY: 6,
//       clipData: FlClipData(top: true, bottom: false, left: true, right: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: convertOriToMonthlySmallScale(trxData),
//           //sampleConvertedWeeklyBigData,
//           isCurved: true, //* Makes the curve of the graph smooth, true: smooth, false: sharp
//           preventCurveOverShooting: true,
//           colors: gradientColors,
//           barWidth: 5, //* Changes how thick the line of the graph is
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             // checkToShowDot: (dataValue, linechartData) {linechartData.},
//             show: true, //* Changes whether to show the turning points of the graph
//           ),
//           belowBarData: BarAreaData(
//             // applyCutOffY: true,
//             // cutOffY: 0,
//             show: true, //* Changes whether to paint the graph below charted points
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }


//   LineChartData bigScaleData({List<MonthlyChart> ?trxDataResult}) {
//     List<MonthlyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();
    
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: gridColour, //* Graph horizontal grid line colour
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: gridColour, //* Graph vertical grid line colour
//             strokeWidth: 1,
//           );
//         },
//       ),
//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBottomMargin: 30,
//           fitInsideVertically: true,
//           getTooltipItems: (touchedSpots) => [ LineTooltipItem( trxData[ touchedSpots[0].spotIndex ].trxAmount?.toStringAsFixed(2) , TextStyle(fontSize: 16, color: ColourTheme.fontBlue, fontWeight: FontWeight.bold) ) ],
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles( //* Graph bottom label
//           showTitles: true,
//           reservedSize: 22, //* Space of the labels
//           getTextStyles: (value) =>
//             TextFontStyle.customFontStyle(16, color: labelColour!),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Wk 1';
//               case 1:
//                 return 'Wk 2';
//               case 2:
//                 return 'Wk 3';
//               case 3:
//                 return 'Wk 4';
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           getTextStyles: (value) => TextFontStyle.customFontStyle(15, color: labelColour! ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '150';
//               case 3:
//                 return '450';
//               case 5:
//                 return '750';
//             }
//             return '';
//           },
//           reservedSize: 22,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)), //* Style the border of the graph
//       //* Number of grids
//       minX: 0,
//       maxX: 3,
//       minY: 0,
//       maxY: 6,
//       clipData: FlClipData(top: true, bottom: false, left: false, right: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: convertOriToMonthlyBigScale(trxData),
//           isCurved: true, //* Makes the curve of the graph smooth, true: smooth, false: sharp
//           preventCurveOverShooting: true,
//           colors: gradientColors,
//           barWidth: 5, //* Changes how thick the line of the graph is
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: true, //* Changes whether to show the turning points of the graph
//           ),
//           belowBarData: BarAreaData(
//             // applyCutOffY: true,
//             // cutOffY: 0.5,
//             show: true, //* Changes whether to paint the graph below charted points
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }