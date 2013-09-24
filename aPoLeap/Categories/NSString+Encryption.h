//
//  NSString+Encryption.h
//  iPhoneOnderweg
//
//  Created by Po Sam | The Mobile Company on 5/29/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    kEncryptionType_Md5,
    kEncryptionType_Sha1,
    kEncryptionType_Sha256,
    kEncryptionType_HmacSha1,
    kEncryptionType_HmacSha256
} kEncryptionType;

@interface NSString (Encryption)

- (NSString*)getHashWithEncryption:(kEncryptionType)encryption withKey:(NSString*)key;

@end
