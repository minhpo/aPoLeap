//
//  PhotoViewCell.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoViewCell.h"
#import "PhotoViewCellDelegate.h"

#import "PhotoManager.h"

@interface PhotoViewCell () {
    UIPanGestureRecognizer *_panGestureRecognizer;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    
    PhotoManager *_photoManager;
    PhotoMetaData *_photoMetaData;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation PhotoViewCell

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _photoManager = [(AppDelegate*)[UIApplication sharedApplication].delegate getSharedPhotoManager];
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognized:)];
    _pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_pinchGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_panGestureRecognizer setMinimumNumberOfTouches:2];
    [_panGestureRecognizer setDelaysTouchesBegan:YES];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public methods

- (UIImage*)image {
    return self.imageView.image;
}

- (void)setPhotoMetaData:(PhotoMetaData*)photoMetaData {
    // Remove self as observer to stop receiving notifications for other photo metadata
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Update reference of photo metadata
    _photoMetaData = photoMetaData;
    
    // Attempt to get image from photo manager
    UIImage *image = [_photoManager getImageUsingPhotoMetaData:_photoMetaData];
    
    // Set new image or clear old image
    self.imageView.image = image;
    
    // If no image is available, retrieve it from remote
    if (!image) {
        NSString *notificationName;
        [_photoManager retrievePhotoUsingPhotoMetaData:_photoMetaData forNotificationName:&notificationName];
        
        // Listen to end retrieval notification
        if (notificationName)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayImage:) name:notificationName object:_photoManager];
        
        // Start loading animation
        [self.activityIndicatorView startAnimating];
    }
    else {
        // Stop loading animation
        [self.activityIndicatorView stopAnimating];
    }
}

#pragma mark - Private methods

- (void)displayImage:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Attempt to get image from photo manager
    UIImage *image = [_photoManager getImageUsingPhotoMetaData:_photoMetaData];
    
    // Display image
    if (!image)
        image = [UIImage imageNamed:@"not_available"];
    
    self.imageView.image = image;
    
    // Stop loading animation
    [self.activityIndicatorView stopAnimating];
}

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
