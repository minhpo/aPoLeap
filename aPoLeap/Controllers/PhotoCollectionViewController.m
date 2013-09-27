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

#import "PhotoManager.h"

static const NSString *photoViewCellIdentifier = @"photoViewCellIdentifier";

@interface PhotoCollectionViewController () {
    PhotoViewController *_photoViewController;
    
    PhotoViewCell *_currentSelectedCell;
    UIView *_snapShot;
    
    BOOL _didEndPinch;
    
    PhotoManager *_photoManager;
    
    NSInteger _maxNumberOrRowsPerSection;
    NSInteger _indexToCurrentPhotoMetaDataInPicturesArray;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register xib for collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:photoViewCellIdentifier];
    
    // Set layout properties for the collection view
    self.flowLayout.itemSize = CGSizeMake(100.0, 100.0);
    
    // Set additional layout properties
    [self setMaxRowAndMinimumInteritemSpacingForWidth:self.view.frame.size.width];
    
    // Get shared instance of PhotoManager object
    _photoManager = [(AppDelegate*)[UIApplication sharedApplication].delegate getSharedPhotoManager];
    
    // Attempt to retrieve content for first page
    _pictures = [_photoManager getListOfPhotoMetaDataForPage:1];
    
    // If no content is available locally, then retrieve it from the web
    if (!_pictures) {
        NSString *notificationName;
        [_photoManager retrieveListOfPhotoMetaDataForPage:1 forNotificationName:&notificationName];
        
        // Listen to end retrieval notification
        if (notificationName)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPhotoMetaData:) name:notificationName object:_photoManager];
        
        _pictures = [NSArray array];
        
        // Start the loading animation
        [self.activityIndicatorView startAnimating];
    }
    else
        // Stop the loading animation
        [self.activityIndicatorView stopAnimating];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Reset additional layout properties on orientation change
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
        [self setMaxRowAndMinimumInteritemSpacingForWidth:self.view.frame.size.width];
    else
        [self setMaxRowAndMinimumInteritemSpacingForWidth:self.view.frame.size.height];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    // Reload the data as the number of columns changed on orientation change
    [self.collectionView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger lastSectionIndex = [self numberOfSectionsInCollectionView:self.collectionView] - 1;
    
    if(section < lastSectionIndex)
        return _maxNumberOrRowsPerSection;
    else {
        NSInteger rows = _pictures.count%_maxNumberOrRowsPerSection;
        return rows == 0 ? _maxNumberOrRowsPerSection : rows;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger additionalSection = _pictures.count%_maxNumberOrRowsPerSection > 0 ? 1 : 0;
    return _pictures.count / _maxNumberOrRowsPerSection + additionalSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoViewCellIdentifier forIndexPath:indexPath];
    if (!cell.photoViewCellDelegate)
        cell.photoViewCellDelegate = self;

    PhotoMetaData *photoMetaData = _pictures[indexPath.section*_maxNumberOrRowsPerSection + indexPath.row];
    [cell setPhotoMetaData:photoMetaData];
    
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
        if (_photoViewController) {
            [_photoViewController.view removeFromSuperview];
            [_photoViewController removeFromParentViewController];
        }
        
        _photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoView" bundle:nil];
        
        // Add it to the root view hierarchy
        [self.view addSubview:_photoViewController.view];
        
        // Add photo viewcontroller to parent viewcontroller to receive view state change events too
        [self addChildViewController:_photoViewController];
        
        // Set delegate and datasource to self to react to events
        _photoViewController.photoViewDelegate = self;
        _photoViewController.photoViewDataSource = self;
        
        // Set initial position and size to the snapshot
        _photoViewController.view.frame = _snapShot.frame;
        
        // Set image content from the current selected cell
        NSIndexPath *currentIndexPath = [self.collectionView indexPathForCell:_currentSelectedCell];
        _indexToCurrentPhotoMetaDataInPicturesArray = currentIndexPath.section * _maxNumberOrRowsPerSection + currentIndexPath.row;
        [_photoViewController setContentForIndex:_indexToCurrentPhotoMetaDataInPicturesArray];
        
        // Remove the old snapshot
        [_snapShot removeFromSuperview];
        
        // Animate the new screen to full screen size
        [UIView animateWithDuration:0.3
                         animations:^(){
                             UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
                             if (UIInterfaceOrientationIsPortrait(orientation))
                                 _photoViewController.view.frame = self.view.frame;
                             else
                                 _photoViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
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
    
    _snapShot = [[_photoViewController getImageView] snapshotViewAfterScreenUpdates:NO];
    _snapShot.frame = [self.view convertRect:[_photoViewController getImageView].frame fromView:_photoViewController.view];
    [self.view addSubview:_snapShot];
    
    [_photoViewController getImageView].hidden = YES;
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
                             CGPoint convertedPoint = [self.view convertPoint:_currentSelectedCell.center fromView:self.collectionView];
                             _snapShot.center = convertedPoint;
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
                             _snapShot.frame = [self.view convertRect:[_photoViewController getImageView].frame fromView:_photoViewController.view];
                             _photoViewController.view.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             
                             [_photoViewController getImageView].hidden = NO;
                             
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
}

- (void)photoViewController:(PhotoViewController*)photoViewController didPinchToPosition:(CGPoint)position {
    if(_snapShot
       && !_didEndPinch) {
        // Adjust the position of the snapshot
        CGPoint convertedPoint = [self.view convertPoint:[_photoViewController getImageView].center fromView:_photoViewController.view];
        convertedPoint.x += position.x;
        convertedPoint.y += position.y;
        
        _snapShot.center = convertedPoint;
    }
}

- (void)photoViewController:(PhotoViewController*)photoViewController didScrollToIndex:(NSInteger)index {
    _indexToCurrentPhotoMetaDataInPicturesArray = index;
    NSIndexPath *indexPath = [self getIndexPathFromIndex:_indexToCurrentPhotoMetaDataInPicturesArray];
    
    // Show old cell
    _currentSelectedCell.alpha = 1;
    
    // Set new reference
    _currentSelectedCell = (PhotoViewCell*)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    // Hide the new cell
    _currentSelectedCell.alpha = 0;
    
    // Scroll collection view to this cell
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

#pragma mark - PhotoViewDataSource

- (UIImage*)photoViewController:(PhotoViewController*)photoViewController getImageForIndex:(NSInteger)index {
    PhotoMetaData *photoMetaData = _pictures[index];
    UIImage *image = [_photoManager getImageUsingPhotoMetaData:photoMetaData];
    
    return image;
}

- (NSInteger)numberOfPhotos {
    return _pictures.count;
}

#pragma mark - Prive methods

- (void)setMaxRowAndMinimumInteritemSpacingForWidth:(CGFloat)width {
    _maxNumberOrRowsPerSection = width / self.flowLayout.itemSize.width;
    
    CGFloat remainingWidth = (CGFloat)width - _maxNumberOrRowsPerSection*self.flowLayout.itemSize.width;
    self.flowLayout.minimumInteritemSpacing = remainingWidth/(_maxNumberOrRowsPerSection-1);
}

- (CGRect)getAspectFillRectForTargetRect:(CGRect)targetRect inRefenceRect:(CGRect)referenceRect {
    CGFloat scale = referenceRect.size.height / fminf(targetRect.size.width, targetRect.size.height);
    
    CGRect aspectFillRect = targetRect;
    aspectFillRect.size.width *= scale;
    aspectFillRect.size.height *= scale;
    
    return aspectFillRect;
}

// Display content for the collection view when data is received
- (void)displayPhotoMetaData:(NSNotification*)notification {
    // Stop listening for notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Check if notifier was from shared instance of PhotoManager
    if (notification.object == _photoManager) {
        // Attempt to retrieve the content
        _pictures = [_photoManager getListOfPhotoMetaDataForPage:1];
        
        // If no content is available, create an empty array
        if (!_pictures)
            _pictures = [NSArray array];
        
        // Reload collection view
        [self.collectionView reloadData];
    }
    
    // Stop the loading animation
    [self.activityIndicatorView stopAnimating];
}

// Get an indexPath for the collection view from an index that points to an array
- (NSIndexPath*)getIndexPathFromIndex:(NSInteger)index {
    NSInteger section = index / _maxNumberOrRowsPerSection;
    NSInteger row = index%_maxNumberOrRowsPerSection;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    return indexPath;
}

@end
