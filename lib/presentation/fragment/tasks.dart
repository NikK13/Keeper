import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/widgets/general/illustrations.dart';
import 'package:keeper/presenter/widgets/general/loading.dart';

class TasksFragment extends StatelessWidget {
  final HomePageBloc? bloc;
  final DatabaseBloc? dbBloc;

  const TasksFragment({super.key, this.bloc, this.dbBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbBloc!.allTasksStream,
      builder: (context, AsyncSnapshot<List<Note>?> snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.isNotEmpty){
            return TasksFragmentView(
              bloc: bloc,
              dbBloc: dbBloc,
              tasksList: snapshot.data,
            );
          }
          return const AppIllustration(icon: Icons.sticky_note_2_rounded);
        }
        return const LoadingView();
      },
    );
  }
}

class TasksFragmentView extends StatelessWidget {
  final HomePageBloc? bloc;
  final DatabaseBloc? dbBloc;
  final List<Note>? tasksList;

  const TasksFragmentView({
    Key? key,
    this.bloc,
    this.dbBloc,
    this.tasksList
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
        child: GridView.builder(
          itemCount: tasksList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.85,
            crossAxisSpacing: 12.0, mainAxisSpacing: 12.0,
          ),
          itemBuilder: (context, index) => NoteItem(
            note: tasksList![index],
            dbBloc: dbBloc,
          ),
        ),
      ),
    );
  }
}
