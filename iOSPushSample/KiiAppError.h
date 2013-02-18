//
//  KiiAppError.h
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KiiAppError : NSObject

+ (KiiAppError *)sharedInstance;

- (NSError *)errorUserNotLoggedIn;

- (NSError *)errorWithCode:(NSInteger)code andMessage:(NSString *)message;

@end
