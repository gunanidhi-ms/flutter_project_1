import 'package:flutter/material.dart';
import 'package:flutter_project_1/user_model.dart';
import 'package:flutter_project_1/widgets/custom_scaffold.dart';
import 'package:flutter_project_1/screens/services/password_service.dart';
import 'package:flutter_project_1/db_helper.dart';
import 'package:flutter_project_1/screens/profile.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _passwordController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _houseController;
  late TextEditingController _landmarkController;
  late TextEditingController _pincodeController;
  late TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  List<String> _passwordFailures = [];
  String? _emailError;
  String? _mobileError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _middleNameController = TextEditingController(text: widget.user.middleName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _mobileController = TextEditingController(text: widget.user.mobileNumber);
    _passwordController = TextEditingController();
    _countryController = TextEditingController(text: widget.user.country);
    _stateController = TextEditingController(text: widget.user.state);
    _cityController = TextEditingController(text: widget.user.city);
    _houseController = TextEditingController(text: widget.user.houseNo);
    _landmarkController = TextEditingController(text: widget.user.landmark);
    _pincodeController = TextEditingController(text: widget.user.pincode);
    _confirmPasswordController = TextEditingController();
    _checkPasswordRequirement(widget.user.password);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _houseController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordRequirement(String password) {
    final failures = PasswordRequirementsService.getFailedRequirements(password);
    setState(() => _passwordFailures = failures);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          // AppBar(
          //   title: Text('Go back to your profile'),
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   foregroundColor: Colors.black,
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEditBox('First Name', _firstNameController),
                    SizedBox(height: 10),
                    _buildEditBox('Middle Name', _middleNameController),
                    SizedBox(height: 10),
                    _buildEditBox('Last Name', _lastNameController),
                    SizedBox(height: 10),
                    _buildEditBox('Email', _emailController, errorText: _emailError),
                    SizedBox(height: 10),
                    _buildEditBox('Mobile Number', _mobileController, errorText: _mobileError, isMobile: true),
                    SizedBox(height: 10),
                    _buildPasswordEditBox('Password', _passwordController),
                    SizedBox(height: 10),
                    _buildPasswordEditBox('Confirm Password', _confirmPasswordController, errorText: _passwordError),
                    if (_passwordFailures.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _passwordFailures.map((failure) => Text('- $failure', style: TextStyle(color: Colors.red, fontSize: 12))).toList(),
                      ),
                    SizedBox(height: 10),
                    _buildEditBox('Country', _countryController),
                    SizedBox(height: 10),
                    _buildEditBox('State', _stateController),
                    SizedBox(height: 10),
                    _buildEditBox('City', _cityController),
                    SizedBox(height: 10),
                    _buildEditBox('House/Flat No.', _houseController),
                    SizedBox(height: 10),
                    _buildEditBox('Landmark', _landmarkController),
                    SizedBox(height: 10),
                    _buildEditBox('Pincode', _pincodeController),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _emailError = null;
                              _mobileError = null;
                              _passwordError = null;
                            });
                            // Email validation
                            String email = _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : widget.user.email;
                            if (!email.contains('@') || !email.contains('.')) {
                              setState(() {
                                _emailError = 'Enter a valid email address';
                              });
                              return;
                            }
                            // Mobile validation
                            String mobile = _mobileController.text.trim().isNotEmpty ? _mobileController.text.trim() : widget.user.mobileNumber;
                            if (mobile.length != 10) {
                              setState(() {
                                _mobileError = 'Mobile number must be 10 digits';
                              });
                              return;
                            }
                            // Password match validation
                            if (_passwordController.text != _confirmPasswordController.text) {
                              setState(() {
                                _passwordError = 'Passwords do not match!';
                              });
                              return;
                            }
                            // Save changes to user profile in local DB
                            final updatedUser = User(
                              id: widget.user.id,
                              firstName: _firstNameController.text.trim().isNotEmpty ? _firstNameController.text.trim() : widget.user.firstName,
                              middleName: _middleNameController.text.trim().isNotEmpty ? _middleNameController.text.trim() : widget.user.middleName,
                              lastName: _lastNameController.text.trim().isNotEmpty ? _lastNameController.text.trim() : widget.user.lastName,
                              email: email,
                              dialCode: widget.user.dialCode,
                              mobileNumber: mobile,
                              password: _passwordController.text.trim().isNotEmpty ? _passwordController.text.trim() : widget.user.password,
                              country: _countryController.text.trim().isNotEmpty ? _countryController.text.trim() : widget.user.country,
                              state: _stateController.text.trim().isNotEmpty ? _stateController.text.trim() : widget.user.state,
                              city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : widget.user.city,
                              houseNo: _houseController.text.trim().isNotEmpty ? _houseController.text.trim() : widget.user.houseNo,
                              landmark: _landmarkController.text.trim().isNotEmpty ? _landmarkController.text.trim() : widget.user.landmark,
                              pincode: _pincodeController.text.trim().isNotEmpty ? _pincodeController.text.trim() : widget.user.pincode,
                            );
                            await DBHelper().insertUser(updatedUser);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(user: updatedUser),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Profile updated!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade300,
                          ),
                          child: Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBox(String label, TextEditingController controller, {String? errorText, bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepPurple[300])),
          SizedBox(height: 2),
          TextField(
            controller: controller,
            keyboardType: isMobile ? TextInputType.number : null,
            inputFormatters: isMobile ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : null,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey[600]),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordEditBox(String label, TextEditingController controller, {String? errorText}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepPurple[300])),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: _obscurePassword,
                  onChanged: _checkPasswordRequirement,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey[600]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    errorText: errorText,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 