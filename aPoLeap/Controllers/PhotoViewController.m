//
//  PhotoViewController.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoViewDelegate.h"

@interface PhotoViewController () {
    UIPanGestureRecognizer *_panGestureRecognizer;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
}
@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognized:)];
    _pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_pinchGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_panGestureRecognizer setMinimumNumberOfTouches:2];
    [_panGestureRecognizer setDelaysTouchesBegan:YES];
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - Private methods

- (void)pinchGestureRecognized:(UIPinchGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan
        && [self.photoViewDelegate respondsToSelector:@selector(photoViewController:didBeginPinchWithScale:)]) {
        [self.photoViewDelegate photoViewController:self didBeginPinchWithScale:sender.scale];
    }
    else if (sender.state == UIGestureRecognizerStateChanged
             && [self.photoViewDelegate respondsToSelector:@selector(photoViewController:didChangePinchWithScale:)]) {
        [self.photoViewDelegate photoViewController:self didChangePinchWithScale:sender.scale];
    }
    else if (sender.state == UIGestureRecognizerStateEnded
             && [self.photoViewDelegate respondsToSelector:@selector(photoViewController:didEndPinchWithScale:)]) {
        [self.photoViewDelegate photoViewController:self didEndPinchWithScale:sender.scale];
    }
}

- (void)panGestureRecognized:(UIPanGestureRecognizer*)sender {
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewController:didPinchToPosition:)])
        [self.photoViewDelegate photoViewController:self didPinchToPosition:[sender translationInView:self.view.superview]];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
