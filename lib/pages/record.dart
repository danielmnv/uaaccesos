import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uaaccesos/classes/colors.dart';

class RecordPage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => RecordPage());

  RecordPage({Key key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  CollectionReference _logs = FirebaseFirestore.instance.collection('logs');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _logs.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                  List<Map<String, dynamic>> registers = docs
                      .map(
                        (doc) => {
                          'door': doc['door'],
                          'date': DateFormat.yMMMd().add_Hm().format(doc['date'].toDate()),
                          'id': doc['email'].split("@")[0],
                          'initials': doc['user']['name'][0] + doc['user']['ap_pat'][0],
                        },
                      )
                      .toList();

                  return ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) => _register(registers.elementAt(index)),
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.blueAccent.withOpacity(0.15),
                        height: 3.0,
                      );
                    },
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _register(Map<String, dynamic> register) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          register['initials'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorPalette.secondary,
      ),
      title: Text(
        register['id'],
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text(
        register['date'],
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(color: ColorPalette.accent.withOpacity(0.3), borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                    child: Icon(
                  Icons.sensor_door_sharp,
                  size: 18,
                  color: Colors.blueGrey[600],
                )),
                TextSpan(text: register['door'], style: TextStyle(color: Colors.blueGrey[600], fontWeight: FontWeight.w500, fontSize: 16.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
