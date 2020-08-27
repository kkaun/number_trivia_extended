import 'package:dartz/dartz.dart';
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
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    trivia.number.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 49),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          //TODO
                        }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
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
