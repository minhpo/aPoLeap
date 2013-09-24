//
//  TMCStorageManager.m
//  iPhoneOnderweg
//
//  Created by Po Sam | The Mobile Company on 5/29/13.
//
//

#import "TMCStorageManager.h"

#import "NSString+Encryption.h"

@interface TMCStorageManager()
@property (assign) NSTimeInterval expiration;
@end

@implementation TMCStorageManager

#pragma mark - Public methods

#pragma mark > Instance methods

/**
 * Method to initialise an instance with an expiration to consider during retrieval
 */
- (id)initWithCacheExpiration:(NSTimeInterval)expiration {
    self = [super init];
    
    if (self) {
        self.expiration = expiration;
    }
    
    return self;
}

/**
 * Method to save content for a given key
 */
- (void)saveContent:(id)content forKey:(NSString*)key {
    [TMCStorageManager saveContent:content forKey:key];
}

/**
 * Method to remove content for a given key
 */
- (void)removeContentForKey:(NSString*)key {
    [TMCStorageManager removeContentForKey:key];
}

/**
 * Method to retrieve content for a given key
 */
- (id)getContentForKey:(NSString*)key {
    // Remove content for the given key if the content exceeds a given expiration
    if (self.expiration != NSNotFound) {
        // Set the path to the content
        NSString *path = [TMCStorageManager getPathToFileForKey:key];
        
        // Get the modification date of the content if content exists
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
        NSDate *modificationDate = fileAttributes[NSFileModificationDate];
        
        // Check if modification date exceeds expiration, then remove the content
        if (-[modificationDate timeIntervalSinceNow]>self.expiration)
            [TMCStorageManager removeContentForKey:key];
    }
    
    // Return the content of the given key
    return [TMCStorageManager getContentForKey:key];
}

#pragma mark > Class methods

/**
 * Method to save content for a given key
 */
+ (void)saveContent:(id)content forKey:(NSString*)key {
    NSAssert(content, @"TMCStorageManager:saveContent:forKey: - Content is not set");
    NSAssert(key, @"TMCStorageManager:saveContent:forKey: - Key is not set");
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:content];
    [data writeToFile:[TMCStorageManager getPathToFileForKey:key] atomically:YES];
}

/**
 * Method to remove content for a given key
 */
+ (void)removeContentForKey:(NSString*)key {
    NSAssert(key, @"TMCStorageManager:saveContent:forKey: - Key is not set");
    // Set the path to the content
    NSString *path = [TMCStorageManager getPathToFileForKey:key];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (error)
        NSLog(@"TMCStorageManager:removeContentForKey - Error:%@", [error localizedDescription]);
}

/**
 * Method to retrieve content for a given key
 */
+ (id)getContentForKey:(NSString*)key {
    id content = nil;
    
    // Retrieve raw data for key
    NSData *data = [NSData dataWithContentsOfFile:[TMCStorageManager getPathToFileForKey:key]];
    if (data)
        // Restore raw data back to original state
        content = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return content;
}

#pragma mark - Private methods

#pragma mark > Class methods

+ (NSString*)getPathToFileForKey:(NSString*)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[key getHashWithEncryption:kEncryptionType_Md5 withKey:nil]];
    
    return path;
}

@end
