import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/colors.dart';
import 'package:uaaccesos/classes/login_state.dart';

class FilterController {
  void Function(String a, String b, String c) method;
}

class RecordPage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => RecordPage());

  RecordPage({Key key, this.controller}) : super(key: key);

  final FilterController controller;

  @override
  _RecordPageState createState() => _RecordPageState(controller);
}

class _RecordPageState extends State<RecordPage> with AfterInitMixin {
  FilterController _controller;

  CollectionReference _logs = FirebaseFirestore.instance.collection('logs');
  Stream<QuerySnapshot> _stream;
  Query _query;

  Map<String, dynamic> _userType;
  DateTime _pickerDate;

  DateTime _selectedDate;
  String _selectedDoor;
  String _careerTexted;
  String _idTexted;

  int _chipSelected = 0;

  _RecordPageState(FilterController controller) {
    _controller = controller;
    _controller.method = _addFilters;
  }

  void _addFilters(String door, String id, String career) {
    setState(() {
      _careerTexted = career;
      _selectedDoor = door;
      _idTexted = id;

      _dateQuery(_selectedDate);
      _getSnapshots();
    });
  }

  void _allDates(int index) {
    setState(() {
      _chipSelected = index;

      _dateQuery(null);
      _getSnapshots();
    });
  }

  void _todayDate(int index) {
    DateTime now = DateTime.now();

    setState(() {
      _chipSelected = index;

      _dateQuery(DateTime(now.year, now.month, now.day));
      _getSnapshots();
    });
  }

  void _selectDate(BuildContext context, int index) async {
    DateTime today = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _pickerDate != null ? _pickerDate : today, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year, today.month, today.day),
      confirmText: 'LIST',
    );
    if (picked != null)
      setState(() {
        _chipSelected = index;
        _pickerDate = picked;

        _dateQuery(picked);
        _getSnapshots();
      });
  }

  void _dateQuery(DateTime start) {
    _selectedDate = start;

    _query = (start != null)
        ? _logs
            .where("date", isGreaterThanOrEqualTo: start)
            .where("date", isLessThan: DateTime(start.year, start.month, start.day + 1))
            .orderBy("date", descending: true)
        : _logs.orderBy("date", descending: true);

    if (!_userType['isAdmin']) _query = _query.where("user.email", isEqualTo: _userType['email']);
  }

  void _getSnapshots() {
    if (_selectedDoor?.isNotEmpty ?? false) _query = _query.where("door", isEqualTo: _selectedDoor);

    if (_userType['isAdmin']) {
      if (_idTexted?.isNotEmpty ?? false) _query = _query.where("user.email", isEqualTo: ("al" + _idTexted + "@edu.uaa.mx"));
      if (_careerTexted?.isNotEmpty ?? false) _query = _query.where("user.career", isEqualTo: _careerTexted);
    }

    _stream = _query.snapshots();
  }

  @override
  void didInitState() {
    bool isAdmin = Provider.of<LoginState>(context).userProp('admin');
    _userType = {"isAdmin": isAdmin, "email": (!isAdmin) ? Provider.of<LoginState>(context).userProp("email") : ''};

    _dateQuery(null);
    _getSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _chipFilters(),
          _logsList(),
        ],
      ),
    );
  }

  Widget _chipFilters() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 15,
        ),
        _chipBuilder("All", 0, (bool selected) => _allDates(0)),
        SizedBox(
          width: 15,
        ),
        _chipBuilder("Today", 1, (bool selected) => _todayDate(1), Icons.calendar_today_rounded),
        SizedBox(
          width: 15,
        ),
        _chipBuilder(
          _pickerDate == null ? 'Custom' : DateFormat.yMd().format(_pickerDate),
          2,
          (bool selected) => _selectDate(context, 2),
          Icons.date_range_rounded,
        ),
      ],
    );
  }

  Widget _chipBuilder(String label, int index, Function callable, [IconData icon]) {
    return ChoiceChip(
      label: Text(label),
      elevation: 5,
      selected: _chipSelected == index,
      onSelected: callable,
      selectedColor: Colors.white,
      avatar: icon != null
          ? InkWell(
              child: Icon(
                icon,
                size: 18,
                color: _chipSelected == index ? Colors.blueGrey : Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _logsList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> docs = snapshot.data.docs;
            List<Map<String, dynamic>> registers = docs
                .map(
                  (doc) => {
                    'door': doc['door'],
                    'date': DateFormat.yMMMd().add_Hm().format(doc['date'].toDate()),
                    'id': doc['user']['email'].split("@")[0],
                    'initials': doc['user']['name'][0] + doc['user']['ap_pat'][0],
                  },
                )
                .toList();

            return (docs.length > 0)
                ? ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) => _register(registers.elementAt(index)),
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.blueAccent.withOpacity(0.15),
                        height: 3.0,
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nodata.png',
                          height: 200,
                          color: ColorPalette.secondary,
                        ),
                        SizedBox(height: 35),
                        Text(
                          'Nothing to show!',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  );
          }

          return CircularProgressIndicator();
        },
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
          color: Colors.white54,
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
                  color: Colors.white70,
                )),
                TextSpan(text: register['door'], style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 16.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
