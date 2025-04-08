# Idle-Timeout-Flutter 

The application locks itself if there is no touch in the drawing area for a specified time. In this case, the icon of the lock appears on the canvas. By clicking on it, the user unlocks the application and can continue drawing.

## Inside Application

The main widget is __IdleTimeoutWrapper__ will track application activity. It's a stateless widget that is driven by __BLoC__ events and keeps track of itself internal states.

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

> __DrawingPainter__
  * Created __CustomPainter__ for drawing lines
  * Take a list of points and draw lines between them
  * Uses orange color with line width 2.0
    
> ___DrawingCanvas__
  * StatelessWidget for managing drawing state
  * Stores a list of points _points
  * Handles drawing gestures only in unlocked state
  * Creates a __ValueNotifier<bool>__ to pass to __AnimatedLock__
  * Resets __isTappedNotifier__ to false after unlocking
    
> __Drawing logic__
  * __onPanStart__: starts a new line
  * __onPanUpdate__: adds points when moving
  * __onPanEnd__: adds null to break line

> __AnimatedLock__
 * Full StatelessWidget
 * Accepts a __ValueNotifier<bool>__ to control the icon state
 * Uses a __ValueListenableBuilder__ to listen for changes to __isTappedNotifier__

> __Integration__
  * __CustomPaint__ added to _Stack_ in any case
  * Drawing is active only when the app is __unlocked__
  * __Timer__ resets on all interactions
  * __AnimatedLock__ added to _Stack_ only when the app is locked

> __How it works__
* Initially, a closed lock is shown (__Icons.lock__)
* When pressed, the icon immediately changes to an open lock (__Icons.lock_open__)
* After 0.5 seconds, the application is unlocked and the icon state is reset

## Movie

https://github.com/user-attachments/assets/12512087-abc5-4aab-bc20-7118a6689d6d

  

