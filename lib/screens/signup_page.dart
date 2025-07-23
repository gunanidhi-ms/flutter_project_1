import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/screens/utils.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_project_1/screens/services/password_service.dart';
import 'package:flutter_project_1/screens/services/location_service.dart';
import 'package:flutter_project_1/user_model.dart';
import 'package:flutter_project_1/db_helper.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _firstnameController = TextEditingController();
  final _middlenameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _houseController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Map<String, GlobalKey> _fieldKeys = {
    'firstname': GlobalKey(),
    'middlename': GlobalKey(),
    'lastname': GlobalKey(),
    'email': GlobalKey(),
    'mobile': GlobalKey(),
    'password': GlobalKey(),
    'confirm_password': GlobalKey(),
    'house': GlobalKey(),
    'pincode': GlobalKey(),
    'country': GlobalKey(),
    'state': GlobalKey(),
    'city': GlobalKey(),
    'dial_code': GlobalKey(),
  };

  List<Map<String, String>> _dialCodesList = [];
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  String? selectedDial;
  String? selectedDialCountry;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? _emailError;
  String? _mobileError;

  bool isLoadingCountries = true;
  bool isLoadingStates = false;
  bool isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    loadCountries();
    loadDialCodes();
  }

  Future<void> loadDialCodes() async {
    final list = await LocationService.getAllDialCodes();
    setState(() {
      _dialCodesList = list;
    });
  }

  Future<void> loadCountries() async {
    final result = await LocationService.getAllCountries();
    setState(() {
      countries = result;
      isLoadingCountries = false;
    });
  }

  Future<void> loadStates(String country) async {
    setState(() {
      isLoadingStates = true;
      states = [];
      cities = [];
      selectedState = null;
      selectedCity = null;
    });

    try {
      final result = await LocationService.getStates(country);
      setState(() {
        states = result;
      });
    } catch (e) {
      debugPrint('Error loading states: $e');
    } finally {
      setState(() {
        isLoadingStates = false;
      });
    }
  }

  Future<void> loadCities(String country, String state) async {
    setState(() {
      isLoadingCities = true;
      cities = [];
      selectedCity = null;
    });

    try {
      final result = await LocationService.getCities(country, state);
      setState(() {
        cities = result;
      });
    } catch (e) {
      debugPrint('Error loading cities: $e');
    } finally {
      setState(() {
        isLoadingCities = false;
      });
    }
  }

  bool _obscurePassword = true;
  List<String> _passwordFailures = [];
  bool _passwordMatchError = false;
  bool _obscureConfirmPassword = true;

  Future<void> _submitForm() async {
    final requiredFields = {
      'firstname': _firstnameController.text.trim(),
      'lastname': _lastnameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'password': _passwordController.text.trim(),
      'confirm_password': _confirmPasswordController.text.trim(),
      'house': _houseController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'country': selectedCountry,
      'state': selectedState,
      'city': selectedCity,
      'dial_code': selectedDial,
    };

    for (var entry in requiredFields.entries) {
      if (entry.value == null || entry.value.toString().trim().isEmpty) {
        _showMessage('Please fill in all required fields');
        _scrollToField(entry.key);
        return;
      }
    }

    if (_emailError == 'Email already registered') {
      _scrollToField('email');
      _showMessage('Email already registered');
      return;
    }

    if (_passwordMatchError == true) {
      _scrollToField('confirm_password');
      _showMessage('Passwords do not match');
      return;
    }

    final newUser = User(
      firstName: _firstnameController.text.trim(),
      middleName: _middlenameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      email: _emailController.text.trim(),
      dialCode: selectedDial ?? '',
      mobileNumber: _mobileController.text.trim(),
      password: _passwordController.text.trim(),
      country: selectedCountry!,
      state: selectedState!,
      city: selectedCity!,
      houseNo: _houseController.text.trim(),
      landmark: _landmarkController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    await DBHelper().insertUser(newUser);
    _showMessage("Account created successfully!!... Redirecting to login page");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _emailValidate(String email) async {
    if (getEmailValidationError(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return;
    }

    bool exists = await DBHelper().userExists(email);
    if (exists) {
      setState(() => _emailError = 'Email already registered');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _scrollToField(String fieldKey) {
    final context = _fieldKeys[fieldKey]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _checkPasswordRequirement(String password) {
    final failures = PasswordRequirementsService.getFailedRequirements(
      password,
    );
    setState(() => _passwordFailures = failures);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText('Create Account'),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _firstnameController,
                  _fieldKeys['firstname'],
                  'First Name',
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: buildCustomTextField(
                        _middlenameController,
                        _fieldKeys['middlename'],
                        'Middle Name',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildCustomTextField(
                        _lastnameController,
                        _fieldKeys['lastname'],
                        'Last Name',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _emailController,
                  _fieldKeys['email'],
                  'Email',
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _emailValidate,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 3, // Smaller width for dial code
                      child: buildCustomDropdown(
                        _fieldKeys['dial_code'],
                        selectedDial,
                        _dialCodesList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['dial_code'],
                            child: Text(
                              '${item['name']} (${item['dial_code']})',
                            ),
                          );
                        }).toList(),
                        'Dial Code',
                        (value) {
                          setState(() => selectedDial = value);
                        },
                        useFormField: false,
                        hideUnderline: true,
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      flex: 6, // More width for mobile number
                      child: buildCustomTextField(
                        _mobileController,
                        _fieldKeys['mobile'],
                        'Mobile Number',
                        errorText: _mobileError,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                buildCustomTextField(
                  _passwordController,
                  _fieldKeys['password'],
                  'Password',
                  obscureText: _obscurePassword,
                  errorText: _passwordFailures.isNotEmpty ? '' : null,
                  suffixIconData:
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  onChanged: (value) {
                    _checkPasswordRequirement(value);
                  },
                ),
                const SizedBox(height: 2),
                if (_passwordFailures.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _passwordFailures.map((failure) {
                          return Text(
                            '- $failure',
                            style: const TextStyle(color: Colors.red),
                          );
                        }).toList(),
                  ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _confirmPasswordController,
                  _fieldKeys['confirm_password'],
                  'Confirm Password',
                  obscureText: _obscureConfirmPassword,
                  errorText:
                      _passwordMatchError ? 'Passwords do not match' : null,
                  suffixIconData:
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                  onChanged: (value) {
                    setState(() {
                      _passwordMatchError =
                          value != _passwordController.text.trim();
                    });
                  },
                ),
                const SizedBox(height: 20),

                buildText('Address'),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: buildCustomDropdown(
                        _fieldKeys['country'],
                        selectedCountry,
                        countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        'Country',
                        (value) async {
                          setState(() {
                            selectedCountry = value;
                          });
                          await loadStates(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildCustomDropdown(
                        _fieldKeys['state'],
                        selectedState,
                        states.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        'State',
                        (value) async {
                          setState(() {
                            selectedState = value;
                          });
                          if (selectedCountry != null &&
                              selectedState != null) {
                            await loadCities(selectedCountry!, selectedState!);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildCustomDropdown(
                        _fieldKeys['city'],
                        selectedCity,
                        cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        'City',
                        (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                buildCustomTextField(
                  _houseController,
                  _fieldKeys['house'],
                  'House/Flat No.',
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _landmarkController,
                  _fieldKeys['landmark'],
                  'Landmark',
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _pincodeController,
                  _fieldKeys['pincode'],
                  'Pincode',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
