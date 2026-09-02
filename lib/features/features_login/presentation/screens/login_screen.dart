import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/config/theme/input_decoration.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/core/screens/main_screen.dart';
import 'package:ketabto_test/core/widgets/primary_button.dart';
import 'package:ketabto_test/core/widgets/snack_bar.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/label_field.dart';
import 'package:ketabto_test/features/feature_forgot_pass/presentation/bloc/forgot_password_bloc.dart';
import 'package:ketabto_test/features/feature_forgot_pass/presentation/screens/forgot_password_screen.dart';

import 'package:ketabto_test/features/features_login/presentation/blocs/bloc/login_bloc.dart';
import 'package:ketabto_test/features/features_signup/presentation/blocs/bloc/signup_bloc.dart';
import 'package:ketabto_test/features/features_signup/presentation/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // ─── Responsive helpers ───────────────────────────────────────────────────

  /// Screen width / height shortcuts.
  double _sw(BuildContext context) => MediaQuery.of(context).size.width;
  double _sh(BuildContext context) => MediaQuery.of(context).size.height;

  /// Scale relative to the 390 px design width.
  double _w(BuildContext context, double value) => _sw(context) / 390 * value;

  /// Scale relative to the 844 px design height.
  double _h(BuildContext context, double value) => _sh(context) / 844 * value;

  // ─── Original BLoC event ─────────────────────────────────────────────────
  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  // ─── Hero-compatible navigation ──────────────────────────────────────────
  void _goToSignup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, __, ___) => BlocProvider(
          create: (_) => sl<SignupBloc>(),
          child: const SignupScreen(),
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  void _goToForgotPassword() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, __, ___) => BlocProvider(
          create: (_) => sl<ForgotPasswordBloc>(),
          child: const ForgotPasswordScreen(),
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    final sw = _sw(context);
    final sh = _sh(context);

    // Header takes 42 % of usable height — unchanged ratio, now explicit.
    final double headerHeight = (sh - topPadding) * 0.42;

    // Responsive constants
    final double hPad = _w(context, 30).clamp(18.0, 44.0);
    final double sheetRadius = _w(context, 45).clamp(28.0, 50.0);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoading) {
          setState(() => _isLoading = true);
        }
        if (state is LoginSuccess) {
          setState(() => _isLoading = false);

          await AppSnackBar.success(context, 'SnackMessages.Welcomeback'.tr());

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
        if (state is LoginFailure) {
          setState(() => _isLoading = false);
          AppSnackBar.error(context, state.message);
        }
        if (state is EmailNotVerifiedState) {
          setState(() => _isLoading = false);
          AppSnackBar.info(
            context,
            'SnackMessages.EmailVerify'.tr(),
            actionLabel: 'SnackMessages.EmailVerifyLabel'.tr(),
            onAction: () {
              context.read<LoginBloc>().add(
                ResendVerificationEmailEvent(state.email),
              );
            },
          );
        }

        if (state is ResendEmailSuccessState) {
          setState(() => _isLoading = false);
          AppSnackBar.success(context, 'SnackMessages.EmailVerifySent'.tr());
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // ── Green hero header ─────────────────────────────────────────
            SizedBox(
              height: topPadding + headerHeight,
              child: Stack(
                children: [
                  Hero(
                    tag: 'hero_header',
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // Hero 2 — logo circle + greeting
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'hero_logo',
                            child: Material(
                              color: Colors.transparent,
                              child: _AmberCircle(
                                // Circle scales between 60 and 100 px
                                size: _w(context, 78).clamp(60.0, 100.0),
                              ),
                            ),
                          ),
                          SizedBox(height: _h(context, 14)),
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              color: colorScheme.onBackground,
                              // Font scales between 17 and 28 px
                              fontSize: (sw * 0.056).clamp(17.0, 28.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── White form panel ──────────────────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(sheetRadius),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      _h(context, 40),
                      hPad,
                      _h(context, 24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Email ─────────────────────────────────────
                        SizedBox(height: _h(context, 4)),
                        LabeledField(
                          //maxLength: 255,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? MyColors.black
                              : MyColors.backgroundColor,
                          label: 'SignupLogin.Email'.tr(),
                          hint: 'example@gmail.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'SignupLogin.nullEmailmsg'.tr();
                            }

                            if (v.length > 255) {
                              return 'SignupLogin.msgEmail255'.tr();
                            }

                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(v)) {
                              return 'SignupLogin.InvalidEmailmsg'.tr();
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: _h(context, 22)),

                        // ── Password ──────────────────────────────────
                        LabeledField(
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? MyColors.black
                              : MyColors.backgroundColor,
                          label: 'SignupLogin.Password'.tr(),
                          hint: '',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: HugeIcon(
                              icon: _obscurePassword
                                  ? HugeIcons.strokeRoundedViewOff
                                  : HugeIcons.strokeRoundedView,
                              color: MyColors.hintGrey,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'SignupLogin.msgPassword'.tr();
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: _h(context, 42)),

                        // ── LOGIN button ──────────────────────────────
                        PrimaryButton(
                          label: 'Buttons.btnLogin'.tr(),
                          onPressed: _isLoading ? null : _handleLogin,
                          isLoading: _isLoading,
                        ),

                        SizedBox(height: _h(context, 32)),

                        // ── Sign-up & Forgot Password link ──────────────────────────────
                        Center(
                          child: Column(
                            spacing: 15,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _isLoading ? null : _goToForgotPassword(),
                                child: Text(
                                  'ForgotPassword.ForgotPasswordTitle'.tr(),
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // SizedBox(height: _h(context, 32)),
                              GestureDetector(
                                onTap: _isLoading ? null : _goToSignup,
                                child: RichText(
                                  text: TextSpan(
                                    text: '${'SignupLogin.msgLogin'.tr()} ',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: (sw * 0.033).clamp(11.0, 15.0),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'SignupLogin.SignUp'.tr(),
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: (sw * 0.033).clamp(
                                            11.0,
                                            15.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Amber logo circle ────────────────────────────────────────────────────────
class _AmberCircle extends StatelessWidget {
  const _AmberCircle({this.size = 78, this.icon = Icons.bar_chart_rounded});

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.15,
            ),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // Icon size remains proportional to the circle (46 % of diameter)
      child: Icon(icon, color: Colors.white, size: size * 0.46),
    );
  }
}
