import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/screens/utils.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_project_1/screens/services/password_service.dart';
import 'package:flutter_project_1/screens/services/location_service.dart';
import 'package:flutter_project_1/screens/services/email_validator_service.dart';
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

    if (_emailError!= null) {
      _scrollToField('email');
      _showMessage(_emailError!);
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

  void _emailValidate(String email) {
    validateEmail(email, false, (error) {
      setState(() => _emailError = error);
    });
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: buildText('Create Account')),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _firstnameController,
                  _fieldKeys['firstname'],
                  'First Name*',
                  'First Name',
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: buildCustomTextField(
                        _middlenameController,
                        _fieldKeys['middlename'],
                        'Middle Name(optional)',
                        'Middle Name',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildCustomTextField(
                        _lastnameController,
                        _fieldKeys['lastname'],
                        'Last Name*',
                        'Last Name',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _emailController,
                  _fieldKeys['email*'],
                  'Email*',
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
                        'Dial Code*',
                        'Dial Code',
                        _dialCodesList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['dial_code'],
                            child: Text(
                              '${item['name']} (${item['dial_code']})',
                            ),
                          );
                        }).toList(),
                        (value) {
                          setState(() => selectedDial = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      flex: 6, // More width for mobile number
                      child: buildCustomTextField(
                        _mobileController,
                        _fieldKeys['mobile'],
                        'Mobile Number*',
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
                  'Password*',
                  'Password',
                  obscureText: _obscurePassword,
                  errorText:
                      _passwordFailures.isNotEmpty
                          ? '- ${_passwordFailures.first}'
                          : null,
                  suffixIconData:
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  onChanged: (value) {
                    _checkPasswordRequirement(value);
                    if (_confirmPasswordController.text.trim().isNotEmpty &&
                        value != _confirmPasswordController.text.trim()) {
                      setState(() {
                        _passwordMatchError = true;
                      });
                    } else {
                      setState(() {
                        _passwordMatchError = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _confirmPasswordController,
                  _fieldKeys['confirm_password'],
                  'Confirm Password*',
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

                buildText('Address', fontSize: 18),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: buildCustomDropdown(
                        _fieldKeys['country'],
                        selectedCountry,
                        'Country*',
                        'Country',
                        countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
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
                        'State*',
                        'State',
                        states.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
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
                        'City*',
                        'City',
                        cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildCustomTextField(
                  _houseController,
                  _fieldKeys['house'],
                  'House/Flat No.*',
                  'House/Flat No.',
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _landmarkController,
                  _fieldKeys['landmark'],
                  'Landmark*',
                  'Landmark',
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  _pincodeController,
                  _fieldKeys['pincode'],
                  'Pincode*',
                  'Pincode',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 78, 136),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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
