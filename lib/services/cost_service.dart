import 'package:my_activities/db_helper/repository.dart';
import 'package:my_activities/models/cost.dart';
import 'package:my_activities/models/report.dart';

class CostService {
  late Repository _repository;
  CostService() {
    _repository = Repository();
  }

  //Save User
  saveCost(Cost cost) async {
    return await _repository.insertData('cost', cost.toMap());
  }

  updateCost(Cost cost) async {
    return await _repository.updateData('Cost', cost.toMap());
  }

  //Read All Users
  readAllCost() async {
    return await _repository.readDataAll('cost');
  }

  Future<List<Report>> getReport(int year, int month) async {
    var groceries = await _repository.report(
        "select category, type, Sum(amount) as amount from cost WHERE (year=$year and month =$month) GROUP BY category,type  ORDER BY category;");
    List<Report> groceryList =
        groceries.isNotEmpty ? List<Report>.from(groceries.map((c) => Report.fromJson(c)).toList()) : [];
    return groceryList;
  }

  // Future<List<Cost>> getCosts() async {
  //   var costs =
  //       await _repository.report("select category, type, COUNT(id) as qty from tasks GROUP BY category, type ORDER BY category;");
  //   List<Cost> groceryList = costs.isNotEmpty ? List<Cost>.from(groceries.map((c) => Cost.fromJson(c)).toList()) : [];
  //   return groceryList;
  // }

  Future<List<Cost>> getAllCostsYearMonth(String month, String year) async {
    var groceries = await _repository.readData("cost", "month=$month and year=$year", "id DESC");
    List<Cost> groceryList =
        groceries.isNotEmpty ? List<Cost>.from(groceries.map((c) => Cost.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<List<Cost>> getAllCostsYearMonthCategory(String month, String year, String cat) async {
    var groceries = await _repository.readData("cost", "month=$month and year=$year and category='$cat'", "id DESC");
    List<Cost> groceryList =
        groceries.isNotEmpty ? List<Cost>.from(groceries.map((c) => Cost.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<List<Cost>> getAllCosts() async {
    var groceries = await _repository.readDataAll("cost");
    List<Cost> groceryList =
        groceries.isNotEmpty ? List<Cost>.from(groceries.map((c) => Cost.fromJson(c)).toList()) : [];
    return groceryList;
  }

  Future<List<Cost>> getTasksWithDate(String date) async {
    var groceries = await _repository.readData("cost", "regDate=\'$date\' ", "id DESC");
    List<Cost> groceryList =
        groceries.isNotEmpty ? List<Cost>.from(groceries.map((c) => Cost.fromJson(c)).toList()) : [];
    return groceryList;
  }

  // Future<Task> getTask(String date) async {
  //   var groceries = await _repository.readData("tasks", "regDate=\'$date\' ", "id");
  //   List<Task> groceryList = groceries.isNotEmpty ? List<Task>.from(groceries.map((c) => Task.fromJson(c)).toList()) : [];
  //   return groceryList[0];
  // }

  getYears() async {
    var result = await _repository.readDataGroup("cost", ['year'], "year");
    List<int> years = [];
    for (var element in result) {
      years.add(element['year']);
    }

    // var groceries = await _repository.readDataGroup("dailyEntery", ['year'], "year");
    //List<String> groceryList = groceries.isNotEmpty ? List<String>.from(groceries.map((c) => fromMap(c)).toList()) : [];
    return years;
  }

  deleteCost() async {
    return await _repository.deleteAllRecords('cost', '');
  }

  // deleteUser(personId) async {
  //   return await _repository.deleteDataById('userInfo', personId);
  // }

  // resetNobatToId(loanNumber) async {
  //   return await _repository.resetNobatToId('userInfo', loanNumber);
  // }

  // addCol() async {
  //   return await _repository.alterTable('persons', 'amount');
  // }
}
