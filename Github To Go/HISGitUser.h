//
//  HISGitUser.h
//  Github To Go
//
//  Created by Tim Hise on 1/29/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HISGitUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *URLForImage;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *URLForProfile;
@property (nonatomic) BOOL isDownloading;
@property (weak, nonatomic) NSOperationQueue *operationQueue;

- (void)downloadAvatar;

@end
