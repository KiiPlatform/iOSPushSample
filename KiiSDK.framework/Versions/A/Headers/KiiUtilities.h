//
//  KiiUtilities.h
//  SampleApp
//
//  Created by Chris Beauchamp on 12/11/11.
//  Copyright (c) 2011 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiUtilities : NSObject

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret;
+ (NSString *)urlEncode:(NSString*)string usingEncoding:(NSStringEncoding)encoding;
+ (UIImage*)generateThumbnail:(NSString*)filePath ofSize:(CGFloat)thumbSize;

+ (void) callMethod:(SEL)method onDelegate:(id)delegate withObjects:(id)firstObj, ...;
+ (void) performRequestMethod:(BOOL)async withBlock:(void (^)(void))block;

//+ (void) executeBlock:(void (^)(id, va_list))block asynchronously:(BOOL)async withObjects:(id)firstObj, ...;

@end
