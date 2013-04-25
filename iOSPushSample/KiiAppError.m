//
//  KiiAppError.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiAppError.h"

@implementation KiiAppError

+ (KiiAppError *)sharedInstance {
    static KiiAppError *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KiiAppError alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSError *)errorUserNotLoggedIn {
    return [self errorWithCode:304 andMessage:@"KiiUser not logged in"];
}

-(NSError *)errorWithCode:(NSInteger) code andMessage:(NSString *)message {
    NSMutableDictionary *dictionary  = [NSMutableDictionary dictionary];
    [dictionary setObject:message forKey:@"message"];
    return [NSError errorWithDomain:ERROR_DOMAIN code:code userInfo:dictionary];
}

@end
