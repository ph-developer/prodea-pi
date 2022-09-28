import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import 'presentation/guards/auth_guard.dart';
import 'presentation/guards/guest_guard.dart';
import 'presentation/pages/account/profile_page.dart';
import 'presentation/pages/admin/admin_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/main_page.dart';
import 'data/repositories/local/json_city_local_repo.dart';
import 'data/repositories/remote/firebase_auth_remote_repo.dart';
import 'data/repositories/remote/firebase_donation_remote_repo.dart';
import 'data/repositories/remote/firebase_file_remote_repo.dart';
import 'data/repositories/remote/firebase_user_remote_repo.dart';
import 'data/services/asuka_notification_service.dart';
import 'data/services/connectivity_network_service.dart';
import 'data/services/image_picker_photo_service.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/repositories/city_repo.dart';
import 'domain/repositories/donation_repo.dart';
import 'domain/repositories/file_repo.dart';
import 'domain/repositories/user_repo.dart';
import 'domain/services/network_service.dart';
import 'domain/services/notification_service.dart';
import 'domain/services/photo_service.dart';
import 'domain/usecases/auth/do_login.dart';
import 'domain/usecases/auth/do_logout.dart';
import 'domain/usecases/auth/do_register.dart';
import 'domain/usecases/auth/get_current_user.dart';
import 'domain/usecases/auth/send_password_reset_email.dart';
import 'domain/usecases/cities/get_city_names.dart';
import 'domain/usecases/donations/create_donation.dart';
import 'domain/usecases/donations/get_available_donations.dart';
import 'domain/usecases/donations/get_donation_photo_url.dart';
import 'domain/usecases/donations/get_my_donations.dart';
import 'domain/usecases/donations/get_requested_donations.dart';
import 'domain/usecases/donations/set_donation_as_canceled.dart';
import 'domain/usecases/donations/set_donation_as_delivered.dart';
import 'domain/usecases/donations/set_donation_as_requested.dart';
import 'domain/usecases/donations/set_donation_as_unrequested.dart';
import 'domain/usecases/network/get_connection_status.dart';
import 'domain/usecases/photo/pick_photo_from_camera.dart';
import 'domain/usecases/photo/pick_photo_from_gallery.dart';
import 'domain/usecases/user/get_beneficiaries.dart';
import 'domain/usecases/user/get_common_users.dart';
import 'domain/usecases/user/get_donors.dart';
import 'domain/usecases/user/get_user_by_id.dart';
import 'domain/usecases/user/set_user_as_authorized.dart';
import 'domain/usecases/user/set_user_as_denied.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/connection_state_controller.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/stores/cities_store.dart';
import 'presentation/stores/donation_store.dart';
import 'presentation/stores/donations_store.dart';
import 'presentation/stores/user_store.dart';
import 'presentation/stores/users_store.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        //! Firebase
        Bind.instance<FirebaseAuth>(FirebaseAuth.instance),
        Bind.instance<FirebaseStorage>(FirebaseStorage.instance),
        Bind.instance<FirebaseFirestore>(FirebaseFirestore.instance),

        //! Third-Party
        Bind.factory<Connectivity>((i) => Connectivity()),
        Bind.factory<ImagePicker>((i) => ImagePicker()),

        //! Repositories
        Bind.factory<IAuthRepo>((i) => FirebaseAuthRemoteRepo(i())),
        Bind.factory<ICityRepo>((i) => JsonCityLocalRepo()),
        Bind.factory<IDonationRepo>((i) => FirebaseDonationRemoteRepo(i())),
        Bind.factory<IFileRepo>((i) => FirebaseFileRemoteRepo(i())),
        Bind.factory<IUserRepo>((i) => FirebaseUserRemoteRepo(i())),

        //! Services
        Bind.factory<INetworkService>((i) => ConnectivityNetworkService(i())),
        Bind.factory<IPhotoService>((i) => ImagePickerPhotoService(i())),
        Bind.factory<INotificationService>((i) => AsukaNotificationService()),

        //! Usecases
        Bind.factory<DoLogin>((i) => DoLogin(i(), i(), i())),
        Bind.factory<DoLogout>((i) => DoLogout(i(), i())),
        Bind.factory<DoRegister>((i) => DoRegister(i(), i(), i())),
        Bind.factory<GetCurrentUser>((i) => GetCurrentUser(i(), i(), i())),
        Bind.factory<SendPasswordResetEmail>(
            (i) => SendPasswordResetEmail(i(), i())),
        Bind.factory<GetCityNames>((i) => GetCityNames(i())),
        Bind.factory<CreateDonation>((i) => CreateDonation(i(), i(), i(), i())),
        Bind.factory<GetAvailableDonations>((i) => GetAvailableDonations(i())),
        Bind.factory<GetDonationPhotoUrl>((i) => GetDonationPhotoUrl(i(), i())),
        Bind.factory<GetMyDonations>((i) => GetMyDonations(i(), i())),
        Bind.factory<GetRequestedDonations>(
            (i) => GetRequestedDonations(i(), i())),
        Bind.factory<SetDonationAsCanceled>(
            (i) => SetDonationAsCanceled(i(), i())),
        Bind.factory<SetDonationAsDelivered>(
            (i) => SetDonationAsDelivered(i(), i())),
        Bind.factory<SetDonationAsRequested>(
            (i) => SetDonationAsRequested(i(), i(), i())),
        Bind.factory<SetDonationAsUnrequested>(
            (i) => SetDonationAsUnrequested(i(), i())),
        Bind.factory<GetConnectionStatus>((i) => GetConnectionStatus(i(), i())),
        Bind.factory<PickPhotoFromCamera>((i) => PickPhotoFromCamera(i(), i())),
        Bind.factory<PickPhotoFromGallery>(
            (i) => PickPhotoFromGallery(i(), i())),
        Bind.factory<GetBeneficiaries>((i) => GetBeneficiaries(i())),
        Bind.factory<GetCommonUsers>((i) => GetCommonUsers(i())),
        Bind.factory<GetDonors>((i) => GetDonors(i())),
        Bind.factory<GetUserById>((i) => GetUserById(i(), i())),
        Bind.factory<SetUserAsAuthorized>((i) => SetUserAsAuthorized(i(), i())),
        Bind.factory<SetUserAsDenied>((i) => SetUserAsDenied(i(), i())),

        //! Controllers
        Bind.singleton<AuthController>(
            (i) => AuthController(i(), i(), i(), i(), i())),
        Bind.singleton<ConnectionStateController>(
            (i) => ConnectionStateController(i())),

        //! Stores
        Bind.singleton<CitiesStore>((i) => CitiesStore(i())),
        Bind.factory<DonationStore>((i) => DonationStore(i(), i(), i())),
        Bind.singleton<DonationsStore>(
            (i) => DonationsStore(i(), i(), i(), i(), i(), i(), i(), i())),
        Bind.factory<UserStore>((i) => UserStore()),
        Bind.singleton<UsersStore>((i) => UsersStore(i(), i(), i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        RedirectRoute('/', to: '/login'),
        ChildRoute(
          '/login',
          child: (_, __) => const LoginPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/register',
          child: (_, __) => const RegisterPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/forgot',
          child: (_, __) => const ForgotPasswordPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/main',
          child: (_, __) => const MainPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/admin',
          child: (_, __) => const AdminPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/profile',
          child: (_, __) => const ProfilePage(),
          guards: [AuthGuard()],
        ),
      ];
}
