import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/config/theme/input_decoration.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/primary_button.dart';
import 'package:ketabto_test/core/widgets/snack_bar.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/label_field.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_progress_bar.dart';
import 'package:ketabto_test/features/features_signup/presentation/blocs/bloc/signup_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  static const int _progressSteps = 3;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // ─── Responsive helpers ───────────────────────────────────────────────────
  double _sw(BuildContext context) => MediaQuery.of(context).size.width;
  double _sh(BuildContext context) => MediaQuery.of(context).size.height;
  double _w(BuildContext context, double value) => _sw(context) / 390 * value;
  double _h(BuildContext context, double value) => _sh(context) / 844 * value;

  // ─── Original BLoC event ─────────────────────────────────────────────────
  void _handleSignup() {
    if (!_formKey.currentState!.validate()) return;

    context.read<SignupBloc>().add(
      SignupSubmitted(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _nextStep() {
    if (!_formKey.currentState!.validate()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _handleSignup();
    }
  }

  void _previousStep() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _currentStep--);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = _sw(context);
    final sh = _sh(context);

    final double topPadding = _h(context, 28);
    final double appBarHeight = _h(context, 89);
    final double sheetRadius = _w(context, 45).clamp(28.0, 50.0);
    final double hPad = _w(context, 28).clamp(16.0, 40.0);

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) async {
        if (state is SignupLoading) {
          setState(() => _isLoading = true);
        }
        if (state is SignupSuccess) {
          setState(() {
            _isLoading = false;
            _currentStep = 0;
          });

          await AppSnackBar.success(
            context,
            'SnackMessages.SuccessfullyCreatedAcc'.tr(),
          );

          if (!mounted) return;

          Navigator.of(context).pop();

          _formKey.currentState!.reset();
          _nameController.clear();
          _phoneController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
        }

        if (state is SignupFailure) {
          setState(() => _isLoading = false);
          AppSnackBar.error(context, state.message);
        }
      },
      child: PopScope(
        canPop: _currentStep == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _previousStep();
          }
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              children: [
                // ── App-bar area ─────────────────────────────────────────
                SizedBox(
                  height: appBarHeight,
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'hero_header',
                        child: Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: const SizedBox.expand(),
                        ),
                      ),
                      Positioned.directional(
                        start: _w(context, 20),
                        end: _w(context, 20),
                        bottom: _h(context, 14),
                        textDirection: Directionality.of(
                          context,
                        ), // reads RTL/LTR from the locale
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _previousStep,
                              child: BackWidget(),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _currentStep == 0
                                  ? Text(
                                      'SignupLogin.CreateAcc'.tr(),
                                      style: TextStyle(
                                        color: colorScheme.onBackground,
                                        fontSize: (_sw(context) * 0.051).clamp(
                                          16.0,
                                          24.0,
                                        ),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    )
                                  : StepProgressBar(
                                      totalSteps: _progressSteps,
                                      currentStep: _currentStep - 1,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: _h(context, 18)),

                // ── White sheet ──────────────────────────────────────────
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sheetRadius),
                        topRight: Radius.circular(sheetRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              hPad,
                              _h(context, 35),
                              hPad,
                              _h(context, 32),
                            ),
                            child: Form(
                              key: _formKey,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _buildCurrentStep(context),
                              ),
                            ),
                          ),
                        ),

                        // ── Footer link ──────────────────────────────────
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: _h(context, 20),
                            top: _h(context, 10),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: '${'SignupLogin.msgSignup'.tr()} ',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: (sw * 0.033).clamp(11.0, 15.0),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'SignupLogin.LOGIN'.tr(),
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: (sw * 0.033).clamp(11.0, 15.0),
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  // ─── Steps ───────────────────────────────────────────────────────────────
  Widget _buildCurrentStep(BuildContext context) {
    switch (_currentStep) {
      // STEP 1 — Email
      case 0:
        return Column(
          key: const ValueKey(0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepTip(
              title: 'SignupLogin.FirstStep'.tr(),
              message: 'SignupLogin.FirstStepmsg'.tr(),
            ),

            SizedBox(height: _h(context, 30)),

            LabeledField(
              maxLength: 255,
              fillColor: Theme.of(context).brightness == Brightness.dark
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

                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return 'SignupLogin.InvalidEmailmsg'.tr();
                }

                return null;
              },
            ),

            SizedBox(height: _h(context, 35)),

            PrimaryButton(
              label: 'Buttons.btnContinue'.tr(),
              onPressed: _nextStep,
            ),
          ],
        );
      // STEP 2 — Name & Phone
      case 1:
        return Column(
          key: const ValueKey(1),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepTip(
              title: 'SignupLogin.SecondStep'.tr(),
              message: 'SignupLogin.SecondStepmsg'.tr(),
            ),

            SizedBox(height: _h(context, 30)),

            LabeledField(
              maxLength: 100,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? MyColors.black
                  : MyColors.backgroundColor,
              label: 'SignupLogin.Name'.tr(),
              controller: _nameController,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'SignupLogin.msgName'.tr();
                }

                if (v.trim().length < 2 || v.trim().length > 100) {
                  return 'SignupLogin.msgNameLength'.tr();
                }
              },
              hint: '',
            ),

            SizedBox(height: _h(context, 20)),

            LabeledField(
              maxLength: 11,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? MyColors.black
                  : MyColors.backgroundColor,
              label: 'SignupLogin.PhoneNum'.tr(),
              hint: '09123456789',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'SignupLogin.msgPhone'.tr();
                }

                if (!RegExp(r'^09\d{9}$').hasMatch(v)) {
                  return 'SignupLogin.msgInvalidPhone'.tr();
                }

                if (v.length != 11) {
                  return 'SignupLogin.msgInvalidPhone'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: _h(context, 35)),

            PrimaryButton(
              label: 'Buttons.btnContinue'.tr(),
              onPressed: _nextStep,
            ),
          ],
        );

      // STEP 3 — Password
      default:
        return Column(
          key: const ValueKey(2),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepTip(
              title: 'SignupLogin.ThirdStep'.tr(),
              message:
                  'SignupLogin.ThirdStepmsg'.tr(),
            ),

            SizedBox(height: _h(context, 30)),

            LabeledField(
              maxLength: 64,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? MyColors.black
                  : MyColors.backgroundColor,
              hint: '',
              label: 'SignupLogin.Password'.tr(),
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: HugeIcon(
                  icon: _obscurePassword
                      ? HugeIcons.strokeRoundedViewOff
                      : HugeIcons.strokeRoundedView,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                if (v.length < 8 || v.length > 64) {
                  return 'SignupLogin.msgPassLength'.tr();
                }
                if (!RegExp(r'[A-Z]').hasMatch(v)) {
                  return 'SignupLogin.msgPassU'.tr();
                }
                if (!RegExp(r'[a-z]').hasMatch(v)) {
                  return 'SignupLogin.msgPassL'.tr();
                }
                if (!RegExp(r'[0-9]').hasMatch(v)) {
                  return 'SignupLogin.msgPassN'.tr();
                }
                // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
                //   return 'SignupLogin.msgPassC'.tr();
                // }
                return null;
              },
            ),

            SizedBox(height: _h(context, 20)),

            LabeledField(
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? MyColors.black
                  : MyColors.backgroundColor,
              hint: '',
              label: 'SignupLogin.ConfirmPass'.tr(),
              controller: _confirmPasswordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'SignupLogin.msgConfirmPass'.tr();
                }

                if (value != _passwordController.text) {
                  return 'SignupLogin.msgPassnotmatch'.tr();
                }

                return null;
              },
            ),

            SizedBox(height: _h(context, 35)),

            PrimaryButton(
              label: 'Buttons.btnSignUp'.tr(),
              onPressed: _isLoading ? null : _nextStep,
              isLoading: _isLoading,
            ),
          ],
        );
    }
  }
}
