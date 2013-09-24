//
//  PhotoCollectionViewController.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewCellDelegate.h"
#import "PhotoViewDelegate.h"
#import "PhotoViewDataSource.h"

@interface PhotoCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, PhotoViewCellDelegate, PhotoViewDelegate, PhotoViewDataSource> {
    @protected
    NSArray *_pictures;
}

@end
