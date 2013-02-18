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

@interface KiiAppSingleton : NSObject {
    KiiUser *currentUser;
}

@property (nonatomic, strong) Reachability *reachabilityInstance;
@property(nonatomic, strong) KiiUser *currentUser;

+ (KiiAppSingleton *)sharedInstance;

- (void)registerToken;

- (BOOL)checkUserToken;

- (void)loginWithTokenSynchronous:(NSError **)error;

- (void)loginWithNewUserSynchronous:(NSError **)error;

- (void)doLogInSynchronous:(NSError **)error;

- (void)doLogOut;

- (NSString *)currentTimeMillisByNSString;

- (BOOL)checkNetworkStatus;


@end
