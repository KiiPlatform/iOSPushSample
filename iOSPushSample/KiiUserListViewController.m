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
    switch (section) {
        case 0:
            return [[self tableCellKiiUserContentsArray] count];
        case 1:
            return [[self tableCellDebugContentsArray] count];
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
    static NSString *CellIdentifier = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self tableCellKiiUserContentsArray] objectAtIndex:(NSUInteger) indexPath.row];
            break;
        case 1:
            if(indexPath.row == 0){
                cell = [self setDebugSwitch:cell withIndex:(NSUInteger) indexPath.row];
            } else if (indexPath.row == 1){
                cell = [self setMessageShowSwitch:cell withIndex:(NSUInteger) indexPath.row];
            }
            break;
        default:
            break;
    }
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
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
                //[self loginKiiUser];
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
            default:
                break;
        }
    } else if (indexPath.section == 1) {

    }
}

// Set debug switch
- (UITableViewCell *)setDebugSwitch:(UITableViewCell *)cell withIndex:(NSUInteger )index{
    UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
    switchObj.on = [[KiiAppSingleton sharedInstance] debugMode];
    [switchObj addTarget:self action:@selector(settingDebugSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchObj;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self tableCellDebugContentsArray] objectAtIndex:index];
    return cell;
}

- (IBAction)settingDebugSwitch:(id)sender {
    if ([sender isOn] == YES) {
        [[KiiAppSingleton sharedInstance] setDebugMode:YES];
    } else {
        [[KiiAppSingleton sharedInstance] setDebugMode:NO];
    }
}

// Set message show switch
- (UITableViewCell *)setMessageShowSwitch:(UITableViewCell *)cell withIndex:(NSUInteger )index{
    UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
    switchObj.on = [[KiiAppSingleton sharedInstance] messageShowOffMode];
    [switchObj addTarget:self action:@selector(settingMessageShowSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchObj;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self tableCellDebugContentsArray] objectAtIndex:index];
    return cell;
}

- (IBAction)settingMessageShowSwitch:(id)sender {
    if ([sender isOn] == YES) {
        [[KiiAppSingleton sharedInstance] setMessageShowOffMode:YES];
    } else {
        [[KiiAppSingleton sharedInstance] setMessageShowOffMode:NO];
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
        [[KiiAppSingleton sharedInstance] doLogOut];
    }
}

// Table index
- (NSArray *)tableIndexContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"KiiUser",
                @"Debug",
                nil];
    }
    return table;
}

// Cell text for KiiUser operation
- (NSArray *)tableCellKiiUserContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"User Login",
                @"User Logout",
                @"User Information",
                nil];
    }
    return table;
}

// Cell text for Debug operation
- (NSArray *)tableCellDebugContentsArray {
    static NSArray *table = nil;
    if (table == nil) {
        table = [[NSArray alloc] initWithObjects:
                @"Debug mode",
                @"Message show off",
                nil];
    }
    return table;
}

@end
