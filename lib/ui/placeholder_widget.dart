import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'task.dart';
class PlaceholderWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PlaceholderWidget();
  }

}
class _PlaceholderWidget extends State<PlaceholderWidget>{
 @override
 Widget build(BuildContext context) {
   return  FutureBuilder<List<Todo>>(
          future: DBProvider.db.getAllTodo(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  Todo item = snapshot.data[index];
                  if(TasklkState.currentIndexTab ==0 && item.status == 0){
                      return ListTile(
                        title: Text(item.todo),
                        trailing: Checkbox(
                        onChanged: (bool value){
                          setState(() {
                             DBProvider.db.blockOrUnblock(item);
                          });
                        },
                        value: item.status ==0? false:true,
                      ),
                    );
                    }if(TasklkState.currentIndexTab ==1 && item.status ==1){
                      return ListTile(
                        title: Text(item.todo),
                        trailing: Checkbox(
                          onChanged: (bool value){
                            setState(() {
                             DBProvider.db.blockOrUnblock(item);
                            });
                          },
                        value: item.status ==0? false:true,                          
                        ),
                      );
                    }
                },
              );
            }else if(widget.isdelete){
              return Center(child: Text("No data found."));
            }
          });
 }

 
}