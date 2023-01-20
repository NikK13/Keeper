import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/widgets/general/illustrations.dart';
import 'package:keeper/presenter/widgets/general/loading.dart';

import '../../domain/utils/styles.dart';

class NotesFragment extends StatelessWidget {
  final HomePageBloc? bloc;
  final DatabaseBloc? dbBloc;

  const NotesFragment({super.key, this.bloc, this.dbBloc});

  @override
  Widget build(BuildContext context) {
    //debugPrint("NotesFragment");
    return StreamBuilder(
      stream: dbBloc!.allNotesStream,
      builder: (context, AsyncSnapshot<List<Note>?> snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.isNotEmpty){
            return NotesFragmentView(
              bloc: bloc,
              dbBloc: dbBloc,
              notesList: snapshot.data,
            );
          }
          return const EmptyIllustration(icon: Icons.sticky_note_2_rounded);
        }
        return const LoadingView();
      },
    );
  }
}

class NotesFragmentView extends StatelessWidget {
  final HomePageBloc? bloc;
  final DatabaseBloc? dbBloc;
  final List<Note>? notesList;

  const NotesFragmentView({
    Key? key,
    this.bloc,
    this.dbBloc,
    this.notesList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification){
        final ScrollDirection direction = notification.direction;
        if (direction == ScrollDirection.reverse) {
          bloc!.changeFabState(false);
        } else if (direction == ScrollDirection.forward) {
          bloc!.changeFabState(true);
        }
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2, itemCount: notesList!.length,
          itemBuilder: (BuildContext context, int index) {
            final item = notesList![index];
            return NoteItem(note: item);
          },
          staggeredTileBuilder: (int index) => StaggeredTile.count(
            1, (index) % 2 == 0 ? 1.3 : 1
          ),
          crossAxisSpacing: 12.0, mainAxisSpacing: 12.0,
        ),
      ),
    );
  }
}
