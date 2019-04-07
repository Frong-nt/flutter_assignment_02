import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'placeholder_widget.dart';
class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }

}
class TaskState extends State<TaskScreen>{
  static int currentIndexTab = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            IconButton(
              icon: IconTheme(
                data: new IconThemeData(color: Colors.white),
                child: TaskState.currentIndexTab==0? new Icon(Icons.add): new Icon(Icons.delete),
              ),
              onPressed: appBarOnpress,
            )
          ],
        ),
        body:FutureBuilder<List<Todo>>(
          future: DBProvider.db.getAllTodo(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  Todo item = snapshot.data[index];
                  if(TaskState.currentIndexTab==0 && item.done == 0){
                      print(item.toString() +" tab0");
                      return ListTile(
                        title: Text(item.title),
                        trailing: Checkbox(
                        onChanged: (bool value){
                          setState(() {
                             DBProvider.db.blockOrUnblock(item);
                          });
                        },
                        value: item.done ==0? false:true,
                      ),
                    );
                    }if(TaskState.currentIndexTab==1 && item.done ==1){
                      print(item.toString() +" tab1");
                      return ListTile(
                        title: Text(item.title),
                        trailing: Checkbox(
                          onChanged: (bool value){
                            setState(() {
                             DBProvider.db.blockOrUnblock(item);
                            });
                          },
                        value: item.done ==0? false:true,                          
                        ),
                      );
                    }
                },
              );
            }else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: TaskState.currentIndexTab,
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
     TaskState.currentIndexTab = index;
   });
 }

 void appBarOnpress(){
  if(TaskState.currentIndexTab==0)
    Navigator.pushNamed(context, "/new_subject");
  else if(TaskState.currentIndexTab==1){
        setState(() {
        DBProvider.db.deleteTodoFromStatus();
      });
   }
 }
}

