//
//  PhotoFactory.m
//  aPoLeap
//
//  Created by Po Sam | The Mobile Company on 9/25/13.
//  Copyright (c) 2013 Po Sam. All rights reserved.
//

#import "PhotoMetaDataFactory.h"
#import "PhotoMetaData.h"

@implementation PhotoMetaDataFactory

+ (NSArray*)getArrayOfPhotoMetaDataObjectsFromInput:(id)input {
    NSArray *result = nil;
    
    if ([input isKindOfClass:[NSDictionary class]]) {
        NSDictionary *inputDictionary = (NSDictionary*)input;
        
        id photosValue = inputDictionary[@"photos"];
        if (photosValue
            && [photosValue isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photosDictionary = (NSDictionary*)photosValue;
            
            id photoArrayValue = photosDictionary[@"photo"];
            if (photoArrayValue
                && [photoArrayValue isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *listOfExtractedObjects = [NSMutableArray array];
                for (id photoValue in (NSArray*)photoArrayValue) {
                    if ([photoValue isKindOfClass:[NSDictionary class]]) {
                        PhotoMetaData *extractedObject = [[PhotoMetaData alloc] initWithDictionary:photoValue];
                        
                        if (extractedObject)
                            [listOfExtractedObjects addObject:extractedObject];
                    }
                }
                result = [NSArray arrayWithArray:listOfExtractedObjects];
            }
        }
    }
    
    return result;
}

+ (PhotoMetaData*)createPhotoMetaDataFromInput:(id)input {
    PhotoMetaData *result = [PhotoMetaData new];
    
    return result;
}

@end
