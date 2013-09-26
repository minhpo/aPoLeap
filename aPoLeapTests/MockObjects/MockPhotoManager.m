//
//  MockPhotoManager.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "MockPhotoManager.h"
#import "MockRemoteCommunicator.h"
#import "PhotoMetaData.h"

@implementation MockPhotoManager

#pragma mark - Public methods

- (void)setMockRemoteCommunicator:(MockRemoteCommunicator*)mockRemoteCommunictor {
    _remoteCommunicator = mockRemoteCommunictor;
}

- (NSString*)getUrlForListOfMetaDataForPage:(NSInteger)page {
    return [NSString stringWithFormat:_listOfPhotoMetaDataUrlTemplate, page];
}

- (NSString*)getUrlForPhotoBelongingToPhotoMetaData:(PhotoMetaData*)photoMetaData {
    NSString *photoUrl = [NSString stringWithFormat:_photoUrlTemplate,
                          photoMetaData.farm,
                          photoMetaData.server,
                          photoMetaData.photoId,
                          photoMetaData.secret];
    
    return photoUrl;
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode withError:(NSError*)error {
    [super remoteCommunicator:remoteCommunicator didReceiveResponse:response fromUrl:url forRequestCode:requestCode withError:error];
    
    self.didNotify = YES;
}

@end
