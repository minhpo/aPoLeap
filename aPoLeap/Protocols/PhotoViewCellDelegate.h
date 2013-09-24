//
//  PhotoViewCellDelegate.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoViewCell;

@protocol PhotoViewCellDelegate <NSObject>

- (void)photoViewCell:(PhotoViewCell*)cell didBeginPinchWithScale:(CGFloat)scale;
- (void)photoViewCell:(PhotoViewCell*)cell didChangePinchWithScale:(CGFloat)scale;
- (void)photoViewCell:(PhotoViewCell*)cell didEndPinchWithScale:(CGFloat)scale;

- (void)photoViewCell:(PhotoViewCell*)cell didPinchToPosition:(CGPoint)position;

@end
