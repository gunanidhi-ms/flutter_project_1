import 'package:flutter/material.dart';
import 'package:flutter_project_1/widgets/custom_scaffold.dart';
import 'package:flutter_project_1/user_model.dart';
import 'package:flutter_project_1/screens/edit_prof.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(

      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('assets/images/profpic.jpg'),
              ),
              SizedBox(height: 120),
              _buildDetailBox("User ID", user.id.toString()),
              SizedBox(height: 16),
              _buildDetailBox("Email", user.email),
              SizedBox(height: 16),
              _buildDetailBox("Password", user.password),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    // Bottom left
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(user: user),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade50,
                          padding: EdgeInsets.symmetric(vertical: 12), // less horizontal padding
                          textStyle: TextStyle(fontSize: 14), // slightly smaller font
                        ),
                        child: Text('Edit Profile', overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Bottom center
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
                            // TODO: Delete user from database
                            Navigator.of(context).popUntil((route) => route.isFirst);
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
                    // Bottom right
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
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
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
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
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
