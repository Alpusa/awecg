import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'dart:math' as math;

import '../repository/I18n.dart';
import '../repository/my_colors.dart';

class SignalContainer extends StatelessWidget {
  double height; // 3508 pixels
  double width; // 2480 pixels
  double ppi; // 300 pixels per inch

  List<double>? ecgData;
  double? scale;
  double? speed;
  double? zoom;
  double? baselineX;
  double? baselineY;
  bool? file = false;
  bool? loaded = false;

  SignalContainer(
      {required this.height,
      required this.width,
      required this.ppi,
      this.ecgData,
      this.scale,
      this.speed,
      this.zoom,
      this.baselineX,
      this.baselineY,
      this.file,
      this.loaded,
      Key? key})
      : super(key: key);

  double getHeight(double value) {
    return value * height / 100;
  }

  double getWidth(double value) {
    return value * width / 100;
  }

  double getDp(double value) {
    return (math.log(width * height * ppi) / math.log(2) / 18 * value).abs();
  }

  @override
  Widget build(BuildContext context) {
    ecgData ??= [];
    scale ??= 10;
    speed ??= 25;
    zoom ??= 1;
    baselineX ??= 0;
    baselineY ??= 0;

    List<double> ecgShow = [];

    print("baselineX: $baselineX");

    if (ecgData!.isNotEmpty) {
      for (int i = 0; i < ecgData!.length; i++) {
        ecgShow.add(ecgData![i] * scale!);
      }
    }

    String scaleText = "";
    String speedText = "";

    if (scale == 10.0) {
      scaleText = '10';
    } else if (scale == 20.0) {
      scaleText = '20';
    } else if (scale == 30.0) {
      scaleText = '30';
    } else if (scale == 2.0) {
      scaleText = '2';
    } else if (scale == 2.5) {
      scaleText = '2.5';
    } else if (scale == 5.0) {
      scaleText = '5';
    }

    if (speed == 25.0) {
      speedText = '25';
    } else if (speed == 30.0) {
      speedText = '30';
    } else if (speed == 50.0) {
      speedText = '50';
    } else if (speed == 20.0) {
      speedText = '20';
    }

    return Container(
      height: height,
      width: width,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: getDp(12),
        bottom: getDp(10),
        left: getDp(10),
        right: getDp(10),
      ),
      child: Stack(
        children: [
          Container(
            child: GestureDetector(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      show: true,
                      color: MyColors.grayL,
                      spots: ecgShow.isEmpty
                          ? []
                          : ecgShow
                              .asMap()
                              .map((index, value) => MapEntry((index),
                                  FlSpot((index) * (0.004) * speed!, value)))
                              .values
                              .toList(),
                      isCurved: false,
                      preventCurveOverShooting: true,
                      //curveSmoothness: 0.1,
                      isStrokeCapRound: false,
                      barWidth: 1,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: false,
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Voltage [mV]',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5), // 0.2
                          fontWeight: FontWeight.bold,
                          fontSize: 12.dp,
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        //getTitlesWidget: leftTitleWidgets,
                        reservedSize: getDp(30),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Time [s]',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5), // 0.2
                          fontWeight: FontWeight.bold,
                          fontSize: getDp(12),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        //getTitlesWidget: bottomTitleWidgets,
                        reservedSize: getDp(26),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1, // scale in mV (0.1 mV)
                    verticalInterval: 1, // scale to show
                    getDrawingHorizontalLine: (value) {
                      return value % 5 == 0
                          ? FlLine(
                              color: MyColors.RedL, // 0.2
                              strokeWidth: 0.5,
                            )
                          : FlLine(
                              color: MyColors.RedL, // 0.2
                              strokeWidth: 0.1,
                            );
                    },
                    getDrawingVerticalLine: (value) {
                      return value % 5 == 0
                          ? FlLine(
                              color: MyColors.RedL, // 0.2
                              strokeWidth: 0.5,
                            )
                          : FlLine(
                              color: MyColors.RedL, // 0.2
                              strokeWidth: 0.1,
                            );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: MyColors.RedL,
                      width: 1,
                    ),
                  ),
                  maxY: 30 * zoom! + baselineY!,
                  minY: -30 * zoom! + baselineY!,
                  minX: (0) + baselineX!,
                  maxX: ((80) * zoom! + baselineX!),
                  clipData: FlClipData.all(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(5.dp),
              decoration: BoxDecoration(
                color: MyColors.RedL,
                borderRadius: BorderRadius.circular(5.dp),
              ),
              child: Text(
                '${I18n.translate("ecgSignal")!} \t ${I18n.translate("scale")!}: $scaleText div/mV \t ${I18n.translate("speed")!}: $speedText div/s',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.dp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
