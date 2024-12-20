// lib/domain/entities/user/user.dart
import 'package:equatable/equatable.dart';
import 'package:experiment_planner/domain/enums/user_enums.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String machineId;
  final DateTime registeredDate;
  final bool isApproved;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.machineId,
    required this.registeredDate,
    required this.isApproved,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    machineId,
    registeredDate,
    isApproved
  ];
}