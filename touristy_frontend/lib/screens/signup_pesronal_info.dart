import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
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
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Nationality',
                      ),
                    ),
                    SizedBox(height: 10),
                    CountryList(
                        _selectedCountry, countrySelected!.code as String),
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Gender',
                          ),
                        ),
                        SizedBox(height: 20),
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
                            SizedBox(
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
                            SizedBox(
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
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Date of Birth',
                          ),
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
