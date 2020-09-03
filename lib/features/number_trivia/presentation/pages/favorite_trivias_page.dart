import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/number_trivia_widgets.dart';
import '../../../../injection_container.dart';

class FavoriteTrviasPage extends StatefulWidget {
  FavoriteTrviasPage({Key key}) : super(key: key);

  @override
  _FavoriteTrviasPageState createState() => _FavoriteTrviasPageState();
}

class _FavoriteTrviasPageState extends State<FavoriteTrviasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: _buildFavoritesPageBody(),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildFavoritesPageBody() {
    // ignore: close_sinks
    final bloc = serviceLocator<NumberTriviaBloc>();
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => bloc,
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          if (state is EmptyFieldState) {
            bloc.add(ObserveAllFavoriteTriviasEvent());
            return LoadingDisplay();
          } else if (state is ObserveAllFavoriteTrviasState) {
            return _buildFavTriviaList(context, state.favTriviaStream);
          } else {
            return Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No favorites were saved yet',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  StreamBuilder<List<FavoriteTrivia>> _buildFavTriviaList(BuildContext context, Stream<List<FavoriteTrivia>> stream) {
    final repository = serviceLocator<NumberTriviaRepository>();
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<List<FavoriteTrivia>> snapshot) {
        final favTriviaList = snapshot.data ?? List();
        return ListView.builder(
          itemCount: favTriviaList.length,
          itemBuilder: (_, index) {
            final favTrivia = favTriviaList[index];
            return _buildListItem(favTrivia, repository);
          },
        );
      },
    );
  }

  Widget _buildListItem(FavoriteTrivia favTrivia, NumberTriviaRepository repository) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => repository.deleteFavoriteNumberTrivia(favTrivia),
        )
      ],
      child: ListTile(
        title: Text(favTrivia.triviaNumber.toString()),
        subtitle: Text(favTrivia.triviaText ?? 'No Description'),
      ),
    );
  }
}
