import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrap_report/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => runApp(const WrapReport()));
}

class WrapReport extends StatelessWidget {
  const WrapReport({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
