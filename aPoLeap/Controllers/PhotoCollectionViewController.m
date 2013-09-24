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
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:photoViewCellIdentifier];
    
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
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoViewCellIdentifier forIndexPath:indexPath];
    if (!cell.photoViewCellDelegate)
        cell.photoViewCellDelegate = self;
    
    [cell setImage:[UIImage imageNamed:@"test.jpg"]];
    
    return cell;
}

#pragma mark - PhotoViewCellDelegate

- (void)photoViewCell:(PhotoViewCell*)cell didBeginPinchWithScale:(CGFloat)scale {
    self.collectionView.scrollEnabled = NO;
    
    _currentSelectedCell = cell;
    _snapShot = [_currentSelectedCell snapshotViewAfterScreenUpdates:NO];
    _snapShot.frame = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
    [self.view addSubview:_snapShot];
    
    _currentSelectedCell.alpha = 0;
}

- (void)photoViewCell:(PhotoViewCell*)cell didChangePinchWithScale:(CGFloat)scale {
    if (_snapShot) {
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        _snapShot.transform = transform;
    }
}

- (void)photoViewCell:(PhotoViewCell*)cell didEndPinchWithScale:(CGFloat)scale {
    _didEndPinch = YES;

    if (scale < 2) {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _snapShot.frame = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             _currentSelectedCell.alpha = 1;
                             _currentSelectedCell = nil;
                             
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
    else {
        _photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoView" bundle:nil];
        [self.view addSubview:_photoViewController.view];
        
        _photoViewController.photoViewDelegate = self;
        _photoViewController.view.frame = _snapShot.frame;
        _photoViewController.imageView.image = _currentSelectedCell.image;
        
        [_snapShot removeFromSuperview];
        
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
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        _snapShot.transform = transform;
    }
}

- (void)photoViewController:(PhotoViewController*)photoViewController didEndPinchWithScale:(CGFloat)scale {
    _didEndPinch = YES;
    
    if (scale < 0.5) {
        [UIView animateWithDuration:0.3
                         animations:^(){
                             _snapShot.frame = [self.view convertRect:_currentSelectedCell.frame fromView:self.collectionView];
                         }
                         completion:^(BOOL finished){
                             [_snapShot removeFromSuperview];
                             _currentSelectedCell.alpha = 1;
                             _currentSelectedCell = nil;
                             
                             self.collectionView.scrollEnabled = YES;
                             _didEndPinch = NO;
                         }];
    }
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
        CGPoint convertedPoint = [self.view convertPoint:_photoViewController.imageView.center fromView:_photoViewController.view];
        convertedPoint.x += position.x;
        convertedPoint.y += position.y;
        
        _snapShot.center = convertedPoint;
    }
}

@end
