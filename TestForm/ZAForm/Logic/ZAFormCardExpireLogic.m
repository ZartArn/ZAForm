//
//  ZAFormCardExpireLogic.m
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormCardExpireLogic.h"

@implementation ZAFormCardExpireLogic

- (NSCharacterSet *)avalaibleCharacterSet {
    NSCharacterSet *characterSet = nil;
    if (!characterSet) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    return characterSet;
}

- (void)applyFormatTo:(UITextField *)textField forText:(NSString *)text {
    textField.text = self.textFormatter ? [self.textFormatter stringForObjectValue:text] : text;
}

- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *currentText = textField.text;
    NSString *newString;

    NSCharacterSet *nonNumberCharacterSet = [[self avalaibleCharacterSet] invertedSet];

    if (string.length == 0 && [[currentText substringWithRange:range] stringByTrimmingCharactersInSet:nonNumberCharacterSet].length == 0) {
        // find non-whitespace character backward
        NSRange numberCharacterRange = [currentText rangeOfCharacterFromSet:[self avalaibleCharacterSet]
                                                                    options:NSBackwardsSearch
                                                                      range:NSMakeRange(0, range.location)];
        // adjust replace range
        if (numberCharacterRange.location != NSNotFound) {
            range = NSUnionRange(range, numberCharacterRange);
        }
    }

    NSString *replacedString = [currentText stringByReplacingCharactersInRange:range withString:string];
    NSString *numberOnlyString = [self clearString:replacedString];

    if (numberOnlyString.length > 4) {
        // NO should replace
        return currentText;
    }

    if (numberOnlyString.length == 1 && [numberOnlyString substringToIndex:1].integerValue > 1) {
        numberOnlyString = [@"0" stringByAppendingString:numberOnlyString];
    }

    if (numberOnlyString.length > 0) {
        
        NSString *monthString = [numberOnlyString substringToIndex:MIN(2, numberOnlyString.length)];
        
        if (monthString.length == 2) {
            NSInteger monthInteger = monthString.integerValue;
            if (monthInteger < 1 || monthInteger > 12) {
                return currentText;
            }
        }
    }
    [self applyFormatTo:textField forText:numberOnlyString];
    return numberOnlyString;
}

- (NSString *)clearString:(NSString *)formattedString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]"
                                                                           options:0
                                                                             error:&error];
    NSString *clearString = [regex stringByReplacingMatchesInString:formattedString
                                                            options:0
                                                              range:NSMakeRange(0, [formattedString length])
                                                       withTemplate:@""];
    return clearString;
}


@end
