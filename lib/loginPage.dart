import 'package:flutter/material.dart';
import 'const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGym(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: goFit,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsetsGeometry.lerp(
                      EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.1,
                        vertical: constraints.maxHeight * 0.1,
                      ),
                      EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05,
                        vertical: constraints.maxHeight * 0.05,
                      ),
                      0.5,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      maxHeight: 500,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.02,
                      vertical: constraints.maxHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontFamily: 'SchibstedGrotesk',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: primaryColor,
                          thickness: 3.0,
                          endIndent: 340,
                        ),
                        const SizedBox(height: 10),
                        const SubTextLogin(),
                        const SizedBox(height: 30),
                        const LoginForm(),
                        const SizedBox(height: 15),
                        const Center(
                          child: SubtextFormLogin(),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formLoginKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var _usernameError;
  var _passwordError;

  bool _passwordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formLoginKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Username',
              errorText: _usernameError,
              errorStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: _passwordVisible ? primaryColor : textColorSecond,
                ),
              ),
              errorText: _passwordError,
              errorStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
              ),
            ),
            obscureText: _passwordVisible,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Username: ${_usernameController.text}');
                debugPrint('Password: ${_passwordController.text}');
                setState(() {
                  _usernameError = "error";
                  _passwordError = "error";
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubtextFormLogin extends StatelessWidget {
  const SubtextFormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Butuh Bantuan? Hubungi ',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          color: textColorSecond,
        ),
        children: [
          TextSpan(
            text: 'IT Support',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: textColorSecond,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SubTextLogin extends StatelessWidget {
  const SubTextLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Anda memasuki website sistem informasi ',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text: 'GoFit.',
            style: TextStyle(
              fontFamily: 'SchibstedGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' Silahkan login untuk melanjutkan.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundGym extends StatelessWidget {
  const BackgroundGym({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/interior_gym.jpg'),
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
        ),
      ),
    );
  }
}
