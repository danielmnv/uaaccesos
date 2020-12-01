import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';
import 'package:uaaccesos/classes/navbar.dart';
import 'package:uaaccesos/classes/tab_page.dart';
import 'package:uaaccesos/pages/account.dart';
import 'package:uaaccesos/pages/qrcode.dart';
import 'package:uaaccesos/pages/record.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CodeController _codeController = CodeController();

  int _lastSelected = 0;

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AccountPage(
                      title: 'Account',
                    ),
                  ),
                );
              },
              child: Icon(Icons.account_circle_outlined, size: 26.0),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _lastSelected,
        children: [
          QrCodePage(
            controller: _codeController,
          ),
          RecordPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        color: Colors.grey,
        selectedColor: Colors.indigo,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          NavBarItem(iconData: Icons.home_outlined, text: 'Home'),
          NavBarItem(iconData: Icons.list_outlined, text: 'Record'),
        ],
      ),
      floatingActionButton: _lastSelected == 0
          ? FloatingActionButton(
              onPressed: () => setState(() => _codeController.method()),
              child: Icon(Provider.of<LoginState>(context).userProp('admin') ? Icons.qr_code_scanner_rounded : Icons.sync_outlined),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
