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
@synthesize reachabilityInstance;

+ (KiiAppSingleton *)sharedInstance {
    static KiiAppSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KiiAppSingleton alloc] init];
    });
    return sharedInstance;
}

- (Reachability *)reachabilityInstance {
    if (reachabilityInstance == nil) {
        [self setReachabilityInstance:[Reachability reachabilityWithHostname:@"api.kii.com"]];
    }
    [reachabilityInstance setReachableOnWWAN:YES];
    return reachabilityInstance;
}

- (void)registerToken {
    if ([self currentUser] == nil) {
        return;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[self.currentUser accessToken] forKey:KIIUSER_TOKEN_KEY];
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
    user = [KiiUser authenticateSynchronous:username withPassword:password andError:error];
    [self setCurrentUser:user];
    NSLog(@"%@", *error);
    if (*error == nil) {
        [self registerToken];
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:KIIUSER_TOKEN_KEY];
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

@end
