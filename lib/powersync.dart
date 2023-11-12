import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:powersync/powersync.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Postgres Response codes that we cannot recover from by retrying.
final List<RegExp> fatalResponseCodes = [
  // Class 22 Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

class SupabaseConnector extends PowerSyncBackendConnector {
  SupabaseConnector({required this.powerSyncDatabase});
  PowerSyncDatabase powerSyncDatabase;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final session = Get.find<SupabaseClient>().auth.currentSession;

    if (session == null) {
      //User not logged in
      return null;
    } else {
      final token = session.accessToken;

      return PowerSyncCredentials(
          endpoint:
              'https://654a890cab49a2a2a593e4a8.powersync.journeyapps.com',
          token: token);
    }
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    try {
      final transaction = await powerSyncDatabase.getNextCrudTransaction();
      if (transaction == null) {
        return;
      } else {
        final rest = Get.find<SupabaseClient>().rest;
        try {
          for (var operation in transaction.crud) {
            debugPrint(
                'uploadData: $operation - ${operation.table}: ${operation.op}');
            final table = rest.from(operation.table);
            switch (operation.op) {
              case UpdateType.put:
                //put -> Supabase upsert
                var values = Map<String, dynamic>.of(operation.opData!);
                values['id'] = operation.id;
                await table.upsert(values);
                break;
              case UpdateType.patch:
                //patch -> Supabase update
                await table.update(operation.opData!).eq('id', operation.id);
                break;
              case UpdateType.delete:
                //delete -> Supabase delete
                await table.delete().eq('id', operation.id);
                break;
            }
          }
          await transaction.complete();
        } on PostgrestException catch (e) {
          debugPrint('Error on powersync uploadData: $e');
          if (e.code != null &&
              fatalResponseCodes.any((element) => element.hasMatch(e.code!))) {
            //TODO register errored data
            await transaction.complete();
          } else {
            rethrow;
          }
        }
      }
    } catch (e) {
      debugPrint('Error on powersync uploadData transaction: $e');
    }
  }
}
