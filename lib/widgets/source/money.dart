import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/source/source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MoneySource extends CalendarDataSource {
  final List<Store> stores;

  MoneySource({required this.stores});

  @override
  List<Store> get appointments => stores;

  @override
  DateTime getStartTime(int index) => DateTime.parse(stores[index].stdate.data);

  @override
  DateTime getEndTime(int index) => DateTime.parse(stores[index].endate.data);

  @override
  bool isAllDay(int index) => false;

  List<Store> parseStores(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Store>((data) => Store.fromJson(data)).toList();
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final response = await http.get(
        Uri.http(APi.money[1]["url"], APi.money[1]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
          "dateinfo": json.encode(DateSource.initialState(
              "${startDate.year}/${startDate.month}/${startDate.day}",
              "${endDate.year}/${endDate.month}/${endDate.day}")),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final List<Store> items = <Store>[];
      final storeBody = parseStores(response.body);
      for (final Store store in storeBody)
        if (stores.indexWhere((element) =>
                element.requireid.orderid == store.requireid.orderid) ==
            -1) items.add(store);
      appointments.addAll(items);
      notifyListeners(CalendarDataSourceAction.add, items);
    }
  }
}
