import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatistBarChart extends StatelessWidget {
  final List<Statist>? statists;

  const StatistBarChart({
    Key? key,
    required this.statists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ColumnSeries<Statist, String>> series = [
      ColumnSeries<Statist, String>(
        dataSource: statists!,
        xValueMapper: (Statist statist, _) => statist.statist.key,
        yValueMapper: (Statist statist, _) => statist.statist.datas,
        borderRadius: BorderRadius.circular(6.0),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(250, 122, 47, 1),
          Color.fromRGBO(234, 169, 75, 1),
        ]),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.inside,
        ),
      )
    ];

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        labelFormat: '{value}',
      ),
      series: series,
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
      ),
    );
  }
}

class StatistEsianChart extends StatelessWidget {
  final List<Statist>? statists;

  const StatistEsianChart({
    Key? key,
    required this.statists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LineSeries<Statist, String>> series = <LineSeries<Statist, String>>[
      LineSeries<Statist, String>(
          animationDuration: 2500,
          dataSource: statists!,
          xValueMapper: (Statist statist, _) => statist.statist.key,
          yValueMapper: (Statist statist, _) => statist.statist.datas,
          pointColorMapper: (Statist statist, _) => Palette.orderColor,
          width: 2)
    ];

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0), labelFormat: '{value}'),
      series: series,
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
      ),
    );
  }
}
