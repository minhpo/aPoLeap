//
//  AppDelegate.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/23/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (PhotoManager*)getSharedPhotoManager;

@property (strong, nonatomic) UIWindow *window;

@end
