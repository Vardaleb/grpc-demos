import 'package:client/generated/event.pbgrpc.dart';
import 'package:client/src/ui/header_cell.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultTable extends StatelessWidget {
  final Event event;

  const ResultTable({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var dateTime = event.time.toDateTime();

    var timeUTC = DateFormat('HH:mm:ss').format(dateTime);
    var timeServer = DateFormat('HH:mm:ss')
        .format(dateTime.add(Duration(seconds: event.offsetSeconds)));
    var timeLocal = DateFormat('HH:mm:ss').format(dateTime
        .add(Duration(seconds: DateTime.now().timeZoneOffset.inSeconds)));

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          createHeaderRow(),
          createRow("UTC", "", timeUTC),
          createRow("Server", event.timezoneName, timeServer),
          createRow("Local", DateTime.now().timeZoneName, timeLocal),
        ],
      ),
    );
  }

  TableRow createHeaderRow() {
    return const TableRow(children: [
      HeaderCell(
        'Origin',
      ),
      HeaderCell(
        "Timezone",
      ),
      HeaderCell(
        "Time",
        centered: true,
      ),
    ]);
  }

  TableRow createRow(String label, String timezone, String time) {
    const textStyle = TextStyle(fontSize: 50, color: Colors.blue);
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(label, style: textStyle),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(timezone, style: textStyle),
      ),
      Center(child: Text(time, style: textStyle)),
    ]);
  }
}
