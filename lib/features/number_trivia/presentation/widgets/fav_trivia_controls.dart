import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:share/share.dart';

class FavoriteTriviaControls extends StatelessWidget {
  final NumberTrivia trivia;

  FavoriteTriviaControls({Key key, @required this.trivia}) : super(key: key);

  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  child: Icon(Icons.share),
                  onPressed: () {
                    _shareTriviaInfo(trivia);
                  }),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    _dispatchInsertNewFavoriteTriviaEvent(context);
                  }),
            ),
          ),
        ),
      ],
    );
  }

  void _dispatchInsertNewFavoriteTriviaEvent(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<NumberTriviaBloc>(context);
    bloc.add(InsertFavoriteTriviaEvent(trivia));
  }

  void _shareTriviaInfo(NumberTrivia trivia) {
    StringBuffer sb = StringBuffer();
    sb.writeAll(['Check out an interesting trivia:\n', 'Number: ${trivia.number}\n', 'Description: ${trivia.text}']);
    final strToShare = sb.toString();
    Share.share(strToShare);
    sb.clear();
  }
}
