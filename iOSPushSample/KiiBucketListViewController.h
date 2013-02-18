//
//  KiiBucketListViewController.h
//  iOSPushSample
//
//  Created by Ryuji OCHI on 2/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KiiBucket;

@interface KiiBucketListViewController : UITableViewController

@property (strong, nonatomic) KiiBucket *passedKiiBucket;

@end
