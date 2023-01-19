// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/styles.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/ui/onboard.dart';
import 'package:keeper/presenter/widgets/general/app_page.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/localization.dart';
import '../provider/provider.dart';
import '../widgets/general/extended_fab.dart';
import '../widgets/general/input.dart';

class HomePage extends StatefulWidget {
  final HomePageBloc? homePageBloC;

  const HomePage({this.homePageBloC, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //debugPrint("HOME BUILD");
    final provider = Provider.of<PreferenceProvider>(context);
    return !provider.isFirst! ? AppPage(
      bottomSafeArea: false,
      isCurrentPageMain: true,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      floatingActionButton: StreamBuilder(
        stream: widget.homePageBloC!.fabStateStream,
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
                onPressed: () {
                  provider.switchThemes();
                },
              ),
            ),
          ) : const SizedBox();
        }
      ),
      child: Center()/*CustomSliverBar(
        topPadding: 48,
        title: AppLocalizations.of(context, 'desc'),
        collapsedTitle: App.appName,
        trailing: IconButton(
          icon: Icon(
            Icons.downloading_rounded,
            size: 32,
            color: provider.theme.accentColor!,
          ),
          onPressed: () {
            if(kDebugMode){
              final provider = Provider.of<PreferenceProvider>(context, listen: false);
              provider.deleteAllData();
            }
          },
        ),
        actions: IconButton(
          icon: Icon(
            !isIosApplication ?
            Icons.settings :
            CupertinoIcons.settings_solid,
            size: isIosApplication ? 28 : 30,
            color: provider.theme.accentColor!,
          ),
          onPressed: () {
            context.push(AppRoutes.settingsPath);
          },
        ),
        onUserScroll: (notification){
          final ScrollDirection direction = notification.direction;
          if (direction == ScrollDirection.reverse) {
            homePageBloC!.changeFabState(false);
          } else if (direction == ScrollDirection.forward) {
            homePageBloC!.changeFabState(true);
          }
          return true;
        },
        sliverHeader: InputField(
          isDatePick: false,
          controller: TextEditingController(),
          hint: AppLocalizations.of(context, 'search_hint'),
          borderRadius: 16,
          prefixIcon: const Icon(
            Icons.search,
            size: 22,
            color: Colors.grey,
          ),
          inputType: TextInputType.text,
        ),
        child: ListView.builder(
          //shrinkWrap: true,
          primary: true,
          itemCount: listing.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index){
            return Container(
              decoration: BoxDecoration(
                color: secondaryColor(context),
                borderRadius: BorderRadius.circular(12)
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(listing[index])
            );
          },
        ),
      )*/
    ) : const OnBoardingPage();
  }

  List<String> get listing => List.generate(
    25, (index) => "NOTE ${index + 1}"
  );
}

class HomePageView extends StatefulWidget {
  final HomePageBloc bloc;

  const HomePageView({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _searchController = TextEditingController();

  HomePageBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          const SizedBox(height: 8),
          InputField(
            isDatePick: false,
            controller: _searchController,
            hint: AppLocalizations.of(context, 'search_hint'),
            borderRadius: 16,
            prefixIcon: const Icon(
              Icons.search,
              size: 22,
            ),
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              primary: false,
              itemCount: listing.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index){
                return Container(
                  decoration: BoxDecoration(
                    color: secondaryColor(context),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(listing[index])
                );
              },
            ),/*Column(
              children: listing.asMap().map((index, item){
                return MapEntry(index, Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: secondaryColor(context),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(listing[index])
                ));
              }).values.toList(),
            )*/
          ),
        ],
      ),
    );
  }

  List<String> get listing => List.generate(
    25, (index) => "NOTE ${index + 1}"
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


