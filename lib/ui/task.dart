import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'placeholder_widget.dart';
class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TasklkState();
  }

}
class TasklkState extends State<TaskScreen>{
  static int currentIndexTab = 0;
  static bool isPressDeleteButton = false;
  final List<PlaceholderWidget> _children = [new PlaceholderWidget(), new PlaceholderWidget()];
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            IconButton(
              icon: IconTheme(
                data: new IconThemeData(color: Colors.white),
                child: TasklkState.currentIndexTab==0? new Icon(Icons.add): new Icon(Icons.delete),
              ),
              onPressed: appBarOnpress,
            )
          ],
        ),
        body: _children[TasklkState.currentIndexTab],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: TasklkState.currentIndexTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: new Text('Task')
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: new Text('Completed')
              )
          ],
        )
        );
  }

  void onTabTapped(int index) {
   setState(() {
     TasklkState.currentIndexTab = index;
   });
 }
 void setIsDeleteStat(bool state){
   setState(() {
    TasklkState.isPressDeleteButton = state;  
   });
 }
 void appBarOnpress(){
  if(TasklkState.currentIndexTab==0)
    Navigator.pushNamed(context, "/new_subject");
  else if(TasklkState.currentIndexTab==1){
        setState(() {
        isPressDeleteButton = true;
        DBProvider.db.deleteTodoFromStatus();
      });
   }
 }
}

