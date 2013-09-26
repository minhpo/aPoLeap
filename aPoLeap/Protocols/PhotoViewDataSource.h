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

- (UIImage*)photoViewController:(PhotoViewController*)photoViewController getImageForIndex:(NSInteger)index;
- (NSInteger)numberOfPhotos;

@end
