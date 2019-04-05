import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'placeholder_widget.dart';
class TaskScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TaslkState();
  }

}
class _TaslkState extends State<TaskScreen>{
 int _currentIndex = 0;
  final List<Widget> _children = [new Placeholder(), new Placeholder()];
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Todo"),
            actions: <Widget>[
              IconButton(
                icon: IconTheme(
                  data: new IconThemeData(color: Colors.white),
                  child: new Icon(Icons.add),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/new_subject");
                },
              )
            ],
          ),
          body: FutureBuilder<List<Todo>>(
            future: DBProvider.db.getAllTodo(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    Todo item = snapshot.data[index];
                    return 
                      ListTile(
                        title: Text(item.todo),
                        leading: Text(item.id.toString()),
                        trailing: Checkbox(
                          onChanged: (bool value){
                            DBProvider.db.blockOrUnblock(item);
                            setState(() {});
                          },
                          value: item.status ==0? false:true,
                        ),
                      );
                  },
                );
              }else{
                return Center(child: Text("No data"));
              }
            }),
          
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: 0,
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
          ),
      length: 2,
    );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
}
