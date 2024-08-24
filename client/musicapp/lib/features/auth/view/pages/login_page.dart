import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/ustils.dart';
import 'package:musicapp/core/widgets/loader.dart';
import 'package:musicapp/features/auth/view/pages/signup_page.dart';
import 'package:musicapp/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musicapp/core/widgets/custom_field.dart';
import 'package:musicapp/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:musicapp/features/home/view/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
    final isLoading = ref.watch(authViewModelProvider.select((value) => value?.isLoading==true,));
    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ), (_) => false,);
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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
                      hintText: "Password",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .loginUser(
                                  email: emailController.text.trim(),
                                  password: passController.text.trim());
                        }
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
