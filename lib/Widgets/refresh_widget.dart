
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatelessWidget {

  final GlobalKey<RefreshIndicatorState> keyRefresh;
  final Widget child;
  final Future Function() onRefresh;

  RefreshWidget({
    required this.keyRefresh,
    required this.onRefresh,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget() : buildiOSWidget();
  }

  Widget buildAndroidWidget() => RefreshIndicator(
    key: keyRefresh,
    onRefresh: onRefresh,
    child: child,
  );

  Widget buildiOSWidget() => CustomScrollView(
    physics: BouncingScrollPhysics(),
    slivers: [
      CupertinoSliverRefreshControl(
        onRefresh: onRefresh,
        key: keyRefresh,
      ),
      SliverToBoxAdapter(child: child),
    ],
  );
}

/*
class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> keyRefresh;
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    required this.keyRefresh,
    required this.onRefresh,
    required this.child,
  });

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) =>
      Platform.isAndroid ? buildAndroidWidget() : buildiOSWidget();

  Widget buildAndroidWidget() => RefreshIndicator(
    key: widget.keyRefresh,
    onRefresh: widget.onRefresh,
    child: widget.child,
  );

  Widget buildiOSWidget() => CustomScrollView(
    physics: BouncingScrollPhysics(),
    slivers: [
      CupertinoSliverRefreshControl(
        onRefresh: widget.onRefresh,
        key: widget.keyRefresh,
      ),
      SliverToBoxAdapter(child: widget.child),
    ],
  );
}
*/

