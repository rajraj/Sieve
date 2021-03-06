import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/Usecase/use_case.dart';
import '../../../../core/error/Faliure.dart';
import '../../../login_screen/domain/entities/login_user.dart';
import '../repos/bottom_nav_repo.dart';

class NavigateToPrivacyTips extends UseCase<LoginUser,LoginUser>{

  final BottomNavRepo bottomNavRepo;

  NavigateToPrivacyTips({@required this.bottomNavRepo});
  

  @override
  Future<Either<Faliure, LoginUser>> call(LoginUser user) async {
    return await this.bottomNavRepo.navigateToPrivacyTips(user);
  }
  
}