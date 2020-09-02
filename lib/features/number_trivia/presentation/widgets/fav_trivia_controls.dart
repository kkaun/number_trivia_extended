import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/insert_fav_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';

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
              child: FloatingActionButton(child: Icon(Icons.share), onPressed: () {}),
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
}
