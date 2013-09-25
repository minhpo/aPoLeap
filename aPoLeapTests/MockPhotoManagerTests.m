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
    
    _photoManager = [[MockPhotoManager alloc] initWithListOfPhotosUrlTemplate:kMockListOfPhotosUrl photoUrlTemplate:nil];
}

- (void)tearDown
{
    [TMCStorageManager removeContentForKey:[[NSString stringWithFormat:kMockListOfPhotosUrl, 1] getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];

    [super tearDown];
}

- (void)testGetNilListOfPhotosForFirstPage {
    NSArray *content = [_photoManager getListOfPhotosForPage:1];
    
    XCTAssertNil(content, @"Expected a nil object when list of photos is not available");
}

- (void)testGetEmptyListOfPhotosForFirstPage {
    // Setup mock data
    NSArray *emptyArray = [NSArray array];
    [TMCStorageManager saveContent:emptyArray forKey:[[NSString stringWithFormat:kMockListOfPhotosUrl, 1] getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
    
    // Get content for list of photos
    NSArray *content = [_photoManager getListOfPhotosForPage:1];
    
    XCTAssertNotNil(content, @"Expected an object when list of photos is available");
    XCTAssertTrue(content.count == 0, @"Expected an empty list");
}

- (void)testGetFilledListOfPhotos {
    // Setup mock data
    NSArray *filledArray = @[@"1", @"2", @"3"];
    [TMCStorageManager saveContent:filledArray forKey:[[NSString stringWithFormat:kMockListOfPhotosUrl, 1] getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
    
    // Get content for list of photos
    NSArray *content = [_photoManager getListOfPhotosForPage:1];
    
    XCTAssertNotNil(content, @"Expected an object when list of photos is available");
    XCTAssertTrue(content.count > 0, @"Expected a list with content");
}

- (void)testNotifyOnEndRetrievingListOfPhotos {
    // Setup mock communictor
    MockRemoteCommunicator *mockRemoteCommunicator = [[MockRemoteCommunicator alloc] init];
    mockRemoteCommunicator.remoteCommunicatorDelegate = _photoManager;
    [_photoManager setMockRemoteCommunicator:mockRemoteCommunicator];
    
    [_photoManager retrieveListOfPhotosForPage:1];
    
    XCTAssertTrue(_photoManager.didNotify, @"Expected a notification when finished retrieving the list of photos");
}

- (void)testAvailabilityOfListOnEndRetrievingListOfPhotos {
    NSString *jsonString = @"{\"photos\":{\"page\":1,\"pages\":100,\"perpage\":10,\"total\":1000,\"photo\":[{\"id\":\"9937659545\",\"owner\":\"98881834@N03\",\"secret\":\"8994369f53\",\"server\":\"7324\",\"farm\":8,\"title\":\"Wallen. Sienna\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937660555\",\"owner\":\"71713493@N03\",\"secret\":\"8e40559c45\",\"server\":\"2884\",\"farm\":3,\"title\":\"\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937660755\",\"owner\":\"94108678@N05\",\"secret\":\"af0c8ec217\",\"server\":\"2859\",\"farm\":3,\"title\":\"#turkey #morning #sea\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937671316\",\"owner\":\"32934182@N00\",\"secret\":\"ab7591643c\",\"server\":\"5480\",\"farm\":6,\"title\":\"Puerto Rico 2013 with The Schneiders\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937672056\",\"owner\":\"22537302@N00\",\"secret\":\"044dcb46f1\",\"server\":\"5455\",\"farm\":6,\"title\":\"_MG_9205\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937672956\",\"owner\":\"49080734@N08\",\"secret\":\"fc840d2669\",\"server\":\"7370\",\"farm\":8,\"title\":\"L&J-102\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937695344\",\"owner\":\"103242817@N06\",\"secret\":\"f4491307d2\",\"server\":\"3688\",\"farm\":4,\"title\":\"iPhone photos/videos\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937695534\",\"owner\":\"97384776@N08\",\"secret\":\"cdfbcb0b82\",\"server\":\"5323\",\"farm\":6,\"title\":\"Obelisco de Buenos Aires, Argentina.\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937783643\",\"owner\":\"103257115@N06\",\"secret\":\"a49137f213\",\"server\":\"5518\",\"farm\":6,\"title\":\"Natur\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"9937784453\",\"owner\":\"59207196@N02\",\"secret\":\"5884943b41\",\"server\":\"7410\",\"farm\":8,\"title\":\"DSC_2242\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}]},\"stat\":\"ok\"}";
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    // Setup mock communictor
    MockRemoteCommunicator *mockRemoteCommunicator = [[MockRemoteCommunicator alloc] init];
    mockRemoteCommunicator.remoteCommunicatorDelegate = _photoManager;
    mockRemoteCommunicator.response = responseObject;
    [_photoManager setMockRemoteCommunicator:mockRemoteCommunicator];
    
    [_photoManager retrieveListOfPhotosForPage:1];
    
    id content = [_photoManager getListOfPhotosForPage:1];
    
    XCTAssertTrue(_photoManager.didNotify, @"Expected a notification when finished retrieving the list of photos");
    XCTAssertNotNil(content, @"Expected a non nil result");
    XCTAssertTrue([content isKindOfClass:[NSArray class]], @"Expected an array class");
}

@end
