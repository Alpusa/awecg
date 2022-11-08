part of 'init_screen_bloc.dart';

@immutable
abstract class InitScreenEvent {}

class LoadECGFIleInitScreen extends InitScreenEvent {
  LoadECGFIleInitScreen();
}

class ChangeScaleInitScreen extends InitScreenEvent {}

class ChangeSpeedInitScreen extends InitScreenEvent {}

class ResetScalesInitScreen extends InitScreenEvent {}

class ZoomInInitScreen extends InitScreenEvent {}

class ZoomOutInitScreen extends InitScreenEvent {}

class ResetZoomInitScreen extends InitScreenEvent {}
