import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_meetupFormData.toJson());
      print(_meetupFormData.category?.name);
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
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Start Date',
            ),
            onSaved: (value) => _meetupFormData.startDate = value,
          ),
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
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Time From',
            ),
            onSaved: (value) => _meetupFormData.timeFrom = value,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Time To',
            ),
            onSaved: (value) => _meetupFormData.timeTo = value,
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
