import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with AfterInitMixin<AccountPage> {
  Stream<DocumentSnapshot> _query;

  @override
  void didInitState() {
    _query = FirebaseFirestore.instance.collection('users').doc(Provider.of<LoginState>(context).currentUser().uid).get().asStream();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _query,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return _account(snapshot.data.data());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _account(Map<String, dynamic> data) {
    return Center(
      child: ListView(
        children: [
          ListTile(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 48,
                height: 48,
                padding: EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://icons.iconarchive.com/icons/diversity-avatars/avatars/1024/batman-icon.png'),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            title: Text(data['email']),
            dense: true,
          ),
          Divider(),
          ListTile(
            title: Text(data['username']),
            dense: false,
          ),
          ListTile(
            title: Text(data['name']),
            dense: false,
          ),
          ListTile(
            title: Text(data['ap_pat']),
            dense: false,
          ),
          Divider(),
          ListTile(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 48,
                height: 48,
                padding: EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: Icon(
                  Icons.logout,
                  color: Colors.red[900],
                ),
              ),
            ),
            onTap: () {
              _logOutDialog();
            },
            title: Text('Log out'),
            dense: false,
          ),
        ],
      ),
    );
  }

  _logOutDialog() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Log out"),
        content: new Text("Are you sure?"),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<LoginState>(context, listen: false).logOut();
              Navigator.of(context).pop(); // FIXME: Found another way to do this
            },
          ),
        ],
      ),
    );
  }
}
