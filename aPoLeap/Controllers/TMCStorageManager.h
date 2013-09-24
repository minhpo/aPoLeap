//
//  TMCStorageManager.h
//  iPhoneOnderweg
//
//  Created by Po Sam | The Mobile Company on 5/29/13.
//
//

#import <Foundation/Foundation.h>

@interface TMCStorageManager : NSObject

+ (void)saveContent:(id)content forKey:(NSString*)key;
+ (void)removeContentForKey:(NSString*)key;
+ (id)getContentForKey:(NSString*)key;

- (id)initWithCacheExpiration:(NSTimeInterval)expiration;
- (void)saveContent:(id)content forKey:(NSString*)key;
- (void)removeContentForKey:(NSString*)key;
- (id)getContentForKey:(NSString*)key;

@end
