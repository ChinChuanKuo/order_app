import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceSource {
  static Future<Map<String, dynamic>> initialState() async {
    try {
      switch (kIsWeb) {
        case true:
          final build = await DeviceInfoPlugin().webBrowserInfo;
          return {
            'info': {'memory': build.deviceMemory},
            'device': build.appName,
            'manufacturer': build.vendor,
            'release': build.productSub,
            'system': build.appCodeName,
            'version': build.appVersion,
            'name': describeEnum(build.browserName),
            'uuid': '',
          };
      }
      if (Platform.isAndroid) {
        final build = await DeviceInfoPlugin().androidInfo;
        return {
          'info': {},
          'device': build.device,
          'manufacturer': build.manufacturer,
          'release': build.version.securityPatch,
          'system': build.brand,
          'version': build.version.release,
          'name': build.model,
          'uuid': build.androidId,
        };
      }
      if (Platform.isIOS) {
        final build = await DeviceInfoPlugin().iosInfo;
        return {
          'info': {},
          'device': build.utsname.nodename,
          'manufacturer': build.utsname.sysname,
          'release': build.utsname.release,
          'system': build.systemName,
          'version': build.systemVersion,
          'name': build.name,
          'uuid': build.identifierForVendor,
        };
      }
      if (Platform.isLinux) {
        final build = await DeviceInfoPlugin().linuxInfo;
        return {
          'info': {},
          'device': build.variant,
          'manufacturer': build.prettyName,
          'release': build.versionCodename,
          'system': build.prettyName,
          'version': build.version,
          'name': build.name,
          'uuid': build.machineId,
        };
      }
      if (Platform.isMacOS) {
        final build = await DeviceInfoPlugin().macOsInfo;
        return {
          'info': {'cpu': build.arch, 'memory': build.memorySize},
          'device': build.model,
          'manufacturer': 'Mac OS',
          'release': build.osRelease,
          'system': build.hostName,
          'version': build.kernelVersion,
          'name': build.computerName,
          'uuid': '',
        };
      }
      if (Platform.isWindows) {
        final build = await DeviceInfoPlugin().windowsInfo;
        return {
          'info': {
            'cpu': build.numberOfCores,
            'memory': build.systemMemoryInMegabytes
          },
          'device': '',
          'manufacturer': 'Window OS',
          'release': '',
          'system': '',
          'version': '',
          'name': build.computerName,
          'uuid': '',
        };
      }
    } on PlatformException {}
    return {};
  }
}
