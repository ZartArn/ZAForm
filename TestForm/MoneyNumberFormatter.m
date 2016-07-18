//
//  MoneyNumberFormatter.m
//  TestForm
//
//  Created by ZartArn on 15.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "MoneyNumberFormatter.h"

@implementation MoneyNumberFormatter

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.numberStyle = NSNumberFormatterDecimalStyle;
    self.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    self.roundingMode = NSRoundBankers;
}

- (NSString *)clearString:(NSString *)aString {
//    NSString *s = [[aString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
    NSString *trimmedString = [aString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

#pragma mark - NSFormatter requirements

- (NSNumber *)numberFromString:(NSString *)string {
    string = [self clearString:string];
    return [super numberFromString:string];
}

@end
