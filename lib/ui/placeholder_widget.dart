import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
class PlaceholderWidget extends StatelessWidget {
Todo item;
 @override
 ListTile build(BuildContext context) {
   return ListTile(
                        title: Text(item.todo),
                        leading: Text(item.id.toString()),
                        trailing: Checkbox(
                          onChanged: (bool value){
                            DBProvider.db.blockOrUnblock(item);
                          },
                          value: item.status ==0? false:true,
                        ),
                      );
 }

 void setItem(Todo todo){
   this.item = todo;
 }
}