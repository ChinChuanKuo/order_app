import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';

class NoticeSelector extends StatelessWidget {
  final Notice notice;

  const NoticeSelector({
    Key? key,
    required this.notice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => OpenContainer(
        closedElevation: 0.0,
        closedColor: Colors.transparent,
        closedBuilder: (BuildContext context, void Function() closeBuilder) =>
            ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          leading: ProfileAvatar(imageUrl: notice.notice.imageUrl),
          title: Text(
            notice.notice.message,
            style: Fontstyle.subtitle(Colors.black),
          ),
          subtitle: Text(
            notice.notice.timeAgo,
            style: Fontstyle.subtitle(Colors.grey[600]),
          ),
          trailing: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 21.0,
              color: Palette.disabledColor,
            ),
            onPressed: () {},
          ),
          onTap: closeBuilder,
        ),
        openElevation: 0.0,
        openColor: Colors.transparent,
        openBuilder: (BuildContext context, void Function() openBuilder) =>
            SizedBox.shrink(),
      );
}
