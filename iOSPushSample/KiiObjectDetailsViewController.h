//
//  KiiObjectDetailsViewController.h
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiObjectDetailsViewController : UITableViewController

@property (retain, nonatomic) KiiObject *passedKiiObject;
@property (retain, nonatomic) NSMutableArray *tableElement;

@end
