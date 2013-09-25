//
//  PhotoManager.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteCommunicatorDelegate.h"

static const NSString *kListOfPhotosUrl = @"http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=b0d9a3d095c12dedaf5c32380bc6586f&per_page=10&format=json&nojsoncallback=1";

@class RemoteCommunicator;

@interface PhotoManager : NSObject <RemoteCommunicatorDelegate> {
    @protected
    RemoteCommunicator *_remoteCommunicator;
}

- (NSArray*)getListOfPhotos;
- (void)retrieveListOfPhotos;
- (void)retrieveDataFromUrl:(NSString*)url;

@end
