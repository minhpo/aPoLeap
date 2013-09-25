//
//  MockPhotoCollectionViewControllerTests.m
//  aPoLeapTests
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MockPhotoCollectionViewController.h"

@interface MockPhotoCollectionViewControllerTests : XCTestCase {
    MockPhotoCollectionViewController *_mockPhotoCollectionViewController;
}

@end

@implementation MockPhotoCollectionViewControllerTests

- (void)setUp
{
    [super setUp];
    
    _mockPhotoCollectionViewController = [[MockPhotoCollectionViewController alloc] initWithNibName:@"PhotoCollectionView" bundle:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPreviousNSIndexPathRetrieval {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *previousIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getPreviousIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertTrue(currentIndexPath.row > previousIndexPath.row, @"Expected previous index path to contain lower row value");
    XCTAssertTrue(currentIndexPath.section == previousIndexPath.section, @"Expected the same section value");
}

- (void)testNextNSIndexPathRetrieval {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *nextIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getNextIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertTrue(currentIndexPath.row < nextIndexPath.row, @"Expected previous index path to contain higher row value");
    XCTAssertTrue(currentIndexPath.section == nextIndexPath.section, @"Expected the same section value");
}

- (void)testPreviousNSIndexPathRetrievalWithRowOverflow {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *previousIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getPreviousIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertTrue(currentIndexPath.section > previousIndexPath.section, @"Expected previous index path to contain lower section value");
    XCTAssertTrue(currentIndexPath.row < previousIndexPath.row, @"Expected previous index path to contain higher row value");
}

- (void)testNextNSIndexPathRetrievalWithRowOverflow {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *nextIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getNextIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertTrue(currentIndexPath.section < nextIndexPath.section, @"Expected next index path to contain higher row value");
    XCTAssertTrue(currentIndexPath.row > nextIndexPath.row, @"Expected next index path to contain lower row value");
}

- (void)testPreviousNSIndexPathRetrievalAtMinBoundary {
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *previousIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getPreviousIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertNil(previousIndexPath, @"Expected nil index path as we already reached the minimum boundary");
}

- (void)testNextNSIndexPathRetrievalAtMaxBoundary {
    NSInteger maxSection = [_mockPhotoCollectionViewController numberOfSectionsInCollectionView:nil] - 1;
    NSInteger maxRow = [_mockPhotoCollectionViewController collectionView:nil numberOfItemsInSection:maxSection] - 1;
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:maxRow inSection:maxSection];
    NSIndexPath *nextIndexPath = [_mockPhotoCollectionViewController photoViewController:nil getNextIndexPathForCurrentIndexPath:currentIndexPath];
    
    XCTAssertNil(nextIndexPath, @"Expected nil index path as we already reached the maximum boundary");
}

@end
