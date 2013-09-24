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
    UIPanGestureRecognizer *_oneFingerPanGestureRecognizer;
    UIPanGestureRecognizer *_twoFingerPanGestureRecognizer;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    
    UIView *_snapShot;
}

@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognized:)];
    _pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_pinchGestureRecognizer];
    
    _twoFingerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPanGestureRecognized:)];
    [_twoFingerPanGestureRecognizer setMinimumNumberOfTouches:2];
    [_twoFingerPanGestureRecognizer setDelaysTouchesBegan:YES];
    _twoFingerPanGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_twoFingerPanGestureRecognizer];
    
    _oneFingerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerPanGestureRecognized:)];
    [_oneFingerPanGestureRecognizer setMaximumNumberOfTouches:1];
    [_oneFingerPanGestureRecognizer setDelaysTouchesBegan:YES];
    [self.view addGestureRecognizer:_oneFingerPanGestureRecognizer];
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

- (void)twoFingerPanGestureRecognized:(UIPanGestureRecognizer*)sender {
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewController:didPinchToPosition:)])
        [self.photoViewDelegate photoViewController:self didPinchToPosition:[sender translationInView:self.view.superview]];
}

- (void)oneFingerPanGestureRecognized:(UIPanGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _snapShot = [self.imageView snapshotViewAfterScreenUpdates:NO];
        _snapShot.frame = self.imageView.frame;
        
        [self.view addSubview:_snapShot];
        self.imageView.alpha = 0;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        if (_snapShot) {
            CGPoint translation = [sender translationInView:self.view];
            
            CGPoint center = self.imageView.center;
            center.x += translation.x;
            
            _snapShot.center = center;
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _snapShot.frame = self.imageView.frame;
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             
                             self.imageView.alpha = 1;
                         }];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
