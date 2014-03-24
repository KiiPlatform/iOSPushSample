//
//  KiiPhotoColleSocialConnect.h
//  KiiSDK-Private
//
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KiiUser.h"

@class KiiCloudPhotoColle;
@class UINavigationController;

/**
 The type of display
 */
typedef NS_ENUM(NSInteger, KiiDCDisplayType) {
    /** Diplay type for smart phone. */
    KIIDCDISPLAYTYPE_SMART_PHONE = 0,
    /** Diplay type for tablet. */
    KIIDCDISPLAYTYPE_TABLET = 1
};

/**
 * An interface to link users to PhotoColle network.
 *
 * KiiPhotoColleSocialConnect is singleton class. You can get the
 * singleton instance by <sharedInstance>. Before getting the
 * singleton instance, You need to set up KiiPhotoColleSocialConnect
 * by
 * <setupNetworkWithClientId:clientSecret:redirectUri:displayType:>.
 * If you create KiiPhotoColleSocialConnect with
 * `[[KiiPhotoColleSocialConnect alloc] init]`, the instance does not
 * work.<br><br>
 * Prior to use KiiPhotoColleSocialConnect, you must initialize
 * the Kii SDK by <[Kii beginWithID:andKey:andSite:]>
 * with kiiSiteJP as the value of Site argument.
 */
@interface KiiPhotoColleSocialConnect : NSObject

/**
 * Set up KiiPhotoColleSocialConnect.
 * You must call this method before calling other methods of
 * KiiPhotoColleSocialConnect.
 * @param clientId The client id string which is issued for your service.
 * @param clientSecret The client secret string which is issued for your
 * service.
 * @param redirectUri The redirect URI which you registered.
 * @param displayType Type of display of target device.  See
 * `DCDisplayType` for details. DCDisplayType is defined in
 * PhotoColleSDK.framework.
 * @exception NSInvalidArgumentException Thrown if:
 * <UL>
 *  <LI>ClientId, clientSecret or redirectUri is nil or empty.</LI>
 *  <LI>displayType is nil.</LI>
 * </UL>
 * @exception NSInternalInconsistencyException PhotoColleSDK.framework
 * is not linked.
 */
+ (void)setupNetworkWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUri:(NSString *)redirectUri
                     displayType:(KiiDCDisplayType)displayType;

/**
 * Get KiiPhotoColleSocialConnect instance.
 * KiiPhotoColleSocialConnect must already be set up via <setupNetwork:withKey:andSecret:andOptions:>
 *
 * @exception KiiIllegalStateException If <setupNetworkWithClientId:clientSecret:redirectUri:displayType:>
 * has not been called.
 */
+ (KiiPhotoColleSocialConnect *)sharedInstance;

/**
 Log a user into PhotoColle network.

 Before calling this method, Application must already set up
 KiiPhotoColleSocialConnect by
 <setupNetworkWithClientId:clientSecret:redirectUri:displayType:>.

 This will initiate the login process for PhotoColle network. If
 Applications already logged into KiiCloud, then the logged in user
 are logged out. New user logs into KiiCloud and the new user is
 linked to PhotoColle network.

 Termination of authentication process is notified by
 callback. Example of the callback is following:

     // controller is a UINavigationController to show authantication
     // page. Application must implement and provide this
     // UINavigationController.
     
     [[KiiPhotoColleSocialConnect sharedInstance]
             logInOnNavigationController:controller
                            withCallback:^(KiiUser *user, NSError *error)
             {
                 if (error == nil) {
                     // Success. Do something which an application needs.
                 } else {
                     // There was a problem.
                 }
             }
      ];

 @param controller UINavigationController which is described in PhotoColle
 authentication page.
 @param callback The callback method to be called when the operation is completed.
 */
- (void)logInOnNavigationController:(UINavigationController *)controller
                       withCallback:(KiiUserBlock)callback;

/**
 Link the currently logged in user with PhotoColle network.

 Before calling this method, Application must already set up
 KiiPhotoColleSocialConnect by
 <setupNetworkWithClientId:clientSecret:redirectUri:displayType:>.

 This will initiate the login process for PhotoColle network with
 the currently logged in user. There must be a currently
 authenticated <KiiUser>. Otherwise, you can use the
 <logInOnNavigationController:withCallback:> to create and login a
 <KiiUser> using PhotoColle.

    // controller is a UINavigationController to show authantication
    // page. Application must implement and provide this
    // UINavigationController.
    
    [[KiiPhotoColleSocialConnect sharedInstance]
            linkCurrentUserOnNavigationController:controller
                                     withCallback:^(
                                         KiiUser *user,
                                         NSError *error)
            {
                if (error == nil) {
                    // Success. Do something which an application needs.
                } else {
                    // There was a problem.
                }
            }
     ];

 @param controller UINavigationController which is described PhotoColle
 authentication page.
 @param callback The callback method to be called when the operation is completed.
 */
- (void)linkCurrentUserOnNavigationController:(UINavigationController *)controller
                       withCallback:(KiiUserBlock)callback;

/**
 * Unlink the currently logged in user from PhotoColle network.
 * @param callback The callback method to be called when the operation is completed.
 */
- (void)unlinkCurrentUserWithCallback:(KiiUserBlock)callback;

/**
   Get <KiiCloudPhotoColle> object.

   Applications must link with PhotoColle newtwrok with
   <[KiiPhotoColleSocialConnect
   logInOnNavigationController:withCallback:]> or
   <[KiiPhotoColleSocialConnect
   linkCurrentUserOnNavigationController:withCallback:]> before
   getting <KiiCloudPhotoColle> object.

   <KiiCloudPhotoColle> instance holds credentials authenticated by
   <[KiiPhotoColleSocialConnect
   logInOnNavigationController:withCallback:]> or
   <[KiiPhotoColleSocialConnect
   linkCurrentUserOnNavigationController:withCallback:]>. The
   credentials will not change after <[KiiPhotoColleSocialConnect
   logInOnNavigationController:withCallback:]>,
   <[KiiPhotoColleSocialConnect
   linkCurrentUserOnNavigationController:withCallback:]>,
   <[KiiPhotoColleSocialConnect unlinkCurrentUserWithCallback:]> or
   <[KiiUser logOut]> called. Please make sure to invalidate the
   KiiCloudPhotoColle instance (ex. nullify) when you switch the login
   user.

   @return If one of following conditions is applied,
   <KiiCloudPhotoColle> instance is returned.

   * <[KiiPhotoColleSocialConnect logInOnNavigationController:withCallback:]> or <[KiiPhotoColleSocialConnect linkCurrentUserOnNavigationController:withCallback:]> has been executed and succeeded.
   * Current longin user's photocolle token has been stored.

   Otherwise, returns null.
 */
- (KiiCloudPhotoColle *)kiiCloudPhotoColle;

@end
