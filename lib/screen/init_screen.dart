import 'dart:io';
import 'dart:math';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/models/arrhythmia_result.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:awecg/screen/splash_screen.dart';
import 'package:awecg/widget/load_project.dart';
import 'package:awecg/widget/menu_button.dart';
import 'package:awecg/widget/new_project.dart';
import 'package:awecg/widget/project_patient.dart';
import 'package:awecg/widget/select_mode.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/init_screen/init_screen_bloc.dart';
import '../widget/new_project_patient.dart';
import '../widget/select_bluetooth_device.dart';

class InitScreen extends StatelessWidget {
  InitScreen({super.key});

  double menuButtonPadding = 5.dp;

  List<double>? ecgData;
  List<double>? filterData;
  double? scale;
  double? speed;
  double? zoom;
  double? baselineX;
  double? baselineY;
  ArrhythmiaResult? resultAr;

  bool file = true;
  bool loaded = false;
  bool pause = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /*NavigationRail(
            elevation: 8,
            extended: false,
            leading: IconButton(n  
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {}),
            backgroundColor: MyColors.blueL,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(
                  Icons.share,
                ),
                label: Text('Share'),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.search,
                ),
                label: Text('Search'),
              ),
            ],
            trailing: IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {}),
            selectedIndex: null,
          ),*/
          Container(
            width: 60.dp,
            color: MyColors.blueL,
            child: Column(
              children: [
                BlocListener<InitScreenBloc, InitScreenState>(
                  listener: (context, state) {
                    if (state is InitScreenError) {
                      EasyLoading.showError(state.message);
                    }
                    if (state is ShowNewProjectInitScreenState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return NewProject();
                        },
                      );
                    }
                    if (state is ShowPatientNewProjectInitScreenState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return NewProjectPatient();
                        },
                      );
                    }
                    if (state is ShowSelectBluetoothDeviceInitScreenState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SelectBluetoothDevice();
                        },
                      );
                    }
                    if (state is ShowOpenProjectInitScreenState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return LoadProject();
                        },
                      );
                    }
                    if (state is ShowPatientInformationInitScreenState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProjectPatient(
                            patient: state.patient,
                          );
                        },
                      );
                    }
                    if (state is StartLoadingIntiScreenState) {
                      String? status = state.message;
                      status != null
                          ? EasyLoading.show(
                              status: status,
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black,
                            )
                          : EasyLoading.show(
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black,
                            );
                    }
                    if (state is StopLoadingIntiScreenState) {
                      EasyLoading.dismiss();
                    }
                  },
                  child: Container(
                    height: 0.0,
                    width: 0.0,
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: Tooltip(
                    message: const I18n().newProject,
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      child: /*SvgPicture.asset(
                      'lib/assets/svg_files/up-and-down.svg', // up and down button
                      width: 40.dp,
                      height: 40.dp,
                      color: MyColors.grayL,
                    ),*/
                          Icon(
                        Icons.create_new_folder_outlined,
                        size: 40.dp,
                        color: MyColors.grayL,
                      ),
                      onPressed: () {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(newProjectInitScreen());
                        /*showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext) {
                            return BlocBuilder<InitScreenBloc, InitScreenState>(
                              builder: (context, state) {
                                if (state is SelectBluetoothDeviceInitScreen) {
                                  return SelectBluetoothDevice();
                                }
                                return SelectMode();
                              },
                              buildWhen: (previous, current) =>
                                  current is SelectBluetoothDeviceInitScreen,
                            );
                          });*/
                        /*BlocProvider.of<InitScreenBloc>(context)
                          .add(LoadECGFIleInitScreen());*/
                      },
                    ),
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: Tooltip(
                    message: const I18n().openProject,
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'lib/assets/svg_files/folder.svg', // up and down button
                        width: 35.dp,
                        height: 35.dp,
                        color: MyColors.grayL,
                      ),
                      onPressed: () {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(openProjectInitScreen());
                      },
                    ),
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: Tooltip(
                    message: I18n().patientInformation,
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.assignment_ind_outlined, // Menu button
                        size: 40.dp,
                        color: MyColors.grayL,
                      ),
                      onPressed: () {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(patientInformationInitScreen());
                      },
                    ),
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: Tooltip(
                    message: I18n().exportAsPDF,
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons
                            .picture_as_pdf_outlined, // share button -----------------------------
                        size: 40.dp,
                        color: MyColors.grayL,
                      ),
                      onPressed: () {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(exportECGDataInitScreen());
                      },
                    ),
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Expanded(child: Container()),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: Tooltip(
                    message: I18n().medicalProfessionalInformation,
                    waitDuration: const Duration(seconds: 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.badge_outlined,
                        size: 40.dp,
                        color: MyColors.grayL,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: 12.dp,
                        bottom: 10.dp,
                        left: 10.dp,
                        right: 10.dp,
                      ),
                      child: Stack(
                        children: [
                          BlocBuilder<InitScreenBloc, InitScreenState>(
                            builder: (context, state) {
                              FlSpot? initSpot;
                              FlSpot? endSpot;
                              int stateRule = 0;
                              if (state is InitScreenLoadData) {
                                ecgData = state.data;
                              }
                              if (state is InitScreenTools) {
                                scale = state.scale;
                                speed = state.speed;
                                zoom = state.zoom;
                                ecgData = state.data;
                                filterData = state.data2;
                                baselineX = state.baselineX;
                                file = state.file;
                                loaded = state.loaded;
                                initSpot = state.initSpot;
                                endSpot = state.endSpot;
                                stateRule = state.stateRule;
                                baselineY = state.baselineY;
                              }
                              ecgData ??= [];
                              filterData ??= [];
                              scale ??= 10;
                              speed ??= 25;
                              zoom ??= 1;
                              baselineX ??= 0;
                              baselineY ??= 0;
                              List<double> ecgShow = [];
                              for (int i = 0; i < ecgData!.length; i++) {
                                ecgShow.add(ecgData![i] * scale!);
                              }
                              List<double> filterShow = [];
                              for (int i = 0; i < filterData!.length; i++) {
                                filterShow.add(filterData![i] * scale!);
                              }
                              initSpot = initSpot != null
                                  ? FlSpot(initSpot.x * (0.004) * speed!,
                                      initSpot.y * scale!)
                                  : null;
                              endSpot = endSpot != null
                                  ? FlSpot(endSpot.x * (0.004) * speed!,
                                      endSpot.y * scale!)
                                  : null;
                              return Container(
                                child: GestureDetector(
                                  child: LineChart(
                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        enabled: true,
                                        mouseCursorResolver: (p0, p1) {
                                          return SystemMouseCursors.precise;
                                        },
                                        touchSpotThreshold: 5,
                                        distanceCalculator:
                                            (touchPoint, spotPixelCoordinates) {
                                          return (touchPoint -
                                                  spotPixelCoordinates)
                                              .distance;
                                        },
                                        touchCallback: (event, response) {
                                          if (event is FlTapUpEvent) {
                                            if (response != null) {
                                              if (response.lineBarSpots !=
                                                  null) {
                                                if (response
                                                    .lineBarSpots!.isNotEmpty) {
                                                  int x = (response
                                                              .lineBarSpots![0]
                                                              .x /
                                                          speed! /
                                                          0.004)
                                                      .round()
                                                      .toInt();
                                                  double y =
                                                      ecgData![x.toInt()];

                                                  if (file && loaded) {
                                                    BlocProvider.of<
                                                                InitScreenBloc>(
                                                            context)
                                                        .add(SetRulePointInitScreen(
                                                            spot: FlSpot(
                                                                x.toDouble(),
                                                                y)));
                                                  }
                                                }
                                              } else {
                                                BlocProvider.of<InitScreenBloc>(
                                                        context)
                                                    .add(
                                                        ResetRulePointInitScreen());
                                              }
                                            } else {
                                              BlocProvider.of<InitScreenBloc>(
                                                      context)
                                                  .add(
                                                      ResetRulePointInitScreen());
                                            }
                                          }
                                        },
                                        touchTooltipData: LineTouchTooltipData(
                                          //maxContentWidth: 1,
                                          tooltipBgColor: MyColors.RedL,
                                          fitInsideHorizontally: true,
                                          fitInsideVertically: true,
                                          maxContentWidth: 300.dp,
                                          getTooltipItems: (touchedSpots) {
                                            final textStyle = TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.dp,
                                            );
                                            if (touchedSpots.length > 1 &&
                                                initSpot != null &&
                                                endSpot != null) {
                                              double init =
                                                  ((initSpot.x) / speed!);
                                              double end =
                                                  ((endSpot.x) / speed!);
                                              double initY =
                                                  initSpot.y / scale!;
                                              double endY = endSpot.y / scale!;
                                              return [
                                                LineTooltipItem(
                                                    '${const I18n().timeDifference}: ${((end - init).abs()).toStringAsFixed(3)} s\n${const I18n().voltageDifference}: ${((endY - initY).abs()).toStringAsFixed(2)} mV',
                                                    textStyle),
                                                LineTooltipItem(
                                                    '${const I18n().time}: ${(touchedSpots[1].x / speed!).toStringAsFixed(3)} s\n${const I18n().voltage}: ${(touchedSpots[1].y / scale!).toStringAsFixed(2)} mV',
                                                    textStyle),
                                              ];
                                            }
                                            if (touchedSpots.length > 1) {
                                              touchedSpots.removeAt(0);
                                            }
                                            return touchedSpots
                                                .map((LineBarSpot touchedSpot) {
                                              return LineTooltipItem(
                                                  '${const I18n().time}: ${(touchedSpot.x / speed!).toStringAsFixed(3)} s\n${const I18n().voltage}: ${(touchedSpot.y / scale!).toStringAsFixed(2)} mV',
                                                  textStyle);
                                            }).toList();
                                          },
                                        ),
                                        handleBuiltInTouches: true,
                                        getTouchedSpotIndicator:
                                            (barData, spotIndexes) {
                                          return spotIndexes.map((spotIndex) {
                                            final spot =
                                                barData.spots[spotIndex];
                                            if (spot.x == 0 || spot.x == 1) {
                                              return null;
                                            }
                                            return TouchedSpotIndicatorData(
                                              FlLine(
                                                color: Colors.transparent,
                                                strokeWidth: 4,
                                              ),
                                              FlDotData(
                                                show: true,
                                                getDotPainter: (spot, percent,
                                                    barData, index) {
                                                  return FlDotCirclePainter(
                                                    radius: 4,
                                                    color: MyColors.RedL,
                                                    strokeWidth: 2,
                                                    strokeColor: Colors.white,
                                                  );
                                                },
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          show: filterShow.isNotEmpty,
                                          spots: filterShow
                                              .asMap()
                                              .entries
                                              .map((e) => FlSpot(
                                                  e.key.toDouble() *
                                                      0.004 *
                                                      speed!,
                                                  e.value))
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
                                        LineChartBarData(
                                          show: (initSpot != null ||
                                                      endSpot != null) &&
                                                  file &&
                                                  loaded
                                              ? true
                                              : false,
                                          color: MyColors.purpleL,
                                          spots: [
                                            initSpot ?? const FlSpot(0, 0),
                                            endSpot ??
                                                (initSpot ??
                                                    const FlSpot(0, 0)),
                                          ],
                                        ),
                                        LineChartBarData(
                                          show: true,
                                          color: MyColors.grayL,
                                          spots: ecgShow.isEmpty
                                              ? []
                                              : ecgShow
                                                  .asMap()
                                                  .map((index, value) =>
                                                      MapEntry(
                                                          (index),
                                                          FlSpot(
                                                              (index) *
                                                                  (0.004) *
                                                                  speed!,
                                                              value)))
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
                                              color: Colors.black
                                                  .withOpacity(0.5), // 0.2
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.dp,
                                            ),
                                          ),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            //getTitlesWidget: leftTitleWidgets,
                                            reservedSize: 30.dp,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          axisNameWidget: Text(
                                            'Time [s]',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5), // 0.2
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.dp,
                                            ),
                                          ),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            //getTitlesWidget: bottomTitleWidgets,
                                            reservedSize: 26.dp,
                                          ),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        drawHorizontalLine: true,
                                        drawVerticalLine: true,
                                        horizontalInterval:
                                            1, // scale in mV (0.1 mV)
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
                              );
                            },
                            buildWhen: (previous, current) =>
                                current is InitScreenLoadData ||
                                current is InitScreenInitial ||
                                current is InitScreenTools,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: BlocBuilder<InitScreenBloc, InitScreenState>(
                              builder: (context, state) {
                                double maxvalue = 0;

                                if (state is InitScreenTools) {
                                  speed = state.speed;
                                  zoom = state.zoom;
                                  scale = state.scale;
                                  baselineX = state.baselineX;
                                  maxvalue = state.silverMax;
                                  file = state.file;
                                  loaded = state.loaded;
                                }
                                baselineX ??= 0;
                                speed ??= 25;
                                zoom ??= 1;
                                if (file && loaded) {
                                  return Tooltip(
                                    message: const I18n().horizontalAlignment,
                                    child: Slider(
                                      onChanged: (value) {
                                        BlocProvider.of<InitScreenBloc>(context)
                                            .add(ChangeBaselineXInitScreen(
                                                baselineX: (value)));
                                      },
                                      value: baselineX!,
                                      min: 0,
                                      max: maxvalue,
                                    ),
                                  );
                                }

                                return Container(
                                  height: 0.0,
                                );
                              },
                              buildWhen: (previous, current) =>
                                  current is InitScreenTools,
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
                              child:
                                  BlocBuilder<InitScreenBloc, InitScreenState>(
                                builder: (context, state) {
                                  String scaleText = "";
                                  String speedText = "";
                                  if (state is InitScreenTools) {
                                    scale = state.scale;
                                    speed = state.speed;
                                  }
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

                                  return Text(
                                    '${const I18n().ecgSignal} \t ${const I18n().scale}: ${scaleText} div/mV \t ${const I18n().speed}: ${speedText} div/s',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.dp,
                                    ),
                                  );
                                },
                                buildWhen: (previous, current) =>
                                    current is InitScreenTools,
                              ),
                            ),
                          ),
                          BlocBuilder<InitScreenBloc, InitScreenState>(
                            builder: (context, state) {
                              double maxvalue = 0;
                              if (state is InitScreenTools) {
                                maxvalue = state.silverMax;
                                baselineX = state.baselineX;
                                resultAr = state.result;
                                loaded = state.loaded;
                              }
                              baselineX ??= 0;
                              if (baselineX! < maxvalue * 0.1 &&
                                  resultAr != null &&
                                  loaded) {
                                if (resultAr!.isStarted) {
                                  return Positioned(
                                    left: 0,
                                    top: 60.dp,
                                    child: Tooltip(
                                      message: const I18n().previousSignal,
                                      waitDuration: const Duration(seconds: 1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.RedL,
                                          borderRadius:
                                              BorderRadius.circular(5.dp),
                                        ),
                                        padding: EdgeInsets.all(5.dp),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                            size: 20.dp,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<InitScreenBloc>(
                                                    context)
                                                .add(
                                                    PreviousECGDataInitScreen());
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 0.0,
                                    width: 0.0,
                                  );
                                }
                              } else {
                                return Container(
                                  height: 0.0,
                                  width: 0.0,
                                );
                              }
                            },
                            buildWhen: (previous, current) =>
                                current is InitScreenTools,
                          ),
                          BlocBuilder<InitScreenBloc, InitScreenState>(
                            builder: (context, state) {
                              double maxvalue = 0;
                              if (state is InitScreenTools) {
                                maxvalue = state.silverMax;
                                baselineX = state.baselineX;
                                resultAr = state.result;
                                loaded = state.loaded;
                              }
                              baselineX ??= 0;
                              if (baselineX! > maxvalue * 0.9 &&
                                  resultAr != null &&
                                  loaded) {
                                if (!resultAr!.isFinished) {
                                  return Positioned(
                                    right: 0,
                                    top: 60.dp,
                                    child: Tooltip(
                                      message: const I18n().nextSignal,
                                      waitDuration: const Duration(seconds: 1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.RedL,
                                          borderRadius:
                                              BorderRadius.circular(5.dp),
                                        ),
                                        padding: EdgeInsets.all(5.dp),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 20.dp,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<InitScreenBloc>(
                                                    context)
                                                .add(NextECGDataInitScreen());
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 0.0,
                                    width: 0.0,
                                  );
                                }
                              } else {
                                return Container(
                                  height: 0.0,
                                  width: 0.0,
                                );
                              }
                            },
                            buildWhen: (previous, current) =>
                                current is InitScreenTools,
                          ),
                        ],
                      )),
                ),
                Platform.isAndroid || Platform.isIOS
                    ? SingleChildScrollView(
                        child: _buildButtons(context),
                      )
                    : _buildButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      color: MyColors.blueL,
      width: 200.dp,
      height: Platform.isAndroid || Platform.isIOS ? 600.dp : double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: menuButtonPadding - 3.dp,
                bottom: menuButtonPadding - 3.dp,
                left: menuButtonPadding,
                right: menuButtonPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // title of section
                    padding: EdgeInsets.all(3.dp),
                    decoration: BoxDecoration(
                      color: MyColors.RedL,
                      borderRadius: BorderRadius.circular(5.dp),
                    ),
                    child: Text(
                      const I18n().frequency.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.dp,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: MyColors.RedL,
                              size: 35.dp,
                            ),
                            BlocBuilder<InitScreenBloc, InitScreenState>(
                              builder: (context, state) {
                                if (state
                                    is ArrhythmiaDetectionInitScreenState) {
                                  resultAr = state.result;
                                  print("arrhythmia detection state");
                                }
                                if (resultAr == null) {
                                  return Text(
                                    "N/A",
                                    style: TextStyle(
                                      color: MyColors.RedL,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.dp,
                                    ),
                                  );
                                }
                                return Text(
                                  resultAr!.frequency != null
                                      ? resultAr!.frequency.toString()
                                      : "N/A",
                                  style: TextStyle(
                                    color: MyColors.RedL,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.dp,
                                  ),
                                );
                              },
                              buildWhen: (previous, current) =>
                                  current is ArrhythmiaDetectionInitScreenState,
                            ),
                            Text(
                              'bpm',
                              style: TextStyle(
                                color: MyColors.RedL,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.dp,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<InitScreenBloc, InitScreenState>(
                          builder: (context, state) {
                            if (state is ArrhythmiaDetectionInitScreenState) {
                              resultAr = state.result;
                              print("arrhythmia detection state");
                            }
                            if (resultAr == null) {
                              return Text(
                                "",
                                style: TextStyle(
                                  color: MyColors.RedL,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.dp,
                                ),
                              );
                            }
                            return Text(
                              resultAr!.getFrequencyClassify ?? "",
                              style: TextStyle(
                                color: MyColors.RedL,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.dp,
                              ),
                            );
                          },
                          buildWhen: (previous, current) =>
                              current is ArrhythmiaDetectionInitScreenState,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: MyColors.grayL,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: menuButtonPadding,
                bottom: menuButtonPadding,
                left: menuButtonPadding,
                right: menuButtonPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*Container( // title of section Scale
                                padding: EdgeInsets.all(5.dp),
                                decoration: BoxDecoration(
                                  color: MyColors.RedL,
                                  borderRadius: BorderRadius.circular(5.dp),
                                ),
                                child: Text(
                                  const I18n().scale.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.dp,
                                  ),
                                ),
                              ),*/
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tooltip(
                              message: const I18n().changeSpeed,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ChangeSpeedInitScreen());
                                },
                                onHover: (value) {
                                  // show tooltip here with name of button
                                },
                                child: Transform.rotate(
                                  angle: 90 * pi / 180,
                                  child: Icon(
                                    Icons.height,
                                    size: 25.dp,
                                    color: MyColors.GrayL,
                                  ),
                                ),
                              ),
                            ),
                            Tooltip(
                              message: const I18n().resetZoom,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ResetZoomInitScreen());
                                },
                                onHover: (value) {
                                  // show tooltip here with name of button
                                },
                                child: Icon(
                                  Icons.find_replace,
                                  size: 25.dp,
                                  color: MyColors.GrayL,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: const I18n().zoomIn,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ZoomInInitScreen());
                                },
                                onHover: (value) {
                                  // show tooltip here with name of button
                                },
                                child: Icon(
                                  Icons.zoom_in,
                                  size: 25.dp,
                                  color: MyColors.GrayL,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tooltip(
                              message: const I18n().changeScale,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ChangeScaleInitScreen());
                                },
                                child: Icon(
                                  Icons.height,
                                  size: 25.dp,
                                  color: MyColors.GrayL,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: const I18n().resetScale,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ResetScalesInitScreen());
                                },
                                child: Icon(
                                  Icons.autorenew,
                                  size: 25.dp,
                                  color: MyColors.GrayL,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: const I18n().zoomOut,
                              waitDuration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.RedL,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.dp),
                                  ),
                                ),
                                onPressed: () {
                                  BlocProvider.of<InitScreenBloc>(context)
                                      .add(ZoomOutInitScreen());
                                },
                                onHover: (value) {
                                  // show tooltip here with name of button
                                },
                                child: Icon(
                                  Icons.zoom_out,
                                  size: 25.dp,
                                  color: MyColors.GrayL,
                                ),
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<InitScreenBloc, InitScreenState>(
                          builder: (context, state) {
                            if (state is InitScreenTools) {
                              baselineY = state.baselineY;
                              zoom = state.zoom;
                            }
                            baselineY ??= 0;
                            zoom ??= 1;
                            return Tooltip(
                              message: const I18n().verticalAlignment,
                              child: Slider(
                                onChanged: (value) {
                                  BlocProvider.of<InitScreenBloc>(context).add(
                                      ChangeBaselineYInitScreen(
                                          baselineY: value));
                                },
                                value: baselineY!,
                                max: 30 * zoom!,
                                min: -30 * zoom!,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: MyColors.grayL,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: menuButtonPadding,
                bottom: menuButtonPadding,
                left: menuButtonPadding,
                right: menuButtonPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // title of section Scale
                    padding: EdgeInsets.all(5.dp),
                    decoration: BoxDecoration(
                      color: MyColors.RedL,
                      borderRadius: BorderRadius.circular(5.dp),
                    ),
                    child: Text(
                      const I18n().arrhythmiaDetection.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.dp,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: BlocBuilder<InitScreenBloc, InitScreenState>(
                      builder: (context, state) {
                        String text = "";
                        String probability = "";
                        //print("state: $state");
                        if (state is ArrhythmiaDetectionInitScreenState) {
                          resultAr = state.result;
                          probability =
                              "${(state.value[resultAr!.getResult + 1] * 100).toStringAsFixed(2)}%";
                          print(resultAr);
                          if (resultAr != null) {
                            print("result ${resultAr!.getResult}");
                            switch (resultAr!.getResult) {
                              case 0:
                                text = const I18n().normal.toUpperCase();
                                break;
                              case 1:
                                text = const I18n().arrhythmia.toUpperCase();
                                break;
                              case 2:
                                text = const I18n().noise.toUpperCase();
                                break;
                              default:
                            }
                          }
                        }
                        return Column(
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: MyColors.RedL,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.dp,
                              ),
                            ),
                            Text(
                              probability,
                              style: TextStyle(
                                color: MyColors.grayL,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.dp,
                              ),
                            ),
                          ],
                        );
                      },
                      buildWhen: (previous, current) =>
                          current is ArrhythmiaDetectionInitScreenState,
                    ),
                  ),
                  /*BlocBuilder<InitScreenBloc, InitScreenState>(
                                builder: (context, state) {
                                  int iter = 10;
                                  int packs = 0;
                                  int resultValidation = 0;
                                  if (state
                                      is ArrhythmiaDetectionInitScreenState) {
                                    resultAr = state.result;
                                  }
                                  if (resultAr != null) {
                                    iter = resultAr!.getIter;
                                    packs = resultAr!.getLength;
                                    resultValidation =
                                        resultAr!.getResultValidation;
                                  }

                                  iter = iter != null ? iter : 10;
                                  packs = packs != null ? packs : 0;
                                  resultValidation = resultValidation != null
                                      ? resultValidation
                                      : 0;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${I18n().pack}: $resultValidation/$packs",
                                        style: TextStyle(
                                          color: MyColors.GrayL,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.dp,
                                        ),
                                      ),
                                      Text(
                                        "${I18n().iter}: $iter",
                                        style: TextStyle(
                                          color: MyColors.GrayL,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.dp,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                buildWhen: (previous, current) => current
                                    is ArrhythmiaDetectionInitScreenState,
                              ),*/
                ],
              ),
            ),
          ),
          /*Divider(
                        color: MyColors.grayL,
                        thickness: 0.5,
                        height: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: menuButtonPadding,
                            bottom: menuButtonPadding,
                            left: menuButtonPadding,
                            right: menuButtonPadding,
                          ),
                          child: Row(
                            children: [],
                          ),
                        ),
                      ),*/
          Divider(
            color: MyColors.grayL,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: menuButtonPadding,
                bottom: menuButtonPadding,
                left: menuButtonPadding,
                right: menuButtonPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<InitScreenBloc, InitScreenState>(
                        builder: (context, state) {
                          bool bluetooth = true;
                          if (state is InitScreenTools) {
                            file = state.file;
                          }
                          if (state
                              is DisconnectBluetoothDeviceInitScreenState) {
                            bluetooth = false;
                          }

                          return file
                              ? Icon(
                                  Icons.folder,
                                  color: MyColors.RedL,
                                  size: 30.dp,
                                )
                              : IconButton(
                                  onPressed: () {
                                    BlocProvider.of<InitScreenBloc>(context).add(
                                        DisconnectBluetoothDeviceInitScreen());
                                  },
                                  icon: Icon(
                                    bluetooth
                                        ? Icons.bluetooth_connected
                                        : Icons.bluetooth,
                                    color: MyColors.RedL,
                                    size: 30.dp,
                                  ),
                                );
                        },
                        buildWhen: (previous, current) =>
                            current is InitScreenTools ||
                            current is DisconnectBluetoothDeviceInitScreenState,
                      ),
                      Expanded(
                        child: BlocBuilder<InitScreenBloc, InitScreenState>(
                          builder: (context, state) {
                            if (state is InitScreenTools) {
                              file = state.file;
                              resultAr = state.result;
                            }

                            return Container(
                              // title of section
                              width: double.infinity,
                              padding: EdgeInsets.all(3.dp),
                              decoration: BoxDecoration(
                                color: MyColors.RedL,
                                borderRadius: BorderRadius.circular(5.dp),
                              ),
                              child: Text(
                                resultAr != null
                                    ? "${const I18n().fileName}: ${resultAr!.nameFile}"
                                    : "${const I18n().fileName}: ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.dp,
                                ),
                              ),
                            );
                          },
                          buildWhen: (previous, current) =>
                              current is InitScreenTools,
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                                children: [
                                  BlocBuilder<InitScreenBloc, InitScreenState>(
                                    builder: (context, state) {
                                      if (state is InitScreenTools) {
                                        file = state.file;
                                        pause = state.pause;
                                        loaded = state.loaded;
                                      }
                                      return file
                                          ? Container()
                                          : IconButton(
                                              onPressed: () {
                                                BlocProvider.of<InitScreenBloc>(
                                                        context)
                                                    .add(
                                                        changePlayECGBluetoothInitScreen());
                                              },
                                              icon: Icon(
                                                !loaded
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: MyColors.RedL,
                                                size: 30.dp,
                                              ),
                                            );
                                    },
                                    buildWhen: (previous, current) =>
                                        current is InitScreenTools,
                                  ),
                                ],
                              )*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
