
import 'package:flutter/material.dart';

import 'shimmer_widget.dart';

class BuildShimmer extends StatelessWidget {
  const BuildShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFAF7F7),
      child: ListTile(
        leading: ShimmerWidget.circular(width: 60, height: 60,
          shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),),
        title: ShimmerWidget.rectangular(height: 16),
        subtitle: ShimmerWidget.rectangular(height: 14),
      ),
    );
  }
}
