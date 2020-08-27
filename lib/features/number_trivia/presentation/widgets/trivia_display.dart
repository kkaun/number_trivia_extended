import 'package:flutter/material.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;

  const TriviaDisplay({Key key, @required this.trivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //1/3 size of the whole screen:
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            trivia.number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 44),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      trivia.text,
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
