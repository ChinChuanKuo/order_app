import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';

class ProfileCard extends StatelessWidget {
  final Money money;
  final void Function()? onTap;
  final UserInfo userInfo;

  const ProfileCard({
    Key? key,
    required this.money,
    required this.onTap,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: Column(
          children: [
            ProfileAvatar(
              imageUrl: this.userInfo.imageUrl,
              radius: 42.0,
            ),
            SizedBox(height: screenSize.height * 0.0175),
            Text(
              this.userInfo.name,
              style: Fontstyle.header(Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              '剩餘餘額：${this.money.item.data}',
              style: Fontstyle.subtitle(Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
