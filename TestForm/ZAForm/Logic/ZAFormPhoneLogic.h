//
//  ZAFormPhoneLogic.h
//  Pods
//
//  Created by ZartArn on 22.11.16.
//
//

#import <Foundation/Foundation.h>
#import "ZAFormTextFieldLogic.h"

@protocol ZAFormFormatterLogicable;

@interface ZAFormPhoneLogic : NSObject <ZAFormTextFieldLogic>

/// text formatter
@property (assign, nonatomic) NSFormatter<ZAFormFormatterLogicable> *textFormatter;

@end



@protocol ZAFormFormatterLogicable <NSObject>

/// Prefix for all formats.
@property (copy, nonatomic) NSString *prefix;

/// value for string
- (NSString *)valuesForString:(NSString *)aString;

/// Check if a char is valuable symbol(part of number). Valuable chars are all digits
- (BOOL)isValuableChar:(unichar)ch;

/// Returns a count of valuable symbols in string
- (NSInteger)valuableCharCountIn:(NSString *)string;

@end
