//
//  iOSPushSample_Tests.m
//  iOSPushSample-Tests
//
//  Created by Syah Riza on 7/10/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KiiAppSingleton.h"
#import <XCTest/XCTest.h>
#import <KiiSDK/Kii.h>
#import <sys/time.h>
#define APPID      @"9a2385ce"
#define APPKEY     @"6a57ef8f144dbd9e41e07359ffb47d62"
#define ERROR_DOMAIN    @"iOSPushSampleApp"

#define USER_BUCKET_NAME   @"PushMyBucket"
#define USER_TOPIC_NAME    @"UserTopic"

#define APP_BUCKET_NAME   @"appBucket"
#define APP_TOPIC_NAME    @"appTestTopic"

#define GROUP_BUCKET_NAME   @"PushGroupBucket"
#define GROUP_TOPIC_NAME    @"GroupTopic"
#define GROUP_NAME    @"PushSampleGroup"

@interface iOSPushSample_Tests : XCTestCase

@end

@implementation iOSPushSample_Tests

- (void)setUp {
    [super setUp];
    [Kii beginWithID:APPID andKey:APPKEY andSite:kiiSiteUS];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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

- (void)testLoginSingleton {
    //NSError* error = nil;
    //[[KiiAppSingleton sharedInstance] doLogInSynchronous:&error];
    XCTestExpectation *expectation = [self expectationWithDescription:@"user registered"];
    NSString *username = [self randomUserName];
    NSString *password = [self randomString:10];
    KiiUser *user = [KiiUser userWithUsername:username andPassword:password];
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        NSLog(@"%@",error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    //[user performRegistrationSynchronous:&error];
    //user = [KiiUser authenticateSynchronous:username withPassword:password andError:&error];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
