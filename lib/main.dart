import 'package:learn_clean_archi/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme : ThemeData.dark(),
      home: NumberTriviaPage()
    );
  }
}