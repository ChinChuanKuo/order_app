import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MobileCalendar extends StatelessWidget {
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;

  const MobileCalendar({
    Key? key,
    required this.dataSource,
    this.onLongPress,
  }) : super(key: key);

  String getMonthDate(int month) => [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ][month - 1];

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showNavigationArrow: false,
      showDatePickerButton: false,
      view: CalendarView.schedule,
      backgroundColor: Colors.transparent,
      todayHighlightColor: Palette.orderColor,
      scheduleViewMonthHeaderBuilder:
          (BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
        final String monthTile = getMonthDate(details.date.month);
        return Stack(
          children: [
            Image(
              image: ExactAssetImage('images/$monthTile.png'),
              fit: BoxFit.cover,
              width: details.bounds.width,
              height: details.bounds.height,
            ),
            Positioned(
              left: 55,
              right: 0,
              top: 20,
              bottom: 0,
              child: Text(
                '$monthTile ${details.date.year}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
      loadMoreWidgetBuilder: (BuildContext context,
              Future<void> Function() loadMoreAppointments) =>
          FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapShot) =>
                  WidgetLoading().centerCircular),
      scheduleViewSettings: ScheduleViewSettings(appointmentItemHeight: 60.0),
      onLongPress: onLongPress,
      dataSource: dataSource,
    );
  }
}
