import 'package:flutter/material.dart';
import 'package:flutter_project_1/widgets/custom_scaffold.dart';
import 'package:flutter_project_1/user_model.dart';
import 'package:flutter_project_1/screens/edit_prof.dart';
import 'package:flutter_project_1/db_helper.dart';
import 'package:flutter_project_1/screens/login.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/profpic.jpg'),
                ),
                SizedBox(height: 40),
                _buildDetailBox("First Name", widget.user.firstName),
                SizedBox(height: 10),
                _buildDetailBox("Middle Name", widget.user.middleName),
                SizedBox(height: 10),
                _buildDetailBox("Last Name", widget.user.lastName),
                SizedBox(height: 10),
                _buildDetailBox("Email", widget.user.email),
                SizedBox(height: 10),
                _buildDetailBox("Mobile Number", '${widget.user.dialCode} ${widget.user.mobileNumber}'),
                SizedBox(height: 10),
                _buildPasswordBox("Password", widget.user.password),
                SizedBox(height: 10),
                _buildDetailBox("Country", widget.user.country),
                SizedBox(height: 10),
                _buildDetailBox("State", widget.user.state),
                SizedBox(height: 10),
                _buildDetailBox("City", widget.user.city),
                SizedBox(height: 10),
                _buildDetailBox("House/Flat No.", widget.user.houseNo),
                SizedBox(height: 10),
                _buildDetailBox("Landmark", widget.user.landmark),
                SizedBox(height: 10),
                _buildDetailBox("Pincode", widget.user.pincode),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(user: widget.user),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade50,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          child: Text('Edit Profile', overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Account'),
                                content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              // Delete user from database
                              await DBHelper().deleteUser(widget.user.email);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Account deleted')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          child: Text('Delete Acc', style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Logged out')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade50,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          child: Text('Logout', overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value) {
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
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordBox(String label, String value) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  _obscurePassword ? '•' * value.length : value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
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
