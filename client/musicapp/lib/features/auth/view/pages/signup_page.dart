import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musicapp/features/auth/view/widgets/custom_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomField(
                controller: nameController,
                hintText: "Name",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomField(
                controller: emailController,
                hintText: "Email",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomField(
                controller: passController,
                isObscuredText: true,
                hintText: "PassWord",
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(
                onPressed: () {},
                buttonText: "Sign up",
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                            color: Pallete.gradient2,
                            fontWeight: FontWeight.bold))
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
