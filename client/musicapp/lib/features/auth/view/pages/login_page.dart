import 'package:flutter/material.dart';
import 'package:fpdart/src/effect.dart';
import 'package:musicapp/core/failure/failure.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/features/auth/model/user_model.dart';
import 'package:musicapp/features/auth/repositories/auth_remote_repository.dart';
import 'package:musicapp/features/auth/view/pages/signup_page.dart';
import 'package:musicapp/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musicapp/features/auth/view/widgets/custom_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                "Sign In.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
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
                onPressed: () async {
                  final res = await AuthRemoteRepository().login(
                      email: emailController.text.trim(),
                      password: passController.text.trim());
                  final val = switch (res) {
                    Left(value: final l) => l,
                    Right(value: final r) => r,
                  };
                  print(val);
                },
                buttonText: "Sign in",
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ));
                },
                child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                        TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
