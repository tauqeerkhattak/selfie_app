import 'package:flutter/material.dart';
import 'package:selfie_app/services/locator.dart';

import 'ui/pages/files_page/files_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const SelfieApp());
}

class SelfieApp extends StatelessWidget {
  const SelfieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FilesPage(),
    );
  }
}
