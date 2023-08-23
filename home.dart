

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController _task=TextEditingController();
  TextEditingController _editT=TextEditingController();
  TextEditingController _editD=TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _title=TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;
  void onSend() async {
    if (_task.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "title": _title.text,
        "task":_task.text,
        "done":false,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _task.clear();
      _title.clear();
      await _firestore
          .collection('task')
          .doc(_auth.currentUser!.email).collection("todo").add(messages);
    } else {
      print("Enter Some Text");
    }
  }
 void onedit(String id)async{
  final DocumentReference docRef =_firestore.collection('task').doc(_auth.currentUser!.email).collection('todo').doc(id);
                  await docRef.update({
                    'title':_editT.text,
                    'task':_editD.text
                  });
 }
  
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicep = MediaQuery.of(context).padding;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(backgroundColor: Color.fromARGB(255, 30, 68, 166), onPressed: ( ){ _showAddTaskDialog(context);},child: Icon(Icons.add),),
      body: SingleChildScrollView(
        child: Container(margin: EdgeInsets.only(top: devicep.top,left: screenSize.width*2/100), 
        child: Column(
          children: [
            SizedBox(height: screenSize.height*6.5/100-devicep.top,),
            
            Container(alignment: Alignment.topLeft, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("DoIt",style: TextStyle(fontSize: screenSize.height*3.5/100),),
                InkWell(
                  onTap: (){
                    _auth.signOut();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Text("Logout  ")
                    ],
                  ),
                )
              ],
            )),
            Container(
              height: screenSize.height*85/100,
              child:StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('task')
                      .doc(_auth.currentUser!.email)
                      .collection('todo')
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                              String id=snapshot.data!.docs[index].id;
                              if (map['time'] == null) {
                                  return Center(child: CircularProgressIndicator());
                              }
                        return Dismissible(
                             key: Key(id), // Use Firestore document ID as the key
                             background: Container(
                             width: screenSize.width*80,
                             color: Colors.red,
                             alignment: Alignment.centerLeft,
                             child: Icon(
                                Icons.delete,
                                color: Colors.white,
                            ),
                         ),
                         secondaryBackground: Container(
                             width: screenSize.width*80,
                           color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Icon(
                                Icons.delete,
                                color: Colors.white,
                            ),
                         ),
                         onDismissed: (direction) {
                           FirebaseFirestore.instance.collection("task").doc(_auth.currentUser!.email).collection("todo").doc(id).delete()
                          .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                             content: Text('Item deleted'),
                          ),
                         );
                        }).catchError((error) {
                           ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content: Text('Error deleting item: $error'),
                          ),
                        );
                        });
                        },
                            child: task(screenSize, map, context,id));
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
            ),)
          ],
        ),
        ),
      ),
    );
  }
  Widget task(Size size,Map<String,dynamic> map,BuildContext context,String id){
    
    Timestamp ti=map["time"];
    
    DateTime time=ti.toDate();
    DateTime date2 = DateTime.now();
    Duration difference = date2.difference(time);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    return Padding(
      padding: EdgeInsets.only(left:size.height*1.5/100,right: size.height*1.5/100,top: size.height*1/100),
      child: InkWell(
        onTap: (){
          _editT.text=map["title"];
          _editD.text=map["task"];
          _editTaskDialog(context, id);
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.height*5/100),border: Border.all(color: Colors.black26)),
          height:size.height*12/100,
          child: Container(
            margin: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: size.width*10/100, child: CircleAvatar(backgroundImage: AssetImage("assets/task.png"),)),
                Container(
                  width: size.width*45/100,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    (map['title'].length<10)?Text(map['title'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: size.height*2.5/100),):
                    Text("${map['title'].toString().substring(0,10)}....",style: TextStyle(fontWeight: FontWeight.w600,fontSize: size.height*2.5/100),)
                    ,(map['task'].length<15)?Text(map['task'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: size.height*2/100),):
                    Text("${map['task'].toString().substring(0,15)}....",style: TextStyle(fontWeight: FontWeight.w500,fontSize: size.height*2/100),),
                    Text("Created : ${minutes} min ${seconds} seconds ago",style: TextStyle(fontSize: size.height*1.25/100),)
                  ],),
                ),
                InkWell(
                  onTap: ()async{
                    final DocumentReference docRef =_firestore.collection('task').doc(_auth.currentUser!.email).collection('todo').doc(id);
                    await docRef.update({
                      'done':!map['done']
                    });
                  },
                  child: Container(width: size.width*30/100,height: size.height*12/100, child: (map['done'])?UnDone( size):Done(size)))
              ],
            ),
          )
        ),
      ),
    );
  }
  void _showAddTaskDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _title,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Task'),
                controller: _task,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                onSend();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget Done(Size size){
    return Container(
      width: size.width*30/100,
      height: size.height*12/100-2,
      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.only(topRight: Radius.circular(size.height*5/100),bottomRight: Radius.circular(size.height*5/100))),
      child: Center(child: Text("Mark as Done",style: TextStyle(color: Colors.white),)),
    );

  }
   Widget UnDone(Size size){
    return Container(
      width: size.width*30/100,
      height: size.height*12/100-2,
      decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.only(topRight: Radius.circular(size.height*5/100),bottomRight: Radius.circular(size.height*5/100))),
      child: Center(child: Text("Mark as UnDone",style: TextStyle(color: Colors.white),)),
    );

  }
  void _editTaskDialog(BuildContext context,String id) {
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            child: AlertDialog(
              title: Text('Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _editT,
                  ),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Task'),
                    controller: _editD,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    onedit(id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}