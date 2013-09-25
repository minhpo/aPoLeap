//
//  RemoteCommunicator.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RemoteCommunicatorDelegate;

@interface RemoteCommunicator : NSObject

- (void)getResponseFromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode;

@property (weak) id<RemoteCommunicatorDelegate>remoteCommunicatorDelegate;

@end
