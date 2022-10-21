import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  InitScreenBloc() : super(InitScreenInitial()) {
    on<InitScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
