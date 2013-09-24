//
//  NSString+Encryption.m
//  iPhoneOnderweg
//
//  Created by Po Sam | The Mobile Company on 5/29/13.
//
//

#import <CommonCrypto/CommonHMAC.h>

#import "NSString+Encryption.h"

@implementation NSString (Encryption)

- (NSString*)getHashWithEncryption:(kEncryptionType)encryption withKey:(NSString*)key {
    NSMutableString *result = nil;
    
    int length = 0;
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (encryption == kEncryptionType_Md5) {
        length = CC_MD5_DIGEST_LENGTH;
        
        // Create byte array of unsigned chars
        unsigned char characterBuffer[length];
        
        // Create MD5 hash value, store in buffer
        CC_MD5(cData, strlen(cData), characterBuffer);
        
        // Convert hash value in the buffer to NSString of hex values
        result = [NSMutableString stringWithCapacity:length * 2];
        for(int i = 0; i < length; i++)
            [result appendFormat:@"%02x",characterBuffer[i]];
    }
    else if (encryption == kEncryptionType_Sha1) {
        length = CC_SHA1_DIGEST_LENGTH;
        
        // Create byte array of unsigned chars
        unsigned char characterBuffer[length];
        
        // Create SHA1 hash value, store in buffer
        CC_SHA1(cData, strlen(cData), characterBuffer);
        
        // Convert hash value in the buffer to NSString of hex values
        result = [NSMutableString stringWithCapacity:length * 2];
        for(int i = 0; i < length; i++)
            [result appendFormat:@"%02x",characterBuffer[i]];
    }
    else if (encryption == kEncryptionType_Sha256) {
        length = CC_SHA256_DIGEST_LENGTH;
        
        // Create byte array of unsigned chars
        unsigned char characterBuffer[length];
        
        // Create SHA256 hash value, store in buffer
        CC_SHA256(cData, strlen(cData), characterBuffer);
        
        // Convert hash value in the buffer to NSString of hex values
        result = [NSMutableString stringWithCapacity:length * 2];
        for(int i = 0; i < length; i++)
            [result appendFormat:@"%02x",characterBuffer[i]];
    }
    else {
        NSAssert(key, @"NSString:getHashWithEncryption:withKey - Key is not set");
        
        const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
        
        CCHmacAlgorithm algorithm;
        
        if (encryption == kEncryptionType_HmacSha256) {
            length = CC_SHA256_DIGEST_LENGTH;
            algorithm = kCCHmacAlgSHA256;
        }
        else {
            length = CC_SHA1_DIGEST_LENGTH;
            algorithm = kCCHmacAlgSHA1;
        }
        
        // Create byte array of unsigned chars
        unsigned char characterBuffer[length];
        
        // Create HMAC hash value, store in buffer
        CCHmac(algorithm, cKey, strlen(cKey), cData, strlen(cData), characterBuffer);
        
        // Convert hash value in the buffer to NSString of hex values
        result = [NSMutableString stringWithCapacity:length * 2];
        for(int i = 0; i < length; i++)
            [result appendFormat:@"%02x",characterBuffer[i]];
    }
	
	return [NSString stringWithString:result];
}

@end
