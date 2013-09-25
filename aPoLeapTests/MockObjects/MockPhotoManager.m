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

- (id)init {
    self = [super init];
    
    if (self) {
        _listOfPhotoMetaDataUrlTemplate = kMockListOfPhotoMetaDataUrlTemplate;
        _photoUrlTemplate = kMockPhotoUrlTemplate;
        
        _remoteCommunicator = nil;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)setMockRemoteCommunicator:(MockRemoteCommunicator*)mockRemoteCommunictor {
    _remoteCommunicator = mockRemoteCommunictor;
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode withError:(NSError*)error {
    [super remoteCommunicator:remoteCommunicator didReceiveResponse:response fromUrl:url forRequestCode:requestCode withError:error];
    
    self.didNotify = YES;
}

@end
