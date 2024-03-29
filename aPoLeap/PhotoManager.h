//
//  PhotoManager.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteCommunicatorDelegate.h"

static const NSString *kListOfPhotoMetaDataUrlTemplate = @"http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=b0d9a3d095c12dedaf5c32380bc6586f&per_page=36&format=json&nojsoncallback=1&page=%d";
static const NSString *kPhotoUrlTemplate = @"http://farm%d.static.flickr.com/%@/%@_%@_m.jpg";

@class RemoteCommunicator;
@class PhotoMetaData;

@interface PhotoManager : NSObject <RemoteCommunicatorDelegate> {
    @protected
    RemoteCommunicator *_remoteCommunicator;
    NSString *_listOfPhotoMetaDataUrlTemplate;
    NSString *_photoUrlTemplate;
}

- (NSArray*)getListOfPhotoMetaDataForPage:(NSInteger)page;
- (void)retrieveListOfPhotoMetaDataForPage:(NSInteger)page forNotificationName:(NSString**)notificationName;
- (UIImage*)getImageUsingPhotoMetaData:(PhotoMetaData*)photoMetaData;
- (void)retrievePhotoUsingPhotoMetaData:(PhotoMetaData*)photoMetaData forNotificationName:(NSString**)notificationName;

@end
