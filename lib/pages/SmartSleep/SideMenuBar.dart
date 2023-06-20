import 'package:flutter/material.dart';
import 'BackgroundCollectedPage.dart';
import '../bluetooth/BackgroundCollectingTask.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Reports.dart';
import 'Records.dart';
import 'MainPage.dart';

class NavigatorDrawer extends StatefulWidget {
  const NavigatorDrawer({Key? key}) : super(key: key);

  _NavigatorDrawer createState() => new _NavigatorDrawer();

}

class _NavigatorDrawer extends State<NavigatorDrawer>{

  BackgroundCollectingTask? _collectingTask2;

  @override
  Widget build(BuildContext context)  =>
      Drawer(
        child: SingleChildScrollView(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );
  Widget buildMenuItems (BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child:Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon (Icons.home_outlined),
            title: const Text('Home'),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>  MainPage2(),
              ));
            },
          ),
          ListTile(
            leading: const Icon (Icons.add_chart_outlined),
            title: const Text('Report'),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Reports(),
              ));
            },
          ),
          ListTile(
            leading: const Icon (Icons.book_outlined),
            title: const Text('All Records'),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Records(),
              ));
            },
          ),
          ListTile(
              leading: const Icon (Icons.workspaces_outline),
              title: const Text('Realtime Data'),
              onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ScopedModel<BackgroundCollectingTask>(
                  model: _collectingTask2!,
                  child: BackgroundCollectedPage(),);},
              ),
              );
              }
          ),
          ]
        ),
      );
}

