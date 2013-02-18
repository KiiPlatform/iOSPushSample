//
//  KiiAppDelegate.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiAppDelegate.h"
#import "KiiAppSingleton.h"
#import "Reachability.h"
#import <KiiSDK/Kii.h>

@implementation KiiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Kii
    [Kii beginWithID:APPID andKey:APPKEY andSite:kiiSiteUS];
    // For push notification. (Development mode : ON)
    [Kii enableAPNSWithDevelopmentMode:YES andNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[KiiAppSingleton sharedInstance] reachabilityInstance] startNotifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[KiiAppSingleton sharedInstance] reachabilityInstance] stopNotifier];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken = %@", deviceToken);

    // Set APNs device token.
    [Kii setAPNSDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive remote notification: %@", [userInfo description]);

    // TODO : Object/Topic conditional handling
    KiiPushMessage *message = [KiiPushMessage messageFromAPNS:userInfo];
    [message showMessageAlertWithTitle:@"RemotePushMessage"];
}

@end
