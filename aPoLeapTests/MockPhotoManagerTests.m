//
//  MockPhotoManagerTests.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TMCStorageManager.h"
#import "MockPhotoManager.h"
#import "MockRemoteCommunicator.h"

#import "NSString+Encryption.h"

@interface MockPhotoManagerTests : XCTestCase {
    MockPhotoManager *_photoManager;
}

@end

@implementation MockPhotoManagerTests

- (void)setUp
{
    [super setUp];
    
    _photoManager = [[MockPhotoManager alloc] init];
}

- (void)tearDown
{
    [TMCStorageManager removeContentForKey:[kListOfPhotosUrl getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];

    [super tearDown];
}

- (void)testGetNilListOfPhotos {
    NSArray *content = [_photoManager getListOfPhotos];
    
    XCTAssertNil(content, @"Expected a nil object when list of photos is not available");
}

- (void)testGetEmptyListOfPhotos {
    // Setup mock data
    NSArray *emptyArray = [NSArray array];
    [TMCStorageManager saveContent:emptyArray forKey:[kListOfPhotosUrl getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
    
    // Rest photomanager
    _photoManager = [[PhotoManager alloc] init];
    NSArray *content = [_photoManager getListOfPhotos];
    
    XCTAssertNotNil(content, @"Expected an object when list of photos is available");
    XCTAssertTrue(content.count == 0, @"Expected an empty list");
}

- (void)testGetFilledListOfPhotos {
    // Setup mock data
    NSArray *filledArray = @[@"1", @"2", @"3"];
    [TMCStorageManager saveContent:filledArray forKey:[kListOfPhotosUrl getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
    
    // Rest photomanager
    _photoManager = [[MockPhotoManager alloc] init];
    NSArray *content = [_photoManager getListOfPhotos];
    
    XCTAssertNotNil(content, @"Expected an object when list of photos is available");
    XCTAssertTrue(content.count > 0, @"Expected a list with content");
}

- (void)testNotifyOnEndRetrievingListOfPhotos {
    // Setup mock communictor
    MockRemoteCommunicator *mockRemoteCommunicator = [[MockRemoteCommunicator alloc] init];
    mockRemoteCommunicator.remoteCommunicatorDelegate = _photoManager;
    [_photoManager setMockRemoteCommunicator:mockRemoteCommunicator];
    
    [_photoManager retrieveListOfPhotos];
    
    XCTAssertTrue(_photoManager.didNotify, @"Expected a notification when finished retrieving the list of photos");
}

@end
