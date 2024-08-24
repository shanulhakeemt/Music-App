import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/ustils.dart';
import 'package:musicapp/core/widgets/loader.dart';
import 'package:musicapp/features/auth/view/pages/login_page.dart';
import 'package:musicapp/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musicapp/core/widgets/custom_field.dart';
import 'package:musicapp/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
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
    final isLoading = ref.watch(authViewModelProvider.select((value) => value?.isLoading==true,));
    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            showSnackBar(context, 'Account created succesfully! Please login.');

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signUpUser(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passController.text.trim());
                          }
                        },
                        buttonText: "Sign up",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        },
                        child: RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: const [
                              TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                      color: Pallete.gradient2,
                                      fontWeight: FontWeight.bold))
                            ])),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
