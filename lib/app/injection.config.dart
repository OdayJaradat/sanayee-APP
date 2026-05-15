// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sanayee_app/app/supabase_module.dart' as _i29;
import 'package:sanayee_app/core/services/storage_service.dart' as _i779;
import 'package:sanayee_app/core/services/storage_service_supabase.dart'
    as _i749;
import 'package:sanayee_app/features/auth/data/datasources/supabase_auth_datasource.dart'
    as _i375;
import 'package:sanayee_app/features/auth/data/repositories/user_repository_supabase.dart'
    as _i966;
import 'package:sanayee_app/features/auth/domain/repositories/user_repository.dart'
    as _i918;
import 'package:sanayee_app/features/auth/domain/usecases/get_current_user.dart'
    as _i285;
import 'package:sanayee_app/features/auth/domain/usecases/get_current_user_role.dart'
    as _i872;
import 'package:sanayee_app/features/auth/domain/usecases/sign_in_with_email.dart'
    as _i990;
import 'package:sanayee_app/features/auth/domain/usecases/sign_in_with_phone.dart'
    as _i491;
import 'package:sanayee_app/features/auth/domain/usecases/sign_out.dart'
    as _i389;
import 'package:sanayee_app/features/auth/domain/usecases/sign_up_with_email.dart'
    as _i121;
import 'package:sanayee_app/features/auth/domain/usecases/verify_phone_otp.dart'
    as _i1057;
import 'package:sanayee_app/features/auth/presentation/cubit/auth_cubit.dart'
    as _i892;
import 'package:sanayee_app/features/chat/data/datasources/chat_supabase_datasource.dart'
    as _i339;
import 'package:sanayee_app/features/chat/data/repositories/chat_repository_supabase.dart'
    as _i564;
import 'package:sanayee_app/features/chat/domain/repositories/chat_repository.dart'
    as _i635;
import 'package:sanayee_app/features/chat/domain/usecases/ensure_conversation_for.dart'
    as _i567;
import 'package:sanayee_app/features/chat/domain/usecases/list_conversations.dart'
    as _i632;
import 'package:sanayee_app/features/chat/domain/usecases/list_messages.dart'
    as _i987;
import 'package:sanayee_app/features/chat/domain/usecases/mark_as_read.dart'
    as _i991;
import 'package:sanayee_app/features/chat/domain/usecases/send_message.dart'
    as _i255;
import 'package:sanayee_app/features/chat/domain/usecases/stream_conversations.dart'
    as _i7;
import 'package:sanayee_app/features/chat/domain/usecases/stream_messages.dart'
    as _i973;
import 'package:sanayee_app/features/chat/presentation/cubit/chat_list_cubit.dart'
    as _i848;
import 'package:sanayee_app/features/chat/presentation/cubit/chat_room_cubit.dart'
    as _i78;
import 'package:sanayee_app/features/hiring/data/datasources/hiring_posts_supabase_datasource.dart'
    as _i484;
import 'package:sanayee_app/features/hiring/data/repositories/hiring_posts_repository_supabase.dart'
    as _i224;
import 'package:sanayee_app/features/hiring/data/repositories/localities_repository.dart'
    as _i1047;
import 'package:sanayee_app/features/hiring/domain/repositories/hiring_posts_repository.dart'
    as _i319;
import 'package:sanayee_app/features/hiring/domain/usecases/close_hiring_post.dart'
    as _i381;
import 'package:sanayee_app/features/hiring/domain/usecases/create_hiring_post.dart'
    as _i1054;
import 'package:sanayee_app/features/hiring/domain/usecases/delete_hiring_post.dart'
    as _i486;
import 'package:sanayee_app/features/hiring/domain/usecases/ensure_conversation_for_hiring.dart'
    as _i684;
import 'package:sanayee_app/features/hiring/domain/usecases/list_my_hiring_posts.dart'
    as _i509;
import 'package:sanayee_app/features/hiring/domain/usecases/list_open_hiring_posts.dart'
    as _i346;
import 'package:sanayee_app/features/hiring/domain/usecases/reopen_hiring_post.dart'
    as _i186;
import 'package:sanayee_app/features/hiring/presentation/cubit/hiring_posts_cubit.dart'
    as _i365;
import 'package:sanayee_app/features/notifications/domain/services/notification_service.dart'
    as _i395;
import 'package:sanayee_app/features/professionals/data/datasources/offers_supabase_datasource.dart'
    as _i947;
import 'package:sanayee_app/features/professionals/data/datasources/professionals_supabase_datasource.dart'
    as _i250;
import 'package:sanayee_app/features/professionals/data/repositories/offers_repository_supabase.dart'
    as _i132;
import 'package:sanayee_app/features/professionals/data/repositories/professionals_repository_supabase.dart'
    as _i29;
import 'package:sanayee_app/features/professionals/domain/repositories/offers_repository.dart'
    as _i1023;
import 'package:sanayee_app/features/professionals/domain/repositories/professionals_repository.dart'
    as _i1001;
import 'package:sanayee_app/features/professionals/domain/usecases/accept_counter_offer.dart'
    as _i719;
import 'package:sanayee_app/features/professionals/domain/usecases/accept_offer.dart'
    as _i984;
import 'package:sanayee_app/features/professionals/domain/usecases/counter_offer.dart'
    as _i562;
import 'package:sanayee_app/features/professionals/domain/usecases/decline_offer.dart'
    as _i752;
import 'package:sanayee_app/features/professionals/domain/usecases/fetch_open_requests.dart'
    as _i39;
import 'package:sanayee_app/features/professionals/domain/usecases/get_professional_by_id.dart'
    as _i583;
import 'package:sanayee_app/features/professionals/domain/usecases/list_active_jobs.dart'
    as _i158;
import 'package:sanayee_app/features/professionals/domain/usecases/list_my_offers.dart'
    as _i718;
import 'package:sanayee_app/features/professionals/domain/usecases/list_offers.dart'
    as _i761;
import 'package:sanayee_app/features/professionals/domain/usecases/mark_job_ready.dart'
    as _i516;
import 'package:sanayee_app/features/professionals/domain/usecases/submit_offer.dart'
    as _i714;
import 'package:sanayee_app/features/professionals/domain/usecases/withdraw_offer.dart'
    as _i603;
import 'package:sanayee_app/features/professionals/presentation/cubit/active_jobs_cubit.dart'
    as _i238;
import 'package:sanayee_app/features/professionals/presentation/cubit/my_offers_cubit.dart'
    as _i343;
import 'package:sanayee_app/features/professionals/presentation/cubit/pro_profile_cubit.dart'
    as _i947;
import 'package:sanayee_app/features/professionals/presentation/cubit/pros_jobs_cubit.dart'
    as _i885;
import 'package:sanayee_app/features/profile/data/datasources/profile_supabase_datasource.dart'
    as _i531;
import 'package:sanayee_app/features/profile/data/repositories/profile_repository_supabase.dart'
    as _i516;
import 'package:sanayee_app/features/profile/data/repositories/session_repository_hive.dart'
    as _i91;
import 'package:sanayee_app/features/profile/domain/repositories/profile_repository.dart'
    as _i925;
import 'package:sanayee_app/features/profile/domain/repositories/session_repository.dart'
    as _i14;
import 'package:sanayee_app/features/profile/domain/usecases/get_current_role.dart'
    as _i98;
import 'package:sanayee_app/features/profile/domain/usecases/switch_role.dart'
    as _i695;
import 'package:sanayee_app/features/ratings/data/datasources/ratings_supabase_datasource.dart'
    as _i651;
import 'package:sanayee_app/features/ratings/data/repositories/ratings_repository_supabase.dart'
    as _i303;
import 'package:sanayee_app/features/ratings/domain/repositories/ratings_repository.dart'
    as _i160;
import 'package:sanayee_app/features/ratings/domain/usecases/add_rating_use_case.dart'
    as _i805;
import 'package:sanayee_app/features/ratings/domain/usecases/get_ratings_for_professional_use_case.dart'
    as _i1050;
import 'package:sanayee_app/features/ratings/presentation/cubit/professional_ratings_cubit.dart'
    as _i648;
import 'package:sanayee_app/features/ratings/presentation/cubit/rating_cubit.dart'
    as _i1068;
import 'package:sanayee_app/features/requests/data/datasources/requests_supabase_datasource.dart'
    as _i61;
import 'package:sanayee_app/features/requests/data/repositories/filters_repository_hive.dart'
    as _i429;
import 'package:sanayee_app/features/requests/data/repositories/requests_repository_supabase.dart'
    as _i1015;
import 'package:sanayee_app/features/requests/domain/repositories/filters_repository.dart'
    as _i414;
import 'package:sanayee_app/features/requests/domain/repositories/requests_repository.dart'
    as _i116;
import 'package:sanayee_app/features/requests/domain/usecases/apply_filters_to_requests.dart'
    as _i67;
import 'package:sanayee_app/features/requests/domain/usecases/clear_filters.dart'
    as _i525;
import 'package:sanayee_app/features/requests/domain/usecases/close_request.dart'
    as _i1050;
import 'package:sanayee_app/features/requests/domain/usecases/confirm_job_completion.dart'
    as _i987;
import 'package:sanayee_app/features/requests/domain/usecases/create_request.dart'
    as _i85;
import 'package:sanayee_app/features/requests/domain/usecases/delete_request.dart'
    as _i106;
import 'package:sanayee_app/features/requests/domain/usecases/find_nearest_professional.dart'
    as _i730;
import 'package:sanayee_app/features/requests/domain/usecases/get_current_position.dart'
    as _i257;
import 'package:sanayee_app/features/requests/domain/usecases/get_request_by_id.dart'
    as _i193;
import 'package:sanayee_app/features/requests/domain/usecases/load_filters.dart'
    as _i187;
import 'package:sanayee_app/features/requests/domain/usecases/mark_request_completed.dart'
    as _i306;
import 'package:sanayee_app/features/requests/domain/usecases/reject_job_completion.dart'
    as _i833;
import 'package:sanayee_app/features/requests/domain/usecases/save_filters.dart'
    as _i554;
import 'package:sanayee_app/features/requests/presentation/cubit/create_request_cubit.dart'
    as _i139;
import 'package:sanayee_app/features/requests/presentation/cubit/request_details_cubit.dart'
    as _i852;
import 'package:sanayee_app/features/requests/presentation/cubit/requests_cubit.dart'
    as _i618;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final supabaseModule = _$SupabaseModule();
    gh.factory<_i67.ApplyFiltersToRequests>(
      () => _i67.ApplyFiltersToRequests(),
    );
    gh.factory<_i257.GetCurrentPosition>(() => _i257.GetCurrentPosition());
    gh.singleton<_i1047.LocalitiesRepository>(
      () => _i1047.LocalitiesRepository(),
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => supabaseModule.localNotifications,
    );
    gh.lazySingleton<_i395.NotificationService>(
      () => _i395.NotificationService(),
    );
    gh.factory<_i339.ChatSupabaseDataSource>(
      () => _i339.ChatSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i484.HiringPostsSupabaseDataSource>(
      () => _i484.HiringPostsSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i375.SupabaseAuthDataSource>(
      () => _i375.SupabaseAuthDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i531.ProfileSupabaseDataSource>(
      () => _i531.ProfileSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i414.FiltersRepository>(
      () => _i429.FiltersRepositoryHive(),
    );
    gh.lazySingleton<_i635.ChatRepository>(
      () => _i564.ChatRepositorySupabase(gh<_i339.ChatSupabaseDataSource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i14.SessionRepository>(
      () => _i91.SessionRepositoryHive(),
    );
    gh.lazySingleton<_i947.OffersSupabaseDataSource>(
      () => _i947.OffersSupabaseDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i395.NotificationService>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i61.RequestsSupabaseDataSource>(
      () => _i61.RequestsSupabaseDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i395.NotificationService>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i98.GetCurrentRole>(
      () => _i98.GetCurrentRole(gh<_i14.SessionRepository>()),
    );
    gh.factory<_i695.SwitchRole>(
      () => _i695.SwitchRole(gh<_i14.SessionRepository>()),
    );
    gh.factory<_i684.EnsureConversationForHiring>(
      () => _i684.EnsureConversationForHiring(gh<_i635.ChatRepository>()),
    );
    gh.factory<_i567.EnsureConversationFor>(
      () => _i567.EnsureConversationFor(gh<_i635.ChatRepository>()),
    );
    gh.factory<_i632.ListConversations>(
      () => _i632.ListConversations(gh<_i635.ChatRepository>()),
    );
    gh.factory<_i987.ListMessages>(
      () => _i987.ListMessages(gh<_i635.ChatRepository>()),
    );
    gh.factory<_i255.SendMessage>(
      () => _i255.SendMessage(gh<_i635.ChatRepository>()),
    );
    gh.lazySingleton<_i991.MarkAsRead>(
      () => _i991.MarkAsRead(gh<_i635.ChatRepository>()),
    );
    gh.lazySingleton<_i7.StreamConversations>(
      () => _i7.StreamConversations(gh<_i635.ChatRepository>()),
    );
    gh.lazySingleton<_i973.StreamMessages>(
      () => _i973.StreamMessages(gh<_i635.ChatRepository>()),
    );
    gh.factory<_i525.ClearFilters>(
      () => _i525.ClearFilters(gh<_i414.FiltersRepository>()),
    );
    gh.factory<_i187.LoadFilters>(
      () => _i187.LoadFilters(gh<_i414.FiltersRepository>()),
    );
    gh.factory<_i554.SaveFilters>(
      () => _i554.SaveFilters(gh<_i414.FiltersRepository>()),
    );
    gh.lazySingleton<_i918.UserRepository>(
      () => _i966.UserRepositorySupabase(gh<_i375.SupabaseAuthDataSource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i779.StorageService>(
      () => _i749.StorageServiceSupabase(gh<_i454.SupabaseClient>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i925.ProfileRepository>(
      () => _i516.ProfileRepositorySupabase(
        gh<_i531.ProfileSupabaseDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i651.RatingsSupabaseDataSource>(
      () => _i651.RatingsSupabaseDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i395.NotificationService>(),
      ),
    );
    gh.lazySingleton<_i250.ProfessionalsSupabaseDataSource>(
      () => _i250.ProfessionalsSupabaseDataSource(gh<_i454.SupabaseClient>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i116.RequestsRepository>(
      () => _i1015.RequestsRepositorySupabase(
        gh<_i61.RequestsSupabaseDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i319.HiringPostsRepository>(
      () => _i224.HiringPostsRepositorySupabase(
        gh<_i484.HiringPostsSupabaseDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i78.ChatRoomCubit>(
      () => _i78.ChatRoomCubit(
        gh<_i973.StreamMessages>(),
        gh<_i255.SendMessage>(),
        gh<_i991.MarkAsRead>(),
      ),
    );
    gh.factory<_i984.AcceptOffer>(
      () => _i984.AcceptOffer(
        gh<_i116.RequestsRepository>(),
        gh<_i567.EnsureConversationFor>(),
      ),
    );
    gh.factory<_i39.FetchOpenRequests>(
      () => _i39.FetchOpenRequests(gh<_i116.RequestsRepository>()),
    );
    gh.factory<_i85.CreateRequest>(
      () => _i85.CreateRequest(gh<_i116.RequestsRepository>()),
    );
    gh.factory<_i106.DeleteRequest>(
      () => _i106.DeleteRequest(gh<_i116.RequestsRepository>()),
    );
    gh.factory<_i193.GetRequestById>(
      () => _i193.GetRequestById(gh<_i116.RequestsRepository>()),
    );
    gh.factory<_i306.MarkRequestCompleted>(
      () => _i306.MarkRequestCompleted(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i158.ListActiveJobs>(
      () => _i158.ListActiveJobs(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i516.MarkJobReady>(
      () => _i516.MarkJobReady(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i1050.CloseRequest>(
      () => _i1050.CloseRequest(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i987.ConfirmJobCompletion>(
      () => _i987.ConfirmJobCompletion(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i833.RejectJobCompletion>(
      () => _i833.RejectJobCompletion(gh<_i116.RequestsRepository>()),
    );
    gh.lazySingleton<_i1023.OffersRepository>(
      () =>
          _i132.OffersRepositorySupabase(gh<_i947.OffersSupabaseDataSource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i285.GetCurrentUser>(
      () => _i285.GetCurrentUser(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i872.GetCurrentUserRole>(
      () => _i872.GetCurrentUserRole(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i990.SignInWithEmail>(
      () => _i990.SignInWithEmail(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i491.SignInWithPhone>(
      () => _i491.SignInWithPhone(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i389.SignOut>(
      () => _i389.SignOut(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i121.SignUpWithEmail>(
      () => _i121.SignUpWithEmail(gh<_i918.UserRepository>()),
    );
    gh.lazySingleton<_i1057.VerifyPhoneOtp>(
      () => _i1057.VerifyPhoneOtp(gh<_i918.UserRepository>()),
    );
    gh.factory<_i238.ActiveJobsCubit>(
      () => _i238.ActiveJobsCubit(
        gh<_i158.ListActiveJobs>(),
        gh<_i516.MarkJobReady>(),
      ),
    );
    gh.factory<_i719.AcceptCounterOffer>(
      () => _i719.AcceptCounterOffer(gh<_i1023.OffersRepository>()),
    );
    gh.factory<_i562.CounterOffer>(
      () => _i562.CounterOffer(gh<_i1023.OffersRepository>()),
    );
    gh.factory<_i752.DeclineOffer>(
      () => _i752.DeclineOffer(gh<_i1023.OffersRepository>()),
    );
    gh.factory<_i761.ListOffers>(
      () => _i761.ListOffers(gh<_i1023.OffersRepository>()),
    );
    gh.factory<_i714.SubmitOffer>(
      () => _i714.SubmitOffer(gh<_i1023.OffersRepository>()),
    );
    gh.lazySingleton<_i718.ListMyOffers>(
      () => _i718.ListMyOffers(gh<_i1023.OffersRepository>()),
    );
    gh.lazySingleton<_i603.WithdrawOffer>(
      () => _i603.WithdrawOffer(gh<_i1023.OffersRepository>()),
    );
    gh.factory<_i852.RequestDetailsCubit>(
      () => _i852.RequestDetailsCubit(
        gh<_i193.GetRequestById>(),
        gh<_i106.DeleteRequest>(),
        gh<_i761.ListOffers>(),
        gh<_i984.AcceptOffer>(),
        gh<_i752.DeclineOffer>(),
        gh<_i562.CounterOffer>(),
        gh<_i306.MarkRequestCompleted>(),
        gh<_i987.ConfirmJobCompletion>(),
        gh<_i833.RejectJobCompletion>(),
        gh<_i1050.CloseRequest>(),
      ),
    );
    gh.lazySingleton<_i160.RatingsRepository>(
      () => _i303.RatingsRepositorySupabase(
        gh<_i651.RatingsSupabaseDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i139.CreateRequestCubit>(
      () => _i139.CreateRequestCubit(
        gh<_i85.CreateRequest>(),
        gh<_i285.GetCurrentUser>(),
        gh<_i779.StorageService>(),
      ),
    );
    gh.factory<_i892.AuthCubit>(
      () => _i892.AuthCubit(
        gh<_i990.SignInWithEmail>(),
        gh<_i121.SignUpWithEmail>(),
        gh<_i491.SignInWithPhone>(),
        gh<_i1057.VerifyPhoneOtp>(),
        gh<_i389.SignOut>(),
        gh<_i285.GetCurrentUser>(),
      ),
    );
    gh.factory<_i848.ChatListCubit>(
      () => _i848.ChatListCubit(
        gh<_i7.StreamConversations>(),
        gh<_i193.GetRequestById>(),
        gh<_i285.GetCurrentUser>(),
        gh<_i925.ProfileRepository>(),
        gh<_i635.ChatRepository>(),
      ),
    );
    gh.lazySingleton<_i1001.ProfessionalsRepository>(
      () => _i29.ProfessionalsRepositorySupabase(
        gh<_i250.ProfessionalsSupabaseDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i618.RequestsCubit>(
      () => _i618.RequestsCubit(
        gh<_i116.RequestsRepository>(),
        gh<_i285.GetCurrentUser>(),
        gh<_i1050.CloseRequest>(),
      ),
    );
    gh.factory<_i381.CloseHiringPost>(
      () => _i381.CloseHiringPost(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i1054.CreateHiringPost>(
      () => _i1054.CreateHiringPost(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i486.DeleteHiringPost>(
      () => _i486.DeleteHiringPost(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i509.ListMyHiringPosts>(
      () => _i509.ListMyHiringPosts(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i346.ListOpenHiringPosts>(
      () => _i346.ListOpenHiringPosts(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i186.ReopenHiringPost>(
      () => _i186.ReopenHiringPost(gh<_i319.HiringPostsRepository>()),
    );
    gh.factory<_i885.ProsJobsCubit>(
      () => _i885.ProsJobsCubit(
        gh<_i39.FetchOpenRequests>(),
        gh<_i714.SubmitOffer>(),
        gh<_i187.LoadFilters>(),
        gh<_i554.SaveFilters>(),
        gh<_i525.ClearFilters>(),
        gh<_i67.ApplyFiltersToRequests>(),
      ),
    );
    gh.factory<_i343.MyOffersCubit>(
      () => _i343.MyOffersCubit(
        gh<_i718.ListMyOffers>(),
        gh<_i603.WithdrawOffer>(),
        gh<_i719.AcceptCounterOffer>(),
      ),
    );
    gh.factory<_i730.FindNearestProfessional>(
      () => _i730.FindNearestProfessional(gh<_i1001.ProfessionalsRepository>()),
    );
    gh.factory<_i805.AddRatingUseCase>(
      () => _i805.AddRatingUseCase(gh<_i160.RatingsRepository>()),
    );
    gh.factory<_i1050.GetRatingsForProfessionalUseCase>(
      () => _i1050.GetRatingsForProfessionalUseCase(
        gh<_i160.RatingsRepository>(),
      ),
    );
    gh.factory<_i583.GetProfessionalById>(
      () => _i583.GetProfessionalById(gh<_i1001.ProfessionalsRepository>()),
    );
    gh.factory<_i1068.RatingCubit>(
      () => _i1068.RatingCubit(
        gh<_i805.AddRatingUseCase>(),
        gh<_i1050.GetRatingsForProfessionalUseCase>(),
      ),
    );
    gh.factory<_i365.HiringPostsCubit>(
      () => _i365.HiringPostsCubit(
        gh<_i1054.CreateHiringPost>(),
        gh<_i381.CloseHiringPost>(),
        gh<_i186.ReopenHiringPost>(),
        gh<_i486.DeleteHiringPost>(),
        gh<_i509.ListMyHiringPosts>(),
        gh<_i346.ListOpenHiringPosts>(),
      ),
    );
    gh.factory<_i648.ProfessionalRatingsCubit>(
      () => _i648.ProfessionalRatingsCubit(
        gh<_i1050.GetRatingsForProfessionalUseCase>(),
      ),
    );
    gh.factory<_i947.ProProfileCubit>(
      () => _i947.ProProfileCubit(
        gh<_i583.GetProfessionalById>(),
        gh<_i1001.ProfessionalsRepository>(),
      ),
    );
    return this;
  }
}

class _$SupabaseModule extends _i29.SupabaseModule {}
