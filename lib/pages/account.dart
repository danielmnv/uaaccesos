import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/colors.dart';
import 'package:uaaccesos/classes/login_state.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.primary,
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
      ),
      body: _account(Provider.of<LoginState>(context).userData()),
    );
  }

  Widget _account(Map<String, dynamic> data) {
    return Center(
      child: ListView(
        children: [
          SizedBox(height: 10),
          ListTile(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 48,
                height: 48,
                padding: EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: CircleAvatar(
                  child: Icon(Icons.person_sharp, color: Colors.white),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            title: Text(data['email']),
            dense: true,
          ),
          _itemUserProp(data['admin'] ? "DOOR" : "CAREER", data['admin'] ? data['door'] : data['career']),
          Divider(),
          _itemUserProp("USERNAME", data['username']),
          _itemUserProp("NAME", data['name']),
          _itemUserProp("LAST NAME", data['ap_pat']),
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
                  color: ColorPalette.secondary,
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

  Widget _itemUserProp(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          height: 1.6,
        ),
      ),
      dense: false,
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
              Navigator.of(context).pop(); // FIXME: Find another way to do this
            },
          ),
        ],
      ),
    );
  }
}
