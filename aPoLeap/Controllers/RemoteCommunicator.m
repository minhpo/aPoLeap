//
//  RemoteCommunicator.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "RemoteCommunicator.h"
#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "RemoteCommunicatorDelegate.h"

@implementation RemoteCommunicator

- (void)getResponseFromUrl:(NSString*)url forRequestCode:(NSInteger)requestCode {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = requestCode == kRequestCodeForListOfPhotoMetaData
                                        ? [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:JSON fromUrl:url forRequestCode:requestCode withError:nil];
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:JSON fromUrl:url forRequestCode:requestCode withError:error];
                                                                                            }
                                                                                        }]
                                        : [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:image fromUrl:url forRequestCode:requestCode withError:nil];
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                            if ([self.remoteCommunicatorDelegate respondsToSelector:@selector(remoteCommunicator:didReceiveResponse:fromUrl:forRequestCode:withError:)]) {
                                                                                                [self.remoteCommunicatorDelegate remoteCommunicator:self didReceiveResponse:nil fromUrl:url forRequestCode:requestCode withError:error];
                                                                                            }
                                                                                        }];
    
    [operation start];
}

@end
