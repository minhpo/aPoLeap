//
//  MockPhotoManager.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "MockPhotoManager.h"
#import "MockRemoteCommunicator.h"

@implementation MockPhotoManager

- (id)initWithListOfPhotosUrlTemplate:(NSString*)listOfPhotosUrlTemplate photoUrlTemplate:(NSString*)photoUrlTemplate {
    self = [super init];
    
    if (self) {
        _listOfPhotosUrlTemplate = listOfPhotosUrlTemplate;
        _photoUrlTemplate = photoUrlTemplate;
        
        _remoteCommunicator = nil;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)setMockRemoteCommunicator:(MockRemoteCommunicator*)mockRemoteCommunictor {
    _remoteCommunicator = mockRemoteCommunictor;
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url withError:(NSError*)error {
    [super remoteCommunicator:remoteCommunicator didReceiveResponse:response fromUrl:url withError:error];
    
    self.didNotify = YES;
}

@end
