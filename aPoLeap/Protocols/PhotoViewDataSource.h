//
//  PhotoViewDataSource.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoViewController;

@protocol PhotoViewDataSource <NSObject>

- (NSIndexPath*)photoViewController:(PhotoViewController*)photoViewController getNextIndexPathForCurrentIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)photoViewController:(PhotoViewController*)photoViewController getPreviousIndexPathForCurrentIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)photoViewController:(PhotoViewController*)photoViewController getImageForIndexPath:(NSIndexPath*)indexPath;

@end
