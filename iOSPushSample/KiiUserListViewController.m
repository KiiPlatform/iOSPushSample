//
//  KiiUserListViewController.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiUserListViewController.h"
#import "MBProgressHUD.h"
#import "KiiAppSingleton.h"
#import <KiiSDK/KiiUser.h>

@interface KiiUserListViewController ()

@end

@implementation KiiUserListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self tableIndexContentsArray] == nil) {
        return 0;
    } else {
        return [[self tableIndexContentsArray] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self tableCellContentsArray] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableIndexContentsArray] == nil || [[self tableIndexContentsArray] count] <= section) {
        return @"";
    }
    return [[self tableIndexContentsArray] objectAtIndex:(NSUInteger) section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self tableCellContentsArray] objectAtIndex:(NSUInteger) indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // For out of range section
    if (indexPath.section != 0) {
        return;
    }
    // Check internet connection status
    if (![[KiiAppSingleton sharedInstance] checkNetworkStatus]) {
        return;
    }

    // KiiUser related operation
    NSString *message = nil;
    UIAlertView *messageAlert = nil;
    switch (indexPath.item) {
        case 0:
            [self loginKiiUser];
            break;
        case 1:
            // Show confirm dialog.
            messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"KiiUser logout confirm."
                                               message:@"Are you sure to log out?"
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"OK", nil];
            [messageAlert show];
            break;
        case 2:
            // TODO: Show more detail information.
            message = [NSString stringWithFormat:@"UserName : %@\n", [[KiiUser currentUser] username]];
            messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Row Selected" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
            break;
        case 3:
            break;
        default:
            break;
    }
}

// TODO : Change return type to void and add NSError argument.
- (NSError *)loginKiiUser {
    // KiiUser check.
    if ([KiiUser currentUser] != nil) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"KiiUser"
                                                        message:@"You are already logged in!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
        return nil;
    }

    // KiiUser login
    NSError *error = nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"User Login...";
    [[KiiAppSingleton sharedInstance] doLogInSynchronous:&error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    return error;
}

// For operation of KiiUser logout
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([KiiUser currentUser] == nil) {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                                      initWithTitle:@"KiiUser"
                                                            message:@"Please logged in first!"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            // Display Alert Message
            [messageAlert show];
            return;
        }
        NSError *error = nil;
        // TODO : Delete push installation same time. (For avoiding installation conflict)
    }
}

// Table index
- (NSArray *)tableIndexContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"KiiUser",
                nil];
    }
    return table;
}

// Cell text for KiiUser operation
- (NSArray *)tableCellContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"User Login",
                @"User Logout",
                @"User Information",
                @"User registration",
                nil];
    }
    return table;
}

@end
