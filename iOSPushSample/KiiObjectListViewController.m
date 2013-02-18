//
//  KiiObjectListViewController.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiObjectListViewController.h"
#import "KiiObjectDetailsViewController.h"
#import <KiiSDK/KiiBucket.h>
#import <KiiSDK/KiiQuery.h>
#import <KiiSDK/KiiObject.h>
#import <KiiSDK/KiiUser.h>
#import "MBProgressHUD.h"
#import "KiiAppSingleton.h"

@interface KiiObjectListViewController ()

@end

@implementation KiiObjectListViewController

@synthesize passedKiiBucket;
@synthesize passedKiiObject;
@synthesize objectDictionary;
@synthesize tableElement;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableElement:nil];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Check bucket status. If bucket is nil, show alert and pop back to previous screen.
    if (passedKiiBucket == nil) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Login Status"
                                                        message:@"Passed bucket is nil."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [messageAlert show];
        return;
    }

    // Prepare+Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Object...";

    // Retrieve objects using bucket.
    NSError *error = nil;
    NSMutableArray *objectArray = [self retrieveObjectArrayDataWithBucket:passedKiiBucket andError:&error];

    // Close progress
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // If error happens, show alert message and pop back to previous screen.
    if (error != nil) {
        NSString *message = [NSString stringWithFormat:@"%@", error];
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Object List"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
        return;
    }

    // If object is nil or empty, show alert message with empty description and pop back to previous screen,
    if (objectArray != nil && [objectArray count] == 0) {
        NSString *message = @"Object is empty";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Object List"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
    }

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *element = [NSMutableArray array];
    for (KiiObject *object in objectArray) {
        [element addObject:[object uuid]];
        [dictionary setObject:object forKey:[object uuid]];
    }

    // Set object data to property
    [self setObjectDictionary:dictionary];
    [self setTableElement:element];

    // Reload table view data.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableElement != nil) {
        return [tableElement count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [tableElement objectAtIndex:(NSUInteger) indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return;
    }
    // Check internet connection status
    if (![[KiiAppSingleton sharedInstance] checkNetworkStatus]) {
        return;
    }

    // Object delete operation.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        // Object delete
        [self deleteObjectSynchronousWithUUID:[tableElement objectAtIndex:(NSUInteger) indexPath.item] andError:&error];

        // If error happens, show alert message.
        if (error != nil) {
            // Show Error alert
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                                      initWithTitle:@"Object List"
                                                            message:@"Object delete was failed."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            // Display Alert Message
            [messageAlert show];
            return;
        }

        // If success, delete the row from the data source
        [tableElement removeObjectAtIndex:(NSUInteger) indexPath.item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return;
    }

    // Pass object data to next segue and open it.
    [self setPassedKiiObject:[objectDictionary objectForKey:[tableElement objectAtIndex:(NSUInteger) indexPath.item]]];
    [self performSegueWithIdentifier:@"ObjectDetailsView" sender:self];
}

// If passed bucketName is nil or error happens, pop back to BucketListView.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)retrieveObjectArrayDataWithBucket:(KiiBucket *)bucket andError:(NSError **)error {
    // Get all object data
    KiiQuery *allQuery = [KiiQuery queryWithClause:nil];
    KiiQuery *nextQuery;
    NSArray *results = [bucket executeQuerySynchronous:allQuery
                                             withError:error
                                               andNext:&nextQuery];
    NSMutableArray *allResults = [NSMutableArray array];
    [allResults addObjectsFromArray:results];

    // While the query was successful and there is more data to retrieve
    while (error != nil && nextQuery != nil) {
        results = [bucket executeQuerySynchronous:allQuery
                                        withError:error
                                          andNext:&nextQuery];
        [allResults addObjectsFromArray:results];
        allQuery = nextQuery;
    }
    return allResults;
}

// Delete object
- (void)deleteObjectSynchronousWithUUID:(NSString *)objectUuid andError:(NSError **)error {
    NSString *objectUri = [[objectDictionary objectForKey:objectUuid] objectURI];
    NSLog(@"Delete Object : %@", objectUri);
    KiiObject *object = [KiiObject objectWithURI:objectUri];
    [object deleteSynchronous:error];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ObjectDetailsView"]) {
        KiiObjectDetailsViewController *viewController = (KiiObjectDetailsViewController *) [segue destinationViewController];
        viewController.passedKiiObject = passedKiiObject;
    }
}

@end
