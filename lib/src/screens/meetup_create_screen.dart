import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/forms.dart';
import '../services/meetup_api_service.dart';
import '../utils/generate_times.dart';
import '../widgets/select_input.dart';
import 'meetup_detail_screen.dart';
import 'meetup_home_screen.dart';

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
        .then((catList) => setState(() => _categories = catList));
    super.initState();
  }

  void _handleDateChange(DateTime selectedDate) {
    _meetupFormData.startDate = selectedDate;
  }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _api.createMeetup(_meetupFormData).then((String meetupId) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MeetupDetailScreen.route,
          // (Route<dynamic> route) => false,
          ModalRoute.withName('/'),
          arguments: MeetupDetailArguments(id: meetupId),
        );
      }).catchError((e) => print(e));
    }
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
          _DatePicker(onDateChange: _handleDateChange),
          SelectInput(
            items: _categories,
            onChange: (Category c) => _meetupFormData.category = c,
            icon: const Icon(Icons.color_lens),
            label: 'Category',
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(300)],
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
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => _meetupFormData.description = value,
          ),
          SelectInput(
            onChange: (String time) =>
                setState(() => _meetupFormData.timeFrom = time),
            label: 'Time From',
            items: generateTimes(endTime: _meetupFormData.timeTo),
            icon: const Icon(Icons.timer),
          ),
          SelectInput(
            onChange: (String time) =>
                setState(() => _meetupFormData.timeTo = time),
            label: 'Time To',
            items: generateTimes(startTime: _meetupFormData.timeFrom),
            icon: const Icon(Icons.timer),
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
