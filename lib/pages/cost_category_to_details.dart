import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_activities/models/cost.dart';
import 'package:my_activities/services/cost_service.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CostCategoryToDetails extends StatefulWidget {
  const CostCategoryToDetails({super.key, required this.year, required this.month, required this.category});
  final int year;
  final int month;
  final String category;

  @override
  State<CostCategoryToDetails> createState() => _CostCategortToDetailsState();
}

class _CostCategortToDetailsState extends State<CostCategoryToDetails> {
  List<Cost> costs = [];
  final _costService = CostService();

  Future fetchFromDb() async {
    costs.clear();
    costs.addAll(await _costService.getAllCostsYearMonthCategory(
        widget.month.toString(), widget.year.toString(), widget.category));
    setState(() {});
  }

  String miladiToShamsi(date) {
    DateTime parseDt = DateTime.parse(date);
    Jalali j1 = parseDt.toJalali();
    final f = j1.formatter;
    return '${f.wN} ${f.d} ${f.mN}';
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
          title: Text('${widget.category}   ${widget.year.toString()}/${widget.month.toString()}'),
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
                                title: Text(costs[index].details!),
                                subtitle: Text(miladiToShamsi(costs[index].regDate)),
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
