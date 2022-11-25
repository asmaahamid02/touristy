import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../utilities/utilities.dart';

enum ImageType { profile, cover }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserProfile? _user;
  File? _profileImage;
  File? _coverImage;
  CountryCode? _countrySelected;
  Map<String, dynamic>? _initialValues;
  Map<String, dynamic>? _updatedValues;
  bool _isLoading = false;
  bool _isInit = true;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();

  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _user = Provider.of<UserProfileProvider>(context).userProfile;

      _initialValues = {
        'fisrt_name': _user!.firstName,
        'last_name': _user!.lastName,
        'gender': _user!.gender,
        'date_of_birth': _user!.birthDate,
        'nationality': _user!.nationality,
        'bio': _user!.bio ?? '',
        'profileImageUrl': _user!.profilePictureUrl,
        'coverImageUrl': _user!.coverPictureUrl,
        'country_code': _user!.countryCode,
        'profile_picture': _profileImage,
        'cover_picture': _coverImage,
      };

      //assign the initial values to the updated values without aliasing
      _updatedValues = Map.from(_initialValues!).cast<String, dynamic>();

      _genderController.text = Gender.values
          .firstWhere((element) => element.name == _user!.gender)
          .name;
      _dateOfBirthController.text = _user!.birthDate!;
      _countrySelected =
          CountryCode(name: _user!.nationality, code: _user!.countryCode);

      _isInit = false;
    }
  }

  Future _pickImage(ImageSource source, {ImageType? imageType}) async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(
        source: source,
        maxHeight: 500,
        maxWidth: 500,
      );

      if (pickedImage == null) return;
      File? img = File(pickedImage.path);

      if (imageType == ImageType.profile) {
        setState(() {
          _profileImage = img;
          _updatedValues!['profileImageUrl'] = null;
          _updatedValues!['profile_picture'] = _profileImage;
        });
      } else {
        setState(() {
          _coverImage = img;
          _updatedValues!['coverImageUrl'] = null;
          _updatedValues!['cover_picture'] = _coverImage;
        });
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      Navigator.of(context).pop();
    }
  }

  void _showBottomSheet(ImageType? imageType) async {
    ModalBottomSheetCommon.show(
      context,
      ImageOtionsBottomSheet(
          onTap: (source) => _pickImage(source, imageType: imageType)),
      height: 215,
    );
  }

  CountryCode _selectedCountry(CountryCode country) {
    setState(() {
      _countrySelected = country;
      _updatedValues!['country_code'] = _countrySelected!.code;
      _updatedValues!['nationality'] = _countrySelected!.name;
    });
    return _countrySelected!;
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    // check if there is any change in every field
    final isChanged = _initialValues!.entries
        .any((element) => element.value != _updatedValues![element.key]);

    if (!isChanged) {
      ToastCommon.show('No changes made');
      return;
    }

    //convert profile image to base64
    if (_profileImage != null) {
      final profileImageBase64 =
          FileHandler.convertFileToBase64(_profileImage!);
      _updatedValues!['profile_picture'] = profileImageBase64;
    }

    //convert cover image to base64
    if (_coverImage != null) {
      final coverImageBase64 = FileHandler.convertFileToBase64(_coverImage!);
      _updatedValues!['cover_picture'] = coverImageBase64;
    }

    //get changed values
    final changedValues = _updatedValues!.entries
        .where((element) => element.value != _initialValues![element.key])
        .toList();

    //convert the list of map entries to a map
    final changedValuesMap = Map.fromEntries(changedValues);

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserProfileProvider>(context, listen: false)
          .updateUserProfile(changedValuesMap);
      FocusScope.of(context).unfocus();
      ToastCommon.show('Profile updated successfully');
    } on HttpException catch (error) {
      ToastCommon.show(error.toString());
    } catch (error) {
      debugPrint(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            brightness == Brightness.light ? AppColors.backgroundWhite : null,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: AppColors.backgroundLightGrey,
              height: 1.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileImages(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    FormUtility.buildTextField(
                      label: 'First name',
                      focusNode: _firstNameFocusNode,
                      prefixIcon: const Icon(Icons.person),
                      initialValue: _updatedValues!['fisrt_name'],
                      onFieldSubmitted: (_) => FormUtility.onSubmitField(
                          context: context, focusNode: _lastNameFocusNode),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          FormUtility.validateName(value!, 'first name'),
                      onSaved: (value) => _updatedValues!['fisrt_name'] = value,
                    ),
                    FormUtility.buildTextField(
                      label: 'Last name',
                      focusNode: _lastNameFocusNode,
                      prefixIcon: const Icon(Icons.person),
                      initialValue: _updatedValues!['last_name'],
                      onFieldSubmitted: (_) => FormUtility.onSubmitField(
                          context: context, focusNode: _genderFocusNode),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          FormUtility.validateName(value!, 'last name'),
                      onSaved: (value) => _updatedValues!['last_name'] = value,
                    ),
                    FormUtility.buildTextField(
                      label: 'Gender',
                      prefixIcon: const Icon(Icons.male),
                      readOnly: true,
                      controller: _genderController,
                      onTap: () => ModalBottomSheetCommon.show(
                          context, _buildGenderSheet(context),
                          height: 220),
                      onSaved: (value) =>
                          _updatedValues?['gender'] = _genderController.text,
                    ),
                    FormUtility.buildTextField(
                      label: 'Birth date',
                      prefixIcon: const Icon(Icons.cake_outlined),
                      suffixIcon: const Icon(Icons.calendar_month_outlined),
                      helperText: 'You must be at least 16 years old',
                      readOnly: true,
                      controller: _dateOfBirthController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                      onTap: () => FormUtility.showDatePickerDialog(
                        context: context,
                        initialDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 16)),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 100)),
                        lastDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 16)),
                      ).then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          _dateOfBirthController.text =
                              DateFormat.yMMMd().format(pickedDate);
                        });
                      }),
                      onSaved: (value) => _updatedValues!['date_of_birth'] =
                          DateFormat('MMM d, y')
                              .parse(value!)
                              .toIso8601String(),
                    ),
                    const SizedBox(height: 8.0),
                    CountryList(
                      _selectedCountry,
                      _countrySelected!.code!,
                    ),
                    FormUtility.buildTextField(
                      label: 'Bio',
                      prefixIcon: const Icon(Icons.description),
                      maxLines: 1,
                      initialValue: _updatedValues!['bio'],
                      validator: (value) {
                        if (value!.length > 150) {
                          return 'Bio must be less than 150 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _updatedValues!['bio'] = value ?? '',
                    ),
                    PrimaryButton(
                      textLabel: 'SAVE CHANGES',
                      onTap: _saveForm,
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildGenderSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              Gender.male.name,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              setState(() {
                _genderController.text = Gender.male.name;

                Navigator.of(context).pop();
              });
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              Gender.female.name,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              _genderController.text = Gender.female.name;
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              Gender.other.name,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              _genderController.text = Gender.other.name;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Stack _buildProfileImages() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ProfileCover(
          coverImageUrl:
              _coverImage == null ? _updatedValues!['coverImageUrl'] : null,
          defaultImageProvider: _coverImage != null
              ? FileImage(_coverImage!) as ImageProvider
              : null,
          onTap: () => _showBottomSheet(ImageType.cover),
        ),
        ProfileAvatar(
          imaegUrl: _updatedValues!['profileImageUrl'],
          defaultImageProvider: _profileImage != null
              ? FileImage(_profileImage!) as ImageProvider
              : null,
          onTap: () => _showBottomSheet(ImageType.profile),
        ),
      ],
    );
  }
}
