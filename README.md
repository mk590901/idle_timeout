# Idle-Timeout-Flutter

The application locks itself if there is no touch in the drawing area for a specified time. In this case, the icon of the lock appears on the canvas. By clicking on it, the user unlocks the application and can continue drawing.

## Inside Application

The main widget is IdleTimeoutWrapper will track application activity. It's a stateless widget that is driven by BLoC events and keeps track of itself internal states.

### Main Points

1. BLoC
   > _Events_ defined: __ResetTimer__, __LockApp__, __UnlockApp__
   > _States_ defined: __UnlockedState__, __LockedState__
   > _IdleBloc_ manages the timer logic and states
2. StatelessWidget
   > __IdleTimeoutWrapper__ is stateless
   > Uses __BlocProvider__ to create __BLoC__
   > __BlocBuilder__ rebuilds UI when state changes
3. Logic
   > _Timer_ is managed in __BLoC__
   > _Events_ are sent via _context.read<IdleBloc>().add()_
   > __UI__ only reacts to the current state


