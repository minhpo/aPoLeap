//
//  PhotoViewCell.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoViewCell.h"
#import "PhotoViewCellDelegate.h"

@interface PhotoViewCell () {
    UIPanGestureRecognizer *_panGestureRecognizer;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewCell

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognized:)];
    _pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_pinchGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_panGestureRecognizer setMinimumNumberOfTouches:2];
    [_panGestureRecognizer setDelaysTouchesBegan:YES];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - Public methods

- (UIImage*)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage*)image {
    self.imageView.image = image;
}

#pragma mark - Private methods

- (void)pinchGestureRecognized:(UIPinchGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan
        && [self.photoViewCellDelegate respondsToSelector:@selector(photoViewCell:didBeginPinchWithScale:)]) {
        [self.photoViewCellDelegate photoViewCell:self didBeginPinchWithScale:sender.scale];
    }
    else if (sender.state == UIGestureRecognizerStateChanged
             && [self.photoViewCellDelegate respondsToSelector:@selector(photoViewCell:didChangePinchWithScale:)]) {
        [self.photoViewCellDelegate photoViewCell:self didChangePinchWithScale:sender.scale];
    }
    else if (sender.state == UIGestureRecognizerStateEnded
             && [self.photoViewCellDelegate respondsToSelector:@selector(photoViewCell:didEndPinchWithScale:)]) {
        [self.photoViewCellDelegate photoViewCell:self didEndPinchWithScale:sender.scale];
    }
}

- (void)panGestureRecognized:(UIPanGestureRecognizer*)sender {
    if ([self.photoViewCellDelegate respondsToSelector:@selector(photoViewCell:didPinchToPosition:)])
        [self.photoViewCellDelegate photoViewCell:self didPinchToPosition:[sender translationInView:self.superview]];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
