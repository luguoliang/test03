//
//  MD5_encryption.m
//  ManagedFuns2.0Demo
//
//  Created by 路国良 on 16/3/22.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "MD5_encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5_encryption
+(NSString*)encryptstring:(NSString*)enstring{
    const char *original_str = [enstring UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
