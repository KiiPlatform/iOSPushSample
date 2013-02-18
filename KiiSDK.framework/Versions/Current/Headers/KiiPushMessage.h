//
//  KiiPushMessage.h
//  KiiSDK-Private
//
//  Created by Riza Alaudin Syah on 1/24/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/** enumeration
 APP_ID = "a";
 SENDER = "s";
 TYPE = "t";
 WHEN = "w";
 ORIGIN = "o";
 TOPIC = "to";
 SCOPE_APP_ID = "sa";
 SCOPE_USER_ID = "su";
 SCOPE_GROUP_ID = "sg";
 SCOPE_TYPE = "st";
 BUCKET_ID = "bi";
 BUCKET_TYPE = "bt";
 OBJECT_ID = "oi";
 OBJECT_MODIFIED_AT = "om";
  */
typedef enum {
    APP_ID,
    SENDER,
    TYPE,
    WHEN,
    ORIGIN,
    TOPIC,
    SCOPE_APP_ID,
    SCOPE_USER_ID,
    SCOPE_GROUP_ID,
    SCOPE_TYPE,
    BUCKET_ID,
    BUCKET_TYPE,
    OBJECT_ID,
    OBJECT_MODIFIED_AT
}KiiMessageField;
@class KiiAPNSFields,KiiGCMFields;

/** Class for encapsulating incoming and outgoing push notification message
 */
@interface KiiPushMessage : NSObject

@property(nonatomic,readonly) NSDictionary* rawMessage;

/**Dictionary representation of	JSON Object with only one-level of nesting. Required if no system-specific “data” fields has been provided for all the systems enabled.	Dictionary with the data that will be sent to all the push systems enabled in this request.
 */
@property(nonatomic,strong) NSDictionary* data;


/** APNS-specific fields.
 */
@property(nonatomic,strong) KiiAPNSFields* apnsFields;

/** GCM-specific fields.
 */
@property(nonatomic,strong) KiiGCMFields* gcmFields;

/**Boolean. Not required.	If true this message will be sent to the devices that have the property "development" to "true" in their installations. Default is true.
 */
@property(nonatomic,strong) NSNumber* sendToDevelopment;

/**Boolean. Not required.	If true this message will be sent to the devices that have the property "development" to "false" or null in their installations. Default is true.
 */
@property(nonatomic,strong) NSNumber* sendToProduction;

/**String. Not required.	Value that will optionally indicate what is the type of the message. Event-generated push messages contain it.
 */
@property(nonatomic,strong) NSString* pushMessageType;

/**Boolean. Not required.	If true, the appID field will also be sent. Default is false.
 */
@property(nonatomic,strong) NSNumber* sendAppID;

/**Boolean. Not required.	If true, send the “sender” field (userID of the user that triggered the notification). Default is true.
 */
@property(nonatomic,strong) NSNumber* sendSender;

/** sendWhen	Boolean. Not required.	If true, send the “when” field (when the push message was sent). Default is false.
 */
@property(nonatomic,strong) NSNumber* sendWhen;

/**Boolean. Not required.	If true, send the “origin” field (indicates if the message is the result of an event or sent explicitly by someone. Default is false.

 */
@property(nonatomic,strong) NSNumber* sendOrigin;

/**Boolean. Not required.	If true, send the “objectScope”-related fields that contain the topic that is the source of this notification. Default is true.

 */
@property(nonatomic,strong) NSNumber* sendObjectScope;

/**Boolean. Not required.	If true, send the “topicID” field, which contains the topicID that is the source of this notification. Default is true.
 */
@property(nonatomic,strong) NSNumber* sendTopicID;
/**Parse incoming APNS message.
 */
+(KiiPushMessage*) messageFromAPNS:(NSDictionary*) userInfo;

/**Constructor method that composes a message for explicit push
 @param fields message data for APNS
 @param fields message data for GCM
 */
+(KiiPushMessage*) composeMessageWithAPNSFields:(KiiAPNSFields*) apnsfields andGCMFields:(KiiGCMFields*)gcmfields;

/**Get specific value of push notification meta data.
 @param field enum of KiiMessageField 
 
    APP_ID = "a";
    SENDER = "s";
    TYPE = "t";
    WHEN = "w";
    ORIGIN = "o";
    TOPIC = "to";
    SCOPE_APP_ID = "sa";
    SCOPE_USER_ID = "su";
    SCOPE_GROUP_ID = "sg";
    SCOPE_TYPE = "st";
    BUCKET_ID = "bi";
    BUCKET_TYPE = "bt";
    OBJECT_ID = "oi";
    OBJECT_MODIFIED_AT = "om";
 
 */
-(NSString*) getValueOfKiiMessageField:(KiiMessageField) field;

/**Get alert body's text message.
 */
-(NSString*) getAlertBody;

/**Show simple alert to display alert body's message.
 @param title Alert title.
 */
-(void) showMessageAlertWithTitle:(NSString*) title;


@end
