import '../Models/task_model.dart';
import '../Utils/Sqflite/db_helper.dart';
import '../Utils/Sqflite/db_table.dart';

class LocalTaskService {

  DBHelper dbHelper = DBHelper();

  readTask() async {
    return await dbHelper.readTask(DBTable.task);
  }

  saveTask(TaskModel task) async {
    //await dbHelper.deleteAllTasks();
    //print('delete all tasks');
    print('save task : ${task.email}');
    return await dbHelper.insertTask(DBTable.task, task.taskMap());
  }

  deleteAllTask() async {
    await dbHelper.deleteAllTasks();
    print('delete all tasks');
  }

  saveTaskStatic() async {
    return await dbHelper.insertTaskStatic(DBTable.task);
  }

//task sync
  readTaskSync() async {
    return await dbHelper.readTaskSync(DBTable.task_sync);
  }
  saveTaskSync(TaskModel task) async {
    print('save task sync : ${task.email}');
    return await dbHelper.insertTaskSync(DBTable.task_sync, task.taskMapSync());
  }
  deleteAllTaskSync() async {
    await dbHelper.deleteAllTaskSync();
    print('delete all tasks sync');
  }
}