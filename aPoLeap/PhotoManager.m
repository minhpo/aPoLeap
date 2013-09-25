//
//  PhotoManager.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoManager.h"
#import "TMCStorageManager.h"
#import "RemoteCommunicator.h"

#import "NSString+Encryption.h"

static const NSInteger kSecondsInOneDay = 86400;

@interface PhotoManager () {
    TMCStorageManager *_storageManager;
    
    NSArray *_listOfPhotos;
}

@end

@implementation PhotoManager

- (id)init {
    self = [super init];
    
    if (self) {
        _storageManager = [[TMCStorageManager alloc] initWithCacheExpiration:kSecondsInOneDay];
        _listOfPhotos = [_storageManager getContentForKey:[kListOfPhotosUrl getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
        
        _remoteCommunicator = [[RemoteCommunicator alloc] init];
        _remoteCommunicator.remoteCommunicatorDelegate = self;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSArray*)getListOfPhotos {
    return _listOfPhotos;
}

- (void)retrieveListOfPhotos {
    [self retrieveDataFromUrl:kListOfPhotosUrl];
}

- (void)retrieveDataFromUrl:(NSString*)url {
    [_remoteCommunicator getResponseFromUrl:url];
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url withError:(NSError*)error {
    NSDictionary *userInfo = nil;
    if (error)
        [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:url object:self userInfo:userInfo];
}

@end
