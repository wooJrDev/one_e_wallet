// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:one_e_sample/models/chartModel.dart';
// import 'package:one_e_sample/shared_objects/const_values.dart';

// class CustomDailyLineChart extends StatefulWidget {

//   final List<DailyChart> ?dailyTrx;

//   CustomDailyLineChart({this.dailyTrx});

//   @override
//   _CustomDailyLineChartState createState() => _CustomDailyLineChartState();
// }

// class _CustomDailyLineChartState extends State<CustomDailyLineChart> {
//   List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];
//   // Color bgColour = ColourTheme.graphBgColour_darkBlackBlue;
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
//   }

//   List<LineBarSpot> ?linebarspotTestList;

//   //Weekly Data: 0: Monday, 3:Thursday, 6:Sunday
//   //Bigdata: RM100 unit = 1
//   List<DailyChart> sample1OriWeeklyData = [ DailyChart(timeOfDay: 0, trxAmount: 250), DailyChart(timeOfDay: 1, trxAmount: 50), DailyChart(timeOfDay: 2, trxAmount: 22.50), DailyChart(timeOfDay: 3, trxAmount: 65.90), DailyChart(timeOfDay: 4, trxAmount: 12.50), DailyChart(timeOfDay: 5, trxAmount: 210.00), DailyChart(timeOfDay: 6, trxAmount: 130.40)];
//   // List<DailyChart> sample2OriWeeklyData = [ DailyChart(timeOfDay: 0, trxAmount: 50), DailyChart(timeOfDay: 1, trxAmount: 0), DailyChart(timeOfDay: 2, trxAmount: 22.50), DailyChart(timeOfDay: 3, trxAmount: 65.90), DailyChart(timeOfDay: 4, trxAmount: 12.50), DailyChart(timeOfDay: 5, trxAmount: 210.00), DailyChart(timeOfDay: 6, trxAmount: 130.40)];
//   List<FlSpot> sampleConvertedDailyBigData = [ FlSpot(0, 3.5), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 4)];
//   List<FlSpot> testBigScale = [];

//   convertOriToDailyBigScale(List<DailyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 3; i++) {
//       tempData.add( FlSpot( dataLst[i].timeOfDay?.toDouble(), dataLst[i].trxAmount! / 25  ) );
//     }
//     return tempData;
//   }

//   convertOriToDailySmallScale(List<DailyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 3; i++) {
//       tempData.add( FlSpot( dataLst[i].timeOfDay?.toDouble(), dataLst[i].trxAmount! / 15  ) );
//     }
//     return tempData;
//   }

//   List<DailyChart> getEmptyWeeklyTrx() {
//     List<DailyChart> emptyTrx = [];

//     for (var i = 0; i <= 3; i++) {
//       emptyTrx.add( DailyChart( timeOfDay: i, trxAmount: 0.00 ) );
//     }
//     return emptyTrx;
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
//                 'Daily E-wallet Expenses',
//                 style: TextFontStyle.customFontStyle(
//                   16,
//                   color: subtitleColour!,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               // Text(
//               //   // "${showSmall ? ' Big Weekly Expenditure' : 'Small Weekly Expenditure'}",
//               //   'Weekly E-wallet Expenditure',
//               //   style: TextStyle(
//               //       color: titleColour,
//               //       fontSize: 32,
//               //       fontWeight: FontWeight.bold,
//               //       letterSpacing: 2),
//               //   textAlign: TextAlign.center,
//               // ),
//               // const SizedBox(
//               //   height: 17,
//               // ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 14.0),
//                   child: Text(
//                     'RM',
//                     style: TextFontStyle.customFontStyle(15, color: axisLabelColour!),
//                   ),
//                 ),
//               ),
//               AspectRatio(
//                 aspectRatio: 1.70,
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 40.0, left: 14.0, top: 24, bottom: 12),
//                     child: LineChart(
//                       showSmall ? bigScaleData(trxDataResult: widget.dailyTrx!) : smallScaleData(trxDataResult: widget.dailyTrx!),
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

//   LineChartData smallScaleData({List<DailyChart> ?trxDataResult}) {
//     print('PrintEmptyTrx: $getEmptyWeeklyTrx()');

//     List<DailyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();
//     //[DailyChart( timeOfDay: 0, trxAmount: 0 ), DailyChart( timeOfDay: 1, trxAmount: 0 ), DailyChart( timeOfDay: 2, trxAmount: 0 ), DailyChart( timeOfDay: 3, trxAmount: 0 ), DailyChart( timeOfDay: 4, trxAmount: 0 ), DailyChart( timeOfDay: 5, trxAmount: 0 ), DailyChart( timeOfDay: 6, trxAmount: 0 )];

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
//           getTooltipItems: (value) {
//             List<LineTooltipItem> toolTipData = [LineTooltipItem( trxData[value[0].spotIndex].trxAmount?.toStringAsFixed(2) , TextStyle(fontSize: 16, color: ColourTheme.fontBlue, fontWeight: FontWeight.bold)) ];
//             return toolTipData;
//           },
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles( //* Graph bottom label
//           showTitles: true,
//           reservedSize: 22, //* Space of the labels
//           margin: 8,
//           getTextStyles: (value) =>
//             TextStyle(color: labelColour, fontWeight: FontWeight.bold, fontSize: 16),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Midnight';
//               case 1:
//                 return 'Morning';
//               case 2:
//                 return 'Noon';
//               case 3:
//                 return 'Evening';
//             }
//             return '';
//           },
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           getTextStyles: (value) => TextStyle( color: labelColour, fontWeight: FontWeight.bold, fontSize: 15),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '15';
//               case 3:
//                 return '45';
//               case 5:
//                 return '75';
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
//           spots: convertOriToDailySmallScale(trxData),
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
//             show: true, //* Changes whether to paint the graph below charted points
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }


//   LineChartData bigScaleData({List<DailyChart> ?trxDataResult}) {
    
//     List<DailyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();

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
//              TextFontStyle.customFontStyle(16, color: labelColour!),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Midnight';
//               case 1:
//                 return 'Morning';
//               case 2:
//                 return 'Noon';
//               case 3:
//                 return 'Evening';
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           getTextStyles: (value) => TextFontStyle.customFontStyle(15, color: labelColour!),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '25';
//               case 3:
//                 return '75';
//               case 5:
//                 return '125';
//             }
//             return '';
//           },
//           reservedSize: 22,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)), //* Style the border of the graph
//       //* Number of cells
//       minX: 0,
//       maxX: 3,
//       minY: 0,
//       maxY: 6,
//       clipData: FlClipData(left: false, top: true, right: false, bottom: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: convertOriToDailyBigScale(trxData),
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