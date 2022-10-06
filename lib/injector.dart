import 'package:kiwi/kiwi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'src/data/services/go_router_navigation_service.dart';
import 'src/domain/services/navigation_service.dart';
import 'src/domain/usecases/navigation/get_current_route.dart';
import 'src/domain/usecases/navigation/go_back.dart';
import 'src/domain/usecases/navigation/go_to.dart';
import 'src/presentation/controllers/navigation_controller.dart';
import 'src/data/repositories/local/json_city_local_repo.dart';
import 'src/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'src/data/repositories/remote/firebase_donation_remote_repo.dart';
import 'src/data/repositories/remote/firebase_file_remote_repo.dart';
import 'src/data/repositories/remote/firebase_user_remote_repo.dart';
import 'src/data/services/asuka_notification_service.dart';
import 'src/data/services/connectivity_network_service.dart';
import 'src/data/services/image_picker_photo_service.dart';
import 'src/domain/repositories/auth_repo.dart';
import 'src/domain/repositories/city_repo.dart';
import 'src/domain/repositories/donation_repo.dart';
import 'src/domain/repositories/file_repo.dart';
import 'src/domain/repositories/user_repo.dart';
import 'src/domain/services/network_service.dart';
import 'src/domain/services/notification_service.dart';
import 'src/domain/services/photo_service.dart';
import 'src/domain/usecases/auth/do_login.dart';
import 'src/domain/usecases/auth/do_logout.dart';
import 'src/domain/usecases/auth/do_register.dart';
import 'src/domain/usecases/auth/get_current_user.dart';
import 'src/domain/usecases/auth/send_password_reset_email.dart';
import 'src/domain/usecases/cities/get_city_names.dart';
import 'src/domain/usecases/donations/create_donation.dart';
import 'src/domain/usecases/donations/get_available_donations.dart';
import 'src/domain/usecases/donations/get_donation_photo_url.dart';
import 'src/domain/usecases/donations/get_my_donations.dart';
import 'src/domain/usecases/donations/get_requested_donations.dart';
import 'src/domain/usecases/donations/set_donation_as_canceled.dart';
import 'src/domain/usecases/donations/set_donation_as_delivered.dart';
import 'src/domain/usecases/donations/set_donation_as_requested.dart';
import 'src/domain/usecases/donations/set_donation_as_unrequested.dart';
import 'src/domain/usecases/network/get_connection_status.dart';
import 'src/domain/usecases/photo/pick_photo_from_camera.dart';
import 'src/domain/usecases/photo/pick_photo_from_gallery.dart';
import 'src/domain/usecases/user/get_beneficiaries.dart';
import 'src/domain/usecases/user/get_common_users.dart';
import 'src/domain/usecases/user/get_donors.dart';
import 'src/domain/usecases/user/get_user_by_id.dart';
import 'src/domain/usecases/user/set_user_as_authorized.dart';
import 'src/domain/usecases/user/set_user_as_denied.dart';
import 'src/presentation/controllers/auth_controller.dart';
import 'src/presentation/controllers/connection_state_controller.dart';
import 'src/presentation/stores/cities_store.dart';
import 'src/presentation/stores/donation_store.dart';
import 'src/presentation/stores/donations_store.dart';
import 'src/presentation/stores/user_store.dart';
import 'src/presentation/stores/users_store.dart';

bool _injected = false;

final _container = KiwiContainer();
KiwiContainer get inject => _container;

void setupInjector() {
  if (_injected) return;
  _injectFirebase();
  _injectThirdParty();
  _injectRepositories();
  _injectServices();
  _injectUsecases();
  _injectControllers();
  _injectStores();
  _injected = true;
}

void setupTestInjector([void Function(KiwiContainer)? setupMocks]) {
  _container.clear();
  _injected = false;
  setupInjector();
  setupMocks?.call(_container);
}

void _injectFirebase() {
  _container.registerFactory<FirebaseAuth>(
    (i) => FirebaseAuth.instance,
  );
  _container.registerFactory<FirebaseStorage>(
    (i) => FirebaseStorage.instance,
  );
  _container.registerFactory<FirebaseFirestore>(
    (i) => FirebaseFirestore.instance,
  );
}

void _injectThirdParty() {
  _container.registerFactory<Connectivity>(
    (i) => Connectivity(),
  );
  _container.registerFactory<ImagePicker>(
    (i) => ImagePicker(),
  );
}

void _injectRepositories() {
  _container.registerFactory<IAuthRepo>(
    (i) => FirebaseAuthRemoteRepo(i()),
  );
  _container.registerFactory<ICityRepo>(
    (i) => JsonCityLocalRepo(),
  );
  _container.registerFactory<IDonationRepo>(
    (i) => FirebaseDonationRemoteRepo(i()),
  );
  _container.registerFactory<IFileRepo>(
    (i) => FirebaseFileRemoteRepo(i()),
  );
  _container.registerFactory<IUserRepo>(
    (i) => FirebaseUserRemoteRepo(i()),
  );
}

void _injectServices() {
  _container.registerFactory<INavigationService>(
    (i) => GoRouterNavigationService(),
  );
  _container.registerFactory<INetworkService>(
    (i) => ConnectivityNetworkService(i()),
  );
  _container.registerFactory<IPhotoService>(
    (i) => ImagePickerPhotoService(i()),
  );
  _container.registerFactory<INotificationService>(
    (i) => AsukaNotificationService(),
  );
}

void _injectUsecases() {
  _container.registerFactory<DoLogin>(
    (i) => DoLogin(i(), i(), i()),
  );
  _container.registerFactory<DoLogout>(
    (i) => DoLogout(i(), i()),
  );
  _container.registerFactory<DoRegister>(
    (i) => DoRegister(i(), i(), i()),
  );
  _container.registerFactory<GetCurrentUser>(
    (i) => GetCurrentUser(i(), i(), i()),
  );
  _container.registerFactory<SendPasswordResetEmail>(
    (i) => SendPasswordResetEmail(i(), i()),
  );
  _container.registerFactory<GetCityNames>(
    (i) => GetCityNames(i()),
  );
  _container.registerFactory<CreateDonation>(
    (i) => CreateDonation(i(), i(), i(), i()),
  );
  _container.registerFactory<GetAvailableDonations>(
    (i) => GetAvailableDonations(i()),
  );
  _container.registerFactory<GetDonationPhotoUrl>(
    (i) => GetDonationPhotoUrl(i(), i()),
  );
  _container.registerFactory<GetMyDonations>(
    (i) => GetMyDonations(i(), i()),
  );
  _container.registerFactory<GetRequestedDonations>(
    (i) => GetRequestedDonations(i(), i()),
  );
  _container.registerFactory<SetDonationAsCanceled>(
    (i) => SetDonationAsCanceled(i(), i()),
  );
  _container.registerFactory<SetDonationAsDelivered>(
    (i) => SetDonationAsDelivered(i(), i()),
  );
  _container.registerFactory<SetDonationAsRequested>(
    (i) => SetDonationAsRequested(i(), i(), i()),
  );
  _container.registerFactory<SetDonationAsUnrequested>(
    (i) => SetDonationAsUnrequested(i(), i()),
  );
  _container.registerFactory<GetCurrentRoute>(
    (i) => GetCurrentRoute(i()),
  );
  _container.registerFactory<GoBack>(
    (i) => GoBack(i()),
  );
  _container.registerFactory<GoTo>(
    (i) => GoTo(i()),
  );
  _container.registerFactory<GetConnectionStatus>(
    (i) => GetConnectionStatus(i(), i()),
  );
  _container.registerFactory<PickPhotoFromCamera>(
    (i) => PickPhotoFromCamera(i(), i()),
  );
  _container.registerFactory<PickPhotoFromGallery>(
    (i) => PickPhotoFromGallery(i(), i()),
  );
  _container.registerFactory<GetBeneficiaries>(
    (i) => GetBeneficiaries(i()),
  );
  _container.registerFactory<GetCommonUsers>(
    (i) => GetCommonUsers(i()),
  );
  _container.registerFactory<GetDonors>(
    (i) => GetDonors(i()),
  );
  _container.registerFactory<GetUserById>(
    (i) => GetUserById(i(), i()),
  );
  _container.registerFactory<SetUserAsAuthorized>(
    (i) => SetUserAsAuthorized(i(), i()),
  );
  _container.registerFactory<SetUserAsDenied>(
    (i) => SetUserAsDenied(i(), i()),
  );
}

void _injectControllers() {
  _container.registerSingleton<AuthController>(
    (i) => AuthController(i(), i(), i(), i(), i()),
  );
  _container.registerSingleton<ConnectionStateController>(
    (i) => ConnectionStateController(i()),
  );
  _container.registerSingleton<NavigationController>(
    (i) => NavigationController(i(), i(), i()),
  );
}

void _injectStores() {
  _container.registerSingleton<CitiesStore>(
    (i) => CitiesStore(i()),
  );
  _container.registerFactory<DonationStore>(
    (i) => DonationStore(i(), i(), i()),
  );
  _container.registerSingleton<DonationsStore>(
    (i) => DonationsStore(i(), i(), i(), i(), i(), i(), i(), i()),
  );
  _container.registerFactory<UserStore>(
    (i) => UserStore(),
  );
  _container.registerSingleton<UsersStore>(
    (i) => UsersStore(i(), i(), i(), i(), i()),
  );
}
