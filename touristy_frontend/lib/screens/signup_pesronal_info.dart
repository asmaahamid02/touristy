import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/logo.dart';
import '../widgets/country_list.dart';
import '../widgets/radio_button.dart';

class SignupPersonalInfo extends StatefulWidget {
  const SignupPersonalInfo({super.key});
  static const routeName = '/signup-personal-info';
  @override
  State<SignupPersonalInfo> createState() => SignupPersonalInfoState();
}

class SignupPersonalInfoState extends State<SignupPersonalInfo> {
  final _form = GlobalKey<FormState>();
  Map<String, Object> _user = {};
  CountryCode? countrySelected;
  Gender? _gender;
  DateTime? _dateOfBirth;

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
        _dateOfBirth = pickedDate;
      });
    });
  }

  @override
  void initState() {
    countrySelected = CountryCode(name: 'Egypt', code: 'EG');
    _gender = Gender.male;
    super.initState();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_user);
    print(countrySelected!.name);
  }

  CountryCode _selectedCountry(CountryCode country) {
    setState(() {
      countrySelected = country;
    });
    return countrySelected!;
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final appBar = AppBar();

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LogoHorizontal('assets/images/logo_horizontal.png', 100),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text('Personal Information',
                  style: Theme.of(context).textTheme.headline5),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Nationality',
                      ),
                    ),
                    const SizedBox(height: 10),
                    CountryList(
                        _selectedCountry, countrySelected!.code as String),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            'Gender',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            GenderRadioButton(
                                value: Gender.male,
                                title: Gender.male.name,
                                gender: _gender as Gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            GenderRadioButton(
                                value: Gender.female,
                                title: Gender.female.name,
                                gender: _gender as Gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            GenderRadioButton(
                                value: Gender.other,
                                title: Gender.other.name,
                                gender: _gender as Gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            'Date of Birth',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.cake_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(_dateOfBirth == null
                                    ? 'No Date Chosen!'
                                    : DateFormat.yMMMd()
                                        .format(_dateOfBirth!))),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: Icon(
                                Icons.calendar_month_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: _saveForm,
                child: const Text('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
