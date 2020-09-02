import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/fav_trivia_controls.dart';
import '../../../../injection_container.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final etController = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TextField(
            controller: etController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: (InputDecoration(border: OutlineInputBorder(), hintText: 'Input a number')),
            onChanged: (value) {
              inputStr = value;
            },
            onSubmitted: (_) {
              _dispatchTriviaButtonEventFor(serviceLocator<GetConcreteNumberTriviaUseCase>());
            }),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: RaisedButton(
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              child: Text('Search Trivia'),
              onPressed: () {
                _dispatchTriviaButtonEventFor(serviceLocator<GetConcreteNumberTriviaUseCase>());
              },
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: RaisedButton(
              textTheme: ButtonTextTheme.primary,
              child: Text('Get Random Trivia'),
              onPressed: () {
                _dispatchTriviaButtonEventFor(serviceLocator<GetRandomNumberTriviaUseCase>());
              },
            ))
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void _dispatchTriviaButtonEventFor(UseCase useCase) {
    //TODO is this a linter issue?
    // ignore: close_sinks
    final bloc = BlocProvider.of<NumberTriviaBloc>(context);

    switch (useCase.runtimeType) {
      case GetConcreteNumberTriviaUseCase:
        bloc.add(GetTriviaForConcreteNumberEvent(inputStr));
        break;
      case GetRandomNumberTriviaUseCase:
        bloc.add(GetTriviaForRandomNumberEvent());
        break;
    }
    etController.clear();
  }
}
