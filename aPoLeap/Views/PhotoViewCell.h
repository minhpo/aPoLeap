//
//  PhotoViewCell.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewCellDelegate;

@interface PhotoViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

- (UIImage*)image;
- (void)setImage:(UIImage*)image;

@property (nonatomic, weak) id<PhotoViewCellDelegate>photoViewCellDelegate;

@end
