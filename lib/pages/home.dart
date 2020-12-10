import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/colors.dart';
import 'package:uaaccesos/classes/login_state.dart';
import 'package:uaaccesos/classes/navbar.dart';
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
  final FilterController _filterController = FilterController();

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _lastSelected = 0;
  int _doorSelected;

  TextEditingController _careerValue = TextEditingController();
  TextEditingController _idValue = TextEditingController();

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  String _doorLabel(int index) {
    switch (index) {
      case 0:
        return "Norte";
      case 1:
        return "Sur";
      case 2:
        return "Este";
      case 3:
        return "Principal";
      default:
        return "";
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: ColorPalette.primary,
        actions: <Widget>[
          _lastSelected == 1
              ? Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => _key.currentState.openEndDrawer(),
                    child: Icon(
                      Icons.filter_list_rounded,
                      size: 26.0,
                    ),
                  ),
                )
              : Container(),
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
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 80.0,
              child: DrawerHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Filters', style: TextStyle(fontSize: 18.0)),
                    FlatButton(
                      child: Text('APPLY'),
                      onPressed: () {
                        _filterController.method(_doorLabel(_doorSelected), _idValue.text, _careerValue.text);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: ColorPalette.primary,
                ),
                margin: EdgeInsets.all(0.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DOOR",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: List<Widget>.generate(
                      4,
                      (int index) {
                        return ChoiceChip(
                          label: Text(_doorLabel(index)),
                          selected: _doorSelected == index,
                          selectedColor: Colors.white,
                          elevation: 5,
                          onSelected: (bool selected) {
                            setState(() {
                              _doorSelected = index;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
            _adminFilters(),
            FlatButton(
              child: Text('RESET ALL'),
              textColor: ColorPalette.secondary,
              onPressed: () {
                _filterController.method("", "", "");
                Navigator.of(context).pop();

                setState(() {
                  _doorSelected = null;
                  _idValue.clear();
                  _careerValue.clear();
                });
              },
            )
          ],
        ),
      ),
      body: IndexedStack(
        index: _lastSelected,
        children: [
          QrCodePage(controller: _codeController),
          RecordPage(controller: _filterController),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        color: Colors.grey[600],
        selectedColor: Colors.white,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          NavBarItem(iconData: Icons.home_outlined, text: 'Home'),
          NavBarItem(iconData: Icons.list_outlined, text: 'Record'),
        ],
      ),
      floatingActionButton: _lastSelected == 0
          ? FloatingActionButton(
              backgroundColor: ColorPalette.primary,
              onPressed: () => _codeController.method(),
              child: Icon(
                Provider.of<LoginState>(context).userProp('admin') ? Icons.qr_code_scanner_rounded : Icons.sync_outlined,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _adminFilters() {
    return (Provider.of<LoginState>(context).userProp('admin'))
        ? Column(
            children: [
              _filterInput(_idValue, TextInputType.number, "ID", Icons.account_box_outlined),
              SizedBox(height: 20),
              _filterInput(_careerValue, TextInputType.text, "Career", Icons.book_outlined),
              SizedBox(height: 40)
            ],
          )
        : SizedBox(height: 20);
  }

  Widget _filterInput(TextEditingController controller, TextInputType type, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        suffixIcon: Icon(
          icon,
          color: Colors.blueGrey,
        ),
        border: InputBorder.none,
        filled: true,
      ),
    );
  }
}
