import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ketabto_test/core/data_source/user_data_source.dart';
import 'package:ketabto_test/core/data_source/user_data_source_impl.dart';
import 'package:ketabto_test/core/localization/bloc/locale_bloc.dart';
import 'package:ketabto_test/features/feature_activity/data/data_source/saved_books_datasource.dart';
import 'package:ketabto_test/features/feature_activity/data/repositories/saved_books_repository_impl.dart';
import 'package:ketabto_test/features/feature_activity/domain/repositories/saved_books_repository.dart';
import 'package:ketabto_test/features/feature_activity/domain/usecases/saved_books_usecases.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/data/data_source/add_book_datasource.dart';
import 'package:ketabto_test/features/feature_addbooks/data/data_source/add_book_datasource_impl.dart';
import 'package:ketabto_test/features/feature_addbooks/data/repositories/add_book_repository_impl.dart';
import 'package:ketabto_test/features/feature_addbooks/domain/repositories/add_book_repository.dart';
import 'package:ketabto_test/features/feature_addbooks/domain/usecases/add_book_upload_image_usecase.dart';
import 'package:ketabto_test/features/feature_addbooks/domain/usecases/add_book_usecase.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/bloc/addbook_bloc.dart';
import 'package:ketabto_test/features/feature_email_verify/data/data_source/email_verify_datasource.dart';
import 'package:ketabto_test/features/feature_email_verify/data/data_source/email_verify_datasource_impl.dart';
import 'package:ketabto_test/features/feature_email_verify/data/repositories/email_verify_repository_impl.dart';
import 'package:ketabto_test/features/feature_email_verify/domain/repositories/email_verify_repository.dart';
import 'package:ketabto_test/features/feature_email_verify/domain/usecases/email_verify_usecase.dart';
import 'package:ketabto_test/features/feature_forgot_pass/data/data_source/forgot_password_datasource.dart';
import 'package:ketabto_test/features/feature_forgot_pass/data/repositories/forgot_password_repository_impl.dart';
import 'package:ketabto_test/features/feature_forgot_pass/domain/repositories/forgot_password_repository.dart';
import 'package:ketabto_test/features/feature_forgot_pass/domain/usecases/forgot_password_usecase.dart';
import 'package:ketabto_test/features/feature_forgot_pass/presentation/bloc/forgot_password_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/data/data_source/get_book_datasource.dart';
import 'package:ketabto_test/features/feature_getbooks/data/data_source/recent_books_datasource.dart';
import 'package:ketabto_test/features/feature_getbooks/data/repositories/get_book_repository_impl.dart';
import 'package:ketabto_test/features/feature_getbooks/data/repositories/recent_books_repository_impl.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/get_book_repository.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/recent_books_repository.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/add_recent_books_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/clear_recent_books_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/get_book_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/get_recent_books_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/recent_books_bloc/recent_books_bloc.dart';
import 'package:ketabto_test/features/feature_home/data/data_source/recent_search_local_data_source.dart';
import 'package:ketabto_test/features/feature_home/domain/repositories/recent_search_repository.dart';
import 'package:ketabto_test/features/feature_home/presentation/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:ketabto_test/features/feature_home/presentation/blocs/search_bloc/search_book_bloc.dart';
import 'package:ketabto_test/features/feature_profile/data/repositories/profile_repository_impl.dart';
import 'package:ketabto_test/features/feature_profile/domain/repositories/profile_repository.dart';
import 'package:ketabto_test/features/feature_profile/domain/usecases/profile_usecase.dart';
import 'package:ketabto_test/features/feature_profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:ketabto_test/features/features_login/data/data_source/login_datasource.dart';
import 'package:ketabto_test/features/features_login/data/repositories/login_repository_impl.dart';
import 'package:ketabto_test/features/features_login/domain/repositories/login_repository.dart';
import 'package:ketabto_test/features/features_login/domain/usecases/login_usecase.dart';
import 'package:ketabto_test/features/features_login/presentation/blocs/bloc/login_bloc.dart';
import 'package:ketabto_test/features/features_signup/data/data_source/signup_datasource.dart';
import 'package:ketabto_test/features/features_signup/data/repositories/signup_repository_impl.dart';
import 'package:ketabto_test/features/features_signup/domain/repositories/signup_repository.dart';
import 'package:ketabto_test/features/features_signup/domain/usecases/signup_usecase.dart';
import 'package:ketabto_test/features/features_signup/presentation/blocs/bloc/signup_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<LocaleBloc>(() => LocaleBloc());
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  //SignUpBloc
  sl.registerLazySingleton<SignupRemoteDataSource>(
    () => SignupRemoteDataSource(),
  );

  sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl(sl()));

  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase(sl()));

  sl.registerFactory(() => SignupBloc(sl()));

  //LoginBloc
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      sl<LoginRemoteDataSource>(),
      sl<UserLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  sl.registerFactory(() => LoginBloc(sl(), sl()));

  //EmailVerifyBloc
  sl.registerLazySingleton<EmailVerificationRemoteDataSource>(
    () => EmailVerificationRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<EmailVerificationRepository>(
    () => EmailVerificationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => ResendVerificationEmailUseCase(sl()));

  //ProfileBloc
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl<UserLocalDataSource>()),
  );

  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));

  sl.registerFactory(() => ProfileBloc(sl<GetProfileUseCase>()));

  //GetBookBloc
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceMock(),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetBooksUseCase(sl()));

  sl.registerFactory(() => BookBloc(getBooksUseCase: sl()));

  //AddBookBloc
  sl.registerLazySingleton<AddBookRemoteDataSource>(
    () => AddBookRemoteDataSourceImpl(sl<UserLocalDataSource>()),
  );

  sl.registerLazySingleton<AddBookRepository>(
    () => AddBookRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  sl.registerLazySingleton(() => AddBookUseCase(sl()));

  sl.registerLazySingleton(
    () => AddBookBloc(
      uploadImageUseCase: sl(),
      addBookUseCase: sl(),
      ownerId: sl(),
      ownerName: sl(),
    ),
  );

  //ForgotPasswordBloc
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  sl.registerFactory(() => ForgotPasswordBloc(sl()));

  //RecentBooksBloc
  sl.registerLazySingleton<RecentBooksLocalDataSource>(
    () => RecentBooksLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<RecentBooksRepository>(
    () => RecentBooksRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetRecentBooksUseCase(sl()));

  sl.registerLazySingleton(() => AddRecentBookUseCase(sl()));

  sl.registerLazySingleton(() => ClearRecentBooksUseCase(sl()));

  sl.registerFactory(
    () => RecentBooksBloc(
      getRecentBooksUseCase: sl(),
      addRecentBookUseCase: sl(),
      clearRecentBooksUseCase: sl(),
    ),
  );

    // SavedBooksBloc
  sl.registerLazySingleton<SavedBooksLocalDataSource>(
    () => SavedBooksLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<SavedBooksRepository>(
    () => SavedBooksRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetSavedBooksUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => SaveBookUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => RemoveSavedBookUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => ClearSavedBooksUseCase(sl()),
  );

  sl.registerFactory(
    () => SavedBooksBloc(
      getSavedBooksUseCase: sl(),
      saveBookUseCase: sl(),
      removeSavedBookUseCase: sl(),
      clearSavedBooksUseCase: sl(),
    ),
  );

  //RecentSearchBloc
  sl.registerLazySingleton<RecentSearchLocalDataSource>(
    () => RecentSearchLocalDataSource(),
  );

  sl.registerLazySingleton<RecentSearchRepository>(
    () => RecentSearchRepository(localDataSource: sl()),
  );

  sl.registerFactory<RecentSearchBloc>(
    () => RecentSearchBloc(repository: sl()),
  );

  //SearchBooksBloc
  sl.registerFactory<SearchBooksBloc>(() => SearchBooksBloc());
}
