import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JoyChat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text(('Log Out'))
                    ],
                  ),
                ),
                value: 'LogOut',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'LogOut') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              //3 dots
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/2biMeARHqi3i239ke6a9/messages')
            .snapshots(),
        builder: (ctx, streamSnapShot) {
          final documents = streamSnapShot.data?.documents;
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
            itemCount: documents.length,
          );
          //snapshots returns a stream
          //stream gives a new value when data changes
          //this function is reexecuted whenever the stream gives a new value
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //     .listen((data) {
          //   data.documents.forEach((element) {
          //     print(element['text']);
          //   });
          // });
          //snapshots returns a stream
          //stream emits a new value when data source changes
          Firestore.instance
              .collection('chats/2biMeARHqi3i239ke6a9/messages')
              .add({
            'text': 'this was added',
          });
        },
      ),
    );
  }
}
