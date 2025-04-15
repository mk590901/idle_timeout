import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// BLoC Event
abstract class OrientationEvent {}

class InitializeOrientation extends OrientationEvent {}

// BLoC State
enum GadgetType { phone, tablet }

class OrientationState {
  final GadgetType deviceType;
  OrientationState(this.deviceType);
}

// BLoC
class OrientationBloc extends Bloc<OrientationEvent, OrientationState> {
  OrientationBloc() : super(OrientationState(GadgetType.phone)) {
    on<InitializeOrientation>(_onInitializeOrientation);
  }

  void _onInitializeOrientation(
      InitializeOrientation event, Emitter<OrientationState> emit) {
    ScreenType screenType = Device.screenType;
    bool isTablet = screenType == ScreenType.mobile ? false : true;
    final deviceType = isTablet ? GadgetType.tablet : GadgetType.phone;
    // Set orientation
    if (isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    emit(OrientationState(deviceType));
  }
}
