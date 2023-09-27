import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Auth/login.dart';
import 'package:to_do/toast.dart';

import 'package:to_do/mybutton.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final auth = FirebaseAuth.instance;
  final _controller = TextEditingController();
  final _editController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Task');
  bool checked = false;
  List todolist = [];
  List<dynamic> list = [];
  String currentRef='';

  void checkBoxChanged(bool? value, bool checked, String task, String currentRef){
    //change state on tapping
    setState((){
      checked = !checked;
    });
    databaseRef.child(currentRef).set({
      'Entry': task,
      'Checked': checked,
      'id' : currentRef
    });
  }

  void createNewTask(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.deepPurple[200],
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  //user input
                  TextField(
                    style: const TextStyle(color: Colors.deepPurple),
                    cursorColor: Colors.deepPurple[400],
                    controller: _controller,
                    decoration: const InputDecoration(border: OutlineInputBorder(),
                    hintText: "Add a new task",
                    ),
                  ),

                  //buttons => save + cancel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      myButton(text: "Save", onPressed: (){
                        currentRef = DateTime.now().millisecondsSinceEpoch.toString();
                        databaseRef.child(currentRef).set({
                          'Entry': _controller.text.toString(),
                          'Checked': checked,
                          'id':currentRef
                        }).then((value){
                          ToastMsg("Task Added");
                          }).onError((error, stackTrace){
                            ToastMsg(error.toString());
                        });
                        setState(() {
                          todolist.add([_controller.text,false]);
                          _controller.clear();
                        });
                        Navigator.of(context).pop();
                      }),
                      const SizedBox(width: 8,),
                      myButton(text: "Cancel", onPressed: ()=>Navigator.of(context).pop()
                      ),

                    ],
                  )
                ],
            ),
          ),
        );
      }
    );
  }

  void deleteTask(int index, String id){
    databaseRef.child(id).remove();
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
        centerTitle: true,
        title: const Text("To Do",style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }).onError((error, stackTrace){
              ToastMsg(error.toString());
            });
          }, icon: const Icon(Icons.logout_outlined,color: Colors.white,),
            color: Colors.deepPurple
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[400],
          onPressed: createNewTask,
          child: const Icon(Icons.add)),
      body:Stack(
      children:[
        Center(
          child: Opacity(
            opacity: 0.08,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Image.asset('spimage/img.png')),
          )),

        Expanded(
          child: StreamBuilder(
              stream: databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                if(snapshot.data!.snapshot.value!=null){
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  list.clear();
                  list = map.values.toList();
                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index){
                    String task = list[index]['Entry'];
                    bool taskCompleted = list[index]['Checked'];
                    String id = list[index]['id'];

                      return GestureDetector(
                        onLongPress: (){showMyDialogue(task,id);},
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            extentRatio: 0.5,
                            children: [
                              SlidableAction(
                                onPressed: (context)=>deleteTask(index,id),
                                icon: Icons.delete,
                                backgroundColor: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.fromLTRB(8,8,8,0),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          value: taskCompleted,
                                          onChanged: (value)=>checkBoxChanged(value, taskCompleted, task, id),
                                          activeColor: Colors.deepPurple[600],
                                        ),
                                        Text(
                                          task,
                                          style: TextStyle(decoration: taskCompleted?(TextDecoration.lineThrough):TextDecoration.none,
                                              color: taskCompleted?Colors.white70:Colors.white, fontSize: 16),
                                        ),
                                      ]),

                                  // Container(
                                  //   child: GestureDetector(
                                  //     onLongPress:(){
                                  //       showMyDialogue(task,id);
                                  //     }
                                  //   ),
                                  // ),
                                ],
                              )
                          ),
                        ),
                      );
                    },
                  );
                }else {
                  return Stack(
                      children:[
                        Center(
                            child: Opacity(
                              opacity: 0.08,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                  ),
                                  child: Image.asset('spimage/img.png')),
                            ))
                      ]
                  );
                }
              }
          )
        )
    ],
    )
    );
  }

  Future<void> showMyDialogue(String title, String id)async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.deepPurple[200],
            content: SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  //user input
                  TextField(
                    style: const TextStyle(color: Colors.deepPurple),
                    cursorColor: Colors.deepPurple[400],
                    controller: _editController,
                    decoration: const InputDecoration(border: OutlineInputBorder(),
                      hintText: "Edit task",
                    ),
                  ),

                  //buttons => save + cancel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      myButton(text: "Save", onPressed: (){
                        databaseRef.child(id).update({
                          'Entry': _editController.text.toString()
                        }).then((value){
                          ToastMsg("Task Added");
                        }).onError((error, stackTrace){
                          ToastMsg(error.toString());
                        });
                        setState(() {
                          todolist.add([_editController.text,false]);
                          _editController.clear();
                        });
                        Navigator.of(context).pop();
                      }),
                      const SizedBox(width: 8,),
                      myButton(text: "Cancel", onPressed: ()=>Navigator.of(context).pop()
                      ),

                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
