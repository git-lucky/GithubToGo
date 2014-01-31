//
//  HISGitUser.m
//  Github To Go
//
//  Created by Tim Hise on 1/29/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISGitUser.h"

@implementation HISGitUser

- (void)downloadAvatar
{
    self.isDownloading = YES;
        
    [self.operationQueue addOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.URLForImage];
        self.image = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_NOTIFICATION
                                                                object:nil
                                                              userInfo:@{USER_KEY: self}];
        }];
        
    }];
}


@end
