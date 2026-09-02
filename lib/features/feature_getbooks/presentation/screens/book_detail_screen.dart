import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class BookDetailScreen extends StatefulWidget {
  final BookEntity book;

  /// Must match the Hero tag used in the source card.
  final String heroTag;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.heroTag,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Content panel slides up from below
  late final Animation<Offset> _panelSlide;

  // 5 groups of content fade in with stagger
  late final List<Animation<double>> _fades;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Each content group fades in 120 ms after the previous one
    _fades = List.generate(5, (i) {
      final start = (i * 0.13).clamp(0.0, 0.9);
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Start after Hero lands (~300 ms)
    Future.delayed(const Duration(milliseconds: 260), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sh = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final imageHeight = sh * 0.46;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: BackWidget(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // ── Hero book cover ───────────────────────────────────────
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
              child: Hero(
                tag: widget.heroTag,
                child: Image.network(
                  widget.book.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Column(
                    children: [
                      SizedBox(height: 50),
                      Container(
                        //color: Colors.grey.shade800,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedBookOpen02,
                          size: 80,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        //  Icon(
                        //   Icons.book_outlined,
                        //   size: 60,
                        //   color: Colors.grey.shade600,
                        // ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.037),

          // ── Sliding content panel ─────────────────────────────────
          Expanded(
            child: SlideTransition(
              position: _panelSlide,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Category ────────────────────────────────
                      _Fade(
                        anim: _fades[0],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _CategoryChip(label: widget.book.category),

                            _SaveButton(book: widget.book),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      const SizedBox(height: 12),

                      // ── Title ────────────────────────────────────
                      _Fade(
                        anim: _fades[1],
                        child: Text(
                          widget.book.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ── Author ───────────────────────────────────
                      _Fade(
                        anim: _fades[1],
                        child: Text(
                          widget.book.writerName,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Stats row ────────────────────────────────
                      _Fade(
                        anim: _fades[2],
                        child: _StatsRow(book: widget.book),
                      ),

                      const SizedBox(height: 28),

                      // ── Divider ──────────────────────────────────
                      _Fade(
                        anim: _fades[2],
                        child: Divider(
                          color: colorScheme.onSurface.withOpacity(0.12),
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Description label ────────────────────────
                      _Fade(
                        anim: _fades[3],
                        child: Text(
                          'DetailBook.Description'.tr(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Description body ─────────────────────────
                      _Fade(
                        anim: _fades[3],
                        child: Text(
                          widget.book.description,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.75,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── Get Book button ──────────────────────────
                      _Fade(
                        anim: _fades[4],
                        child: _GetBookButton(book: widget.book),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Back button ───────────────────────────────────────────
        ],
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final BookEntity book;

  const _StatsRow({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),

      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: HugeIcons.strokeRoundedBookOpen01,
                //Icons.menu_book_outlined,
                label: "DetailBook.Pages".tr(),
                value: "${book.pages}",
              ),
            ),

            VerticalDivider(
              color: colorScheme.onSurface.withOpacity(0.12),
              thickness: 1,
            ),

            Expanded(
              child: _StatItem(
                icon: HugeIcons.strokeRoundedDollar01,
                label: "DetailBook.Price".tr(),
                value: "\$${book.price.toStringAsFixed(2)}",
              ),
            ),

            VerticalDivider(
              color: colorScheme.onSurface.withOpacity(0.12),
              thickness: 1,
            ),

            Expanded(
              child: _StatItem(
                icon: HugeIcons.strokeRoundedUser,
                label: "DetailBook.Owner".tr(),
                value: book.ownerName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(icon: icon, color: colorScheme.primary, size: 22),
        const SizedBox(height: 10),

        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ─── Get Book button ──────────────────────────────────────────────────────────
class _GetBookButton extends StatelessWidget {
  final BookEntity book;
  const _GetBookButton({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          // TODO: connect to purchase / borrow flow
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Buttons.GetBook'.tr(),
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '\$${book.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category chip ────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

// ─── Fade wrapper ─────────────────────────────────────────────────────────────
class _Fade extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _Fade({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: anim, child: child);
  }
}

class _SaveButton extends StatelessWidget {
  final BookEntity book;

  const _SaveButton({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SavedBooksBloc, SavedBooksState>(
      builder: (context, state) {
        bool isSaved = false;

        if (state is SavedBooksLoaded) {
          isSaved = state.bookIds.contains(book.id);
        }

        return IconButton(
          onPressed: () {
            if (isSaved) {
              context.read<SavedBooksBloc>().add(RemoveSavedBookEvent(book.id));
            } else {
              context.read<SavedBooksBloc>().add(SaveBookEvent(book.id));
            }
          },
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            foregroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(Symbols.bookmark_rounded, size: 24, fill: isSaved ? 1 : 0),
        );
      },
    );
  }
}
