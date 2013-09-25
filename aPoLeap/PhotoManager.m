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

enum {
    kRequestCodeForListOfPhotoMetaData,
    kRequestCodeForPhoto
};

@interface PhotoManager () {
    TMCStorageManager *_storageManager;
}

@end

@implementation PhotoManager

- (id)init {
    self = [super init];
    
    if (self) {
        _listOfPhotoMetaDataUrlTemplate = kListOfPhotoMetaDataUrlTemplate;
        _photoUrlTemplate = kPhotoUrlTemplate;
        
        _storageManager = [[TMCStorageManager alloc] initWithCacheExpiration:kSecondsInOneDay];
        
        _remoteCommunicator = [[RemoteCommunicator alloc] init];
        _remoteCommunicator.remoteCommunicatorDelegate = self;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSArray*)getListOfPhotoMetaDataForPage:(NSInteger)page {
    return [_storageManager getContentForKey:[[NSString stringWithFormat:_listOfPhotoMetaDataUrlTemplate, page] getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
}

- (void)retrieveListOfPhotoMetaDataForPage:(NSInteger)page forNotificationName:(NSString**)notificationName {
    NSString *url = [NSString stringWithFormat:_listOfPhotoMetaDataUrlTemplate, page];
    *notificationName = url;
    [self retrieveDataFromUrl:url forRequestCode:kRequestCodeForListOfPhotoMetaData];
}

#pragma mark - Private methods

- (void)retrieveDataFromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode {
    [_remoteCommunicator getResponseFromUrl:url forRequestCode:requestCode];
}

#pragma mark - RemoteCommunicatorDelegate

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode withError:(NSError*)error {
    NSDictionary *userInfo = nil;
    if (error)
        [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    else {
        if (requestCode == kRequestCodeForListOfPhotoMetaData) {
            // Extract list of photo meta data
            NSArray *listOfPhotoMetaData = [PhotoMetaDataFactory getArrayOfPhotoMetaDataObjectsFromInput:response];
            
            // Persist list of photo meta data
            if (listOfPhotoMetaData)
                [_storageManager saveContent:listOfPhotoMetaData forKey:[url getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:url object:self userInfo:userInfo];
}

@end
