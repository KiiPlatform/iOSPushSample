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
    [Kii beginWithID:APPID andKey:APPKEY andSite:APPSITE];
    // For push notification.
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // Set Log level is verbose
    [Kii setLogLevel:3];
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
    self.deviceToken = deviceToken;
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register Remote Notification: %@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive remote notification : %@", [userInfo description]);
    [self showMessageAlert:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    NSLog(@"Receive remote notification in background mode : %@", [userInfo description]);
    [self showMessageAlert:userInfo];
}

- (void)showMessageAlert:(NSDictionary *)userInfo {
    if ([[KiiAppSingleton sharedInstance] debugMode]) {
        long long int receiveTime = [[[KiiAppSingleton sharedInstance] currentTimeMillisByNSString] longLongValue];
        long long int sendTime = [[userInfo objectForKey:@"w"] longLongValue];
        double timeDiff = ((double) (receiveTime - sendTime) / 1000);
        NSString *message = [NSString stringWithFormat:@"\t[Send] : \t%qi\t[Receive] : \t%qi\t[Diff] : \t%f\t[ID] : \t%@", sendTime, receiveTime, timeDiff, [[KiiAppSingleton sharedInstance] pushIdentifier:userInfo]];
        NSLog(@"Push debug : %@", message);

        // If do not show dialog,
        if ([[KiiAppSingleton sharedInstance] messageShowOffMode]) {
            return;
        }

        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"RemotePushMessage"
                                     message:message
                                     delegate:nil cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
    } else {
        // If do not show dialog,
        if ([[KiiAppSingleton sharedInstance] messageShowOffMode]) {
            return;
        }
        KiiPushMessage *message = [KiiPushMessage messageFromAPNS:userInfo];
        [message showMessageAlertWithTitle:@"RemotePushMessage"];
    }
}

@end
