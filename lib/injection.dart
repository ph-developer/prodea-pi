import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/repositories/firebase_auth_repo.dart';
import 'package:prodea/repositories/firebase_donation_repo.dart';
import 'package:prodea/repositories/firebase_user_info_repo.dart';
import 'package:prodea/services/asuka_notification_service.dart';
import 'package:prodea/services/contracts/navigation_service.dart';
import 'package:prodea/services/contracts/notification_service.dart';
import 'package:prodea/services/seafarer_navigation_service.dart';
import 'package:prodea/stores/auth_store.dart';
import 'package:prodea/stores/beneficiaries_store.dart';
import 'package:prodea/stores/my_donations_store.dart';

final i = GetIt.instance;

Future<void> setupInjection() async {
  // Firebase
  i.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  i.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  i.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Services
  i.registerFactory<INotificationService>(
    () => AsukaNotificationService(),
  );
  i.registerFactory<INavigationService>(
    () => SeafarerNavigationService(),
  );

  // Repos
  i.registerFactory<IAuthRepo>(
    () => FirebaseAuthRepo(i(), i(), i()),
  );
  i.registerFactory<IDonationRepo>(
    () => FirebaseDonationRepo(i(), i(), i(), i()),
  );
  i.registerFactory<IUserInfoRepo>(
    () => FirebaseUserInfoRepo(i(), i(), i()),
  );

  // Stores
  i.registerSingleton<AuthStore>(AuthStore(i(), i(), i()));
  i.registerSingleton<BeneficiariesStore>(BeneficiariesStore(i()));
  i.registerFactory<MyDonationsStore>(() => MyDonationsStore(i()));
}
