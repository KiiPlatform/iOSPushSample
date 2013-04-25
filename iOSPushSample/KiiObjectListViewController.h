//
//  KiiObjectListViewController.h
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KiiBucket;
@class KiiObject;

@interface KiiObjectListViewController : UITableViewController

@property (retain, nonatomic) KiiBucket *passedKiiBucket;
@property (retain, nonatomic) KiiObject *passedKiiObject;
@property (retain, nonatomic) NSMutableDictionary *objectDictionary;
@property (retain, nonatomic) NSMutableArray *tableElement;
@property (retain, nonatomic) NSMutableArray *tableSubElement;

@end
