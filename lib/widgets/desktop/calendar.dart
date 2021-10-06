import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DesktopCalendar extends StatelessWidget {
  final CalendarDataSource? dataSource;
  final void Function(CalendarLongPressDetails calendarLongPressDetails)?
      onLongPress;

  const DesktopCalendar({
    Key? key,
    required this.dataSource,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showDatePickerButton: false,
      showNavigationArrow: false,
      view: CalendarView.month,
      selectionDecoration: BoxDecoration(
          border: Border.all(color: Palette.disabledColor, width: 2)),
      todayHighlightColor: Palette.orderColor,
      monthViewSettings:
          MonthViewSettings(showAgenda: true, agendaItemHeight: 60),
      loadMoreWidgetBuilder: (BuildContext context,
              Future<void> Function() loadMoreAppointments) =>
          FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapShot) =>
                  WidgetLoading().centerCircular),
      onLongPress: onLongPress,
      dataSource: dataSource,
    );
  }
}
