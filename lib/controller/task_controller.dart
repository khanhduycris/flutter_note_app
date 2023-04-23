import 'package:get/get.dart';
import 'package:note_app/db/db_helper.dart';
import 'package:note_app/models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    getTasks();
    super.onReady();
  }


  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get all the data from table
  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }


  //delete
  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  //update
  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();
  }
}