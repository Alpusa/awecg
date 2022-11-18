import 'dart:io';
import 'dart:math';

import 'package:awecg/models/arrhythmia_result.dart';
import 'package:awecg/repository/classifier.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meta/meta.dart';
import 'package:iirjdart/butterworth.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  bool file = true;
  bool loaded = false;
  List<double> ecgData = [];
  List<double> filterData = [];
  double scale = 10;
  double speed = 25;
  double zoom = 1;
  double baselineX = 0.0;
  double silverMax = 0.0;
  FlSpot? initSpot;
  FlSpot? endSpot;
  int ruleState = 0;
  Classifier classifier = Classifier();
  ArrhythmiaResult result = ArrhythmiaResult();

  InitScreenBloc() : super(InitScreenInitial()) {
    on<InitScreenEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadECGFIleInitScreen>((event, emit) async {
      loaded = false;
      baselineX = 0.0;
      speed = 25;
      zoom = 1;
      scale = 10;
      ecgData = [];
      filterData = [];
      baselineX = 0.0;
      silverMax = 0.0;
      initSpot = null;
      endSpot = null;
      ruleState = 0;
      result.clear();

      if (file) {
        // load file from local storage
        FilePickerResult? rr = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['txt', 'csv'],
        );
        if (rr != null) {
          File fileLoad = File(rr.files.single.path!);

          // load de file like a text
          String text = await fileLoad.readAsString();
          // split the text into a list of doubles separated by ','
          List<double> data =
              text.split(',').map((e) => double.parse(e)).toList();
          // multiply the data by 100 to get the data in mV
          data = data.map((e) => e).toList();
          ecgData.clear();
          ecgData.addAll(data);
          loaded = true;
          updateSilver();
          //evaluate(data);
          add(evaluateDataInitScreen());
          emit(
            InitScreenTools(
              scale: scale,
              speed: speed,
              data: ecgData,
              data2: filterData,
              zoom: zoom,
              baselineX: baselineX,
              loaded: loaded,
              file: file,
              silverMax: silverMax,
              initSpot: initSpot,
              endSpot: endSpot,
              stateRule: ruleState,
            ),
          );
        }
      }
    });

    on<ChangeScaleInitScreen>((event, emit) {
      if (scale == 10.0) {
        scale = 20;
      } else if (scale == 20.0) {
        scale = 30;
      } else if (scale == 30.0) {
        scale = 2;
      } else if (scale == 2.0) {
        scale = 2.5;
      } else if (scale == 2.5) {
        scale = 5;
      } else if (scale == 5.0) {
        scale = 10;
      }

      updateSilver();
      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ChangeSpeedInitScreen>((event, emit) {
      if (speed == 25.0) {
        speed = 30;
      } else if (speed == 30.0) {
        speed = 50;
      } else if (speed == 50.0) {
        speed = 20;
      } else if (speed == 20.0) {
        speed = 25;
      }

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ResetScalesInitScreen>((event, emit) {
      scale = 10;
      speed = 25;
      updateSilver();
      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ZoomOutInitScreen>((event, emit) {
      if (zoom == 1.0) {
        zoom = 2;
      } else if (zoom == 2.0) {
        zoom = 3;
      } else if (zoom == 3.0) {
        zoom = 4;
      } else if (zoom == 4.0) {
        zoom = 5;
      } else if (zoom == 5.0) {
        zoom = 6;
      } else if (zoom == 0.1) {
        zoom = 0.2;
      } else if (zoom == 0.2) {
        zoom = 0.4;
      } else if (zoom == 0.4) {
        zoom = 0.6;
      } else if (zoom == 0.6) {
        zoom = 0.8;
      } else if (zoom == 0.8) {
        zoom = 1;
      }

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ZoomInInitScreen>((event, emit) {
      if (zoom == 6.0) {
        zoom = 5;
      } else if (zoom == 5.0) {
        zoom = 4;
      } else if (zoom == 4.0) {
        zoom = 3;
      } else if (zoom == 3.0) {
        zoom = 2;
      } else if (zoom == 2.0) {
        zoom = 1;
      } else if (zoom == 1.0) {
        zoom = 0.8;
      } else if (zoom == 0.8) {
        zoom = 0.6;
      } else if (zoom == 0.6) {
        zoom = 0.4;
      } else if (zoom == 0.4) {
        zoom = 0.2;
      } else if (zoom == 0.2) {
        zoom = 0.1;
      }

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ResetZoomInitScreen>((event, emit) {
      zoom = 1;

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ChangeBaselineXInitScreen>((event, emit) {
      baselineX = event.baselineX;

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<SetRulePointInitScreen>((event, emit) {
      switch (ruleState) {
        case 0:
          initSpot = event.spot;
          ruleState = 1;
          break;
        case 1:
          endSpot = event.spot;
          ruleState = 2;
          break;
        case 2:
          initSpot = null;
          endSpot = null;
          ruleState = 0;
          break;
        default:
      }

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });

    on<ResetRulePointInitScreen>((event, emit) {
      initSpot = null;
      endSpot = null;
      ruleState = 0;

      updateSilver();

      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
        ),
      );
    });
    on<evaluateDataInitScreen>((event, emit) {
      if (ecgData != null) {
        if (ecgData.isNotEmpty) {
          int max = ecgData.length;

          //----------------- prueba error -----------------
          //.
          //ecgData.add(0);
          //----------------- prueba error -----------------

          print("max: $max");
          max = (max / 2049).toInt();
          print("max: $max");
          result.setPacks = max;
          for (int j = 0; j < max; j++) {
            int count_0 = 0;
            int count_1 = 0;
            int count_2 = 0;

            for (int i = 0; i < result.getIter; i++) {
              int value = evaluate(ecgData);
              if (value == 0) {
                count_0++;
              } else if (value == 1) {
                count_1++;
              } else if (value == 2) {
                count_2++;
              }
            }

            int value = count_0 > count_1 && count_0 > count_2
                ? 0
                : count_1 > count_0 && count_1 > count_2
                    ? 1
                    : count_2 > count_0 && count_2 > count_1
                        ? 2
                        : 0;
            print("value: $value");
            print("result: ${result}");
            result.addResult(value);
            print("result: ${result}");
          }
          emit(ArrhythmiaDetectionInitScreenState(result: result));
        }
      }
    });
  }

  void updateSilver() {
    silverMax = (ecgData.length * (0.004) * speed) - (80 * zoom);
    silverMax = silverMax >= 0 ? silverMax : 0;
    baselineX = baselineX > silverMax ? silverMax : baselineX;
  }

  int evaluate(List<double> data) {
    Array ldata = Array.empty();
    List<double> b = [0.05833987, 0, -0.05833987];
    List<double> a = [1, -1.72253523, 0.88332027];
    for (int i = 0; i < data.length; i++) {
      // evaluate filter iir with b and a

      double value = data[i] * b[0] +
          (i > 0 ? data[i - 1] * b[1] : 0) +
          (i > 1 ? data[i - 2] * b[2] : 0) -
          (i > 0 ? ldata[i - 1] * a[1] : 0) -
          (i > 1 ? ldata[i - 2] * a[2] : 0);

      ldata.add(value);
    }

    for (int i = 0; i < ldata.length; i++) {
      if (ldata[i] > 0.03) {
        ldata[i] = 1;
      } else {
        ldata[i] = 0;
      }
    }

    //print("ldata length: ${ldata.length}");
    //Array dd = arrayDiff(ldata);
    // add data to dd array
    //dd.add(0);
    //print("dd length: ${dd.length}");

    //print(ldata);
    ldata = convolution(ldata, ones(30));
    Array ldataP = Array.empty();
    ldataP.add(0);
    for (int i = 1; i < ldata.length; i++) {
      if (ldata[i] > 0 && ldata[i - 1] == 0) {
        ldataP.add(1);
      } else {
        ldataP.add(0);
      }
    }

    // select the first 1500 points and count the number of 1s
    /*int count = 0;
    int init = ldataP.indexOf(1);
    print("init: $init");
    int end = init + 1500;
    print("end: $end");
    end = end > ldataP.length ? ldataP.length : end;
    for (int i = init; i <= end; i++) {
      if (ldataP[i] == 1) {
        count++;
      }
    }
    */

    int count = 0;
    for (int i = 0; i < ldataP.length; i++) {
      if (ldataP[i] == 1) {
        count++;
      }
    }

    //print("length ldatap: ${ldataP.length}");
    result.setFrequency = count * data.length ~/ 250; // count * 10;
    //print("Frequency: ${result.getFrequency}");
    //filterData = [];
    //filterData.addAll(ldataP.toList().sublist(0, data.length));
    //print("length: ${filterData.length}");
    var result_ = classifier.classify(data);
    // print the result

    // show the result
    // get the position of highest value in the result
    var index = result_.indexOf(result_.reduce(max));
    // if the index is  0 resultString = Normal Signal
    // if the index is  1 resultString = Arrhythmia Signal
    // if the index is  2 resultString = Noise
    if (index == 0) {
      print("Normal Signal");
      //resultString = 'Normal Signal';
    } else if (index == 1) {
      print("Arrhythmia Signal");
      //resultString = 'Arrhythmia Signal';
    } else if (index == 2) {
      print("Noise");
      //resultString = 'Noise';
    }
    return index;
  }
}
