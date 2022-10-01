// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as firebase show User;
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart' as fake;
import 'package:prodea/src/domain/repositories/auth_repo.dart';
import 'package:prodea/src/domain/repositories/city_repo.dart';
import 'package:prodea/src/domain/repositories/donation_repo.dart';
import 'package:prodea/src/domain/repositories/file_repo.dart';
import 'package:prodea/src/domain/repositories/user_repo.dart';
import 'package:prodea/src/domain/services/network_service.dart';
import 'package:prodea/src/domain/services/notification_service.dart';
import 'package:prodea/src/domain/services/photo_service.dart';
import 'package:prodea/src/domain/usecases/auth/do_login.dart';
import 'package:prodea/src/domain/usecases/auth/do_logout.dart';
import 'package:prodea/src/domain/usecases/auth/do_register.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';
import 'package:prodea/src/domain/usecases/auth/send_password_reset_email.dart';
import 'package:prodea/src/domain/usecases/cities/get_city_names.dart';
import 'package:prodea/src/domain/usecases/donations/create_donation.dart';
import 'package:prodea/src/domain/usecases/donations/get_available_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_donation_photo_url.dart';
import 'package:prodea/src/domain/usecases/donations/get_my_donations.dart';
import 'package:prodea/src/domain/usecases/donations/get_requested_donations.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_canceled.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_delivered.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_requested.dart';
import 'package:prodea/src/domain/usecases/donations/set_donation_as_unrequested.dart';
import 'package:prodea/src/domain/usecases/network/get_connection_status.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_camera.dart';
import 'package:prodea/src/domain/usecases/photo/pick_photo_from_gallery.dart';
import 'package:prodea/src/domain/usecases/user/get_beneficiaries.dart';
import 'package:prodea/src/domain/usecases/user/get_common_users.dart';
import 'package:prodea/src/domain/usecases/user/get_donors.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_authorized.dart';
import 'package:prodea/src/domain/usecases/user/set_user_as_denied.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

abstract class Callable<T> {
  void call([T? arg]) {}
}

class MockCallable<T> extends Mock implements Callable<T> {}

const whenReaction = reaction;

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase.User {}

class MockFirebaseUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthCredential extends Mock implements AuthCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

typedef FakeFirebaseStorage = fake.MockFirebaseStorage;

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockConnectivity extends Mock implements Connectivity {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockNotificationService extends Mock implements INotificationService {}

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

class MockCityRepo extends Mock implements ICityRepo {}

class MockDonationRepo extends Mock implements IDonationRepo {}

class MockFileRepo extends Mock implements IFileRepo {}

class MockNetworkService extends Mock implements INetworkService {}

class MockPhotoService extends Mock implements IPhotoService {}

class MockModularNavigator extends Mock implements IModularNavigator {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockDoLogin extends Mock implements DoLogin {}

class MockDoRegister extends Mock implements DoRegister {}

class MockDoLogout extends Mock implements DoLogout {}

class MockSendPasswordResetEmail extends Mock
    implements SendPasswordResetEmail {}

class MockGetConnectionStatus extends Mock implements GetConnectionStatus {}

class MockGetCityNames extends Mock implements GetCityNames {}

class MockCreateDonation extends Mock implements CreateDonation {}

class MockPickPhotoFromCamera extends Mock implements PickPhotoFromCamera {}

class MockPickPhotoFromGallery extends Mock implements PickPhotoFromGallery {}

class MockGetRequestedDonations extends Mock implements GetRequestedDonations {}

class MockGetAvailableDonations extends Mock implements GetAvailableDonations {}

class MockGetMyDonations extends Mock implements GetMyDonations {}

class MockSetDonationAsDelivered extends Mock
    implements SetDonationAsDelivered {}

class MockSetDonationAsRequested extends Mock
    implements SetDonationAsRequested {}

class MockSetDonationAsUnrequested extends Mock
    implements SetDonationAsUnrequested {}

class MockSetDonationAsCanceled extends Mock implements SetDonationAsCanceled {}

class MockGetDonationPhotoUrl extends Mock implements GetDonationPhotoUrl {}

class MockGetCommonUsers extends Mock implements GetCommonUsers {}

class MockGetBeneficiaries extends Mock implements GetBeneficiaries {}

class MockGetDonors extends Mock implements GetDonors {}

class MockSetUserAsAuthorized extends Mock implements SetUserAsAuthorized {}

class MockSetUserAsDenied extends Mock implements SetUserAsDenied {}

class MockCitiesStore extends Mock implements CitiesStore {}
