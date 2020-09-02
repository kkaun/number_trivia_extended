import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/number_trivia_widgets.dart';
import 'package:numbers_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  NumberTriviaPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  //Our body root is actually number trivia bloc
  //which is provided by service locator (aka dependency injector)
  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              //Top half:
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(builder: (context, state) {
                if (state is EmptyFieldState) {
                  debugPrint('EmptyFieldState');
                  return MessageDisplay(message: 'Start Searching!');
                } else if (state is LoadingState) {
                  debugPrint('LoadingState');
                  return LoadingDisplay();
                } else if (state is LoadedState) {
                  debugPrint('LoadedState');
                  return TriviaDisplay(trivia: state.result);
                } else if (state is ErrorState) {
                  return MessageDisplay(message: 'Error : ${state.errorMessage}');
                } else if (state is InsertFavoriteTriviaState) {
                  return MessageDisplay(
                      message: 'Trivia with number ${state.trivia.number} was succesfully added to Favorites!');
                } else
                  return Placeholder();
              }),
              SizedBox(
                height: 20,
              ),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
