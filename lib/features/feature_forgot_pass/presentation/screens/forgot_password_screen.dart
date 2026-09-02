import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/primary_button.dart';
import 'package:ketabto_test/core/widgets/snack_bar.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/label_field.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';
import 'package:ketabto_test/features/feature_forgot_pass/presentation/bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  bool _isLoading = false;

  // Responsive Helpers
  double _sw(BuildContext context) => MediaQuery.of(context).size.width;
  double _sh(BuildContext context) => MediaQuery.of(context).size.height;

  double _w(BuildContext context, double value) => _sw(context) / 390 * value;

  double _h(BuildContext context, double value) => _sh(context) / 844 * value;

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordRequested(_emailController.text.trim()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = _sw(context);

    final double topPadding = _h(context, 28);
    final double appBarHeight = _h(context, 89);
    final double sheetRadius = _w(context, 45).clamp(28.0, 50.0);
    final double hPad = _w(context, 28).clamp(16.0, 40.0);

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordLoading) {
          setState(() => _isLoading = true);
        }

        if (state is ForgotPasswordSuccess) {
          setState(() => _isLoading = false);

          AppSnackBar.success(context, 'SnackMessages.PasswordLinkSent'.tr());

          // بعدا:
          // Navigator.push(...)
        }

        if (state is ForgotPasswordFailure) {
          setState(() => _isLoading = false);

          AppSnackBar.error(context, state.message);
        }
      },
      child: Scaffold(
        //  backgroundColor: colorScheme.surface,
        body: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            children: [
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
                      textDirection: Directionality.of(context),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: BackWidget(),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'ForgotPassword.ForgotPasswordTitle'.tr(),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: (_sw(context) * 0.051).clamp(
                                  16.0,
                                  24.0,
                                ),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: _h(context, 18)),

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
                            child: _buildContent(context),
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
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTip(
          title: 'ForgotPassword.StepTip'.tr(),
          message: 'ForgotPassword.StepTipmsg'.tr(),
        ),

        SizedBox(height: _h(context, 30)),

        LabeledField(
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? MyColors.black
              : MyColors.backgroundColor,
          // maxLength: 255,
          label: 'SignupLogin.Email',
          hint: 'example@gmail.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'ForgotPassword.msgEmail'.tr();
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
          label: 'Buttons.SendResetLink'.tr(),
          isLoading: _isLoading,
          onPressed: _isLoading ? null : _sendEmail,
        ),
      ],
    );
  }
}
