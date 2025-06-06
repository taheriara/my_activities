import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_activities/models/report.dart';
import 'package:my_activities/services/cost_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Report> report = [];
  final _costService = CostService();
  late int _cost = 0;
  late int _income = 0;

  bool _canShowButton = true;

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
    });
  }

  Future fetchFromDb() async {
    report.clear();
    report.addAll(await _costService.getReport());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش هزینه‌ها'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('حذف شود؟'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('لغو'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('تایید'),
                        onPressed: () async {
                          _costService.deleteCost();
                          fetchFromDb();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: report.length,
                  itemBuilder: (context, index) {
                    report[index].type == 'cost' ? _cost += report[index].amount : _income += report[index].amount;
                    return report.isEmpty
                        ? const Center(
                            child: Text('فعلا خبری نیست!'),
                          )
                        : ListTile(
                            title: Text(report[index].category),
                            // subtitle: Text(report[index].type),
                            trailing: Text(
                              NumberFormat.decimalPattern().format(report[index].amount).toString(),
                              style: TextStyle(
                                  color: report[index].type == 'cost' ? Colors.red : Colors.green, fontSize: 14),
                            ),
                          );
                  }),
            ),
            !_canShowButton
                ? const SizedBox.shrink()
                : TextButton(
                    child: Text("جمـــع کلــی"),
                    onPressed: () {
                      setState(() {});
                      hideWidget();
                    },
                  ),
            Text(
              NumberFormat.decimalPattern().format(_income).toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),
            Text(
              NumberFormat.decimalPattern().format(_cost).toString(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
