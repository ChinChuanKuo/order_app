import 'package:flutter/material.dart';
import 'package:order_app/widgets/widgets.dart';

class ProfileLoading extends StatelessWidget {
  const ProfileLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
        child: Column(
          children: [
            shimmerUser(screenSize),
            SizedBox(height: screenSize.height * 0.01),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) =>
                    shimmerProfile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget shimmerUser(Size screenSize) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        children: [
          WidgetShimmer.circular(width: 90.0, height: 90.0),
          SizedBox(height: screenSize.height * 0.0175),
          WidgetShimmer.rectangular(width: 50.0, height: 25.0),
          SizedBox(height: screenSize.height * 0.02),
          WidgetShimmer.rectangular(width: 50.0, height: 25.0),
        ],
      ),
    );

Widget shimmerProfile() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        leading: WidgetShimmer.circular(width: 52.0, height: 52.0),
        title: WidgetShimmer.rectangular(height: 30.0),
      ),
    );
