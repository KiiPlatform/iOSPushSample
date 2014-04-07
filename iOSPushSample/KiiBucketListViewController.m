//
//  KiiBucketListViewController.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiBucketListViewController.h"
#import "KiiObjectListViewController.h"
#import "MBProgressHUD.h"
#import "KiiAppSingleton.h"
#import "KiiAppError.h"
#import "TSMessage.h"
#import <KiiSDK/KiiUser.h>
#import <KiiSDK/KiiBucket.h>
#import <KiiSDK/KiiObject.h>
#import <KiiSDK/KiiACL.h>
#import <KiiSDK/KiiACLEntry.h>
#import <KiiSDK/KiiTopic.h>
#import <KiiSDK/KiiAPNSFields.h>
#import <KiiSDK/KiiPushMessage.h>
#import <KiiSDK/KiiAnyAuthenticatedUser.h>

typedef enum {
    kApp,
    kUser,
    kGroup,
} ScopeType;

@interface KiiBucketListViewController ()

@end

@implementation KiiBucketListViewController

@synthesize passedKiiBucket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self tableIndexContentsArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [[self tableUserScopeObjectCellContentsArray] count];
        case 1:
            return [[self tableUserScopeTopicCellContentsArray] count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableIndexContentsArray] == nil || [[self tableIndexContentsArray] count] <= section) {
        return @"";
    }
    return [[self tableIndexContentsArray] objectAtIndex:(NSUInteger) section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BucketCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self tableUserScopeObjectCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [[self tableUserScopeTopicCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section >= [[self tableIndexContentsArray] count]) {
        return;
    }
    // Check internet connection status
    if (![[KiiAppSingleton sharedInstance] checkNetworkStatus]) {
        return;
    }

    // Prepare+Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Bucket related operation
    NSError *error = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Object Creating...";
                [self createObject:kUser withError:&error];
                break;
            case 1:
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self setPassedKiiBucket:[[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME]];
                [self performSegueWithIdentifier:@"ObjectListView" sender:self];
                return;
            case 2:
                hud.labelText = @"Object ACL adding...";
                [self addObjectACL:kUser withError:&error];
                break;
            case 3:
                hud.labelText = @"Object ACL deleting...";
                [self deleteObjectACL:kUser withError:&error];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        // Topic related operation
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Topic Creating...";
                [self createTopic:kUser withError:&error];
                break;
            case 1:
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self inputMessageAlert];
                return;
            case 2:
                hud.labelText = @"Topic ACL adding...";
                [self addTopicACL:kUser withError:&error];
                break;
            case 3:
                hud.labelText = @"Topic ACL deleting...";
                [self deleteTopicACL:kUser withError:&error];
                break;
            default:
                break;
        }
    }

    // Close progress
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // If error happens, show alert message.
    if (error != nil) {
        NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Title" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    } else {
        [TSMessage showNotificationWithTitle:@"Successed!!"
                                        type:TSMessageNotificationTypeSuccess];
    }
}

// Create object
- (void)createObject:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }

    KiiBucket *bucket = nil;
    switch (scopeType) {
        case kUser:
            bucket = [[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME];
            break;
        default:
            break;
    }

    KiiObject *object = [bucket createObject];
    [object setObject:@"UserScopeObject" forKey:@"message"];
    [object setObject:[[KiiAppSingleton sharedInstance] currentTimeMillisByNSString] forKey:@"time"];
    [object saveSynchronous:error];
}

// Add object ACL
- (void)addObjectACL:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }

    KiiBucket *bucket = nil;
    switch (scopeType) {
        case kUser:
            bucket = [[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME];
            break;
        default:
            break;
    }

    KiiACL *acl = [bucket bucketACL];
    KiiAnyAuthenticatedUser *authUser = [KiiAnyAuthenticatedUser aclSubject];
    KiiACLEntry *entry = [KiiACLEntry entryWithSubject:authUser andAction:KiiACLBucketActionCreateObjects];
    [acl putACLEntry:entry];
    NSArray *succeeded, *failed;
    [acl saveSynchronous:error didSucceed:&succeeded didFail:&failed];
}

// Delete object ACL
- (void)deleteObjectACL:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }

    KiiBucket *bucket = nil;
    switch (scopeType) {
        case kUser:
            bucket = [[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME];
            break;
        default:
            break;
    }

    KiiACL *acl = [bucket bucketACL];
    KiiAnyAuthenticatedUser *authUser = [KiiAnyAuthenticatedUser aclSubject];
    KiiACLEntry *entry = [KiiACLEntry entryWithSubject:authUser andAction:KiiACLBucketActionCreateObjects];
    entry.grant = FALSE;
    [acl putACLEntry:entry];
    NSArray *succeeded, *failed;
    [acl saveSynchronous:error didSucceed:&succeeded didFail:&failed];
}

// Create topic
- (void)createTopic:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }
    KiiTopic *topic = nil;
    switch (scopeType) {
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        default:
            break;
    }
    [topic saveSynchronous:error];
}

// Show alert for input message
-(void)inputMessageAlert {
    if ([KiiUser currentUser] == nil) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"KiiPushMessage"
                                                        message:@"Please logged in first!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [messageAlert show];
        return;
    }

    UIAlertView *inputMessageAlert = [[UIAlertView alloc]
                                              initWithTitle:@"KiiPushMessage"
                                                    message:nil
                                                   delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [inputMessageAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [inputMessageAlert show];
}

// Send message to topic subscriber
- (void)sendMessageToTopic:(ScopeType)scopeType withMessage:(NSString *)message andError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }
    KiiTopic *topic = nil;
    switch (scopeType) {
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        default:
            break;
    }

    // Create APNs message fields
    KiiAPNSFields *apnsFields = [KiiAPNSFields createFields];
    [apnsFields setAlertBody:message];
    [apnsFields setContentAvailable:@1];

    // If you want to extra data, create dictionary and set to it.
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[[KiiAppSingleton sharedInstance] currentTimeMillisByNSString] forKey:@"time"];
    [apnsFields setSpecificData:dictionary];

    // Create message. In this case GCM fields set nil, so will not send message to Android devices.
    KiiPushMessage *pushMessage = [KiiPushMessage composeMessageWithAPNSFields:apnsFields andGCMFields:nil];
    [topic sendMessageSynchronous:pushMessage withError:error];
}

// Add topic ACL
- (void)addTopicACL:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }

    KiiTopic *topic= nil;
    switch (scopeType) {
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        default:
            break;
    }

    KiiACL *acl = [topic topicACL];
    KiiAnyAuthenticatedUser *authUser = [KiiAnyAuthenticatedUser aclSubject];
    KiiACLEntry *entry = [KiiACLEntry entryWithSubject:authUser andAction:KiiACLTopicActionSubscribe];
    [acl putACLEntry:entry];
    NSArray *succeeded, *failed;
    [acl saveSynchronous:error didSucceed:&succeeded didFail:&failed];
}

// Delete topic ACL
- (void)deleteTopicACL:(ScopeType)scopeType withError:(NSError **)error {
    if ([KiiUser currentUser] == nil) {
        *error = [[KiiAppError sharedInstance] errorUserNotLoggedIn];
        return;
    }

    KiiTopic *topic = nil;
    switch (scopeType) {
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        default:
            break;
    }

    KiiACL *acl = [topic topicACL];
    KiiAnyAuthenticatedUser *authUser = [KiiAnyAuthenticatedUser aclSubject];
    KiiACLEntry *entry = [KiiACLEntry entryWithSubject:authUser andAction:KiiACLTopicActionSubscribe];
    entry.grant = FALSE;
    [acl putACLEntry:entry];
    NSArray *succeeded, *failed;
    [acl saveSynchronous:error didSucceed:&succeeded didFail:&failed];
}

// Prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ObjectListView"]) {
        KiiObjectListViewController *viewController = (KiiObjectListViewController *) [segue destinationViewController];
        viewController.passedKiiBucket = passedKiiBucket;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *message = [alertView textFieldAtIndex:0];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Send message to Topic...";
        NSError *error = nil;
        [self sendMessageToTopic:kUser withMessage:message.text andError:&error];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

// Table index
- (NSArray *)tableIndexContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"UserScope Bucket",
                @"UserScope Topic",
                nil];
    }
    return table;
}

// Cell text for object handling
- (NSArray *)tableUserScopeObjectCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Create Object",
                @"Show Objects",
                @"Add Bucket ACL",
                @"Delete Bucket ACL",
                nil];
    }
    return table;
}

// Cell text for topic handling
- (NSArray *)tableUserScopeTopicCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Create Topic",
                @"Send message to Topic",
                @"Add Topic ACL",
                @"Delete Topic ACL",
                nil];
    }
    return table;
}

@end
