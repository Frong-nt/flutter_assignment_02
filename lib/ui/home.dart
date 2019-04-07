
import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'placeholder_widget.dart';
import 'new_subject.dart';
class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  List<Todo> _taskList = List<Todo>();
  List<Todo> _completedList = List<Todo>();
  int _currentIndex = 0;

  @override
  initState(){
    super.initState();
    this._updateList();
  }

   void _updateList() {
     setState(() { 
      FutureBuilder<List<Todo>>(
          future: DBProvider.db.getAllTodo(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
            if(snapshot.hasData){
              ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  Todo item = snapshot.data[index];
                  if(item.done ==0)
                    _taskList.add(item);
                  else
                  _completedList.add(item);                    
                },
              );
            }
      });
     });

      print(_taskList.toString()+" task");
      print(_completedList.toString()+" complete");

   }
  
  @override
  Widget build(BuildContext context) {
    List<AppBar> appBars = <AppBar>[
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
          Navigator.pushNamed(context, "/new_subject");
            },
          ),
        ],
      ),
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                DBProvider.db.deleteTodoFromStatus();
                this._updateList();
              });
            },
          ),
        ],
      ),
    ];

    final List<Widget> pages = <Widget>[
      Center(
        child: (this._taskList.length == 0)
            ? Text('No data found')
            : ListView(
                children: this
                    ._taskList
                    .map(
                      (todo) => CheckboxListTile(
                            title: Text(todo.title),
                            value: todo.done==0? false:true,
                            onChanged: (bool value) {
                              setState(() {
                                todo.done = value? 1:0;
                                DBProvider.db.updateTodo(todo);
                                this._updateList();
                              });
                            },
                          ),
                    )
                    .toList(),
              ),
      ),
      Center(
        child: (this._completedList.length == 0)
            ? Text('No data found')
            : ListView(
                children: this
                    ._completedList
                    .map(
                      (todo) => CheckboxListTile(
                            title: Text(todo.title),
                            value: todo.done==0? false:true,
                            onChanged: (bool value) {
                              setState(() {
                                 todo.done = value? 1:0;
                                DBProvider.db.updateTodo(todo);
                                this._updateList();
                              });
                            },
                          ),
                    )
                    .toList(),
              ),
      ),
    ];

    return Scaffold(
      appBar: appBars[_currentIndex],
      body: pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: this._currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              title: Text('Completed'),
            ),
          ],
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
            });
          },
        ),
      ),
    );
  }
}
