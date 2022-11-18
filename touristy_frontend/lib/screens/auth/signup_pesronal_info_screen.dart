import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/widgets.dart';

import '../screens.dart';

class SignupPersonalInfoScreen extends StatefulWidget {
  const SignupPersonalInfoScreen({super.key});
  static const routeName = '/signup-personal-info';
  @override
  State<SignupPersonalInfoScreen> createState() =>
      SignupPersonalInfoScreenState();
}

class SignupPersonalInfoScreenState extends State<SignupPersonalInfoScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, Object> _user = {};
  CountryCode? countrySelected;
  Gender? _gender;
  TextEditingController dateInputController = TextEditingController();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dateInputController.text = DateFormat.yMMMd().format(pickedDate);
      });
    });
  }

  @override
  void initState() {
    countrySelected = CountryCode(name: 'Egypt', code: 'EG');
    _gender = Gender.male;
    dateInputController.text = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    _user['nationality'] = countrySelected!.name as String;
    _user['country_code'] = countrySelected!.code as String;
    _user['gender'] = _gender!.name;
    _user['date_of_birth'] = dateInputController.text;

    Navigator.of(context)
        .pushNamed(SignupProfileScreen.routeName, arguments: _user);
  }

  CountryCode _selectedCountry(CountryCode country) {
    setState(() {
      countrySelected = country;
    });
    return countrySelected!;
  }

  void _onChangeGender(Gender? gender) {
    setState(() {
      _gender = gender;
    });
  }

  void _onSavedDateOfBirth(String? value) {
    setState(() {
      _user['date_of birth'] = value as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final appBar = AppBar();

    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.light ? Theme.of(context).cardColor : null,
      appBar: appBar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LogoHorizontal(
                      brightness == Brightness.light
                          ? 'assets/images/logo_horizontal.png'
                          : 'assets/images/login_dark.png',
                      100),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text('Personal Information',
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          _buildTextFieldLabel('Nationality'),
                          const SizedBox(height: 10),
                          CountryList(_selectedCountry,
                              countrySelected!.code as String),
                          const SizedBox(height: 30),
                          Column(
                            children: [
                              _buildTextFieldLabel('Gender'),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  GenderRadioButton(
                                      value: Gender.male,
                                      gender: _gender as Gender,
                                      onChanged: (value) =>
                                          _onChangeGender(value)),
                                  const SizedBox(width: 8.0),
                                  GenderRadioButton(
                                      value: Gender.female,
                                      gender: _gender as Gender,
                                      onChanged: (value) =>
                                          _onChangeGender(value)),
                                  const SizedBox(width: 8.0),
                                  GenderRadioButton(
                                      value: Gender.other,
                                      gender: _gender as Gender,
                                      onChanged: (value) =>
                                          _onChangeGender(value)),
                                ],
                              ),
                              const SizedBox(height: 30),
                              _buildTextFieldLabel('Date of Birth'),
                              const SizedBox(height: 10),
                              _buildDateTextField(
                                'Date of Birth',
                                dateInputController,
                                _onSavedDateOfBirth,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PrimaryButton(
            onTap: _saveForm,
            textLabel: 'NEXT',
          )
        ],
      ),
    );
  }

  Widget _buildDateTextField(
      String labelText, TextEditingController controller, Function onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
        prefixIcon: const Icon(Icons.cake_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: _presentDatePicker,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select your date of birth';
        }
        return null;
      },
      onTap: _presentDatePicker,
      readOnly: true,
      controller: controller,
      onSaved: (newValue) => onSaved(newValue),
    );
  }

  Widget _buildTextFieldLabel(String labelText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        labelText,
      ),
    );
  }
}
