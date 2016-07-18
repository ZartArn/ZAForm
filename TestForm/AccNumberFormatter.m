//
//  AccNumberFormatter.m
//  TestForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "AccNumberFormatter.h"

@implementation AccNumberFormatter

- (instancetype)initWithMask:(NSString *)maskString {
    if (self = [super init]) {
        _mask = maskString;
    }
    return self;
}

#pragma mark -

- (BOOL)isRequireSubstitute:(unichar)ch {
    return ( ch == '#') ? YES : NO;
}

- (NSString *)applyFormatTostring:(NSString *)aString {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSInteger charIndex = 0;
    for (NSInteger i = 0; i < [self.mask length] && charIndex < [aString length]; i++) {
        unichar ch = [self.mask characterAtIndex:i];
        if ([self isRequireSubstitute:ch]) {
            unichar sp = [aString characterAtIndex:charIndex++];
            [result appendString:[NSString stringWithCharacters:&sp length:1]];
        } else {
            [result appendString:[NSString stringWithCharacters:&ch length:1]];
        }
    }
    return [result copy];
}

- (NSString *)clearString:(NSString *)formattedString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/[^A-Z,0-9]/"
                                                                           options:0
                                                                             error:&error];
    NSString *clearString = [regex stringByReplacingMatchesInString:formattedString
                                                     options:0
                                                       range:NSMakeRange(0, [formattedString length])
                                                       withTemplate:@""];
    return clearString;
}

#pragma mark - NSFormatter requirements

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString  **)error {
    *obj = [self clearString:string];
    return YES;
}

- (NSString *) stringForObjectValue:(id)anObject {
    return [self applyFormatTostring:anObject];
}


@end
