import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/Platform/network_info.dart';
import 'features/bottom_nav/data/repos/bottom_nav_repo_impl.dart';
import 'features/bottom_nav/domain/repos/bottom_nav_repo.dart';
import 'features/bottom_nav/domain/usecases/navigate_to_category.dart';
import 'features/bottom_nav/domain/usecases/navigate_to_dashbaord.dart';
import 'features/bottom_nav/domain/usecases/navigate_to_news_feed.dart';
import 'features/bottom_nav/domain/usecases/navigate_to_privacy_laws.dart';
import 'features/bottom_nav/domain/usecases/navigate_to_privacy_tips.dart';
import 'features/bottom_nav/presentation/bloc/bottom_nav_bloc.dart';
import 'features/categories/data/datasources/apps_remote_datasource.dart';
import 'features/categories/data/datasources/categories_remote_datasource.dart';
import 'features/categories/data/repos/apps_repo_impl.dart';
import 'features/categories/data/repos/categories_repo_impl.dart';
import 'features/categories/domain/repos/apps_repo.dart';
import 'features/categories/domain/repos/categories_repo.dart';
import 'features/categories/domain/usecases/load_apps.dart';
import 'features/categories/domain/usecases/load_apps_search.dart';
import 'features/categories/domain/usecases/load_categories.dart';
import 'features/categories/presentation/bloc/apps_bloc.dart';
import 'features/categories/presentation/bloc/apps_search_bloc.dart';
import 'features/categories/presentation/bloc/categories_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repos/dashboard_repo_impl.dart';
import 'features/dashboard/domain/repos/dashboard_repo.dart';
import 'features/dashboard/domain/usecases/load_dashboard.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/interesting_news/data/datasources/interesting_news_remote_datasource.dart';
import 'features/interesting_news/data/repos/interestig_news_repo_impl.dart';
import 'features/interesting_news/domain/repos/interesting_news_repo.dart';
import 'features/interesting_news/domain/usecases/load_intersting_news.dart';
import 'features/interesting_news/presentation/bloc/interesting_news_bloc.dart';
import 'features/login_screen/data/datasources/login_screen_local_datasource.dart';
import 'features/login_screen/data/datasources/login_screen_remote_datasource.dart';
import 'features/login_screen/data/repos/login_screen_repo_impl.dart';
import 'features/login_screen/domain/repos/login_screen_repo.dart';
import 'features/login_screen/domain/usecases/get_facebook_login.dart'
    as fbLoginScreen;
import 'features/login_screen/domain/usecases/get_google_login.dart'
    as gLoginScreen;
import 'features/login_screen/domain/usecases/get_login.dart';
import 'features/login_screen/presentation/bloc/login_screen_bloc.dart';
import 'features/login_signup_screen/data/datasources/login_signup_screen_remote_datasource.dart';
import 'features/login_signup_screen/data/repos/login_signup_screen_repo_impl.dart';
import 'features/login_signup_screen/domain/repos/login_signup_screen_repo.dart';
import 'features/login_signup_screen/domain/usecases/get_facebook_login.dart';
import 'features/login_signup_screen/domain/usecases/get_google_login.dart';
import 'features/login_signup_screen/presentation/bloc/login_signup_screen_bloc.dart';
import 'features/privacy_laws/data/datasources/privacy_laws_remote_datasource.dart';
import 'features/privacy_laws/data/repos/privacy_laws_repo_impl.dart';
import 'features/privacy_laws/domain/repos/privacy_laws_repo.dart';
import 'features/privacy_laws/domain/usecases/load_privacy_laws.dart';
import 'features/privacy_laws/presentation/bloc/privacy_laws_bloc.dart';
import 'features/privacy_policy/data/datasources/privacy_policy_remote_datasource.dart';
import 'features/privacy_policy/data/repos/privacy_policy_repo_impl.dart';
import 'features/privacy_policy/domain/repos/privacy_policy_repo.dart';
import 'features/privacy_policy/domain/usecases/get_privacy_policy.dart';
import 'features/privacy_policy/presentation/bloc/privacy_policy_bloc.dart';
import 'features/privacy_tips/data/datasources/privacy_tips_remote_datasource.dart';
import 'features/privacy_tips/data/repos/privacy_tips_repo_impl.dart';
import 'features/privacy_tips/domain/repos/privacy_tips_repo.dart';
import 'features/privacy_tips/domain/usecases/load_privacy_tips.dart';
import 'features/privacy_tips/presentation/bloc/privacy_tips_bloc.dart';
import 'features/signup_screen/data/datasources/signup_screen_remote_datasource.dart';
import 'features/signup_screen/data/repos/signup_screen_repo_impl.dart';
import 'features/signup_screen/domain/repos/signup_screen_repo.dart';
import 'features/signup_screen/domain/usecases/get_signup.dart';
import 'features/signup_screen/presentation/bloc/signup_screen_bloc.dart';
import 'features/splash_screen/data/datasources/splash_screen_local_datasource.dart';
import 'features/splash_screen/data/repos/splash_screen_repo_impl.dart';
import 'features/splash_screen/domain/repos/splash_screen_repo.dart';
import 'features/splash_screen/domain/usecases/auto_login.dart';
import 'features/splash_screen/domain/usecases/navigate_to_login_screen.dart';
import 'features/splash_screen/presentation/bloc/splash_screen_bloc.dart';
import 'features/suggestion/data/datasources/suggestion_remote_datasource.dart';
import 'features/suggestion/data/repos/suggestion_repo_impl.dart';
import 'features/suggestion/domain/repos/suggestion_repo.dart';
import 'features/suggestion/domain/usecases/send_suggestion.dart';
import 'features/suggestion/presentation/bloc/suggestion_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! Features - splash_screen

  //* Bloc
  sl.registerFactory(
    () => SplashScreenBloc(
      navigateToMainScreen: sl(),
      autoLogin: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => NavigateToLoginScreen(
      splashScreenRepo: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AutoLogin(
      splashScreenRepo: sl(),
    ),
  );
  //* repo

  sl.registerLazySingleton<SplashScreenRepo>(
    () => SplashScreenRepoImpl(
      networkInfo: sl(),
      splashScreenLocalDataSource: sl(),
    ),
  );

  //* datascources
  sl.registerLazySingleton<SplashScreenLocalDataSource>(
      () => SplashScreenLocalDataSourceImpl(sharedPreferences: sl()));

  //! Features - login_signup_screen

  //* Bloc
  sl.registerFactory(
    () => LoginSignupScreenBloc(
      getFacebookLogin: sl(),
      getGoogleLogin: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => GetGoogleLogin(
      loginSignuScreenRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetFacebookLogin(
      loginSignuScreenRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<LoginSignuScreenRepo>(
    () => LoginSignupScreenRepoImpl(
      networkInfo: sl(),
      loginSignupScreenRemoteDataSource: sl(),
      loginScreenLocalDataSource: sl(),
    ),
  );

  //* datascources
  sl.registerLazySingleton<LoginSignupScreenRemoteDataSource>(
      () => LoginSignupScreenRemoteDataSourceImpl(httpClient: sl()));

  //! Features - login_screen

  //* Bloc
  sl.registerFactory(
    () => LoginScreenBloc(
      getFacebookLogin: sl(),
      getGoogleLogin: sl(),
      getLogin: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => fbLoginScreen.GetFacebookLogin(
      loginScreenRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => gLoginScreen.GetGoogleLogin(
      loginRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetLogin(
      repo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<LoginScreenRepo>(
    () => LoginScreenRepoImpl(
      networkInfo: sl(),
      loginSignuScreenRepo: sl(),
      loginScreenRemoteDataSource: sl(),
      loginScreenLocalDataSource: sl(),
    ),
  );

  //* datasource
  sl.registerLazySingleton<LoginScreenRemoteDataSource>(
      () => LoginScreenRemoteDataSourceImpl(httpClient: sl()));
  sl.registerLazySingleton<LoginScreenLocalDataSource>(
      () => LoginScreenLocalDataSourceImpl(sharedPreferences: sl()));

  //! Features - signup_screen

  //* Bloc
  sl.registerFactory(
    () => SignupScreenBloc(
      getSignup: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => GetSignup(
      signupRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<SignupScreenRepo>(
    () => SignupScreenRepoImpl(
        networkInfo: sl(), signupScreenRemoteDataSource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<SignupScreenRemoteDataSource>(
      () => SignupScreenRemoteDataSourceImpl(httpClient: sl()));

  //! Features - bottom_nav

  //* Bloc
  sl.registerFactory(
    () => BottomNavBloc(
      navigateToNewsFeed: sl(),
      navigateToCategory: sl(),
      navigateToDashboard: sl(),
      navigateToPrivacyLaws: sl(),
      navigateToPrivacyTips: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => NavigateToNewsFeed(
      bottomNavRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NavigateToCategory(
      bottomNavRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NavigateToDashboard(
      bottomNavRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NavigateToPrivacyTips(
      bottomNavRepo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NavigateToPrivacyLaws(
      bottomNavRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<BottomNavRepo>(
    () => BottomNavRepoImpl(networkInfo: sl()),
  );

  //* datasource

  //! Features - privacy_tips

  //* Bloc
  sl.registerFactory(
    () => PrivacyTipsBloc(
      loadPriavacyTips: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => LoadPriavacyTips(
      privacyTipsRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<PrivacyTipsRepo>(
    () => PrivacyTipsRepoImpl(
        networkInfo: sl(), privacyTipsRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<PrivacyTipsRemoteDatasource>(
      () => PrivacyTipsRemoteDatasourceImpl(httpClient: sl()));

  //! Features - Interesting_news

  //* Bloc
  sl.registerFactory(
    () => InterestingNewsBloc(
      loadInterestingNews: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => LoadInterestingNews(
      interestingNewsRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<InterestingNewsRepo>(
    () => InterestingNewsRepoImpl(
        networkInfo: sl(), interestingNewsRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<InterestingNewsRemoteDatasource>(
      () => InterestingNewsRemoteDatasourceImpl(httpClient: sl()));


  //! Feature - Dashboard

  //* Bloc
  sl.registerFactory(
    () => DashboardBloc(
      loadDashboard:  sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => LoadDashboard(
      dashboardRepo:  sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(
        networkInfo: sl(), dashboardRemoteDatasource:  sl()),
  );

  //* datasource
  sl.registerLazySingleton<DashboardRemoteDatasource>(
      () => DashboardRemoteDatasourceImpl(httpClient: sl()));


  //! Features - privacy_laws

  //* Bloc
  sl.registerFactory(
    () => PrivacyLawsBloc(
      loadPrivacyLaws: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => LoadPrivacyLaws(
      privacyLawsRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<PrivacyLawsRepo>(
    () => PrivacyLawsRepoImpl(
        networkInfo: sl(), privacyLawsRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<PrivacyLawsRemoteDatasource>(
      () => PrivacyLawsRemoteDatasourceImpl(httpClient: sl()));

  //! Features - suggestions

  //* Bloc
  sl.registerFactory(
    () => SuggestionBloc(
      sendSuggestion: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => SendSuggestion(
      suggestionRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<SuggestionRepo>(
    () =>
        SuggestionRepoImpl(networkInfo: sl(), suggestionRemoteDataSource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<SuggestionRemoteDataSource>(
      () => SuggestionRemoteDataSourceImpl(httpClient: sl()));


  //! Features - Categories

  //* Bloc
  sl.registerFactory(
        () => CategoriesBloc(
      loadCategories: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
        () => LoadCategories(
      categoriesRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<CategoriesRepo>(
        () => CategoriesRepoImpl(
        networkInfo: sl(), categoriesRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<CategoriesRemoteDatasource>(
          () => CategoriesRemoteDatasourceImpl(httpClient: sl()));

  //! Features - Categories - Apps

  //* Bloc
  sl.registerFactory(
        () => AppsBloc(
      loadApps: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
        () => LoadApps(
      appsRepo: sl(),
    ),
  );


  //* repo
  sl.registerLazySingleton<AppsRepo>(
        () => AppsRepoImpl(
        networkInfo: sl(), appsRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<AppsRemoteDatasource>(
          () => AppsRemoteDatasourceImpl(httpClient: sl()));


  //! Sub Features - Categories - Search Page
  //* Bloc
  sl.registerFactory(
        () => AppsSearchBloc(
      loadAppsSearch: sl(),

    ),
  );

  //* usecases
  sl.registerLazySingleton(
        () => LoadAppsSearch(
      appsRepo: sl(),
    ),
  );

  

  //! Features - privacy_policy

  //* Bloc
  sl.registerFactory(
    () => PrivacyPolicyBloc(
      getPriacyPolicy: sl(),
    ),
  );

  //* usecases
  sl.registerLazySingleton(
    () => GetPriacyPolicy(
      privacyPolicyRepo: sl(),
    ),
  );

  //* repo
  sl.registerLazySingleton<PrivacyPolicyRepo>(
    () => PrivacyPolicyRepoImpl(
        networkInfo: sl(), privacyPolicyRemoteDatasource: sl()),
  );

  //* datasource
  sl.registerLazySingleton<PrivacyPolicyRemoteDatasource>(
      () => PrivacyPolicyRemoteDatasourceImpl(httpClient: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External Libraries
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerFactory(() => http.Client());
}
