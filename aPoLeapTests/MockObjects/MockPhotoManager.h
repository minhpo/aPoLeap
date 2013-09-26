//
//  MockPhotoManager.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoManager.h"

@class MockRemoteCommunicator;
@class PhotoMetaData;

@interface MockPhotoManager : PhotoManager

- (void)setMockRemoteCommunicator:(MockRemoteCommunicator*)mockRemoteCommunictor;
- (NSString*)getUrlForListOfMetaDataForPage:(NSInteger)page;
- (NSString*)getUrlForPhotoBelongingToPhotoMetaData:(PhotoMetaData*)photoMetaData;

@property (assign) BOOL didNotify;

@end
