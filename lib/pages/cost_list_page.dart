import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_activities/models/cost.dart';
import 'package:my_activities/pages/report_page.dart';
import 'package:my_activities/services/cost_service.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CostListPage extends StatefulWidget {
  const CostListPage({super.key});

  @override
  State<CostListPage> createState() => _CostListPageState();
}

class _CostListPageState extends State<CostListPage> {
  List<Cost> costs = [];
  final _costService = CostService();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  int dropdownYearValue = 1403; // موقتا
  int dropdownMonthValue = 3; // موقتا
  final bool editable = false;

  List<int> years = [];
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();

  Future fetchFromDb(String year, String month) async {
    years = await _costService.getYears();

    DateTime parseDt = DateTime.parse(DateTime.now().toString());
    Jalali j1 = parseDt.toJalali();
    year = year != '' ? year : j1.year.toString();
    month = month != '' ? month : j1.month.toString();

    // final f = j1.formatter;
    // String m = month != '' ? month : f.mN;

    costs.clear();
    //costs.addAll(await _costService.getAllCosts());
    costs.addAll(await _costService.getAllCostsYearMonth(month, year));
    setState(() {
      setState(() {
        dropdownMonthValue = int.parse(month); // فروردین ...
        dropdownYearValue = int.parse(year);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromDb('', '');
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: dropdownYearValue,
                        // items: dropdownItems.map((String value) {
                        //   return DropdownMenuItem<String>(
                        //     value: value,
                        //     child: Text(value),
                        //   );
                        // }).toList(),
                        items: years.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              //style: fieldStyle,
                            ),
                          );
                        }).toList(),
                        // validator: (value) {
                        //   return Validator.validateDropDefaultData(value);
                        // },
                        decoration: InputDecoration(
                          labelText: 'سال:',
                          //labelStyle: fieldStyle,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: editable
                            ? null
                            : (val) {
                                fetchFromDb(val.toString(), dropdownMonthValue.toString());
                              },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: dropdownMonthValue,
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              // style: fieldStyle,
                            ),
                          );
                        }).toList(),
                        // validator: (value) {
                        //   return Validator.validateDropDefaultData(value);
                        // },
                        decoration: InputDecoration(
                          labelText: 'ماه:',
                          //  labelStyle: fieldStyle,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: editable
                            ? null
                            : (val) {
                                fetchFromDb(dropdownYearValue.toString(), val.toString());
                              },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
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
