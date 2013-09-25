//
//  PhotoMetaData.h
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *idKey = @"id";
static const NSString *ownerKey = @"owner";
static const NSString *secretKey = @"secret";
static const NSString *serverKey = @"server";
static const NSString *farmKey = @"farm";
static const NSString *titleKey = @"title";
static const NSString *isPublicKey = @"ispublic";
static const NSString *isFriendKey = @"isfriend";
static const NSString *isFamilyKey = @"isfamily";

@interface PhotoMetaData : NSObject <NSCoding>

- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (readonly) NSString *photoId;
@property (readonly) NSString *owner;
@property (readonly) NSString *secret;
@property (readonly) NSString *server;
@property (readonly) NSInteger farm;
@property (readonly) NSString *title;
@property (readonly) NSInteger isPublic;
@property (readonly) NSInteger isFriend;
@property (readonly) NSInteger isFamily;

@end
