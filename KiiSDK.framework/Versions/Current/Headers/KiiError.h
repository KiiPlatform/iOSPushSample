//
//  KiiError.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 12/21/11.
//  Copyright (c) 2011 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Find error codes and messages that can be returned by Kii SDK
 
 <h3>Application Errors (1xx)</h3>
 - *101* - The application received invalid credentials and was not initialized
 - *102* - The application was not found on the server. Please ensure your app id and key were entered correctly.

 <h3>Connectivity Errors (2xx)</h3>
 - *201* - Unable to connect to the internet
 - *202* - Unable to parse server response
 - *203* - Unable to authorize request
 
 <h3>User API Errors (3xx)</h3>
 - *301* - Unable to retrieve valid access token
 - *302* - Unable to authenticate user
 - *303* - Unable to retrieve file list
 - *304* - Invalid password format. Password must be at least 4 characters and can include these characters: a-z, A-Z, 0-9, @, #, $, %, ^, and &
 - *305* - Invalid email format. Email must be a valid address
 - *306* - Invalid user object. Please ensure the credentials were entered properly
 - *307* - Invalid username format. The username must be 5-50 alphanumeric characters - the first character must be a letter
 - *308* - Invalid phone format. The phone number must begin with a '+' and must be at least 10 digits
 - *309* - Unable to verify account. Please ensure the verification code provided is correct
 - *310* - Invalid displayname format. The displayname must be 4-50 alphanumeric characters - the first character must be a letter
 - *311* - The user's email was unable to be updated on the server
 - *312* - The user's phone number was unable to be updated on the server
 - *313* - Invalid email address format or phone number format. A userIdentifier must be one of the two
 - *314* - The request could not be made - the key associated with the social network is invalid
 - *315* - Invalid country code.
 - *316* - Invalid local phone format. The phone number numerical and must be at least 7 digits
 
 <h3>File API Errors (4xx)</h3>
 - *401* - Unable to delete file from cloud
 - *402* - Unable to upload file to cloud
 - *403* - Unable to retrieve local file for uploading. May not exist, or may be a directory
 - *404* - Unable to shred file. Must be in the trash before it is permanently deleted
 - *405* - Unable to perform operation - a valid container must be set first
 
 <h3>Core Object Errors (5xx)</h3>
 - *501* - Invalid objects passed to method. Must be already saved on server
 - *502* - Unable to parse object. Must be JSON-encodable
 - *503* - Duplicate entry exists
 - *504* - Invalid remote path set for KiiFile. Must be of form:  /root/path/subpath
 - *505* - Unable to delete object from cloud
 - *506* - Invalid KiiObject type - the type does not match the regex [A-Za-z]{1}[A-Za-z0-9-_]{4,49}
 - *507* - Unable to set an object as a child of itself
 - *508* - The key of the object being set is being used by the system. Please use a different key
 - *509* - The container you are trying to operate on does not exist
 - *510* - The object you are trying to operate on does not exist on the server
 - *511* - The URI provided is invalid
 - *512* - The object you are saving is older than what is on the server. Use one of the KiiObject#save:forced: methods to forcibly override data on the server
 - *513* - The group name provided is not valid. Ensure it is alphanumeric and more than 0 characters in length
 - *514* - At least one of the ACL entries saved to an object failed. Please note there may also have been one or more successful entries

 <h3>Query Errors (6xx)</h3>
 - *601* - No more query results exist
 - *602* - Query limit set too high
 
 
 <h3>Push Notification error (7xx)
 - *701* - Push installation error. Installation already exist
 - *702* - Push subscription already exists
 - *703* - Push subscription does not exist
 - *704* - Topic is already exist
 - *705* - Topic does not exist
 - *706* - invalid push message data
 - *707* - APNS field is required
 - *708* - Push data is required
 - *709* - Device token is not set

 */
@interface KiiError : NSError

+ (NSError*) errorWithCode:(NSString*)code andMessage:(NSString*)message;


/* The application received invalid credentials and was not initialized. Make sure you have called [Kii begin...] with the proper app id and key before making any requests */
+ (NSError*) invalidApplication;

/* The application was not found on the server. Please ensure your app id and key were entered correctly. */
+ (NSError*) appNotFound;


/* Connectivity Errors (2xx) */

/* Unable to connect to the internet */
+ (NSError*) unableToConnectToInternet;

/* Unable to parse server response */
+ (NSError*) unableToParseResponse;

/* Unable to authorize request */
+ (NSError*) unauthorizedRequest;


/* User API Errors (3xx) */

/* Unable to retrieve valid access token */
+ (NSError*) invalidAccessToken;

/* Unable to authenticate user */
+ (NSError*) unableToAuthenticateUser;

/* Unable to retrieve file list */
+ (NSError*) unableToRetrieveUserFileList;

/* Invalid password format. Password must be at least 5 characters and can include these characters: a-z, A-Z, 0-9, @, #, $, %, ^, and & */
+ (NSError*) invalidPasswordFormat;

/* Invalid email format. Email must be a valid address */
+ (NSError*) invalidEmailFormat;

/* Invalid email address format or phone number format. A userIdentifier must be one of the two */
+ (NSError*) invalidUserIdentifier;

/* Invalid username format. The username must be 5-50 alphanumeric characters - the first character must be a letter. */
+ (NSError*) invalidUsername;

/* Invalid user object. Please ensure the credentials were entered properly */
+ (NSError*) invalidUserObject;

/* Invalid phone format. The username may begin with a '+' and must be at least 10 digits */
+ (NSError*) invalidPhoneFormat;

/* Invalid Country code. 2-letters country code, capital letters*/
+ (NSError*) invalidCountryCode;
/* Invalid local phone format. The phone number numerical and must be at least 7 digits*/
+ (NSError*) invalidLocalPhoneFormat;

/* Invalid verification code */
+ (NSError*) unableToVerifyUser;

/* Invalid displayname format. The displayname must be 4-50 alphanumeric characters - the first character must be a letter. */
+ (NSError*) invalidDisplayName;

/* The user's email was unable to be updated on the server */
+ (NSError*) unableToUpdateEmail;

/* The user's phone number was unable to be updated on the server */
+ (NSError*) unableToUpdatePhoneNumber;

/* The request could not be made - the key associated with the social network is invalid. */
+ (NSError*) invalidSocialNetworkKey;



/* File API Errors (4xx) */

/* Unable to delete file from cloud */
+ (NSError*) unableToDeleteFile;

/* Unable to upload file to cloud */
+ (NSError*) unableToUploadFile;

/* Unable to retrieve local file for uploading. May not exist, or may be a directory. */
+ (NSError*) localFileInvalid;

/* Unable to shred file. Must be in the trash before it is permanently deleted. */
+ (NSError*) shreddedFileMustBeInTrash;

/* Unable to perform operation - a valid container must be set first. */
+ (NSError*) fileContainerNotSpecified;


/* Core Object Errors (5xx) */

/* Invalid objects passed to method. Must be already saved on server. */
+ (NSError*) invalidObjects;

/* Unable to parse object. Must be JSON-encodable */
+ (NSError*) unableToParseObject;

/* Duplicate entry exists */
+ (NSError*) duplicateEntry;

/* Invalid remote path set for KiiFile. Must be of form:  /root/path/subpath    */
+ (NSError*) invalidRemotePath;

/* Unable to delete object from cloud */
+ (NSError*) unableToDeleteObject;

/* Invalid KiiObject - the class name contains one or more spaces */
+ (NSError*) invalidObjectType;

/* Unable to set an object as a child of itself */
+ (NSError*) unableToSetObjectToItself;

/* The key of the object being set is a preferred key, please try a different key */
+ (NSError*) invalidAttributeKey;

/* The container you are trying to operate on does not exist */
+ (NSError*) invalidContainer;

/* The object you are trying to operate on does not exist */
+ (NSError*) objectNotFound;

/* The URI provided is invalid */
+ (NSError*) invalidURI;

/* The group name provided is not valid. Ensure it is alphanumeric and more than 0 characters in length */
+ (NSError*) invalidGroupName;

/* At least one of the ACL entries saved to an object failed. Please note there may also have been one or more successful entries. */
+ (NSError*) partialACLFailure;



/* Query Errors (6xx) */

/* No more query results exist */
+ (NSError*) noMoreResults;

/* Query limit set too high */
+ (NSError*) singleQueryLimitExceeded;

/* Push Notification Errors */

/*Push installation error. Installation already exist*/
+ (NSError*) installationAlreadyExist;

/* Push subcription already exist */
+ (NSError*) subscriptionAlreadyExist;

/*Push subscription does not exist*/
+ (NSError*) subscriptionNotExist;

/* Topic is already exist */
+ (NSError*) topicAlreadyExist;

/* Topic does not exist */
+ (NSError*) topicNotExist;

/* invalid push message data */
+ (NSError*) invalidPushMessageData;

/* APNS field is required */
+ (NSError*) apnsFieldRequired;

/* Push data is required */
+ (NSError*) pushDataRequired;

/* Device token is not set*/
+ (NSError*) deviceTokenNotSet;
@end
