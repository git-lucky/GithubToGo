//
//  HISNetworkController.h
//  Github To Go
//
//  Created by Tim Hise on 1/27/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HISNetworkController : NSObject

+ (HISNetworkController *)sharedController;

- (NSMutableArray *)reposForSearchString:(NSString *)searchString;

- (NSMutableArray *)usersForSearchString:(NSString *)searchString;

@end