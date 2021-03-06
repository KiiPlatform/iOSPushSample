//
//  KiiAppSingleton.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiAppSingleton.h"
#import "Reachability.h"
#import <sys/time.h>
#import <KiiSDK/Kii.h>

#define KIIUSER_TOKEN_KEY @"KII_TOKEN"

@implementation KiiAppSingleton

@synthesize currentUser = _currentUser;
@synthesize reachabilityInstance = _reachabilityInstance;
@synthesize debugMode = _debugMode;
@synthesize messageShowOffMode = _messageShowOffMode;

+ (KiiAppSingleton *)sharedInstance {
    static KiiAppSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KiiAppSingleton alloc] init];
    });
    return sharedInstance;
}

- (Reachability *)reachabilityInstance {
    if (_reachabilityInstance == nil) {
        [self setReachabilityInstance:[Reachability reachabilityWithHostname:@"api.kii.com"]];
    }
    [_reachabilityInstance setReachableOnWWAN:YES];
    return _reachabilityInstance;
}

- (BOOL)checkUserToken {
    [self.currentUser accessToken];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [prefs objectForKey:KIIUSER_TOKEN_KEY];
    // Check whether token is empty
    if (accessToken == nil || [accessToken isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void) setCurrentUser:(KiiUser *)currentUser {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _currentUser = currentUser;
    if (currentUser == nil) {
        [prefs removeObjectForKey:KIIUSER_TOKEN_KEY];
    }
    [prefs setObject:[currentUser accessToken] forKey:KIIUSER_TOKEN_KEY];
}

- (void)loginWithTokenSynchronous:(NSError **)error {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *token = [prefs objectForKey:KIIUSER_TOKEN_KEY];
    KiiUser *user = [KiiUser authenticateWithTokenSynchronous:token andError:error];
    [self setCurrentUser:user];
}

- (void)loginWithNewUserSynchronous:(NSError **)error {
    NSString *username = [self randomUserName];
    NSString *password = [self randomString:10];
    KiiUser *user = [KiiUser userWithUsername:username andPassword:password];
    [user performRegistrationSynchronous:error];
    NSLog(@"%@", *error);
    if (*error == nil) {
        [self setCurrentUser:user];
    }
}

- (void)doLogInSynchronous:(NSError **)error {
    if ([self checkUserToken]) {
        [self loginWithTokenSynchronous:error];
        if (*error == nil) {
            return;
        }
    }
    [self loginWithNewUserSynchronous:error];
}

- (void)doLogOut {
    [KiiUser logOut];
    [self setCurrentUser:nil];
}

- (NSString *)randomUserName {
    NSString *userName = [NSString stringWithFormat:@"testuser-%@", [self currentTimeMillisByNSString]];
    return [userName lowercaseString];
}

- (NSString *)currentTimeMillisByNSString {
    struct timeval t;
    gettimeofday(&t, NULL);
    return [NSString stringWithFormat:@"%qi", (((long long) t.tv_sec) * 1000) + (((long long) t.tv_usec) / 1000)];
}

- (NSString *)randomString:(int)length {
    NSString *stringSet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int index;
    int userNameLen;
    NSString *retStr;
    NSMutableString *randomStr;
    static bool randInitFlag = NO;

    if (randInitFlag == NO) {
        srand((unsigned int) time(NULL));
        randInitFlag = YES;
    }

    userNameLen = length;
    randomStr = [NSMutableString stringWithCapacity:(NSUInteger) (userNameLen + 1)];
    for (int i = 0; i < userNameLen; i++) {
        index = rand() % [stringSet length];
        NSString *aStr = [[stringSet substringFromIndex:(NSUInteger) index] substringToIndex:1];
        [randomStr appendString:aStr];
    }
    retStr = [[NSString alloc] initWithString:randomStr];
    return (retStr);
}

- (BOOL)checkNetworkStatus {
    if ([[[KiiAppSingleton sharedInstance] reachabilityInstance] currentReachabilityStatus] == NotReachable) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Network Status"
                                                        message:@"No internet connection. Please check your network status."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
        return NO;
    } else {
        return YES;
    }
}

- (void)setDebugMode:(BOOL)debug {
    _debugMode = debug;
    if (debug) {
        [Kii setLogLevel:3];
    } else {
        [Kii setLogLevel:0];
    }
}

- (NSString *)createObjectURIFromMessage:(NSDictionary *)userInfo {

    KiiPushMessage *message = [KiiPushMessage messageFromAPNS:userInfo];
    NSString *scope = @"";
    if ([message getValueOfKiiMessageField:KiiMessage_SCOPE_APP_ID] != nil) {
        // Nothing to do.
    } else if ([message getValueOfKiiMessageField:KiiMessage_SCOPE_USER_ID] != nil) {
        scope = [NSString stringWithFormat:@"users/%@/", [message getValueOfKiiMessageField:KiiMessage_SCOPE_USER_ID]];
    } else if ([message getValueOfKiiMessageField:KiiMessage_SCOPE_GROUP_ID] != nil) {
        scope = [NSString stringWithFormat:@"groups/%@/", [message getValueOfKiiMessageField:KiiMessage_SCOPE_GROUP_ID]];
    }

    // If bucket
    if ([message getValueOfKiiMessageField:KiiMessage_BUCKET_ID] != nil) {
        NSString *buckets = @"";
        if ([[message getValueOfKiiMessageField:KiiMessage_BUCKET_TYPE] isEqualToString:@"sync"]) {
            buckets = [NSString stringWithFormat:@"buckets/sync:%@", [message getValueOfKiiMessageField:KiiMessage_BUCKET_ID]];
        } else {
            buckets = [NSString stringWithFormat:@"buckets/%@", [message getValueOfKiiMessageField:KiiMessage_BUCKET_ID]];
        }

        NSString *objects = @"";
        if ([message getValueOfKiiMessageField:KiiMessage_OBJECT_ID] != nil) {
            objects = [NSString stringWithFormat:@"/objects/%@", [message getValueOfKiiMessageField:KiiMessage_OBJECT_ID]];
        }
        return [NSString stringWithFormat:@"kiicloud://%@%@%@", scope, buckets, objects];
    }

    // If topic
    if ([message getValueOfKiiMessageField:KiiMessage_TOPIC] != nil) {
        NSString *topicName = [message getValueOfKiiMessageField:KiiMessage_TOPIC];
        return [NSString stringWithFormat:@"kiicloud://%@topics/%@", scope, topicName];
    }

    return nil;
}

- (NSString *)pushIdentifier:(NSDictionary *)userInfo {
    KiiPushMessage *message = [KiiPushMessage messageFromAPNS:userInfo];
    // If bucket
    if ([message getValueOfKiiMessageField:KiiMessage_BUCKET_ID] != nil) {
        return [message getValueOfKiiMessageField:KiiMessage_OBJECT_ID];
    }
    // If topic
    if ([message getValueOfKiiMessageField:KiiMessage_TOPIC] != nil) {
        return [userInfo valueForKeyPath:@"time"];
    }

    return nil;
}

@end
