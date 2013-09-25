//
//  RemoteCommunicatorDelegate.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RemoteCommunicator;

@protocol RemoteCommunicatorDelegate <NSObject>

- (void)remoteCommunicator:(RemoteCommunicator*)remoteCommunicator didReceiveResponse:(id)response fromUrl:(NSString*)url withError:(NSError*)error;

@end
