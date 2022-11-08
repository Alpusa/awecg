part of 'init_screen_bloc.dart';

@immutable
abstract class InitScreenState {
  const InitScreenState();
}

class InitScreenInitial extends InitScreenState {}

class InitScreenLoadData extends InitScreenState {
  final List<double> data;
  InitScreenLoadData(this.data);
}

class InitScreenChangeScales extends InitScreenState {
  double scale;
  double speed;
  double zoom;
  final List<double> data;

  InitScreenChangeScales({
    required this.scale,
    required this.speed,
    required this.data,
    required this.zoom,
  });
}
