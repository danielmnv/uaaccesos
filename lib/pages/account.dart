import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
      ),
      body: Center(
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
              title: Text('email@domain.com'),
              dense: true,
            ),
            Divider(),
            ListTile(
              title: Text('nickname'),
              dense: false,
            ),
            ListTile(
              title: Text('Name'),
              dense: false,
            ),
            ListTile(
              title: Text('Last Name'),
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
      ),
    );
  }
}
