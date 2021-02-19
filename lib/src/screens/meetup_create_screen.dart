import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/forms.dart';
import '../services/meetup_api_service.dart';

class MeetupCreateScreen extends StatefulWidget {
  static const String route = '/meetupCreate';

  @override
  _MeetupCreateScreenState createState() => _MeetupCreateScreenState();
}

class _MeetupCreateScreenState extends State<MeetupCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _scaffoldContext;

  MeetupFormData _meetupFormData = MeetupFormData();
  MeetupApiService _api = MeetupApiService();
  List<Category> _categories = [];

  @override
  void initState() {
    _api
        .fetchCategories()
        // .then((catList) => catList.forEach((c) => print(c.name)));
        .then((catList) => setState(() => _categories = catList));
    super.initState();
  }

  void _handleDateChange(DateTime selectedDate) {
    _meetupFormData.startDate = selectedDate;
  }

  void _handleTimeFromChange(String time) {
    _meetupFormData.timeFrom = time;
  }

  void _handleTimeToChange(String time) {
    _meetupFormData.timeTo = time;
  }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_meetupFormData.toJson());
      print(_meetupFormData.startDate);
    }
  }

  void handleSuccessfulCreate(dynamic data) async {
    // await Navigator.pushNamed(
    //   context,
    //   LoginScreen.route,
    //   arguments: LoginScreenArguments('You have been successfully logged in!'),
    // );
  }

  void handleError(String message) {
    Scaffold.of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Meetup')),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: _buildForm(),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTitle(),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Location',
            ),
            onSaved: (value) => _meetupFormData.location = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Title',
            ),
            onSaved: (value) => _meetupFormData.title = value,
          ),
          // TextFormField(
          //   style: Theme.of(context).textTheme.headline6,
          //   inputFormatters: [LengthLimitingTextInputFormatter(30)],
          //   decoration: InputDecoration(
          //     hintText: 'Start Date',
          //   ),
          //   onSaved: (value) => _meetupFormData.startDate = value,
          // ),
          _DatePicker(onDateChange: _handleDateChange),
          // TextFormField(
          //   style: Theme.of(context).textTheme.headline6,
          //   inputFormatters: [LengthLimitingTextInputFormatter(30)],
          //   decoration: InputDecoration(
          //     hintText: 'Category',
          //   ),
          //   onSaved: (value) => _meetupFormData.category = null,
          // ),
          _CategorySelect(
            categories: _categories,
            meetupFormData: _meetupFormData,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Image',
            ),
            onSaved: (value) => _meetupFormData.image = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            decoration: InputDecoration(
              hintText: 'Short Info',
            ),
            onSaved: (value) => _meetupFormData.shortInfo = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            onSaved: (value) => _meetupFormData.description = value,
          ),
          // TextFormField(
          //   style: Theme.of(context).textTheme.headline6,
          //   inputFormatters: [LengthLimitingTextInputFormatter(30)],
          //   decoration: InputDecoration(
          //     hintText: 'Time From',
          //   ),
          //   onSaved: (value) => _meetupFormData.timeFrom = value,
          // ),
          // TextFormField(
          //   style: Theme.of(context).textTheme.headline6,
          //   inputFormatters: [LengthLimitingTextInputFormatter(30)],
          //   decoration: InputDecoration(
          //     hintText: 'Time To',
          //   ),
          //   onSaved: (value) => _meetupFormData.timeTo = value,
          // ),
          _TimeSelect(
            onTimeChange: _handleTimeFromChange,
            label: 'Time From',
          ),
          _TimeSelect(
            onTimeChange: _handleTimeToChange,
            label: 'Time To',
          ),
          _buildSubmitBtn(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Create Awesome Meetup',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      alignment: Alignment(-1.0, 0.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: const Text('Submit'),
        onPressed: _submitCreate,
      ),
    );
  }
}

// This is for dropdown select input....
class _CategorySelect extends StatelessWidget {
  final List<Category> categories;
  final MeetupFormData meetupFormData;

  _CategorySelect({@required this.categories, @required this.meetupFormData});

  @override
  Widget build(BuildContext context) {
    return FormField<Category>(
      builder: (FormFieldState<Category> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.color_lens),
            labelText: 'Category',
          ),
          isEmpty: meetupFormData.category == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: meetupFormData.category,
              isDense: true,
              onChanged: (Category newCategory) {
                meetupFormData.category = newCategory;
                state.didChange(newCategory);
              },
              items: categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _DatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;
  _DatePicker({@required this.onDateChange});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  DateTime _dateNow = DateTime.now();
  DateTime _initialDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: _dateNow,
      lastDate: DateTime(_dateNow.year + 1, _dateNow.month, _dateNow.day),
    );

    if (picked != null && picked != _initialDate) {
      widget.onDateChange(picked);
      setState(() {
        _dateController.text = _dateFormat.format(picked);
        _initialDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            enabled: false,
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter date when meetup starts',
              labelText: 'Dob',
            ),
            keyboardType: TextInputType.datetime,
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_horiz),
          tooltip: 'Choose Date',
          onPressed: (() => _selectDate(context)),
        ),
      ],
    );
  }
}

class _TimeSelect extends StatefulWidget {
  final Function(String) onTimeChange;
  final String label;
  _TimeSelect({@required this.onTimeChange, this.label});

  @override
  __TimeSelectState createState() => __TimeSelectState();
}

class __TimeSelectState extends State<_TimeSelect> {
  final List<String> _times = [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  String _selectedTime;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.timer),
            labelText: widget.label ?? 'Time',
          ),
          isEmpty: _selectedTime == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTime,
              isDense: true,
              onChanged: (String newTime) {
                widget.onTimeChange(newTime);
                _selectedTime = newTime;
                state.didChange(newTime);
              },
              items: _times.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
