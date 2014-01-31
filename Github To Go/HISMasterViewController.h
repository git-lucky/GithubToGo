//
//  HISMasterViewController.h
//  Github To Go
//
//  Created by Tim Hise on 1/27/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HISDetailViewController;

@interface HISMasterViewController : UITableViewController

@property (strong, nonatomic) HISDetailViewController *detailViewController;

@end
