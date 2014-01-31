//
//  HISCollectionViewCell.h
//  Github To Go
//
//  Created by Tim Hise on 1/29/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HISCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (readwrite, nonatomic) BOOL isDownloading;

@end
