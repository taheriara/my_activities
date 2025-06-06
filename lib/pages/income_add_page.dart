import 'package:flutter/material.dart';
import 'package:my_activities/models/cost.dart';
import 'package:my_activities/pages/cost_list_page.dart';
import 'package:my_activities/services/cost_service.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';

class IncomeAddPage extends StatefulWidget {
  const IncomeAddPage({super.key});

  @override
  State<IncomeAddPage> createState() => _IncomeAddPageState();
}

class _IncomeAddPageState extends State<IncomeAddPage> {
  TextEditingController incomeDateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String costCatValue = 'حقوق';
  var items = ['حقوق', 'اسنپ', 'یارانه', 'پاداش', 'برنامه‌نویسی', 'سایر'];
  DateTime today = DateTime.now();
  final _costService = CostService();

  String formNum(String s) {
    return s == ''
        ? '0'
        : NumberFormat.decimalPattern().format(
            int.parse(s),
          );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: today, firstDate: DateTime(2024), lastDate: DateTime(2101));
    if (picked != null && picked != today) {
      setState(() {
        today = picked;
        incomeDateController.text = miladiToShamsi(today.toLocal().toString().split(" ")[0]);
      });
    }
  }

  String miladiToShamsi(date) {
    DateTime parseDt = DateTime.parse(date);
    Jalali j1 = parseDt.toJalali();
    final f = j1.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yyyy}';
  }

  @override
  void initState() {
    incomeDateController.text = miladiToShamsi(DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درج درآمد'),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.trending_flat),
        //     onPressed: () async {
        //       // await Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => const CostListPage()),
        //       // );
        //     },
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: incomeDateController,
                readOnly: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: const Icon(Icons.calendar_month)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              DropdownButton(
                  value: costCatValue,
                  items: items.map((String items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      costCatValue = newValue!;
                    });
                  }),
              const SizedBox(height: 17),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                maxLines: null,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'مبلغ',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) {
                  val = formNum(
                    val.replaceAll(',', ''),
                  );
                  amountController.value = TextEditingValue(
                    text: val,
                    selection: TextSelection.collapsed(offset: val.length),
                  );
                },
              ),
              const SizedBox(height: 17),
              TextFormField(
                controller: detailsController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'توضیحات',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (amountController.text.isEmpty) return;
                            // DateTime parseDt = DateTime.parse(today.toString());
                            Jalali j1 = today.toJalali();
                            //final f = j1.formatter;

                            Cost cost = Cost(
                              type: 'income', //درآمد
                              regDate: today.toString().split(" ")[0],
                              year: j1.year,
                              month: j1.month, // f.mN,
                              day: j1.day, // f.d,
                              category: costCatValue,
                              amount: int.parse(amountController.text.replaceAll(',', '')),
                              details: detailsController.text,
                              archive: false,
                            );
                            await _costService.saveCost(cost);

                            setState(() {
                              detailsController.text = "";
                              amountController.text = "";
                            });
                            // if (!context.mounted) return;
                            // Navigator.of(context).pop();
                          },
                          child: const Text("ثبت درآمد")),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
