import 'package:flutter/material.dart';
import 'package:flutter_project_1/db_helper.dart';
import '../widgets/custom_scaffold.dart';
import 'signup_page.dart';
import 'profile.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState()=> _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  bool _obscureText=true;
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child:Padding(
        padding:const EdgeInsets.all(16.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:const Color.fromARGB(255, 4, 22, 58),

              ),
              ),
              const SizedBox(height:10),
              Text(
                'Please Log in to your Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:Colors.black,
                ),
              ),
              const SizedBox(height:30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText:'Email',
                  filled:true,
                  fillColor:Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
             const SizedBox(height:30),
             TextField(
              controller: _passwordController,
              obscureText:_obscureText,
              decoration: InputDecoration(
                hintText: 'Enter your Password',
                filled:true,
                fillColor: Colors.white70,
                border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,

                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off:Icons.visibility,
                  ),
                  onPressed: (){
                    setState(()
                    {
                      _obscureText=!_obscureText;

                    });
                  },
                ),
              ),
             ),
             const SizedBox(height: 20),
             ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text;
                if(email.isEmpty || password.isEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')
                    ),
                  );
                    return;
                }
                else if (!email.contains('@') || !email.contains('.')) {
                     ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid email')),
                );
                return;
                }
                final user=await DBHelper().getUser(email,password);
                if(user!=null)
                {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login Succesfull for ${user.email}')),
                   );
                   //later will naviagte to homepage or profile page depeding upon sharvari pages
                  Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                   );
                }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid email or password')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50,vertical:15),
                shape:RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(10),
                  ),
                  elevation: 5, 
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16,color:Colors.white),
                  ),
                  ),
                  const SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style:TextStyle(color:Colors.black),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>SignupPage()),
                          );
                        },
                        child: Text(
                         "sign up",
                         style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.bold),
                          ),
                      ),
                    ],
                  ),
          ],

        ),
      ),
     

    );
    
  }
}