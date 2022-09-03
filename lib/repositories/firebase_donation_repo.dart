import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:prodea/firebase/dtos/firebase_dto.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/models/dtos/donation_dto.dart';
import 'package:prodea/repositories/contracts/donation_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';
import 'package:uuid/uuid.dart';

class FirebaseDonationRepo implements IDonationRepo {
  final FirebaseAuth auth;
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;
  final INotificationService notificationService;

  FirebaseDonationRepo(
    this.auth,
    this.storage,
    this.firestore,
    this.notificationService,
  );

  CollectionReference get _collectionRef => firestore.collection('donation');

  @override
  Future<String?> uploadPhoto(File file) async {
    final photoId = const Uuid().v4();
    final photoRef = storage.ref("donation/$photoId");

    try {
      final result = await photoRef.putFile(file);
      return result.ref.fullPath;
    } catch (e) {
      throw Exception('Ocorreu um erro ao enviar a foto.');
    }
  }

  @override
  Future<String> getPhotoUrl(String path) async {
    // TODO ...
    return "...";
  }

  @override
  Future<Donation?> create(Donation donation) async {
    final donorId = auth.currentUser?.uid;

    if (donorId != null) {
      try {
        final temp = donation.copyWith(donorId: donorId);
        final result = await _collectionRef.add(temp.toMap());
        final id = result.id;
        return temp.copyWith(id: id);
      } catch (e) {
        notificationService
            .notifyError('Ocorreu um erro ao cadastrar a doação.');
      }
    } else {
      notificationService.notifyError('Usuário não autenticado.');
    }
    return null;
  }

  @override
  Future<void> setAsDelivered(Donation donation) async {
    try {
      final docRef = _collectionRef.doc(donation.id);
      final temp = donation.copyWith(isDelivered: true);
      docRef.set(temp.toMap());
    } catch (e) {
      notificationService
          .notifyError('Ocorreu um erro ao marcar a doação como entregue');
    }
  }

  @override
  Future<void> setAsCanceled(Donation donation, String reason) async {
    try {
      final docRef = _collectionRef.doc(donation.id);
      final temp = donation.copyWith(cancellation: reason);
      docRef.set(temp.toMap());
    } catch (e) {
      notificationService
          .notifyError('Ocorreu um erro ao marcar a doação como cancelada');
    }
  }

  @override
  Future<void> setAsRequested(Donation donation) async {
    final beneficiaryId = auth.currentUser?.uid;

    if (beneficiaryId != null) {
      try {
        final docRef = _collectionRef.doc(donation.id);
        final temp = donation.copyWith(beneficiaryId: beneficiaryId);
        docRef.set(temp.toMap());
      } catch (e) {
        notificationService
            .notifyError('Ocorreu um erro ao solicitar a doação.');
      }
    } else {
      notificationService.notifyError('Usuário não autenticado.');
    }
  }

  @override
  Future<void> setAsUnrequested(Donation donation) async {
    try {
      final docRef = _collectionRef.doc(donation.id);
      final temp = donation.copyWith(beneficiaryId: null);
      docRef.set(temp.toMap());
    } catch (e) {
      notificationService
          .notifyError('Ocorreu um erro ao cancelar a solicitação da doação');
    }
  }

  @override
  Stream<List<Donation>> availableDonations() {
    return _collectionRef
        .where('beneficiaryId', isNull: true)
        .where('cancellation', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((donation) => donation.toMap())
            .map(DonationDTO.fromMap)
            .where((donation) => !donation.isExpired)
            .toList());
  }

  @override
  Stream<List<Donation>> myDonations() {
    final donorId = auth.currentUser?.uid;

    return _collectionRef
        .where('donorId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((donation) => donation.toMap())
            .map(DonationDTO.fromMap)
            .toList());
  }

  @override
  Stream<List<Donation>> receivedDonations() {
    final beneficiaryId = auth.currentUser?.uid;

    return _collectionRef
        .where('beneficiaryId', isEqualTo: beneficiaryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((donation) => donation.toMap())
            .map(DonationDTO.fromMap)
            .toList());
  }
}
