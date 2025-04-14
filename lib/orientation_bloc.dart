import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC Event
abstract class OrientationEvent {}

class InitializeOrientation extends OrientationEvent {}

// BLoC State
enum DeviceType { phone, tablet }

class OrientationState {
  final DeviceType deviceType;
  OrientationState(this.deviceType);
}

// BLoC
class OrientationBloc extends Bloc<OrientationEvent, OrientationState> {
  OrientationBloc() : super(OrientationState(DeviceType.phone)) {
    on<InitializeOrientation>(_onInitializeOrientation);
  }

  void _onInitializeOrientation(
      InitializeOrientation event, Emitter<OrientationState> emit) {
    // Get screen size
    final size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    final pixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final width = size.width / pixelRatio;
    final height = size.height / pixelRatio;

    // Calculate diagonal in inches
    final diagonalInches = sqrt(width * width + height * height) / pixelRatio / 160;

    // Determine device type
    final isTablet = diagonalInches >= 7.0;
    final deviceType = isTablet ? DeviceType.tablet : DeviceType.phone;

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
