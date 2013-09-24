//
//  PhotoViewDelegate.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoViewController;

@protocol PhotoViewDelegate <NSObject>

- (void)photoViewController:(PhotoViewController*)photoViewController didBeginPinchWithScale:(CGFloat)scale;
- (void)photoViewController:(PhotoViewController*)photoViewController didChangePinchWithScale:(CGFloat)scale;
- (void)photoViewController:(PhotoViewController*)photoViewController didEndPinchWithScale:(CGFloat)scale;

- (void)photoViewController:(PhotoViewController*)photoViewController didPinchToPosition:(CGPoint)position;

- (void)photoViewController:(PhotoViewController*)photoViewController didScrollToIndexPath:(NSIndexPath*)indexPath;

@end
