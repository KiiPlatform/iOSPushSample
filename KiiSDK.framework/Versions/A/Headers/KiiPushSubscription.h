//
//  KiiPushSubscription.h
//  KiiSDK-Private
//
//  Created by Riza Alaudin Syah on 1/21/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KiiPushSubscription,KiiBucket;
@protocol KiiPrivateSubscribable,KiiSubscribable;

typedef void (^KiiPushSubscriptionBlock)(KiiPushSubscription *subscription,NSError *error);
@interface KiiPushSubscription : NSObject

/** Asynchronously subscribe a subscribable object using block.
     
     [KiiPushSubscription subscribe:aBucket withBlock:^(KiiPushSubscription *subscription, NSError *error) {
         if (nil == error) {
             NSLog(@"Subscribed");
         }
     }];
     
 @param subscribable A subscribable object
 @param completion block to handle after process completed
 */
+(void) subscribe:(id<KiiSubscribable>) subscribable withBlock:(KiiPushSubscriptionBlock) completion;
/** Asynchronously subscribe a subscribable object using block.
 
 @param subscribable A subscribable object
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
    - (void)bucketSubscribed:(KiiPushSubscription*)subscription withError:(NSError*)error {
        // check whether the request was successful
        if (error == nil) {
            // do something
        } else {
            // there was a problem
        }
    }
 
 */
+(void)subscribe:(id<KiiSubscribable>) subscribable withDelegate:(id) delegate andCallback:(SEL) callback;


/** Synchronously subscribe a subscribable object using block
 
 @param subscribable A subscribable object
 @param error An NSError object, set to nil, to test for errors
 */
+(KiiPushSubscription*) subscribeSynchronous:(id<KiiSubscribable>) subscribable withError:(NSError**) error;

/** Asynchronously unsubscribe a subscribable object using block

    [KiiPushSubscription subscribe:aBucket withBlock:^(KiiPushSubscription *subscription, NSError *error) {
        if (nil == error) {
            NSLog(@"Subscribed");
        }
    }];
 
 @param subscribable A subscribable object
 @param completion block to handle after process completed
 */
+(void) unsubscribe:(id<KiiSubscribable>) subscribable withBlock:(KiiPushSubscriptionBlock) completion;


/** Asynchronously subscribe a subscribable object using block
 
 @param subscribable A subscribable object
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
    - (void)bucketUnsubscribed:(KiiPushSubscription*)subscription withError:(NSError*)error {
         // check whether the request was successful
         if (error == nil) {
             // do something
         } else {
             // there was a problem
         }
     }

 */
+(void) unsubscribe:(id<KiiSubscribable>) subscribable withDelegate:(id) delegate andCallback:(SEL) callback;

/** Synchronously unsubscribe a subscribable object using block
 
 @param subscribable A subscribable object 
 @param error An NSError object, set to nil, to test for errors
 */
+(KiiPushSubscription*) unsubscribeSynchronous:(id<KiiSubscribable>) subscribable withError:(NSError**) error;
@end

/** A subscribable object
 */
@protocol KiiSubscribable <NSObject>





@end
