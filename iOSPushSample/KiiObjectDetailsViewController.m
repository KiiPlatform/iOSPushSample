//
//  KiiObjectDetailsViewController.m
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <KiiSDK/KiiObject.h>
#import "KiiObjectDetailsViewController.h"

@interface KiiObjectDetailsViewController ()

@end

@implementation KiiObjectDetailsViewController

@synthesize passedKiiObject;
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

    // Check object status. If object is nil, show alert and pop back to previous screen.
    if (passedKiiObject == nil) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Login Status"
                                                        message:@"Passed object is nil."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [messageAlert show];
        return;
    }

    // Prepare data
    // TODO : Add internal data (UUID / modificationTime / ObjectURI / etc...)
    NSArray *array = [[passedKiiObject dictionaryValue] allKeys];
    if (array == nil || [array count] == 0) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Data Read"
                                                        message:@"Object details is empty"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
        return;
    }
    NSMutableArray *detailsArray = [NSMutableArray array];
    for (NSString *key in array) {
        NSString *details = [NSString stringWithFormat:@"Key : %@ / Value : %@", key, [passedKiiObject getObjectForKey:key]];
        [detailsArray addObject:details];
    }
    [self setTableElement:detailsArray];

    // Reload table data.
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

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // TODO : Implement object element delete
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO : Implement object element edit
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
