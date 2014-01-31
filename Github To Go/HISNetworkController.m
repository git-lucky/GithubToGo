//
//  HISNetworkController.m
//  Github To Go
//
//  Created by Tim Hise on 1/27/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISNetworkController.h"

@implementation HISNetworkController

+ (HISNetworkController *)sharedController
{
    static HISNetworkController *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (NSMutableArray *)reposForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", searchString];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    @try {
        NSURL *searchURL = [NSURL URLWithString:searchString];
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
        return [searchDictionary objectForKey:@"items"];
    }
    @catch (NSException *exception) {
        NSLog(@"API Limit Reached %@", exception.debugDescription);
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
}

- (NSMutableArray *)usersForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    @try {
        NSURL *searchURL = [NSURL URLWithString:searchString];
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
        return [searchDictionary objectForKey:@"items"];
    }
    @catch (NSException *exception) {
        NSLog(@"API Limit Reached %@", exception.debugDescription);
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
}

@end
