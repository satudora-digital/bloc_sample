import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import './showCalendarInputModal.dart';

class CalendarCarouselScreen extends StatefulWidget {
  @override
  _CalendarCarouselState createState() => new _CalendarCarouselState();
}

class _CalendarCarouselState extends State<CalendarCarouselScreen> {
  DateTime _currentDate = DateTime.now();
  String _currentMonth = '';

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2018, 12, 10): [
        new Event(
          date: new DateTime(2018, 12, 10),
          title: 'Event 1',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2018, 12, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2018, 12, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel;

  CalendarEditMode calendarEditMode = CalendarEditMode.day;

  calendarModeChanged(CalendarEditMode mode) {
    setState(() {
      this.calendarEditMode = mode;
    });
  }

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    super.initState();
  }

  CalendarCarousel buildCalendarCarousel() {
    return CalendarCarousel<Event>(
      //todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        switch (this.calendarEditMode) {
          case CalendarEditMode.day:
            showCalendarInputModal(context);
            break;
          case CalendarEditMode.range:
            showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                    children: <Widget>[Text("日付範囲を選択できるようなアクションになる予定です")]));
            break;
          default:
            Error();
        }
        //this.setState(() => _currentDate2 = date);
        //events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 350.0,
      selectedDateTime: _currentDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal: false,
      // null for not showing hidden events indicator
      //showHeader: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.green,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 60)),
      maxSelectedDate: _currentDate.add(Duration(days: 60)),
//      inactiveDateColor: Colors.black12,
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
      locale: "ja",
    );
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarousel = buildCalendarCarousel();

    return new Scaffold(
        appBar: AppBar(),
        body: Column(children: <Widget>[
          Row(children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //custom icon
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: _calendarCarousel,
                    ), // This trailing comma makes auto-formatting nicer for build methods.
                  ],
                ),
              ),
            ),
          ]),
          RaisedButton(
              child: Text("何らかのCycleを追加・編集", style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (this.calendarEditMode == CalendarEditMode.day) {
                  calendarModeChanged(CalendarEditMode.range);
                } else {
                  calendarModeChanged(CalendarEditMode.day);
                }
              }),
          Text(this.calendarEditMode == CalendarEditMode.day
              ? "1日ごとに生理情報入力"
              : "生理周期の範囲を入力")
        ]));
  }
}

enum CalendarEditMode { range, day }
