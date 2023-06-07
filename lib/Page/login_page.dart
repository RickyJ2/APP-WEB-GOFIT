import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../Asset/line_divider.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../Bloc/LoginBloc/login_bloc.dart';
import '../Bloc/LoginBloc/login_event.dart';
import '../Bloc/LoginBloc/login_state.dart';
import '../Repository/login_repository.dart';
import '../const.dart';
import '../StateBlocTemplate/form_submission_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(loginRepository: LoginRepository()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
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
                      const TitleFormText(),
                      const LineDivider(),
                      const SizedBox(height: 10),
                      const SubTextLogin(),
                      const SizedBox(height: 30),
                      LoginForm(),
                      const SizedBox(height: 15),
                      const SubtextFormLogin(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TitleFormText extends StatelessWidget {
  const TitleFormText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Selamat Datang',
      style: TextStyle(
        fontFamily: 'SchibstedGrotesk',
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final _formLoginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.formSubmissionState != current.formSubmissionState,
          listener: (context, state) {
            final formState = state.formSubmissionState;
            if (formState is SubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Berhasil Login"),
                ),
              );
              BlocProvider.of<AppBloc>(context).add(const AppLogined());
            } else if (formState is SubmissionFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(formState.exception.toString()),
                ),
              );
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.authenticated != current.authenticated,
          listener: (context, state) {
            if (state.authenticated == true) {
              context.go('/home');
            }
          },
        ),
      ],
      child: Form(
        key: _formLoginKey,
        child: const Column(
          children: [
            UsernameTextFormField(),
            SizedBox(height: 10),
            PasswordTextFormField(),
            SizedBox(height: 40),
            ButtonLoginForm(),
          ],
        ),
      ),
    );
  }
}

class ButtonLoginForm extends StatelessWidget {
  const ButtonLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<LoginBloc>().add(LoginSubmitted());
          },
          child: Stack(
            children: [
              state.formSubmissionState is FormSubmitting
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  state.formSubmissionState is! FormSubmitting ? 'Login' : '',
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: 'Password',
          suffixIcon: IconButton(
            onPressed: () {
              context.read<LoginBloc>().add(PasswordVisibleChanged());
            },
            icon: Icon(
              state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: state.isPasswordVisible ? primaryColor : textColorSecond,
            ),
          ),
        ),
        obscureText: !state.isPasswordVisible,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.passwordError == '' ? null : state.passwordError,
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }
}

class UsernameTextFormField extends StatelessWidget {
  const UsernameTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Username',
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.usernameError == '' ? null : state.usernameError,
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }
}

class SubtextFormLogin extends StatelessWidget {
  const SubtextFormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
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
