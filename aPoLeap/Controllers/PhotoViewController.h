//
//  PhotoViewController.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewDelegate;

@interface PhotoViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) id<PhotoViewDelegate>photoViewDelegate;

@end
