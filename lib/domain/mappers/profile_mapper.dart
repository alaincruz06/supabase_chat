import 'package:smartstruct/smartstruct.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_chat/domain/models/profile_domain.dart';

part 'profile_mapper.mapper.g.dart';

@Mapper()
abstract class ProfileMapper {
  ProfileDomain profileDomainByProfileProvider(ProfileModel profileModel);
  ProfileModel profileModelByProfileDomain(ProfileDomain profileDomain);
}
