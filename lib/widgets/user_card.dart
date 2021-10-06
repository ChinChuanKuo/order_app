import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';

class UserCard extends StatelessWidget {
  final void Function()? onTap;
  final UserInfo? userinfo;
  final bool showName;

  const UserCard({
    Key? key,
    this.onTap,
    required this.userinfo,
    this.showName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24.0),
      child: userinfo == null
          ? SizedBox.shrink()
          : showName
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileAvatar(
                      imageUrl: userinfo!.imageUrl,
                      radius: 24.0,
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      userinfo!.name,
                      style: Fontstyle.info(Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : ProfileAvatar(imageUrl: userinfo!.imageUrl),
    );
  }
}
