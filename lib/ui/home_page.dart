import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/task.dart';
import 'package:note_app/ui/add_task_bar.dart';
import 'package:note_app/ui/theme.dart';
import 'package:note_app/ui/widgets/button.dart';
import 'package:note_app/ui/widgets/task_title.dart';
import '../controller/task_controller.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _dateTime = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTask(),
        ],
      ),
    );
  }

  _showTask(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            print(task.toJson());
            if(task.repeat == 'Daily'){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                // _taskController.delete(_taskController.taskList[index]);
                                // _showBottomSheet(context, task);
                              },
                              child: TaskTile(task)
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
            if(task.date == DateFormat.yMd().format(_dateTime)){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                _taskController.delete(_taskController.taskList[index]);
                                // _showBottomSheet(context, task);
                              },
                              child: TaskTile(task)
                          )
                        ],
                      ),
                    ),
                  )
              );
            }else{
              return Container();
            }
            }
        );
      }),
    );
  }


  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
            MediaQuery.of(context).size.height*0.24:
            MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode?darkGreyClr:Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
              ),
            ),
            const Spacer(),
            task.isCompleted==1
            ?Container()
                : _bottomSheetBotton(
                label: "Task Completed",
                onTap: (){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primakyClr,
                context: context,
            ),
            _bottomSheetBotton(
              label: "Delete Task",
              onTap: (){
                _taskController.delete(task);
                _taskController.getTasks();
                Get.back();
              },
              clr: Colors.red,
              context: context,
            ),
            const SizedBox(height: 18,),
            _bottomSheetBotton(
              label: "Close",
              onTap: (){
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose:true,
              context: context,
            )
          ],
        ),
      )
    );
  }


  _bottomSheetBotton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context
  }){
    return GestureDetector(
       onTap: (){
         // print('data');
         Get.back();
       },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),
        child: Center(
            child: Text(
                label,
              style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
            ),
        ),
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primakyClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        onDateChange: (date){
          setState(() {
            _dateTime = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
         MyButton(lable: "+ Add Task", onTap: ()async{
           await Get.to(()=>AddTaskPgae());
           _taskController.getTasks();
         })
          
          // MyButton(lable: "+ Add Task", onTap: ()=>Get.to(()=>AddTaskPgae()))
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          print('object');
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "abc", body: Get.isDarkMode ? "dsa" : "ghjk");
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
              'img/img.png'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
