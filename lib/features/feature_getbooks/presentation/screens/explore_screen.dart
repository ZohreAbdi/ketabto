import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/section_label.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/recent_books_bloc/recent_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/screens/book_detail_screen.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/widgets/book_card.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/widgets/recent_books_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ExploreView();
  }
}

// ─── Main view ────────────────────────────────────────────────────────────────
class _ExploreView extends StatelessWidget {
  const _ExploreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookInitial || state is BookLoading) {
              return const _SkeletonLoader();
            }
            if (state is BookError) {
              return _ErrorView(message: state.message);
            }
            if (state is BookLoaded) {
              return _BookContent(books: state.books);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ─── Loaded content ───────────────────────────────────────────────────────────
class _BookContent extends StatelessWidget {
  final List<BookEntity> books;
  const _BookContent({required this.books});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── App bar ───────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          snap: true,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 20,
          title: Text(
            'Explore.Title'.tr(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),

        // ── Recently Viewed (only rendered once there's something
        //    to show — hidden entirely for a first-time user) ──────
        SliverToBoxAdapter(
          child: BlocBuilder<RecentBooksBloc, RecentBooksState>(
            builder: (context, rvState) {
              final recentBooks = rvState is RecentBooksLoaded
                  ? rvState.books
                  : <BookEntity>[];

              // Map ids back to books still in the catalog, keeping
              // the most-recent-first order already stored.
              final recent = recentBooks;
              if (recent.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  SectionLabel(title: 'Explore.RecentlyViewed'.tr()),
                  SizedBox(height: 14),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: RecentlyViewedCard(
                            book: recent[index],
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // ── All books section label ────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 14),
              SectionLabel(
                title: 'Explore.AllBooks'.tr(),
                trailing: Text(
                  'books_count'.tr(
                    namedArgs: {'count': books.length.toString()},
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Books list ────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => BookCard(
                book: books[index],
                index: index,
                onTap: () {
                  final book = books[index];

                  context.read<RecentBooksBloc>().add(AddRecentBookEvent(book));

                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 400,
                      ),
                      pageBuilder: (_, __, ___) {
                        return BlocProvider.value(
                          value: context.read<SavedBooksBloc>(),
                          child: BookDetailScreen(book: book, heroTag: book.id),
                        );
                      },
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              childCount: books.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Skeleton loader ──────────────────────────────────────────────────────────
class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader();

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacity = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) {
        return Opacity(
          opacity: _opacity.value,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  _SkeletonBox(width: 120, height: 28, radius: 8),
                  const SizedBox(height: 24),
                  // Recently-viewed row skeletons
                  Row(
                    children: [
                      SizedBox(
                        height: 248,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (_, __) {
                            return const _SkeletonBox(
                              width: 128,
                              height: 248,
                              radius: 18,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SkeletonBox(width: 100, height: 20, radius: 6),
                  const SizedBox(height: 16),
                  // List item skeletons
                  for (int i = 0; i < 4; i++) ...[
                    _buildListSkeleton(),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 70, height: 100, radius: 12),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 60, height: 18, radius: 30),
                const SizedBox(height: 10),
                _SkeletonBox(width: double.infinity, height: 16, radius: 6),
                const SizedBox(height: 6),
                _SkeletonBox(width: 120, height: 13, radius: 6),
                const SizedBox(height: 16),
                _SkeletonBox(width: 60, height: 15, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Errors.Somethingwentwrong'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () =>
                context.read<BookBloc>().add(const GetBooksEvent()),
            child: Text(
              'Buttons.Tryagain'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
