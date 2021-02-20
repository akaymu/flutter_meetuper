import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetuper/src/utils/generate_times.dart';
import 'package:flutter_meetuper/src/widgets/select_input.dart';
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
    setState(() => _meetupFormData.timeFrom = time);
  }

  void _handleTimeToChange(String time) {
    setState(() => _meetupFormData.timeTo = time);
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
          _DatePicker(onDateChange: _handleDateChange),
          SelectInput(
            items: _categories,
            onChange: (Category c) => _meetupFormData.category = c,
            icon: const Icon(Icons.color_lens),
            label: 'Category',
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
            times: generateTimes(endTime: _meetupFormData.timeTo),
          ),
          _TimeSelect(
            onTimeChange: _handleTimeToChange,
            label: 'Time To',
            times: generateTimes(startTime: _meetupFormData.timeFrom),
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
  final List<String> times;

  _TimeSelect({
    @required this.onTimeChange,
    this.label,
    this.times,
  });

  @override
  __TimeSelectState createState() => __TimeSelectState();
}

class __TimeSelectState extends State<_TimeSelect> {
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
              items: widget.times.map((String time) {
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
