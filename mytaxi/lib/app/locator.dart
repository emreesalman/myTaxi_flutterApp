import 'package:get_it/get_it.dart';
import 'package:mytaxi/repository/user_repository.dart';
import 'package:mytaxi/services/firebase_auth_services.dart';
import 'package:mytaxi/services/firebase_storage_services.dart';
import 'package:mytaxi/services/firestore_db_service.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}