//
//  PhotoCollectionViewController.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoViewController.h"
#import "PhotoViewCell.h"

static const NSString *photoViewCellIdentifier = @"photoViewCellIdentifier";

@interface PhotoCollectionViewController () {
    PhotoViewController *_photoViewController;
    
    __weak PhotoViewCell *_currentSelectedCell;
    UIView *_snapShot;
    
    BOOL _didEndPinch;
    
    NSArray *_pictures;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Fill array with content
    _pictures = @[@"01.jpg", @"02.jpg", @"03.jpg"];
    
    // Register xib for collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:photoViewCellIdentifier];
    
    // Set layout properties for the collection view
    self.flowLayout.itemSize = CGSizeMake(100.0, 100.0);
    self.flowLayout.minimumInteritemSpacing = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pictures.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoViewCellIdentifier forIndexPath:indexPath];
    if (!cell.photoViewCellDelegate)
        cell.photoViewCellDelegate = self;
    
    [cell setImage:[UIImage imageNamed:_pictures[indexPath.row]]];
    
    return cell;
}

#pragma mark - PhotoViewCellDelegate

- (void)photoViewCell:(PhotoViewCell*)cell didBeginPinchWithScale:(CGFloat)scale {
    // Disable scroll to avoid scrolling of collection while pinching
    self.collectionView.scrollEnabled = NO;
    
    // Keep reference to current selected cell
    _currentSelectedCell = cell;
    
    // Take snapshot of content for interaction
    _snapShot = [_currentSelectedCell snapshotViewAfterScreenUpdates:NO];
    
    // Get converted position in root view coordinate system
    _snapShot.frame = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
    [self.view addSubview:_snapShot];
    
    // Hide content of current cell
    _currentSelectedCell.alpha = 0;
}

- (void)photoViewCell:(PhotoViewCell*)cell didChangePinchWithScale:(CGFloat)scale {
    if (_snapShot) {
        // Adjust the size depending on the scale
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        _snapShot.transform = transform;
    }
}

- (void)photoViewCell:(PhotoViewCell*)cell didEndPinchWithScale:(CGFloat)scale {
    // Set semaphore to prevent two finger pan gesture from changing properties
    _didEndPinch = YES;

    // If scale threshold is not reached, then animate the snapshot back to small display
    if (scale < 2) {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _snapShot.frame = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
                         }
                         completion:^(BOOL finished){
                             // Remove the snapshot on completion
                             [_snapShot removeFromSuperview];
                             
                             // Show current selected cell
                             _currentSelectedCell.alpha = 1;
                             
                             // Remove obsolete reference
                             _currentSelectedCell = nil;
                             
                             // Enable scroll
                             self.collectionView.scrollEnabled = YES;
                             
                             // Reset semaphore
                             _didEndPinch = NO;
                         }];
    }
    // If scale threshold is reached or exceeded, display image in full screen mode
    else {
        // Create the full screen view controller
        _photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoView" bundle:nil];
        
        // Add it to the root view hierarchy
        [self.view addSubview:_photoViewController.view];
        
        // Set delegate to self to react to events
        _photoViewController.photoViewDelegate = self;
        
        // Set initial position and size to the snapshot
        _photoViewController.view.frame = _snapShot.frame;
        
        // Set image content from the current selected cell
        _photoViewController.imageView.image = _currentSelectedCell.image;
        
        // Remove the old snapshot
        [_snapShot removeFromSuperview];
        
        // Animate the new screen to full screen size
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _photoViewController.view.frame = self.view.frame;
                         }
                         completion:^(BOOL finished){
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
}

- (void)photoViewCell:(PhotoViewCell*)cell didPinchToPosition:(CGPoint)position {
    if(_snapShot
       && !_didEndPinch) {
        // Adjust the position of the snapshot
        CGPoint convertedPoint = [self.view convertPoint:_currentSelectedCell.center fromView:self.collectionView];
        convertedPoint.x += position.x;
        convertedPoint.y += position.y;
        
        _snapShot.center = convertedPoint;
    }
}

#pragma mark -  PhotoViewDelegate

- (void)photoViewController:(PhotoViewController*)photoViewController didBeginPinchWithScale:(CGFloat)scale {
    self.collectionView.scrollEnabled = NO;
    
    _snapShot = [_photoViewController.imageView snapshotViewAfterScreenUpdates:NO];
    _snapShot.frame = [self.view convertRect:_photoViewController.imageView.frame fromView:_photoViewController.view];
    [self.view addSubview:_snapShot];
    
    _photoViewController.imageView.hidden = YES;
    [UIView animateWithDuration:0.3
                     animations:^(){
                         _photoViewController.view.alpha = 0;
                     }];
}

- (void)photoViewController:(PhotoViewController*)photoViewController didChangePinchWithScale:(CGFloat)scale {
    if (_snapShot) {
        // Adjust the size depending on the scale
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        _snapShot.transform = transform;
    }
}

- (void)photoViewController:(PhotoViewController*)photoViewController didEndPinchWithScale:(CGFloat)scale {
    _didEndPinch = YES;
    
    // If scale reach threshold or exceeds it, then animate back to collection view
    if (scale < 0.5) {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             CGRect referenceRect = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
                             CGRect targetRect = _snapShot.frame;
                             
                             CGRect aspectFillRect = [self getAspectFillRectForTargetRect:targetRect inRefenceRect:referenceRect];
                             _snapShot.frame = aspectFillRect;
                             _snapShot.center = _currentSelectedCell.center;
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             _currentSelectedCell.alpha = 1;
                             _currentSelectedCell = nil;
                             
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
    // Otherwise animate back to full screen size
    else {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _snapShot.frame = [self.view convertRect:_photoViewController.imageView.frame fromView:_photoViewController.view];
                             _photoViewController.view.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             
                             _photoViewController.imageView.hidden = NO;
                             
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
}

- (void)photoViewController:(PhotoViewController*)photoViewController didPinchToPosition:(CGPoint)position {
    if(_snapShot
       && !_didEndPinch) {
        // Adjust the position of the snapshot
        CGPoint convertedPoint = [self.view convertPoint:_photoViewController.imageView.center fromView:_photoViewController.view];
        convertedPoint.x += position.x;
        convertedPoint.y += position.y;
        
        _snapShot.center = convertedPoint;
    }
}

#pragma mark - PhotoViewDataSource
// TODO: Should be implemented
- (NSIndexPath*)photoViewController:(PhotoViewController*)photoViewController getNextIndexPathForCurrentIndexPath:(NSIndexPath*)indexPath {
    NSAssert(NO, @"%s not yet implemented", __FUNCTION__);
    return nil;
}
// TODO: Should be implemented
- (NSIndexPath*)photoViewController:(PhotoViewController*)photoViewController getPreviousIndexPathForCurrentIndexPath:(NSIndexPath*)indexPath {
    NSAssert(NO, @"%s not yet implemented", __FUNCTION__);
    return nil;
}
// TODO: Should be implemented
- (UIImage*)photoViewController:(PhotoViewController*)photoViewController getImageForIndexPath:(NSIndexPath*)indexPath {
    NSAssert(NO, @"%s not yet implemented", __FUNCTION__);
    return nil;
}

#pragma mark - Prive methods

- (CGRect)getAspectFillRectForTargetRect:(CGRect)targetRect inRefenceRect:(CGRect)referenceRect {
    CGFloat scale = referenceRect.size.height / fminf(targetRect.size.width, targetRect.size.height);
    
    CGRect aspectFillRect = targetRect;
    aspectFillRect.size.width *= scale;
    aspectFillRect.size.height *= scale;
    
    return aspectFillRect;
}

@end
