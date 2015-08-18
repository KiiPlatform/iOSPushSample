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
#import "TSMessage.h"
#import <KiiSDK/Kii.h>

@implementation KiiAppDelegate

- (void) setUpPushNotification {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.destructive = NO;

    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"DECLINE_IDENTIFIER";
    declineAction.title = @"Decline";
    declineAction.destructive = YES;
    declineAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.authenticationRequired = NO;

    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];

    inviteCategory.identifier = @"INVITE_CATEGORY";

    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextMinimal];

    NSSet *categories= [NSSet setWithObject:inviteCategory];

    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings
                                              settingsForTypes:types
                                              categories:categories];

    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    NSDictionary* aps = userInfo[@"aps"];
    //categorized push
    if ([aps[@"category"] isEqualToString:@"INVITE_CATEGORY"]) {
        if ([identifier isEqualToString:@"DECLINE_IDENTIFIER"]){
            NSLog(@"Receive remote notification in background mode : %@", [userInfo description]);
            //invitation declined
        }
        else if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
            NSLog(@"Receive remote notification in foreground mode : %@", [userInfo description]);
            [TSMessage showNotificationWithTitle:@"Invitation Accepted!!"
                                            type:TSMessageNotificationTypeSuccess];
        }
    } else {
        [self showMessageAlert:userInfo];
    }
    completionHandler();
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Kii
    [Kii beginWithID:APPID andKey:APPKEY andSite:APPSITE];
    [self setUpPushNotification];
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
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        //return if called from background
        return;
    }
    NSLog(@"Receive remote notification : %@", [userInfo description]);
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
