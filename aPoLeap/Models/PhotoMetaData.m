//
//  PhotoMetaData.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoMetaData.h"

@implementation PhotoMetaData

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        id idValue = dictionary[idKey];
        id ownerValue = dictionary[ownerKey];
        id secretValue = dictionary[secretKey];
        id serverValue = dictionary[serverKey];
        id farmValue = dictionary[farmKey];
        id titleValue = dictionary[titleKey];
        id isPublicValue = dictionary[isPublicKey];
        id isFriendValue = dictionary[isFriendKey];
        id isFamilyValue = dictionary[isFamilyKey];
        
        if (idValue && [idValue isKindOfClass:[NSString class]]
            && ownerValue && [ownerValue isKindOfClass:[NSString class]]
            && secretValue && [secretValue isKindOfClass:[NSString class]]
            && serverValue && [serverValue isKindOfClass:[NSString class]]
            && farmValue && [farmValue isKindOfClass:[NSNumber class]]
            && titleValue && [titleValue isKindOfClass:[NSString class]]
            && isPublicValue && [isPublicValue isKindOfClass:[NSNumber class]]
            && isFriendValue && [isFriendValue isKindOfClass:[NSNumber class]]
            && isFamilyValue && [isFamilyValue isKindOfClass:[NSNumber class]]) {
            _photoId = idValue;
            _owner = ownerValue;
            _secret = secretValue;
            _server = serverValue;
            _farm = [farmValue integerValue];
            _title = titleValue;
            _isPublic = [isPublicValue integerValue];
            _isFriend = [isFriendKey integerValue];
            _isFamily = [isFamilyKey integerValue];
        }
        else {
            self = nil;
        }
    }
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _photoId = [aDecoder decodeObjectForKey:idKey];
        _owner = [aDecoder decodeObjectForKey:ownerKey];
        _secret = [aDecoder decodeObjectForKey:secretKey];
        _server = [aDecoder decodeObjectForKey:serverKey];
        _farm = [aDecoder decodeIntegerForKey:farmKey];
        _title = [aDecoder decodeObjectForKey:titleKey];
        _isPublic = [aDecoder decodeIntegerForKey:isPublicKey];
        _isFriend = [aDecoder decodeIntegerForKey:isFriendKey];
        _isFamily = [aDecoder decodeIntegerForKey:isFamilyKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_photoId forKey:idKey];
    [aCoder encodeObject:_owner forKey:ownerKey];
    [aCoder encodeObject:_secret forKey:secretKey];
    [aCoder encodeObject:_server forKey:serverKey];
    [aCoder encodeInteger:_farm forKey:farmKey];
    [aCoder encodeObject:_title forKey:titleKey];
    [aCoder encodeInteger:_isPublic forKey:isPublicKey];
    [aCoder encodeInteger:_isFriend forKey:isFriendKey];
    [aCoder encodeInteger:_isFamily forKey:isFamilyKey];
}

@end
