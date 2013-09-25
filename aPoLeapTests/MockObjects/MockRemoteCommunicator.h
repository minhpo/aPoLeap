//
//  MockRemoteCommunicator.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "RemoteCommunicator.h"

@interface MockRemoteCommunicator : RemoteCommunicator

@property (assign) id response;
@property (assign) NSError *error;

@end
