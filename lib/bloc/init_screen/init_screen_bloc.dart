import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  bool file = true;
  bool loaded = false;
  List<double> ecgData = [];
  double scale = 10;
  double speed = 25;
  double zoom = 1;
  double baselineX = 0.0;
  double silverMax = 0.0;

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
          emit(
            InitScreenChangeScales(
              scale: scale,
              speed: speed,
              data: ecgData,
              zoom: zoom,
              baselineX: baselineX,
              loaded: loaded,
              file: file,
              silverMax: silverMax,
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
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
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
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
        ),
      );
    });

    on<ResetScalesInitScreen>((event, emit) {
      scale = 10;
      speed = 25;
      updateSilver();
      emit(
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
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
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
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
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
        ),
      );
    });

    on<ResetZoomInitScreen>((event, emit) {
      zoom = 1;

      updateSilver();

      emit(
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
        ),
      );
    });

    on<ChangeBaselineXInitScreen>((event, emit) {
      baselineX = event.baselineX;

      updateSilver();

      emit(
        InitScreenChangeScales(
          scale: scale,
          speed: speed,
          data: ecgData,
          zoom: zoom,
          baselineX: baselineX,
          loaded: loaded,
          file: file,
          silverMax: silverMax,
        ),
      );
    });
  }

  void updateSilver() {
    silverMax = (ecgData.length * (0.004) * speed) - (80 * zoom);
    silverMax = silverMax >= 0 ? silverMax : 0;
    baselineX = baselineX > silverMax ? silverMax : baselineX;
  }
}
