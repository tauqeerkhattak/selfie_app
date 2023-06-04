import 'package:get_it/get_it.dart';
import 'package:selfie_app/services/google_ml_service.dart';
import 'package:selfie_app/services/permission_service.dart';

final locator = GetIt.instance;

Future<void> initServices() async {
  await locator.reset();
  locator
    ..registerSingleton(GoogleMlService())
    ..registerSingleton(PermissionService());
}
