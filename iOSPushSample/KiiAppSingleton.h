//
//  KiiAppSingleton.h
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KiiUser;
@class Reachability;
@class KiiPushMessage;

@interface KiiAppSingleton : NSObject {
    KiiUser *_currentUser;
    Reachability *_reachabilityInstance;
    BOOL _debugMode;
    BOOL _messageShowOffMode;
}

@property(nonatomic, strong) KiiUser *currentUser;
@property (nonatomic, strong) Reachability *reachabilityInstance;
@property(nonatomic) BOOL debugMode;
@property(nonatomic) BOOL messageShowOffMode;

+ (KiiAppSingleton *)sharedInstance;

- (void)registerToken;

- (BOOL)checkUserToken;

- (void)loginWithTokenSynchronous:(NSError **)error;

- (void)loginWithNewUserSynchronous:(NSError **)error;

- (void)doLogInSynchronous:(NSError **)error;

- (void)doLogOut;

- (NSString *)currentTimeMillisByNSString;

- (BOOL)checkNetworkStatus;

- (NSString *)createObjectURIFromMessage:(NSDictionary *)userInfo;


@end
