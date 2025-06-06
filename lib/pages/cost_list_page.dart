import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_activities/models/cost.dart';
import 'package:my_activities/pages/report_page.dart';
import 'package:my_activities/services/cost_service.dart';

class CostListPage extends StatefulWidget {
  const CostListPage({super.key});

  @override
  State<CostListPage> createState() => _CostListPageState();
}

class _CostListPageState extends State<CostListPage> {
  List<Cost> costs = [];
  final _costService = CostService();

  Future fetchFromDb() async {
    costs.clear();
    costs.addAll(await _costService.getAllCosts());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('آرشیو ثبت هزینه/درآمد'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportPage()),
                  );
                },
                icon: const Icon(
                  Icons.print,
                ))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: costs.length,
                      itemBuilder: (context, index) {
                        return costs.isEmpty
                            ? const Center(
                                child: Text('فعلا خبری نیست!'),
                              )
                            : ListTile(
                                title: Text(costs[index].category),
                                subtitle: Text(costs[index].details!),
                                trailing: Text(
                                  NumberFormat.decimalPattern().format(costs[index].amount).toString(),
                                  style: TextStyle(
                                      color: costs[index].type == 'cost' ? Colors.red : Colors.green, fontSize: 14),
                                ),
                              );
                      }),
                ),
              ],
            )));
  }
}
