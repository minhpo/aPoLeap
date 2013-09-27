//
//  PhotoViewController.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoViewDelegate.h"
#import "PhotoViewDataSource.h"

@interface PhotoViewController () {
    UIPanGestureRecognizer *_oneFingerPanGestureRecognizer;
    UIPanGestureRecognizer *_twoFingerPanGestureRecognizer;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    
    NSInteger _centerIndex;
    
    UIView *_leftSnapShot;
    UIView *_centerSnapShot;
    UIView *_rightSnapShot;
    
    CGPoint _startingPoint;
}

@property (nonatomic, strong) IBOutlet UIImageView *leftImageView;
@property (nonatomic, strong) IBOutlet UIImageView *centerImageView;
@property (nonatomic, strong) IBOutlet UIImageView *rightImageView;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.leftImageView.center = CGPointMake(self.view.center.x - self.view.frame.size.width, self.view.center.y);
    self.rightImageView.center = CGPointMake(self.view.center.x + self.view.frame.size.width, self.view.center.y);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    // Set views to be visible
    self.leftImageView.alpha = 1;
    self.rightImageView.alpha = 1;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    // Set views to be invisible to avoid the effect of short flickering at start of rotation
    self.leftImageView.alpha = 0;
    self.rightImageView.alpha = 0;
    
    // Reposition image views on orientation change
    [UIView animateWithDuration:duration
                     animations:^(){
                         self.leftImageView.center = CGPointMake(self.view.center.x - self.view.frame.size.height, self.view.center.y);
                         self.rightImageView.center = CGPointMake(self.view.center.x + self.view.frame.size.height, self.view.center.y);
                     }];
}

#pragma mark - Public methods

- (UIImageView*)getImageView {
    return self.centerImageView;
}

- (void)setContentForIndex:(NSInteger)index {
    // Keep reference to index path
    _centerIndex = index;

    // Notify delegate of current index
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewController:didScrollToIndex:)])
        [self.photoViewDelegate photoViewController:self didScrollToIndex:_centerIndex];
    
    // Set center image
    if ([self.photoViewDataSource respondsToSelector:@selector(photoViewController:getImageForIndex:)])
        self.centerImageView.image = [self.photoViewDataSource photoViewController:self getImageForIndex:_centerIndex];
    
    // Set left image
    if (_centerIndex > 0) {
        self.leftImageView.image = [self.photoViewDataSource photoViewController:self getImageForIndex:_centerIndex-1];
        self.leftImageView.hidden = NO;
    }
    else {
        self.leftImageView.hidden = YES;
    }
    
    // Set right image
    if ([self.photoViewDataSource respondsToSelector:@selector(numberOfPhotos)]
        && _centerIndex < [self.photoViewDataSource numberOfPhotos] - 1) {
        self.rightImageView.image = [self.photoViewDataSource photoViewController:self getImageForIndex:_centerIndex + 1];
    }
    else {
        self.rightImageView.hidden = YES;
    }
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
        // Create snapshots for translations
        _leftSnapShot = [self.leftImageView snapshotViewAfterScreenUpdates:NO];
        _leftSnapShot.frame = self.leftImageView.frame;
        [self.view addSubview:_leftSnapShot];
        self.leftImageView.alpha = 0;
        
        _centerSnapShot = [self.centerImageView snapshotViewAfterScreenUpdates:NO];
        _centerSnapShot.frame = self.centerImageView.frame;
        [self.view addSubview:_centerSnapShot];
        self.centerImageView.alpha = 0;
        
        _rightSnapShot = [self.rightImageView snapshotViewAfterScreenUpdates:NO];
        _rightSnapShot.frame = self.rightImageView.frame;
        [self.view addSubview:_rightSnapShot];
        self.rightImageView.alpha = 0;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        // Update the positions during pan
        CGPoint translation = [sender translationInView:self.view];
        
        CGPoint leftCenter = self.leftImageView.center;
        leftCenter.x += translation.x;
        _leftSnapShot.center = leftCenter;
        
        CGPoint center = self.centerImageView.center;
        center.x += translation.x;
        _centerSnapShot.center = center;
        
        CGPoint rightCenter = self.rightImageView.center;
        rightCenter.x += translation.x;
        _rightSnapShot.center = rightCenter;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [sender translationInView:self.view];
        
        float xTranslation = fabsf(translation.x);
        // Return to initial state if translation threshold is not exceeded or there is not content on the left/right side
        if (xTranslation < self.view.frame.size.width / 2
            || (self.leftImageView.hidden && translation.x > 0)
            || (self.rightImageView.hidden && translation.x < 0)) {
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 _leftSnapShot.frame = self.leftImageView.frame;
                                 _centerSnapShot.frame = self.centerImageView.frame;
                                 _rightSnapShot.frame = self.rightImageView.frame;
                             }
                             completion:^(BOOL finished){
                                 [_leftSnapShot removeFromSuperview];
                                 [_centerSnapShot removeFromSuperview];
                                 [_rightSnapShot removeFromSuperview];
                                 
                                 self.leftImageView.alpha = 1;
                                 self.centerImageView.alpha = 1;
                                 self.rightImageView.alpha = 1;
                             }];
        }
        // Left translation, should get next image after completion
        else if (translation.x < 0) {
            // No content on the right side, should return to normal position
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 _centerSnapShot.frame = self.leftImageView.frame;
                                 _rightSnapShot.frame = self.centerImageView.frame;
                             }
                             completion:^(BOOL finished){
                                 [_leftSnapShot removeFromSuperview];
                                 [_centerSnapShot removeFromSuperview];
                                 [_rightSnapShot removeFromSuperview];
                                 
                                 self.leftImageView.alpha = 1;
                                 self.centerImageView.alpha = 1;
                                 self.rightImageView.alpha = 1;
                                 
                                 // Set right image
                                 if ([self.photoViewDataSource respondsToSelector:@selector(numberOfPhotos)]
                                     && _centerIndex < [self.photoViewDataSource numberOfPhotos] - 1) {
                                     [self setContentForIndex:_centerIndex + 1];
                                 }
                             }];
        }
        // Right translation, should get previous image after completion
        else {
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 _leftSnapShot.frame = self.centerImageView.frame;
                                 _centerSnapShot.frame = self.rightImageView.frame;
                             }
                             completion:^(BOOL finished){
                                 [_leftSnapShot removeFromSuperview];
                                 [_centerSnapShot removeFromSuperview];
                                 [_rightSnapShot removeFromSuperview];
                                 
                                 self.leftImageView.alpha = 1;
                                 self.centerImageView.alpha = 1;
                                 self.rightImageView.alpha = 1;
                                 
                                 // Set left image
                                 if (_centerIndex > 0) {
                                     [self setContentForIndex:_centerIndex - 1];
                                 }
                             }];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
