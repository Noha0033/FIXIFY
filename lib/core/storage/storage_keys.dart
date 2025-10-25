import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _box = GetStorage();

  static const String onboardingKey = 'isOnboardingShown';

  static bool isOnboardingShown() {
    return _box.read(onboardingKey) ?? false;
  }

  static void setOnboardingShown() {
    _box.write(onboardingKey, true);
  }
}
