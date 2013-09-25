//
//  MockPhotoManager.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoManager.h"

static const NSString* kMockListOfPhotoMetaDataUrlTemplate = @"kMockListOfPhotoMetaDataUrlTemplate%d";
static const NSString* kMockPhotoUrlTemplate = @"kMockPhotoUrlTemplate";

@class MockRemoteCommunicator;

@interface MockPhotoManager : PhotoManager

- (void)setMockRemoteCommunicator:(MockRemoteCommunicator*)mockRemoteCommunictor;

@property (assign) BOOL didNotify;

@end
