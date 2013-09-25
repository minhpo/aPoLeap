//
//  RemoteCommunicator.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "RemoteCommunicator.h"
#import "AFJSONRequestOperation.h"
#import "RemoteCommunicatorDelegate.h"

@implementation RemoteCommunicator

- (void)getResponseFromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:JSON fromUrl:url forRequestCode:requestCode withError:nil];
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:JSON fromUrl:url forRequestCode:requestCode withError:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
}

@end
