#import "LiveRtmpPushPlugin.h"
#if __has_include(<live_rtmp_push_plugin/live_rtmp_push_plugin-Swift.h>)
#import <live_rtmp_push_plugin/live_rtmp_push_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "live_rtmp_push_plugin-Swift.h"
#endif

@implementation LiveRtmpPushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [registrar registerViewFactory:[[LivePushViewFactory alloc] initWithMessenger:[registrar messenger]] withId:@"com.xinlianshiye.live"];
  [SwiftLiveRtmpPushPlugin registerWithRegistrar:registrar];
}
@end
