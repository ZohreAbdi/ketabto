import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/fade_slide_in.dart';
import 'package:ketabto_test/core/widgets/primary_button.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/bloc/addbook_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/screens/add_book_success_screen.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step3.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step4.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step5.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_progress_bar.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step2.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step1.dart';
import 'package:ketabto_test/features/feature_category/domain/category_entity.dart';

const String kAddBookHeroTag = 'add_book_cover_hero';

class AddBookScreen extends StatelessWidget {
  final String ownerId;
  final String ownerName;

  const AddBookScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddBookBloc(
        uploadImageUseCase: sl(),
        addBookUseCase: sl(),
        ownerId: ownerId,
        ownerName: ownerName,
      ),
      child: const _AddBookView(),
    );
  }
}

class _AddBookView extends StatefulWidget {
  const _AddBookView();

  @override
  State<_AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<_AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  int _currentStep = 0;
  static const int _totalSteps = 5;

  // Text fields need controllers for two-way binding; they stay local and
  // get merged into the bloc's draft when the user advances past each step.
  // Image and category update the draft immediately on selection.
  final _nameController = TextEditingController();
  final _writerController = TextEditingController();
  final _pagesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _writerController.dispose();
    _pagesController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double _sw(BuildContext context) => MediaQuery.of(context).size.width;
  double _sh(BuildContext context) => MediaQuery.of(context).size.height;
  double _w(BuildContext context, double v) => _sw(context) / 390 * v;
  double _h(BuildContext context, double v) => _sh(context) / 844 * v;

  AddBookBloc get _bloc => context.read<AddBookBloc>();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      _bloc.add(
        AddBookDraftUpdated(
          _bloc.state.draft.copyWith(image: File(picked.path)),
        ),
      );
    }
  }

  void _onCategorySelected(Category category) {
    _bloc.add(
      AddBookDraftUpdated(_bloc.state.draft.copyWith(category: category)),
    );
  }

  void _showSnack(String message) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: colorScheme.error),
    );
  }

  void _nextStep() {
    final draft = _bloc.state.draft;

    if (_currentStep == 0 && draft.image == null) {
      _showSnack('SnackMessages.AddPhoto'.tr());
      return;
    }
    if (_currentStep == 2 && draft.category == null) {
      _showSnack('SnackMessages.SelectCategory'.tr());
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    // Merge this step's text input into the draft before moving on.
    switch (_currentStep) {
      case 1:
        _bloc.add(
          AddBookDraftUpdated(
            draft.copyWith(
              name: _nameController.text.trim(),
              writerName: _writerController.text.trim(),
            ),
          ),
        );
        break;
      case 2:
        _bloc.add(
          AddBookDraftUpdated(
            draft.copyWith(pages: int.tryParse(_pagesController.text.trim())),
          ),
        );
        break;
      case 3:
        _bloc.add(
          AddBookDraftUpdated(
            draft.copyWith(description: _descriptionController.text.trim()),
          ),
        );
        break;
      case 4:
        _bloc.add(
          AddBookDraftUpdated(
            draft.copyWith(
              price: double.tryParse(_priceController.text.replaceAll(',', '')),
            ),
          ),
        );
        break;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _bloc.add(const AddBookSubmitted());
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = _w(context, 24).clamp(16.0, 36.0);

    return BlocListener<AddBookBloc, AddBookState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AddBookStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddBookSuccessScreen(
                coverImage: state.draft.image!,
                bookName: state.draft.name!,
                writerName: state.draft.writerName!,
                heroTag: kAddBookHeroTag,
              ),
            ),
          );
        }
        if (state.status == AddBookStatus.failure) {
          _showSnack(state.errorMessage ?? 'Errors.Somethingwentwrong'.tr());
        }
      },
      child: PopScope(
        canPop: _currentStep == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _currentStep > 0) _previousStep();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar: back + progress + thumbnail ──────────
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, _h(context, 16), hPad, 0),
                  child: Row(
                    children: [
                      _buildBackButton(),
                      SizedBox(width: _w(context, 12)),
                      Expanded(
                        child: StepProgressBar(
                          totalSteps: _totalSteps,
                          currentStep: _currentStep - 1,
                        ),
                      ),
                      SizedBox(width: _w(context, 12)),
                      // Persistent Hero source — reads straight from the
                      // bloc's draft, so it appears the instant an image
                      // is picked and survives every later step.
                      BlocBuilder<AddBookBloc, AddBookState>(
                        buildWhen: (prev, curr) =>
                            prev.draft.image != curr.draft.image,
                        builder: (context, state) {
                          final image = state.draft.image;
                          if (image == null) {
                            return const SizedBox(width: 34, height: 34);
                          }
                          return Hero(
                            tag: kAddBookHeroTag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                width: 34,
                                height: 34,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ── Step content ──────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      _h(context, 28),
                      hPad,
                      _h(context, 24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 320),
                        transitionBuilder: (child, animation) {
                          final slide =
                              Tween<Offset>(
                                begin: const Offset(0.06, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              );
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slide,
                              child: child,
                            ),
                          );
                        },
                        child: _buildStep(context),
                      ),
                    ),
                  ),
                ),

                // ── Bottom action button ───────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 0, hPad, _h(context, 20)),
                  child: BlocBuilder<AddBookBloc, AddBookState>(
                    builder: (context, state) {
                      final isLastStep = _currentStep == _totalSteps - 1;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.isLoading) ...[
                            Text(
                              state.loadingMessage,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween(
                                    begin: .96,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: PrimaryButton(
                              label: isLastStep ? 'Buttons.AddBook'.tr() : 'Buttons.Continue'.tr(),
                              onPressed: state.isLoading ? null : _nextStep,
                              isLoading: state.isLoading,
                              key: ValueKey(isLastStep),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    if (_currentStep == 0) {
      return const SizedBox(width: 34, height: 34);
    }

    return GestureDetector(onTap: _previousStep, child: BackWidget());
  }

  Widget _buildStep(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return FadeSlideIn(
          key: const ValueKey('step0'),
          index: 0,
          child: CoverStep(onTapPick: _pickImage),
        );
      case 1:
        return TitleAuthorStep(
          key: const ValueKey(1),
          nameController: _nameController,
          writerController: _writerController,
        );
      case 2:
        return PagesCategoryStep(
          key: const ValueKey(2),
          pagesController: _pagesController,
          onCategorySelected: _onCategorySelected,
        );
      case 3:
        return DescriptionStep(
          key: const ValueKey(3),
          controller: _descriptionController,
        );
      
      default:
        return PriceStep(key: const ValueKey(4), controller: _priceController);
    }
  }
}
