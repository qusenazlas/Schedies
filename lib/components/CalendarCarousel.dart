import 'package:schedule_app/model/DateProvider.dart';
import 'package:schedule_app/screens/addEvent.dart';
import 'package:schedule_app/services/AppLanguage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class CalendarCarousel extends StatefulWidget {
  @override
  _CalendarCarouselState createState() => _CalendarCarouselState();
  final String _uid;
  bool isMe;

  String name;
  QuerySnapshot document;
  CalendarCarousel(this._uid, {this.isMe = true, this.document, this.name});
}

class _CalendarCarouselState extends State<CalendarCarousel> {
  CalendarController _calendarController;
  Map<String, dynamic> myevents = {};
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.document.documents.forEach((doc) {
      if ((doc.data['sender'] == (widget._uid) ||
              doc.data['receiver'] == (widget._uid) ||
              doc.data['moreInvite'].contains(widget.name)) &&
          (doc.data['eventMemberList'][widget.name] == 'Pending' ||
              doc.data['eventMemberList'][widget.name] == 'Approved') &&
          (doc.data['eventStatus'] == 'Pending' ||
              doc.data['eventStatus'] == 'Approved')) {
        myevents.putIfAbsent(doc.data['date'], () => 1);
      }
    });
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    var appLanguage = Provider.of<AppLanguage>(context);
    String shrink = appLanguage.appLocal.languageCode == 'en' ? 'Shirnk' : 'หด';
    String expand =
        appLanguage.appLocal.languageCode == 'en' ? 'Expand' : 'ขยาย';
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(134, 227, 206, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            child:
                // Incase other's calendar
                !widget.isMe
                    ? TableCalendar(
                        locale: appLanguage.appLocal.languageCode == 'en'
                            ? 'en_US'
                            : 'th_TH',
                        calendarController: _calendarController,
                        onDaySelected: (date, events) {
                          dateProvider.getDate(date.toIso8601String());
                        }, // send date to events lister
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        initialCalendarFormat: CalendarFormat.week,
                        headerStyle: HeaderStyle(
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20,
                          ),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mitr',
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mitr',
                          ),
                          formatButtonDecoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Color.fromRGBO(252, 254, 255, 1),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        availableCalendarFormats: {
                          CalendarFormat.week: shrink,
                          CalendarFormat.month: expand,
                        },
                        builders: CalendarBuilders(
                          dayBuilder: (context, date, events) =>
                              GestureDetector(
                            onLongPress: () {
                              if (date.isAfter(DateTime.now())) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEventScreen(
                                          date: date, uid: widget._uid)),
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                    fontFamily: 'Mitr',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 221, 148, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          selectedDayBuilder: (context, date, events) =>
                              GestureDetector(
                            onLongPress: () {
                              if (date.isAfter(DateTime.now())) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEventScreen(
                                          date: date, uid: widget._uid)),
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                    fontFamily: 'Mitr',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(250, 137, 123, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          todayDayBuilder: (context, date, events) =>
                              GestureDetector(
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEventScreen(
                                        date: date, uid: widget._uid)),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                    fontFamily: 'Mitr',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(208, 230, 165, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          dowWeekdayBuilder: (context, weekday) => Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: Text(
                              weekday.toString(),
                              style: TextStyle(
                                  fontFamily: 'Mitr',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    //Incase own calendar
                    : TableCalendar(
                        locale: appLanguage.appLocal.languageCode == 'en'
                            ? 'en_US'
                            : 'th_TH',
                        calendarController: _calendarController,
                        onDaySelected: (date, events) {
                          dateProvider.getDate(date.toIso8601String());
                        }, // send date to events lister
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        initialCalendarFormat: CalendarFormat.week,
                        headerStyle: HeaderStyle(
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20,
                          ),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mitr',
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mitr',
                          ),
                          formatButtonDecoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Color.fromRGBO(252, 254, 255, 1),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        availableCalendarFormats: {
                          CalendarFormat.week: shrink,
                          CalendarFormat.month: expand,
                        },
                        builders: CalendarBuilders(
                          dayBuilder: (context, date, events) =>
                              GestureDetector(
                            child: myevents[date.toIso8601String()] == 1
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Badge(
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 221, 148, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 221, 148, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                          selectedDayBuilder: (context, date, events) =>
                              GestureDetector(
                            child: myevents[date.toIso8601String()] == 1
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Badge(
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(250, 137, 123, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(250, 137, 123, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                          todayDayBuilder: (context, date, events) =>
                              GestureDetector(
                            child: myevents[date.toIso8601String()] == 1
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Badge(
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(208, 230, 165, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(208, 230, 165, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                          dowWeekdayBuilder: (context, weekday) => Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: Text(
                              weekday.toString(),
                              style: TextStyle(
                                  fontFamily: 'Mitr',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
