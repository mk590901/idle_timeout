import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events BLoC
abstract class IdleEvent {}

class ResetTimer extends IdleEvent {}

class LockApp extends IdleEvent {}

class UnlockApp extends IdleEvent {}

class AddPoint extends IdleEvent {
  final Offset? point;
  AddPoint(this.point);
}

class ClearPoints extends IdleEvent {}

// State BLoC
class IdleState {
  final bool isLocked;
  final List<Offset?> points;

  IdleState(this.isLocked, this.points);
}

// BLoC
class IdleBloc extends Bloc<IdleEvent, IdleState> {
  static const int _timeoutSeconds = 5;
  Timer? _idleTimer;

  IdleBloc() : super(IdleState(false, [])) {
    on<ResetTimer>(_onResetTimer);
    on<LockApp>((event, emit) => emit(IdleState(true, state.points)));
    on<UnlockApp>((event, emit) => emit(IdleState(false, state.points)));
    on<AddPoint>(
      (event, emit) =>
          emit(IdleState(state.isLocked, [...state.points, event.point])),
    );
    on<ClearPoints>((event, emit) => emit(IdleState(state.isLocked, [])));
  }

  void _onResetTimer(ResetTimer event, Emitter<IdleState> emit) {
    _idleTimer?.cancel();
    if (!state.isLocked) {
      _idleTimer = Timer(const Duration(seconds: _timeoutSeconds), () {
        if (!isClosed) {
          add(LockApp());
        }
      });
    }
  }

  @override
  Future<void> close() {
    _idleTimer?.cancel();
    return super.close();
  }
}

// Custom painter for drawing
class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

// Wrapper
class IdleTimeoutWrapper extends StatelessWidget {
  const IdleTimeoutWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdleBloc()..add(ResetTimer()),
      child: _DrawingCanvas(),
    );
  }
}

class _DrawingCanvas extends StatelessWidget {
  const _DrawingCanvas();

  @override
  Widget build(BuildContext context) {
    final isTappedNotifier = ValueNotifier<bool>(false);

    return BlocBuilder<IdleBloc, IdleState>(
      builder: (context, state) {
        return GestureDetector(
          onPanStart: (details) {
            context.read<IdleBloc>().add(ResetTimer());
            if (!state.isLocked) {
              context.read<IdleBloc>().add(AddPoint(details.localPosition));
            }
          },
          onPanUpdate: (details) {
            context.read<IdleBloc>().add(ResetTimer());
            if (!state.isLocked) {
              context.read<IdleBloc>().add(AddPoint(details.localPosition));
            }
          },
          onPanEnd: (details) {
            context.read<IdleBloc>().add(ResetTimer());
            if (!state.isLocked) {
              context.read<IdleBloc>().add(AddPoint(null));
            }
          },
          onTap: () => context.read<IdleBloc>().add(ResetTimer()),
          child: Stack(
            children: [
              CustomPaint(
                painter: DrawingPainter(state.points),
                size: Size.infinite,
              ),
              if (state.isLocked)
                Container(
                  color: Colors.blue.withValues(alpha: 0.3),
                  child: Center(
                    child: AnimatedLock(
                      isTappedNotifier: isTappedNotifier,
                      onUnlock: () {
                        context.read<IdleBloc>().add(UnlockApp());
                        context.read<IdleBloc>().add(ResetTimer());
                        isTappedNotifier.value = false; // Reset state
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// _AnimatedLock widget
class AnimatedLock extends StatelessWidget {
  final ValueNotifier<bool> isTappedNotifier;
  final VoidCallback onUnlock;

  const AnimatedLock({super.key, required this.isTappedNotifier, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTappedNotifier,
      builder: (context, isTapped, child) {
        return GestureDetector(
          onTap: () {
            isTappedNotifier.value = true;
            Future.delayed(const Duration(milliseconds: 500), onUnlock);
          },
          child: Icon(
            isTapped ? Icons.lock_open : Icons.lock,
            size: 96,
            color: Colors.black26,
          ),
        );
      },
    );
  }
}

// Sample
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Drawing Timeout Demo',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontStyle: FontStyle.normal,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.indigo,
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: IdleTimeoutWrapper(),
    );
  }
}
