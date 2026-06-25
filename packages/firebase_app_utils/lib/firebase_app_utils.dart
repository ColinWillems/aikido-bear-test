library;

export 'firebase_app_utils.dart';
export 'handlers/handlers.dart';
export 'middlewares/middlewares.dart';
export 'routes/routes.dart';
export 'services/services.dart';
export 'utils/cache_manager/firebase/firebase.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
