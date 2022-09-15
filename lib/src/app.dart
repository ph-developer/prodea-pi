import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import 'data/repositories/local/json_city_local_repo.dart';
import 'data/repositories/remote/firebase_auth_remote_repo.dart';
import 'data/repositories/remote/firebase_donation_remote_repo.dart';
import 'data/repositories/remote/firebase_file_remote_repo.dart';
import 'data/repositories/remote/firebase_user_info_remote_repo.dart';
import 'data/services/connectivity_network_service.dart';
import 'data/services/image_picker_photo_service.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/repositories/city_repo.dart';
import 'domain/repositories/donation_repo.dart';
import 'domain/repositories/file_repo.dart';
import 'domain/repositories/user_info_repo.dart';
import 'domain/services/network_service.dart';
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
import 'domain/usecases/user_infos/get_beneficiaries_info.dart';
import 'domain/usecases/user_infos/get_common_users_info.dart';
import 'domain/usecases/user_infos/get_donors_info.dart';
import 'domain/usecases/user_infos/get_user_info_by_id.dart';
import 'domain/usecases/user_infos/set_user_info_as_authorized.dart';
import 'domain/usecases/user_infos/set_user_info_as_denied.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/connection_state_controller.dart';
import 'presentation/controllers/main_page_controller.dart';
import 'presentation/pages/account/profile_page.dart';
import 'presentation/pages/admin/admin_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/boot_page.dart';
import 'presentation/pages/main/available_donations_page.dart';
import 'presentation/pages/main/donate_page.dart';
import 'presentation/pages/main/my_donations_page.dart';
import 'presentation/pages/main/requested_donations_page.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/status/denied_page.dart';
import 'presentation/pages/status/waiting_page.dart';
import 'presentation/stores/cities_store.dart';
import 'presentation/stores/donation_store.dart';
import 'presentation/stores/donations_store.dart';
import 'presentation/stores/user_info_store.dart';
import 'presentation/stores/user_infos_store.dart';

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
        Bind.factory<IUserInfoRepo>((i) => FirebaseUserInfoRemoteRepo(i())),

        //! Services
        Bind.factory<INetworkService>((i) => ConnectivityNetworkService(i())),
        Bind.factory<IPhotoService>((i) => ImagePickerPhotoService(i())),

        //! Usecases
        Bind.factory<DoLogin>((i) => DoLogin(i())),
        Bind.factory<DoLogout>((i) => DoLogout(i())),
        Bind.factory<DoRegister>((i) => DoRegister(i(), i())),
        Bind.factory<GetCurrentUser>((i) => GetCurrentUser(i())),
        Bind.factory<SendPasswordResetEmail>(
            (i) => SendPasswordResetEmail(i())),
        Bind.factory<GetCityNames>((i) => GetCityNames(i())),
        Bind.factory<CreateDonation>((i) => CreateDonation(i(), i(), i())),
        Bind.factory<GetAvailableDonations>((i) => GetAvailableDonations(i())),
        Bind.factory<GetDonationPhotoUrl>((i) => GetDonationPhotoUrl(i())),
        Bind.factory<GetMyDonations>((i) => GetMyDonations(i(), i())),
        Bind.factory<GetRequestedDonations>(
            (i) => GetRequestedDonations(i(), i())),
        Bind.factory<SetDonationAsCanceled>((i) => SetDonationAsCanceled(i())),
        Bind.factory<SetDonationAsDelivered>(
            (i) => SetDonationAsDelivered(i())),
        Bind.factory<SetDonationAsRequested>(
            (i) => SetDonationAsRequested(i(), i())),
        Bind.factory<SetDonationAsUnrequested>(
            (i) => SetDonationAsUnrequested(i())),
        Bind.factory<GetConnectionStatus>((i) => GetConnectionStatus(i())),
        Bind.factory<PickPhotoFromCamera>((i) => PickPhotoFromCamera(i())),
        Bind.factory<PickPhotoFromGallery>((i) => PickPhotoFromGallery(i())),
        Bind.factory<GetBeneficiariesInfo>((i) => GetBeneficiariesInfo(i())),
        Bind.factory<GetCommonUsersInfo>((i) => GetCommonUsersInfo(i())),
        Bind.factory<GetDonorsInfo>((i) => GetDonorsInfo(i())),
        Bind.factory<GetUserInfoById>((i) => GetUserInfoById(i())),
        Bind.factory<SetUserInfoAsAuthorized>(
            (i) => SetUserInfoAsAuthorized(i())),
        Bind.factory<SetUserInfoAsDenied>((i) => SetUserInfoAsDenied(i())),

        //! Controllers
        Bind.singleton<AuthController>(
            (i) => AuthController(i(), i(), i(), i(), i(), i())),
        Bind.singleton<ConnectionStateController>(
            (i) => ConnectionStateController(i())),
        Bind.singleton<MainPageController>((i) => MainPageController(i(), i())),

        //! Stores
        Bind.singleton<CitiesStore>((i) => CitiesStore(i())),
        Bind.factory<DonationStore>((i) => DonationStore(i(), i(), i())),
        Bind.singleton<DonationsStore>(
            (i) => DonationsStore(i(), i(), i(), i(), i(), i(), i(), i())),
        Bind.factory<UserInfoStore>((i) => UserInfoStore()),
        Bind.singleton<UserInfosStore>(
            (i) => UserInfosStore(i(), i(), i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const BootPage()),
        ChildRoute('/login', child: (_, __) => const LoginPage()),
        ChildRoute('/register', child: (_, __) => const RegisterPage()),
        ChildRoute('/forgot', child: (_, __) => const ForgotPasswordPage()),
        ChildRoute('/main', child: (_, __) => const MainPage(), children: [
          ChildRoute(
            '/donate',
            child: (_, __) => const DonatePage(),
          ),
          ChildRoute(
            '/my-donations',
            child: (_, __) => const MyDonationsPage(),
          ),
          ChildRoute(
            '/available-donations',
            child: (_, __) => const AvailableDonationsPage(),
          ),
          ChildRoute(
            '/requested-donations',
            child: (_, __) => const RequestedDonationsPage(),
          ),
        ]),
        ChildRoute('/admin', child: (_, __) => const AdminPage()),
        ChildRoute('/profile', child: (_, __) => const ProfilePage()),
        ChildRoute('/denied', child: (_, __) => const DeniedPage()),
        ChildRoute('/waiting', child: (_, __) => const WaitingPage()),
      ];
}
