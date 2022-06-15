//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_ble_lib/FlutterBleLibPlugin.h>)
#import <flutter_ble_lib/FlutterBleLibPlugin.h>
#else
@import flutter_ble_lib;
#endif

#if __has_include(<flutter_blue/FlutterBluePlugin.h>)
#import <flutter_blue/FlutterBluePlugin.h>
#else
@import flutter_blue;
#endif

#if __has_include(<flutter_secure_storage/FlutterSecureStoragePlugin.h>)
#import <flutter_secure_storage/FlutterSecureStoragePlugin.h>
#else
@import flutter_secure_storage;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<google_maps_flutter/FLTGoogleMapsPlugin.h>)
#import <google_maps_flutter/FLTGoogleMapsPlugin.h>
#else
@import google_maps_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterBleLibPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBleLibPlugin"]];
  [FlutterBluePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBluePlugin"]];
  [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FLTGoogleMapsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleMapsPlugin"]];
}

@end
