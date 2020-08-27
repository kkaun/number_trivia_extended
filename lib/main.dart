import 'package:flutter/material.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as dependencyInjector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //We're ensuring that UI building will NOT happen UNTIL all dependencies will be resolved:
  await dependencyInjector.init();
  runApp(NumberTriviaApp());
}

class NumberTriviaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Colors.green.shade800, accentColor: Colors.green.shade600),
      home: NumberTriviaPage(),
    );
  }
}
