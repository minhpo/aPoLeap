//
//  PhotoManager.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoManager.h"
#import "TMCStorageManager.h"
#import "PhotoMetaDataFactory.h"
#import "RemoteCommunicator.h"

#import "NSString+Encryption.h"

static const NSInteger kSecondsInOneDay = 86400;

typedef enum {
    PhotoManagerRetrievingListOfPhotosState,
    PhotoManagerRetrievingPhotoState,
    PhotoManagerIdleState
} PhotoManagerState;

@interface PhotoManager () {
    TMCStorageManager *_storageManager;
    
    PhotoManagerState _state;
}

@end

@implementation PhotoManager

- (id)init {
    self = [super init];
    
    if (self) {
        _state = PhotoManagerIdleState;
        
        _listOfPhotosUrlTemplate = kListOfPhotosUrl;
        _photoUrlTemplate = nil;
        
        _storageManager = [[TMCStorageManager alloc] initWithCacheExpiration:kSecondsInOneDay];
        
        _remoteCommunicator = [[RemoteCommunicator alloc] init];
        _remoteCommunicator.remoteCommunicatorDelegate = self;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSArray*)getListOfPhotosForPage:(NSInteger)page {
    return [_storageManager getContentForKey:[[NSString stringWithFormat:_listOfPhotosUrlTemplate, page] getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
}

- (void)retrieveListOfPhotosForPage:(NSInteger)page {
    if (_state == PhotoManagerIdleState) {
        // Update state
        _state = PhotoManagerRetrievingListOfPhotosState;
        
        [self retrieveDataFromUrl:[NSString stringWithFormat:_listOfPhotosUrlTemplate, page]];
    }
}

#pragma mark - Private methods

- (void)retrieveDataFromUrl:(NSString*)url {
    [_remoteCommunicator getResponseFromUrl:url];
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url withError:(NSError*)error {
    NSDictionary *userInfo = nil;
    if (error)
        [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    else {
        if (_state == PhotoManagerRetrievingListOfPhotosState) {
            // Extract list of photo meta data
            NSArray *listOfPhotoMetaData = [PhotoMetaDataFactory getArrayOfPhotoMetaDataObjectsFromInput:response];
            
            // Persist list of photo meta data
            if (listOfPhotoMetaData)
                [_storageManager saveContent:listOfPhotoMetaData forKey:[url getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
        }
    }
    
    // Update state
    _state = PhotoManagerIdleState;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:url object:self userInfo:userInfo];
}

@end
