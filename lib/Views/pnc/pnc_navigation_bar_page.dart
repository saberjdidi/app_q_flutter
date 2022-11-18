import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/custom_colors.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import 'decideur_pnc_page.dart';
import 'new_pnc.dart';
import 'pnc_page.dart';
import 'products/products_page.dart';

class PNCNavigationBarPage extends StatefulWidget {
  const PNCNavigationBarPage({Key? key}) : super(key: key);

  @override
  State<PNCNavigationBarPage> createState() => _PNCNavigationBarPageState();
}

class _PNCNavigationBarPageState extends State<PNCNavigationBarPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    PNCPage(),
    ProductsPage(),
    DecideurPNCPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;

    final items = <Widget>[
      Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Icon(
              Icons.home,
              size: 25,
            ),
            Text(
              'home'.tr,
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Icon(
              Icons.plus_one,
              size: 25,
            ),
            Text('product'.tr,
                style: TextStyle(color: Colors.white, fontSize: 10))
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Icon(
              Icons.person_search_rounded,
              size: 25,
            ),
            Text('Decideur',
                style: TextStyle(color: Colors.white, fontSize: 10))
          ],
        ),
      )
      /* Icon(Icons.home, size: 25,),
      Icon(Icons.plus_one, size: 25,),
      Icon(Icons.person_search_rounded, size: 25,), */
    ];

    return Scaffold(
      extendBody: true,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'P.N.C',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          color: Colors.blue,
          buttonBackgroundColor: Colors.cyan,
          height: 45,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
