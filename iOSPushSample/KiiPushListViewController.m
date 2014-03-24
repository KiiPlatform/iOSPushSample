//
//  KiiPushListViewController.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiPushListViewController.h"
#import "MBProgressHUD.h"
#import "KiiAppSingleton.h"
#import "TSMessage.h"
#import <KiiSDK/KiiPushInstallation.h>
#import <KiiSDK/KiiUser.h>
#import <KiiSDK/Kii.h>
#import "KiiAppDelegate.h"

typedef enum {
    kApp,
    kUser,
    kGroup,
} ScopeType;

@interface KiiPushListViewController ()

@end

@implementation KiiPushListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Already logged-in,
    if ([KiiUser currentUser] != nil) {
        return;
    }

    // Check network status.
    // If there is no internet connection, show network status error alert.
    if (![[KiiAppSingleton sharedInstance] checkNetworkStatus]) {
        return;
    }

    // Prepare+Show progress
    NSString *message = nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Now loading...";

    // Login to KiiCloud
    NSError *error = nil;
    [[KiiAppSingleton sharedInstance] doLogInSynchronous:&error];

    // Close progress
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error == nil) {
        [TSMessage showNotificationWithTitle:@"Login Successed!!"
                                        type:TSMessageNotificationTypeSuccess];
    } else {
        message = [NSString stringWithFormat:@"%@", error];
        // Display Login Message
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Login Status"
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [messageAlert show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self tableIndexContentsArray] == nil) {
        return 0;
    } else {
        return [[self tableIndexContentsArray] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [[self tablePushInstallationCellContentsArray] count];
        case 1:
            return [[self tablePushBucketSubscriptionCellContentsArray] count];
        case 2:
            return [[self tablePushTopicSubscriptionCellContentsArray] count];
        case 3:
            return [[self tablePushBucketSubscriptionCellContentsArray] count];
        case 4:
            return [[self tablePushTopicSubscriptionCellContentsArray] count];
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
    static NSString *CellIdentifier = @"PushCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self tablePushInstallationCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [[self tablePushBucketSubscriptionCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [[self tablePushTopicSubscriptionCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 3:
            cell.textLabel.text = [[self tablePushBucketSubscriptionCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 4:
            cell.textLabel.text = [[self tablePushTopicSubscriptionCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // For out of range section
    if (indexPath.section >= [[self tableIndexContentsArray] count]) {
        return;
    }
    // Check internet connection status
    if (![[KiiAppSingleton sharedInstance] checkNetworkStatus]) {
        return;
    }

    // Prepare+Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Push related operation
    NSError *error = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Push Installing...";
                [self installationPush:&error];
                break;
            case 1:
                [self uninstallationPush:&error];
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Subscribing Bucket...";
                [self subscribeBucket:kUser withError:&error];
                break;
            case 1:
                hud.labelText = @"Unsubscribing Bucket...";
                [self unsubscribeBucket:kUser withError:&error];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Subscribing Topic...";
                [self subscribeTopic:kUser withError:&error];
                break;
            case 1:
                hud.labelText = @"Unsubscribing Topic...";
                [self unsubscribeTopic:kUser withError:&error];
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Subscribing Bucket...";
                [self subscribeBucket:kApp withError:&error];
                break;
            case 1:
                hud.labelText = @"Unsubscribing Bucket...";
                [self unsubscribeBucket:kApp withError:&error];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 4) {
        switch (indexPath.row) {
            case 0:
                hud.labelText = @"Subscribing Topic...";
                [self subscribeTopic:kApp withError:&error];
                break;
            case 1:
                hud.labelText = @"Unsubscribing Topic...";
                [self unsubscribeTopic:kApp withError:&error];
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
                                                  initWithTitle:@"iOSPushSampleApp"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [messageAlert show];
    } else {
        [TSMessage showNotificationWithTitle:@"Successed!!"
                                        type:TSMessageNotificationTypeSuccess];
    }
}

// Push installation
- (void)installationPush:(NSError **)error {
    KiiAppDelegate *app = [[UIApplication sharedApplication]delegate];
    if (app.deviceToken == nil) {
        NSLog(@"No device token found.");
        return;
    }
    [KiiPushInstallation
     installSynchronousWithDeviceToken:app.deviceToken andDevelopmentMode:YES
                                                  andError:error];
}

// Push uninstallation. But not support this operation.
- (void)uninstallationPush:(NSError **)error {
    NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
    [errorDetails setValue:@"This operation not supported." forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:@"iOSPushSample App" code:999 userInfo:errorDetails];
}

// Subscribe bucket
- (void)subscribeBucket:(ScopeType)scopeType withError:(NSError **)error {
    KiiBucket *bucket = nil;
    switch (scopeType) {
        case kApp:
            bucket = [Kii bucketWithName:APP_BUCKET_NAME];
            break;
        case kUser:
            bucket = [[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME];
            break;
        case kGroup:
            bucket = [[KiiGroup groupWithName:GROUP_NAME] bucketWithName:GROUP_BUCKET_NAME];
            break;
    }
    [KiiPushSubscription subscribeSynchronous:bucket withError:error];
}

// Unsubscribe bucket
- (void)unsubscribeBucket:(ScopeType)scopeType withError:(NSError **)error {
    KiiBucket *bucket = nil;
    switch (scopeType) {
        case kApp:
            bucket = [Kii bucketWithName:APP_BUCKET_NAME];
            break;
        case kUser:
            bucket = [[KiiUser currentUser] bucketWithName:USER_BUCKET_NAME];
            break;
        case kGroup:
            bucket = [[KiiGroup groupWithName:GROUP_NAME] bucketWithName:GROUP_BUCKET_NAME];
            break;
    }
    [KiiPushSubscription unsubscribeSynchronous:bucket withError:error];
}

// Subscribe topic
- (void)subscribeTopic:(ScopeType)scopeType withError:(NSError **)error {
    KiiTopic *topic = nil;
    switch (scopeType) {
        case kApp:
            topic = [Kii topicWithName:APP_TOPIC_NAME];
            break;
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        case kGroup:
            topic = [[KiiGroup groupWithName:GROUP_NAME] topicWithName:GROUP_TOPIC_NAME];
            break;
    }
    [KiiPushSubscription subscribeSynchronous:topic withError:error];
}

// Unsubscribe topic
- (void)unsubscribeTopic:(ScopeType)scopeType withError:(NSError **)error {
    KiiTopic *topic = nil;
    switch (scopeType) {
        case kApp:
            topic = [Kii topicWithName:APP_TOPIC_NAME];
            break;
        case kUser:
            topic = [[KiiUser currentUser] topicWithName:USER_TOPIC_NAME];
            break;
        case kGroup:
            topic = [[KiiGroup groupWithName:GROUP_NAME] topicWithName:GROUP_TOPIC_NAME];
            break;
    }
    [KiiPushSubscription unsubscribeSynchronous:topic withError:error];
}

// Table index
- (NSArray *)tableIndexContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Push Installation",
                @"UserScope Bucket Subscription",
                @"UserScope Topic Subscription",
                @"AppScope Bucket Subscription",
                @"AppScope Topic Subscription",
                nil];
    }
    return table;
}

// Cell text for push installation
- (NSArray *)tablePushInstallationCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Push Installation",
                @"Push Uninstallation",
                nil];
    }
    return table;
}

// Cell text for object subscription
- (NSArray *)tablePushBucketSubscriptionCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Subscribe Bucket",
                @"Unsubscribe Bucket",
                nil];
    }
    return table;
}

// Cell text for topic subscription
- (NSArray *)tablePushTopicSubscriptionCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Subscribe Topic",
                @"Unsubscribe Topic",
                nil];
    }
    return table;
}

@end
