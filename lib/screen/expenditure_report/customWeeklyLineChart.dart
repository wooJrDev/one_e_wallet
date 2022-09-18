// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:one_e_sample/models/chartModel.dart';
// import 'package:one_e_sample/shared_objects/const_values.dart';

// class CustomWeeklyLineChart extends StatefulWidget {

//   List<WeeklyChart> ?wkTrx = [];

//   CustomWeeklyLineChart({this.wkTrx});

//   @override
//   _CustomWeeklyLineChartState createState() => _CustomWeeklyLineChartState();
// }

// class _CustomWeeklyLineChartState extends State<CustomWeeklyLineChart> {
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
//   List<WeeklyChart> sample1OriWeeklyData = [ WeeklyChart(day: 0, trxAmount: 250), WeeklyChart(day: 1, trxAmount: 50), WeeklyChart(day: 2, trxAmount: 22.50), WeeklyChart(day: 3, trxAmount: 65.90), WeeklyChart(day: 4, trxAmount: 12.50), WeeklyChart(day: 5, trxAmount: 210.00), WeeklyChart(day: 6, trxAmount: 130.40)];
//   // List<WeeklyChart> sample2OriWeeklyData = [ WeeklyChart(day: 0, trxAmount: 50), WeeklyChart(day: 1, trxAmount: 0), WeeklyChart(day: 2, trxAmount: 22.50), WeeklyChart(day: 3, trxAmount: 65.90), WeeklyChart(day: 4, trxAmount: 12.50), WeeklyChart(day: 5, trxAmount: 210.00), WeeklyChart(day: 6, trxAmount: 130.40)];
//   List<FlSpot> sampleConvertedWeeklyBigData = [ FlSpot(0, 3.5), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 4), FlSpot(4, 2.3), FlSpot(5, 0.8), FlSpot(6, 1.7)];
//   List<FlSpot> testBigScale = [];

//   convertOriToWeeklyBigScale(List<WeeklyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 6; i++) {
//       tempData.add( FlSpot( dataLst[i].day?.toDouble(), dataLst[i].trxAmount! / 100  ) );
//     }
//     return tempData;
//   }

//   convertOriToWeeklySmallScale(List<WeeklyChart> dataLst) {
//     List<FlSpot> tempData = [];
//     for (var i = 0; i <= 6; i++) {
//       tempData.add( FlSpot( dataLst[i].day?.toDouble(), dataLst[i].trxAmount! / 50  ) );
//     }
//     return tempData;
//   }

//   List<WeeklyChart> getEmptyWeeklyTrx() {
//     List<WeeklyChart> emptyTrx = [];

//     for (var i = 0; i <= 6; i++) {
//       emptyTrx.add( WeeklyChart( day: i, trxAmount: 0.00 ) );
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
//                 'Weekly E-wallet Expenses',
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
//                     padding: const EdgeInsets.only(right: 30.0, left: 14.0, top: 24, bottom: 12),
//                     child: LineChart(
//                       showSmall ? bigScaleData(trxDataResult: widget.wkTrx!) : smallScaleData(trxDataResult: widget.wkTrx!),
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

//   LineChartData smallScaleData({List<WeeklyChart> ?trxDataResult}) {
//     print('PrintEmptyTrx: $getEmptyWeeklyTrx()');

//     List<WeeklyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();
//     //[WeeklyChart( day: 0, trxAmount: 0 ), WeeklyChart( day: 1, trxAmount: 0 ), WeeklyChart( day: 2, trxAmount: 0 ), WeeklyChart( day: 3, trxAmount: 0 ), WeeklyChart( day: 4, trxAmount: 0 ), WeeklyChart( day: 5, trxAmount: 0 ), WeeklyChart( day: 6, trxAmount: 0 )];

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
//           showTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Mon';
//               case 1:
//                 return 'Tue';
//               case 2:
//                 return 'Wed';
//               case 3:
//                 return 'Thur';
//               case 4:
//                 return 'Fri';
//               case 5:
//                 return 'Sat';
//               case 6:
//                 return 'Sun';
//             }
//             return '1';
//           },
//         ),
//         leftTitles: SideTitles( //* Graph left label
//           showTitles: true,
//           getTextStyles: (value) => TextStyle( color: labelColour, fontWeight: FontWeight.bold, fontSize: 15),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '50';
//               case 3:
//                 return '150';
//               case 5:
//                 return '250';
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
//       maxX: 6,
//       minY: 0,
//       maxY: 6,
//       clipData: FlClipData(top: true, bottom: false, left: false, right: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: convertOriToWeeklySmallScale(trxData),
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


//   LineChartData bigScaleData({List<WeeklyChart> ?trxDataResult}) {
    
//     List<WeeklyChart> trxData = trxDataResult ?? getEmptyWeeklyTrx();

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
        
//         bottomTitles: AxisTitles( //* Graph bottom label
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 22, //* Space of the labels
//             getTitlesWidget: (value, meta) =>
//               TextFontStyle.customFontStyle(16, color: labelColour!),
            
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return 'Mon';
//               case 1:
//                 return 'Tue';
//               case 2:
//                 return 'Wed';
//               case 3:
//                 return 'Thur';
//               case 4:
//                 return 'Fri';
//               case 5:
//                 return 'Sat';
//               case 6:
//                 return 'Sun';
//             }
//             return '1';
//           },
//           // margin: 8,
//         ),
        
//         leftTitles: AxisTitles(
          
//           sideTitles: SideTitles( //* Graph left label
//             showTitles: true,
//             getTitlesWidget: (value, meta) => TextFontStyle.customFontStyle(15, color: labelColour!),
//             // getTextStyles: (value) => 
//             getTitles: (value) {
//               switch (value.toInt()) {
//                 case 1:
//                   return '100';
//                 case 3:
//                   return '300';
//                 case 5:
//                   return '500';
//               }
//               return '';
//             },
//             reservedSize: 22,
//             // margin: 12,
//           ),
//         )
//       ),
//       borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)), //* Style the border of the graph
//       //* Number of grids
//       minX: 0,
//       maxX: 6,
//       minY: 0,
//       maxY: 6,
//       clipData: FlClipData(left: false, top: true, right: false, bottom: false),
//       lineBarsData: [
//         LineChartBarData( //* Chart Data
//           spots: convertOriToWeeklyBigScale(trxData),
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