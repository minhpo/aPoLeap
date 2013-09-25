//
//  MockRemoteCommunicator.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "MockRemoteCommunicator.h"
#import "RemoteCommunicatorDelegate.h"

@implementation MockRemoteCommunicator

- (void)getResponseFromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode{
    if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
        [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:self.response fromUrl:url forRequestCode:requestCode withError:self.error];
    }
}

@end
