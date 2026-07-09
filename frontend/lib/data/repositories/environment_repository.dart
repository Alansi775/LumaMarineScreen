import '../../features/overview/domain/environment_reading.dart';

abstract class EnvironmentRepository {
  Stream<EnvironmentReading> watchEnvironment();
}
