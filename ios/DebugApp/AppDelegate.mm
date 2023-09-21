#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTLinkingManager.h>

// CleverTap imports from official documentation doesn't work.
// Using this solution instead: https://stackoverflow.com/a/72031172/4932261
#import "CleverTap.h"
#import "CleverTapReactManager.h"
#import "CleverTapPushNotificationDelegate.h"
#import "CleverTapReact.h"

#import <Firebase.h>

@interface AppDelegate () <CleverTapPushNotificationDelegate> {}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"DebugApp";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  // [CleverTap autoIntegrate]; // integrate CleverTap SDK using the autoIntegrate option
  
  [[CleverTapReactManager sharedInstance] applicationDidLaunchWithOptions:launchOptions];
  CleverTap *instance = [CleverTap sharedInstance];
  [instance setPushNotificationDelegate:self];

  [FIRApp configure]; // integrate Firebase

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void) application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
      [[CleverTap sharedInstance] setPushToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"%@", userInfo);
  
  [[CleverTap sharedInstance] handleNotificationWithData:userInfo];
}


- (void)pushNotificationTappedWithCustomExtras:(NSDictionary *)customExtras{
  NSLog(@"pushNotificationTapped: customExtras: %@", customExtras);
  
  NSMutableDictionary *pushNotificationExtras = [NSMutableDictionary new];
  if (customExtras != nil) {
      pushNotificationExtras[@"customExtras"] = customExtras;
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:kCleverTapPushNotificationClicked object:nil userInfo:pushNotificationExtras];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
