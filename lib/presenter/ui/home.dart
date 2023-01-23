// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeper/data/navigator/nested/nested_delegate.dart';
import 'package:keeper/data/navigator/nested/nested_parser.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/domain/utils/constants.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/ui/onboard.dart';
import 'package:keeper/presenter/widgets/general/app_page.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/localization.dart';
import '../provider/provider.dart';
import '../widgets/general/drawer.dart';
import '../widgets/general/extended_fab.dart';
import '../widgets/general/input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageBloc _homePageBloC;
  late DatabaseBloc _databaseBloc;

  late NestedRouterDelegate _nestedDelegate;
  late NestedRouterParser _nestedParser;
  late ChildBackButtonDispatcher _backButtonDispatcher;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  void Function(void Function())? _setSearchState;

  @override
  void initState() {
    _homePageBloC = HomePageBloc();
    _databaseBloc = DatabaseBloc();
    _nestedParser = NestedRouterParser();
    _nestedDelegate = NestedRouterDelegate(
      _homePageBloC, _databaseBloc
    );
    debugPrint(DateFormat('HH:mm:ss').format(DateTime(2023, 1, 1, 24, 55, 40)));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context)
    .backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("HOME BUILD");
    final provider = Provider.of<PreferenceProvider>(context);
    return !provider.isFirst! ? AppPage(
      bottomSafeArea: true,
      isCurrentPageMain: true,
      scaffoldKey: _scaffoldKey,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      floatingActionButton: StreamBuilder(
        stream: _homePageBloC.fabStateStream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return snapshot.hasData ? AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: snapshot.data! ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: snapshot.data! ? 1 : 0,
              child: ExtendedFAB(
                icon: Icons.add,
                title: AppLocalizations.of(context, 'add'),
                onPressed: (){
                  if(_homePageBloC.currentLocation == NestedRoutes.notesPath){
                    context.push(AppRoutes.noteViewPath, {
                      "type": notesType,
                      "db_bloc": _databaseBloc
                    });
                  }
                  else if(_homePageBloC.currentLocation == NestedRoutes.tasksPath){
                    context.push(AppRoutes.noteViewPath, {
                      "type": tasksType,
                      "db_bloc": _databaseBloc
                    });
                  }
                },
              ),
            ),
          ) : const SizedBox();
        }
      ),
      drawer: StreamBuilder(
        initialData: NestedRoutes.notesPath,
        stream: _homePageBloC.selectedLocationStream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          //debugPrint("DRAWER: ${snapshot.data}");
          return AppDrawer(
            bloc: _homePageBloC,
            scaffoldKey: _scaffoldKey,
            location: snapshot.data,
            nestedDelegate: _nestedDelegate,
            onTabChanged: (){
              _searchController.clear();
              _databaseBloc.searchQuery = "";
            },
          );
        }
      ),
      child: Column(
        children: [
          if(kIsWeb)
          const SizedBox(height: 8),
          homeAppBar,
          const SizedBox(height: 12),
          StreamBuilder(
            initialData: false,
            stream: _homePageBloC.showSearchStream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 200),
                child: snapshot.data! ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: StatefulBuilder(
                    builder: (context, setItem) {
                      _setSearchState = setItem;
                      return Column(
                        children: [
                          InputField(
                            isDatePick: false,
                            controller: _searchController,
                            hint: AppLocalizations.of(context, 'search_hint'),
                            borderRadius: 16,
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 22,
                              color: Colors.grey,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty ? GestureDetector(
                              child: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onTap: () async{
                                _searchController.clear();
                                _databaseBloc.searchQuery = "";
                                FocusScope.of(context).unfocus();
                                await _inAppSearch();
                              },
                            ) : const SizedBox(),
                            onChanged: (String value) async{
                              _databaseBloc.searchQuery = value;
                              _setSearchState!(() {});
                              await _inAppSearch();
                            },
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 8)
                        ],
                      );
                    }
                  ),
                ) : const SizedBox(),
              );
            }
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Router(
              routerDelegate: _nestedDelegate,
              routeInformationParser: _nestedParser,
              backButtonDispatcher: _backButtonDispatcher,
            ),
          ),
        ],
      )
    ) : const OnBoardingPage();
  }

  Future<void> _inAppSearch() async{
    switch(_homePageBloC.currentLocation){
      case NestedRoutes.notesPath:
        await _databaseBloc.getNotes();
        break;
      case NestedRoutes.tasksPath:
        await _databaseBloc.getTasks();
        break;
    }
  }

  Widget get homeAppBar => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.dehaze,
            size: 28,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        StreamBuilder(
          initialData: NestedRoutes.notesPath,
          stream: _homePageBloC.selectedLocationStream,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Text(
              AppLocalizations.of(context, snapshot.data!.substring(1)),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400
              ),
            );
          }
        ),
        StreamBuilder(
          initialData: false,
          stream: _homePageBloC.showSearchStream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return IconButton(
              icon: Icon(
                snapshot.data! ?
                Icons.clear :
                Icons.search,
                size: 28,
              ),
              onPressed: () {
                _homePageBloC.changeSearchState(!snapshot.data!);
              },
            );
          }
        )
      ],
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


