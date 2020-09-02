import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class FavoriteTrviasPage extends StatefulWidget {
  FavoriteTrviasPage({Key key}) : super(key: key);

  @override
  _FavoriteTrviasPageState createState() => _FavoriteTrviasPageState();
}

class _FavoriteTrviasPageState extends State<FavoriteTrviasPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        if (state is ObserveAllFavoriteTrviasState) {
          return _buildFavTriviaList(context, state.favTriviaStream);
        } else {
          return Container();
        }
      },
    );
  }

  StreamBuilder<List<FavoriteTrivia>> _buildFavTriviaList(BuildContext context, Stream<List<FavoriteTrivia>> stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<List<FavoriteTrivia>> snapshot) {
        final favTriviaList = snapshot.data ?? List();
        return ListView.builder(
          itemCount: favTriviaList.length,
          itemBuilder: (_, index) {
            final favTrivia = favTriviaList[index];
            return _buildListItem(favTrivia);
          },
        );
      },
    );
  }

  Widget _buildListItem(FavoriteTrivia favTrivia) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _dispatchDeleteFavoriteTriviaEvent(context, favTrivia),
        )
      ],
      child: ListTile(
        title: Text(favTrivia.triviaNumber.toString()),
        subtitle: Text(favTrivia.triviaText ?? 'No Description'),
      ),
    );
  }

  void _dispatchDeleteFavoriteTriviaEvent(BuildContext context, FavoriteTrivia trivia) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<NumberTriviaBloc>(context);
    bloc.add(DeleteFavoriteTriviaEvent(trivia));
  }
}
