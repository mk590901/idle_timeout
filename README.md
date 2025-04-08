# Idle-Timeout-Flutter

The application locks itself if there is no touch in the drawing area for a specified time. In this case, the icon of the lock appears on the canvas. By clicking on it, the user unlocks the application and can continue drawing.

## Inside Application

The main widget is IdleTimeoutWrapper will track application activity. It's a stateless widget that is driven by BLoC events and keeps track of itself internal states.

### Main Points

> __BLoC__
  * __Events__ defined: __ResetTimer__, __LockApp__, __UnlockApp__, __AddPoint__ and __ClearPoints__
  * __IdleState__ it's a class with two fields: __isLocked__ and __points__
  * __IdleBloc__ manages the timer logic and states
     
> __StatelessWidget__
  * __IdleTimeoutWrapper__ is stateless
  * Uses __BlocProvider__ to create __BLoC__
  * __BlocBuilder__ rebuilds UI when state changes
     
> __Logic__
  * _Timer_ is managed in __BLoC__
  * _Events_ are sent via _context.read<IdleBloc>().add()_
  * __UI__ only reacts to the current state

> DrawingPainter
  * Created CustomPainter for drawing lines
  * Take a list of points and draw lines between them
  * Uses orange color with line width 2.0
  * 
> _DrawingCanvas
  * StatelessWidget for managing drawing state
  * Stores a list of points _points
  * Handles drawing gestures only in unlocked state
    
> Drawing logic
  * onPanStart: starts a new line
  * onPanUpdate: adds points when moving
  * onPanEnd: adds null to break line

> Integration
  * CustomPaint added to Stack in any case
  * Drawing is active only when the app is unlocked
  * Timer resets on all interactions

