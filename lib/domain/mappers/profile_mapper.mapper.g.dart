// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class ProfileMapperImpl extends ProfileMapper {
  ProfileMapperImpl() : super();

  @override
  ProfileDomain profileDomainByProfileProvider(ProfileModel profileModel) {
    final profiledomain = ProfileDomain.initData(
      id: profileModel.id,
      userId: profileModel.userId,
      username: profileModel.username,
      createdAt: profileModel.createdAt,
    );
    return profiledomain;
  }

  @override
  ProfileModel profileModelByProfileDomain(ProfileDomain profileDomain) {
    final profilemodel = ProfileModel(
      id: profileDomain.id,
      userId: profileDomain.userId,
      username: profileDomain.username,
      createdAt: profileDomain.createdAt,
    );
    return profilemodel;
  }
}
