import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_scaffold.dart';
import 'services/password_service.dart';
import 'services/location_service.dart';
import 'services/email_validator_service.dart';
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
  };

  List<Map<String, String>> _dialCodesList = [];
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  String? selectedDial;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
    String? _emailError;

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

    if (_emailError == 'Email already registered'){
      _scrollToField('email');
      _showMessage('Email already registered');
      return;
    }

    if (_passwordMatchError==true) {
      _scrollToField('confirm_password');
      _showMessage('Passwords do not match');
      return;
    }




    final newUser = User(
      firstName: _firstnameController.text.trim(),
      middleName: _middlenameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      email: _emailController.text.trim(),
      dialCode: selectedDial!,
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
    if (!EmailValidatorService.isEmailValid(email)) {
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

  InputDecoration buildInputDecoration(
    String label, {
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white70,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
      errorText: errorText,
    );
  }

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
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _firstnameController,
                  key: _fieldKeys['firstname'],
                  decoration: buildInputDecoration('First Name'),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _middlenameController,
                        key: _fieldKeys['middlename'],
                        decoration: buildInputDecoration('Middle Name'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _lastnameController,
                        key: _fieldKeys['lastname'],
                        decoration: buildInputDecoration('Last Name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _emailController,
                  key: _fieldKeys['email'],
                  decoration: buildInputDecoration(
                    'Email',
                    errorText: _emailError,
                  ),
                  onChanged: (value) {_emailValidate(value);},
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 3, // Smaller width for dial code
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          key: _fieldKeys['dial_code'],
                          hint: const Text('Dial Code'),
                          value: selectedDial,
                          isExpanded: true,
                          items:
                              _dialCodesList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['dial_code'],
                                  child: Text(
                                    '${item['name']} (${item['dial_code']})',
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDial = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      flex: 6, // More width for mobile number
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        key: _fieldKeys['mobile'],
                        decoration: buildInputDecoration('Mobile Number'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _passwordController,
                  key: _fieldKeys['password'],
                  obscureText: _obscurePassword,
                  decoration: buildInputDecoration(
                    'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    errorText: _passwordFailures.isNotEmpty ? '' : null,
                  ),
                  onChanged: _checkPasswordRequirement,
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

                TextField(
                  controller: _confirmPasswordController,
                  key: _fieldKeys['confirm_password'],
                  obscureText: _obscureConfirmPassword,
                  decoration: buildInputDecoration(
                    'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                        );
                      },
                    ),
                    errorText:
                        _passwordMatchError ? 'Passwords do not match' : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _passwordMatchError = value != _passwordController.text;
                    });
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        key: _fieldKeys['country'],
                        value: selectedCountry,
                        items:
                            countries
                                .map(
                                  (country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ),
                                )
                                .toList(),
                        decoration: buildInputDecoration('Country'),
                        onChanged: (value) async {
                          setState(() {
                            selectedCountry = value;
                          });
                          await loadStates(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        key: _fieldKeys['state'],
                        value: selectedState,
                        items:
                            states
                                .map(
                                  (state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state),
                                  ),
                                )
                                .toList(),
                        decoration: buildInputDecoration('State'),
                        onChanged: (value) async {
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
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        key: _fieldKeys['city'],
                        value: selectedCity,
                        items:
                            cities
                                .map(
                                  (city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  ),
                                )
                                .toList(),
                        decoration: buildInputDecoration('City'),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _houseController,
                  key: _fieldKeys['house'],
                  decoration: buildInputDecoration('House/Flat No.'),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _landmarkController,
                  key: _fieldKeys['landmark'],
                  decoration: buildInputDecoration('Landmark'),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _pincodeController,
                  key: _fieldKeys['pincode'],
                  decoration: buildInputDecoration('Pincode'),
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
