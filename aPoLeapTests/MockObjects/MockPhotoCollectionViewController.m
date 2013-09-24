//
//  MockPhotoCollectionViewController.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/24/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "MockPhotoCollectionViewController.h"

@interface MockPhotoCollectionViewController ()

@end

@implementation MockPhotoCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pictures = @[@"01.jpg", @"02.jpg", @"03.jpg"];
    }
    return self;
}

@end
