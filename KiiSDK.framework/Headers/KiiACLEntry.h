//
//  KiiACLEntry.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 6/11/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KiiACLBucketActionCreateObjects,
    KiiACLBucketActionQueryObjects,
    KiiACLBucketActionDropBucket,
    KiiACLFileActionRead,
    KiiACLFileActionWrite,
    KiiACLObjectActionRead,
    KiiACLObjectActionWrite, 
    KiiACLTopicActionSubscribe,
    KiiACLTopicActonSend

} KiiACLAction; 


/** A reference to a single ACL
 
 This object is used to control permissions on an object at a user/group level.
 */
@interface KiiACLEntry : NSObject 

/** The action that is being permitted/restricted. Possible values:
 
 KiiACLBucketActionCreateObjects,
 
 KiiACLBucketActionQueryObjects,
 
 KiiACLBucketActionDropBucket,
 
 KiiACLFileActionRead,
 
 KiiACLFileActionWrite,
 
 KiiACLObjectActionRead,
 
 KiiACLObjectActionWrite,
 
 KiiACLTopicActionSubscribe,

 KiiACLTopicActonSend

 */
@property (nonatomic, assign) KiiACLAction action; 

/** The KiiGroup or KiiUser that is being permitted/restricted */
@property (nonatomic, strong) id subject; 

/** When TRUE, the associated action is granted. When FALSE, the action is restricted */
@property (nonatomic, assign) BOOL grant; 

// internal use
@property (readonly) BOOL updated;


/** Create a KiiACLEntry object with a subject and action
 
 The entry will not be applied on the server until the KiiACL object is explicitly saved. This method simply returns a working KiiACLEntry with a specified subject and action. 
 @param subject A KiiGroup, KiiUser, KiiAnyAuthenticatedUser or KiiAnonymousUser object to which the action/grant is being applied
 @param action One of the specified KiiACLAction values the permissions is being applied to
 @return A KiiACLEntry object with the specified attributes. nil if the subject is not an accepted type
 */
+ (KiiACLEntry*) entryWithSubject:(id)subject andAction:(KiiACLAction)action; 

@end
