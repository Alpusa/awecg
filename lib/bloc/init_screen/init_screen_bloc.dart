import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/models/arrhythmia_result.dart';
import 'package:awecg/models/medical_professional.dart';
import 'package:awecg/models/patient.dart';
import 'package:awecg/repository/classifier.dart';
import 'package:awecg/repository/save_data.dart';
import 'package:bloc/bloc.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meta/meta.dart';
import 'package:iirjdart/butterworth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_blue/models.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  List<BlueScanResult> scanResults = [];
  String? deviceId;

  bool file = true;
  bool loaded = false;
  List<double> ecgData = [];
  List<double> ecgDataTemp = [];
  List<double> filterData = [];
  double scale = 10;
  double speed = 25;
  double zoom = 1;
  double baselineX = 0.0;
  double silverMax = 0.0;
  double baselineY = 0.0;
  double silverMaxY = 0.0;
  double silverMinY = 0.0;
  FlSpot? initSpot;
  FlSpot? endSpot;
  int ruleState = 0;
  Classifier classifier = Classifier();
  ArrhythmiaResult? result;
  int ecgMaxLength = 2049;
  bool pause = false;

  InitScreenBloc() : super(InitScreenInitial()) {
    on<InitScreenEvent>((event, emit) {
      checkStoragePermission();
    });

    on<InitScreenInitialEvent>(
      (event, emit) {
        emit(InitScreenInitial());
      },
    );

    on<LoadECGFIleInitScreen>((event, emit) async {
      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;

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
      file = true;
      result = null;

      if (deviceId != null) {
        try {
          QuickBlue.disconnect(deviceId!);
        } catch (e) {
          print(e);
        }
        deviceId = null;
      }
      try {
        QuickBlue.stopScan();
      } catch (e) {
        print(e);
      }

      bool storagePermission = await checkStoragePermission();
      if (storagePermission) {
        // load file from local storage
        Directory appDocDir = await getApplicationDocumentsDirectory();
        FilePickerResult? rr;
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          rr = await FilePicker.platform.pickFiles(
            initialDirectory: appDocDir.path,
            type: FileType.custom,
            allowedExtensions: [/*'txt', 'csv',*/ 'awecg'],
          );
        } else {
          FilePicker.platform.clearTemporaryFiles();

          Directory? directory = await getExternalStorageDirectory();
          print("directory: $directory");
          rr = await FilePicker.platform.pickFiles(
            //initialDirectory: appDocDir.path,
            type: FileType.any,
            allowMultiple: false,
            //allowedExtensions: [/*'txt', 'csv',*/ 'awecg'],
          );

          var name = rr!.names.first;
          print("namefile: ${rr!.names.first} path: ${rr.files.first.path}}");
          rr.files.clear();
          rr.files.add(
            PlatformFile(
                name: name!,
                path: "${directory!.path!}/$name",
                size: 0,
                bytes: null),
          );
          print("rr: $rr");
        }

        if (rr != null) {
          String path = rr.files.single.path!;
          String name = rr.files.single.name;
          print('path: ${path} name: $name');

          result =
              await ArrhythmiaResult(nameFile: name, pathFolder: path).init();

          /*File fileLoad = await File(rr.files.single.path!);

        // load de file like a text
        String text = await fileLoad.readAsString();
        // split the text into a list of doubles separated by ','
        List<double> data =
            text.split(',').map((e) => double.parse(e)).toList();
        // multiply the data by 100 to get the data in mV
        data = data.map((e) => e).toList();
        ecgData.clear();
        ecgData.addAll(data);
        */

          ecgData = result!.loadECG(0);
          loaded = true;
          updateSilver(ecgMaxLength);
          updateSilverY();
          //evaluate(data);
          add(evaluateDataInitScreen(data: ecgData));
          if (result != null) {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                result: result!,
                pause: pause,
              ),
            );
          } else {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                pause: pause,
              ),
            );
          }
        }
      } else {
        emit(InitScreenError(const I18n().storagePermissionRequired));
      }
    });

    on<LoadECGBluetoothInitScreen>((event, emit) async {
      scanResults = [];
      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;
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
      result = null;

      file = false;

      // start the bluetooth connection
      print('start scan');
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

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
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

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ResetScalesInitScreen>((event, emit) {
      scale = 10;
      speed = 25;
      baselineY = 0.0;
      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
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

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
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

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ResetZoomInitScreen>((event, emit) {
      zoom = 1;

      updateSilver(ecgMaxLength);

      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ChangeBaselineXInitScreen>((event, emit) {
      baselineX = event.baselineX;

      updateSilver(ecgMaxLength);
      //ecgData = result!.loadECG(0);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ChangeBaselineYInitScreen>((event, emit) {
      baselineY = event.baselineY;

      //ecgData = result!.loadECG(0);

      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
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

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ResetRulePointInitScreen>((event, emit) {
      initSpot = null;
      endSpot = null;
      ruleState = 0;

      updateSilver(ecgMaxLength);
      updateSilverY();
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });
    on<evaluateDataInitScreen>((event, emit) {
      if (event.data != null) {
        if (event.data.isNotEmpty) {
          /*int max = event.data.length;

          //----------------- prueba error -----------------
          //.
          //ecgData.add(0);
          //----------------- prueba error -----------------

          print("max: $max");
          max = (max / 2049).toInt();
          print("max: $max");*/
          //result.setPacks = max;
          /*for (int j = 0; j < max; j++) {
            int count_0 = 0;
            int count_1 = 0;
            int count_2 = 0;*/

          //for (int i = 0; i < result.getIter; i++) {
          List<double> value = evaluate(event.data);
          /*if (value == 0) {
                count_0++;
              } else if (value == 1) {
                count_1++;
              } else if (value == 2) {
                count_2++;
              }*/
          //}

          /*int value = count_0 > count_1 && count_0 > count_2
                ? 0
                : count_1 > count_0 && count_1 > count_2
                    ? 1
                    : count_2 > count_0 && count_2 > count_1
                        ? 2
                        : 0;*/
          print("value: $value");
          print("result: ${result}");
          result!.addResult(value[0].toInt());
          print("result: ${result}");
          emit(ArrhythmiaDetectionInitScreenState(
              result: result!, value: value));
        }

        //}
      }
    });

    on<NextECGDataInitScreen>((event, emit) {
      if (result != null) {
        ecgData = result!.loadECG(result!.getPosition + 1);
        add(evaluateDataInitScreen(data: ecgData));
        baselineX = 0;
        if (ecgData.isNotEmpty) {
          if (result != null) {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                result: result!,
                pause: pause,
              ),
            );
          } else {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                pause: pause,
              ),
            );
          }
        }
      }
    });

    on<PreviousECGDataInitScreen>((event, emit) {
      if (result != null) {
        ecgData = result!.loadECG(result!.getPosition - 1);
        add(evaluateDataInitScreen(data: ecgData));
        baselineX = silverMax;
        if (ecgData.isNotEmpty) {
          if (result != null) {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                result: result!,
                pause: pause,
              ),
            );
          } else {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                pause: pause,
              ),
            );
          }
        }
      }
    });

    on<AddBluetoothDevice>((event, emit) {
      // check if device is already added
      Iterable<BlueScanResult> devicesFound = scanResults
          .where((element) => element.deviceId == event.scanResult.deviceId);

      if (devicesFound.isEmpty) {
        scanResults.add(event.scanResult);
        emit(AddBluetoothDeviceInitScreenState(scanResults: scanResults));
      } else {
        int deviceIndex = scanResults.indexOf(devicesFound.first);
        scanResults[deviceIndex] = event.scanResult;
        emit(AddBluetoothDeviceInitScreenState(scanResults: scanResults));
      }
    });

    on<ConnectBluetoothDeviceInitScreen>((event, emit) async {
      emit(StartLoadingIntiScreenState());
      //emit(ConnectingBluetoothDeviceInitScreenState());
      QuickBlue.stopScan();
      QuickBlue.setConnectionHandler(_handleConnectionChange);
      QuickBlue.setServiceHandler(_handleServiceDiscovery);
      deviceId = event.deviceId;
      print("Connecting to device");
      connectToDevice();
    });

    on<CancelBluetoothDeviceInitScreen>((event, emit) async {
      QuickBlue.stopScan();
      if (deviceId != null) {
        QuickBlue.disconnect(deviceId!);
      }
    });

    on<DisconnectBluetoothDeviceInitScreen>((event, emit) async {
      //QuickBlue.stopScan();
      print("Disconnecting from device");
      if (deviceId != null) {
        QuickBlue.disconnect(deviceId!);
      }

      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;

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
      file = true;
      result = null;
      if (result != null) {
        emit(
          DisconnectBluetoothDeviceInitScreenState(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          DisconnectBluetoothDeviceInitScreenState(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
      //emit(DisconnectBluetoothDeviceInitScreenState());
      emit(InitScreenError(I18n().disconnected));
    });

    on<AddECGMonitorValue>((event, emit) {
      if (ecgData == null) {
        ecgData = [];
      }
      if (loaded) {
        ecgDataTemp = ecgData;
        ecgData = [];
        ecgData = result!.loadECG(0);
        updateSilver(ecgData.length);
        updateSilverY();
        baselineX = silverMax;
        if (ecgDataTemp.length >= 2049) {
          result!.addECG(ecgDataTemp.sublist(0, 2049));
          add(evaluateDataInitScreen(data: ecgData.toList()));
          ecgData = ecgData.length > 2049
              ? ecgDataTemp.sublist(2049, ecgDataTemp.length)
              : [];
        }
      } else {
        ecgData.addAll(event.value);
        /*if (ecgData.length > 100000) {
        ecgData.removeRange(0, 10000);
      }*/
        updateSilver(ecgData.length);
        updateSilverY();
        baselineX = silverMax;
        if (ecgData.length >= 2049) {
          result!.addECG(ecgData.sublist(0, 2049));
          add(evaluateDataInitScreen(data: ecgData.sublist(0, 2049)));
          ecgData = ecgData.length > 2049
              ? ecgData.sublist(2049, ecgData.length)
              : [];
        }
      }
      if (result != null) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            result: result!,
            pause: pause,
          ),
        );
      } else {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
      }
    });

    on<ConnectedBluetoothDeviceInitScreen>((event, emit) async {
      emit(StopLoadingIntiScreenState());
      file = false;
      emit(ConnectedBluetoothDeviceInitScreenState());
    });

    on<changePlayECGBluetoothInitScreen>((event, emit) {
      loaded = !loaded;
      emit(
        InitScreenTools(
          scale: scale,
          speed: speed,
          data: ecgData,
          data2: filterData,
          zoom: zoom,
          baselineX: baselineX,
          baselineY: baselineY,
          silverMaxY: silverMaxY,
          silverMinY: silverMinY,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
          initSpot: initSpot,
          endSpot: endSpot,
          stateRule: ruleState,
          result: result!,
          pause: pause,
        ),
      );
    });

    on<exportECGDataInitScreen>((event, emit) async {
      emit(StartLoadingIntiScreenState(message: I18n().exporingAsPDF));
      if (result != null) {
        await result!.exportPDF();
        emit(StopLoadingIntiScreenState());
      } else {
        emit(InitScreenError(
            const I18n().firstLoadOrCreateNewProjectToUseToUseThisFunction));
      }
    });

    on<newProjectInitScreen>((event, emit) async {
      scanResults = [];
      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;
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
      result = null;

      file = true;

      bool storagePermission = await checkStoragePermission();
      bool bluetoothPermission = await checkBluetoothPermission();
      if (storagePermission && bluetoothPermission) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
        emit(ShowNewProjectInitScreenState());
        //
      } else {
        emit(InitScreenError(
            "${const I18n().storagePermissionRequired}.${I18n().bluetoothPermissionRequired} ${const I18n().or} ${I18n().bluetoothIsDisabled}"));
      }
    });

    on<cancelNewProjectInitScreen>((event, emit) {
      scanResults = [];
      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;
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
      result = null;

      file = true;
    });

    on<selectProjectFolderInitScreen>((event, emit) async {
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        print("path: $directory");
        emit(ProjectFolderInitScreenState(folder: directory));
      }
    });

    on<randomProjectNameInitScreen>((event, emit) {
      String nameFile = const Uuid().v4();
      emit(ProjectRandomNameInitScreenState(name: nameFile));
    });

    on<validateProjectLocationInitScreen>((event, emit) async {
      emit(StartLoadingIntiScreenState());
      if (event.projectFolder != null) {
        if (event.projectName != null) {
          // validate if the folder exists
          Directory directory = Directory(event.projectFolder);
          if (await directory.exists()) {
            // check if a folder with the same name exists in the folder
            Directory directory2 =
                Directory('${event.projectFolder}/${event.projectName}');
            if (await directory2.exists()) {
              emit(InitScreenError(const I18n().projectIsAlreadyExist));
            } else {
              // create result object and set the folderpath and name
              result = ArrhythmiaResult(
                  nameFile: event.projectName, pathFolder: event.projectFolder);
              emit(StopLoadingIntiScreenState());
              emit(ShowPatientNewProjectInitScreenState());
            }
          } else {
            emit(InitScreenError(const I18n().folderDoesNotExist));
          }
        } else {
          emit(InitScreenError(const I18n().fieldsAreRequired));
        }
      } else {
        emit(InitScreenError(const I18n().fieldsAreRequired));
      }
    });

    on<addPatientProjectInitScreen>((event, emit) async {
      emit(StartLoadingIntiScreenState());
      if (result != null) {
        result!.setPatient(event.patient);
        MedicalProfessional medicalProfessional =
            await SaveData().getMedicalProfessional();
        result!.setMedicalProfessional(medicalProfessional);
        emit(StopLoadingIntiScreenState());

        emit(ShowSelectBluetoothDeviceInitScreenState());
        add(startBluetoothScanInitScreen());
      } else {
        emit(InitScreenError(
            const I18n().firstLoadOrCreateNewProjectToUseToUseThisFunction));
      }
    });

    on<startBluetoothScanInitScreen>((event, emit) {
      if (result != null) {
        getDeviceName();
      } else {
        emit(InitScreenError(
            const I18n().firstLoadOrCreateNewProjectToUseToUseThisFunction));
      }
    });

    on<errorBluetoothScanInitScreen>((event, emit) {
      emit(InitScreenError(const I18n().errorCreatingProject));
    });

    on<openProjectInitScreen>((event, emit) async {
      scanResults = [];
      loaded = false;
      baselineX = 0.0;
      baselineY = 0.0;
      silverMaxY = 0.0;
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
      result = null;

      file = true;

      if (deviceId != null) {
        try {
          QuickBlue.disconnect(deviceId!);
        } catch (e) {
          print(e);
        }
        deviceId = null;
      }
      try {
        QuickBlue.stopScan();
      } catch (e) {
        print(e);
      }

      bool storagePermission = await checkStoragePermission();
      if (storagePermission) {
        emit(
          InitScreenTools(
            scale: scale,
            speed: speed,
            data: ecgData,
            data2: filterData,
            zoom: zoom,
            baselineX: baselineX,
            baselineY: baselineY,
            silverMaxY: silverMaxY,
            silverMinY: silverMinY,
            loaded: loaded,
            file: file,
            silverMax: silverMax,
            initSpot: initSpot,
            endSpot: endSpot,
            stateRule: ruleState,
            pause: pause,
          ),
        );
        emit(ShowOpenProjectInitScreenState());
        //
      } else {
        result = null;
        emit(InitScreenError("${const I18n().storagePermissionRequired}."));
      }
    });

    on<loadProjectInitScreen>((event, emit) async {
      emit(StartLoadingIntiScreenState());

      result = ArrhythmiaResult(nameFile: "", pathFolder: "");

      bool validateProject =
          await result!.validateProjectFolder(event.projectPath);
      print("validate: $validateProject");
      if (validateProject) {
        bool loadedProject = await result!.loadProject(event.projectPath);
        print("loaded: $loadedProject");
        if (loadedProject) {
          emit(StopLoadingIntiScreenState());
          ecgData = result!.loadECG(0);
          loaded = true;
          updateSilver(ecgMaxLength);
          updateSilverY();
          //evaluate(data);
          add(evaluateDataInitScreen(data: ecgData));
          if (result != null) {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                result: result!,
                pause: pause,
              ),
            );
          } else {
            emit(
              InitScreenTools(
                scale: scale,
                speed: speed,
                data: ecgData,
                data2: filterData,
                zoom: zoom,
                baselineX: baselineX,
                baselineY: baselineY,
                silverMaxY: silverMaxY,
                silverMinY: silverMinY,
                loaded: loaded,
                file: file,
                silverMax: silverMax,
                initSpot: initSpot,
                endSpot: endSpot,
                stateRule: ruleState,
                pause: pause,
              ),
            );
          }
        } else {
          result = null;
          emit(StopLoadingIntiScreenState());
          emit(InitScreenError(
              "${const I18n().projectIsNotValid} or ${const I18n().projectIsBroken}"));
        }
      } else {
        result = null;
        emit(StopLoadingIntiScreenState());
        emit(InitScreenError(
            "${const I18n().projectIsNotValid} or ${const I18n().projectIsBroken}"));
      }
    });

    on<patientInformationInitScreen>((event, emit) async {
      if (result != null) {
        emit(ShowPatientInformationInitScreenState(patient: result!.patient!));
      } else {
        emit(InitScreenError(
            const I18n().firstLoadOrCreateNewProjectToUseToUseThisFunction));
      }
    });

    on<medicalInformationInitScreen>((event, emit) async {
      if (result != null) {
        emit(ShowMedicalProfessionalInformationInitScreenState(
            loaded: true, medicalProfessional: result!.medicalProfessional!));
      } else {
        // get medical professional information using SaveData
        MedicalProfessional medicalProfessional =
            await SaveData().getMedicalProfessional();
        emit(ShowMedicalProfessionalInformationInitScreenState(
            loaded: false, medicalProfessional: medicalProfessional));
      }
    });

    on<saveMedicalProfessionalInitScreen>((event, emit) async {
      // save medical professional information using SaveData
      emit(StartLoadingIntiScreenState());
      await SaveData().saveMedicalProfessional(event.medicalProfessional);
      emit(StopLoadingIntiScreenState());
    });

    on<deleteMedicalProfessionalInitScreen>((event, emit) async {
      // delete medical professional information using SaveData
      emit(StartLoadingIntiScreenState());
      await SaveData().removeMedicalProfessional();
      emit(StopLoadingIntiScreenState());
    });
  }

  Future<void> _handleConnectionChange(
      String deviceId, BlueConnectionState state) async {
    print('_handleConnectionChange $deviceId, ${state.toString()}');
    if (state == BlueConnectionState.connected && result != null) {
      bool created = await result!.createProject();
      if (created) {
        add(ConnectedBluetoothDeviceInitScreen());
        print('connected to $deviceId');
        QuickBlue.setServiceHandler(_handleServiceDiscovery);
        //QuickBlue.discoverServices(deviceId);
        QuickBlue.setValueHandler(_handleValueChange);
        if (Platform.isAndroid || Platform.isIOS) {
          QuickBlue.discoverServices(deviceId);
        } else {
          QuickBlue.setNotifiable(
              deviceId,
              "832a0638-67db-11ed-9022-0242ac120002",
              '00002b18-0000-1000-8000-00805f9b34fb',
              BleInputProperty.notification);
        }
      } else {
        add(errorBluetoothScanInitScreen());
        add(DisconnectBluetoothDeviceInitScreen());
      }
    } else if (state == BlueConnectionState.disconnected) {
      print('disconnected from $deviceId');
      add(DisconnectBluetoothDeviceInitScreen());
    }
  }

  void _handleServiceDiscovery(String deviceId, String serviceId) {
    print('_handleServiceDiscovery $deviceId, $serviceId');
    if (serviceId == '832a0638-67db-11ed-9022-0242ac120002') {
      QuickBlue.setNotifiable(
          deviceId,
          serviceId,
          '00002b18-0000-1000-8000-00805f9b34fb',
          BleInputProperty.notification);
    }
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    final utf8Decoder = const Utf8Decoder(allowMalformed: false);
    var dat = utf8Decoder.convert(value);
    // split the string using the delimiter ','
    //var data = [dat.substring(0, 4), dat.substring(4, 84)];
    // remove latest character
    dat = dat.substring(0, dat.length - 1);
    var data = dat.split(',');
    //print("data $data");
    // convert the string to double
    var valueF = data.map((e) {
      print(e);
      double temp = 0.0;

      try {
        temp = double.parse(e);
        temp = (temp * (3.3 / 4095.0));
        temp = temp - 1.65;
        temp = temp / 1.1;
      } catch (e) {
        print(e);
        print("error");
        temp = 0.0;
      }

      return temp;
    }).toList();

    //print('${temp}');
    add(AddECGMonitorValue(value: valueF));

    //print(
    //    '_handleValueChange $deviceId, $characteristicId, ${hex.encode(value)}');
  }

  void connectToDevice() async {
    print("connectToDevice $deviceId");
    if (deviceId != null) {
      QuickBlue.connect(deviceId!);
    }
  }

  void getDeviceName(/*ScanResult event*/) async {
    // Start scanning
    try {
      QuickBlue.stopScan();
    } catch (e) {
      print(e);
      add(errorBluetoothScanInitScreen());
    }
    QuickBlue.setConnectionHandler(_handleConnectionChange);
    QuickBlue.setServiceHandler(_handleServiceDiscovery);
    QuickBlue.scanResultStream.listen((result) {
      print('onScanResult $result');
      add(AddBluetoothDevice(scanResult: result));
    });
    QuickBlue.startScan();
  }

  void updateSilver(int maxLength) {
    //silverMax = (ecgData.length * (0.004) * speed) - (80 * zoom);
    silverMax = (maxLength * (0.004) * speed) - (80 * zoom);
    silverMax = silverMax >= 0 ? silverMax : 0;
    baselineX = baselineX > silverMax ? silverMax : baselineX;
  }

  void updateSilverY() {
    if (baselineY > (30 * zoom)) {
      baselineY = (30 * zoom);
    }
    if (baselineY < (-30 * zoom)) {
      baselineY = (-30 * zoom);
    }
  }

  List<double> evaluate(List<double> data) {
    print("data length: ${data.length}");
    Array ldata = Array.empty();
    // filter iir
    List<double> b = [0.05833987, 0, -0.05833987]; // numerators
    List<double> a = [1, -1.72253523, 0.88332027]; // denominators
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
        ldataP.add(i.toDouble());
      } /*else {
        ldataP.add(0);
      }*/
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
    }*/

    double HR = 0;
    if (ldataP.length > 2) {
      for (int i = 0; i < ldataP.length - 1; i++) {
        HR = HR + (ldataP[i + 1] - ldataP[i]) * 0.004;
        print("HR: $HR");
      }
      HR = HR / (ldataP.length - 1);
      HR = 60 / HR;
    }

    //print("length ldatap: ${ldataP.length}");
    //print("frequency: ${HR/*count * data.length ~/ 250*/}");
    result!.setFrequency =
        HR.toInt(); //count * data.length ~/ 250; // count * 10;
    print("Frequency: ${result!.getFrequency}");
    //filterData = [];
    //filterData.addAll(ldataP.toList().sublist(0, data.length));
    //print("length: ${filterData.length}");

    data = data.map((e) => (e - 0.001572584) / 0.16089901).toList();
    var result_ = classifier.classify(data);
    // print the result

    // show the result
    // get the position of highest value in the result
    var index = result_.indexOf(result_.reduce(max));
    // e^10/(e^10 + e^5 + e^2	)
    double probability = exp(result_[index]) /
        (exp(result_[0]) + exp(result_[1]) + exp(result_[2]));
    print("Probability: $probability");
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
    return [
      index.toDouble(),
      exp(result_[0]) / (exp(result_[0]) + exp(result_[1]) + exp(result_[2])),
      exp(result_[1]) / (exp(result_[0]) + exp(result_[1]) + exp(result_[2])),
      exp(result_[2]) / (exp(result_[0]) + exp(result_[1]) + exp(result_[2]))
    ];
  }

  Future<bool> checkStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      await [Permission.manageExternalStorage].request();
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> checkBluetoothPermission() async {
    if (!await QuickBlue.isBluetoothAvailable()) {
      return false;
    }
    // validate the api version of android

    try {
      if (await Permission.bluetooth.isGranted &&
          await Permission.bluetoothAdvertise.isGranted &&
          await Permission.bluetoothConnect.isGranted &&
          await Permission.bluetoothScan.isGranted) {
        return true;
      } else {
        await [
          Permission.bluetooth,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.bluetoothScan
        ].request();
        if (await Permission.bluetooth.isGranted &&
            await Permission.bluetoothAdvertise.isGranted &&
            await Permission.bluetoothConnect.isGranted &&
            await Permission.bluetoothScan.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
      if ( //await Permission.bluetooth.isGranted &&
          await Permission.bluetoothAdvertise.isGranted &&
              await Permission.bluetoothConnect.isGranted &&
              await Permission.bluetoothScan.isGranted) {
        return true;
      } else {
        await [
          //Permission.bluetooth,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.bluetoothScan
        ].request();
        if ( //await Permission.bluetooth.isGranted &&
            await Permission.bluetoothAdvertise.isGranted &&
                await Permission.bluetoothConnect.isGranted &&
                await Permission.bluetoothScan.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}
