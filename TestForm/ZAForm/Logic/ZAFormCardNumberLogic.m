//
//  ZAFormCardNumberLogic.m
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormCardNumberLogic.h"

@implementation ZAFormCardNumberLogic

- (NSCharacterSet *)avalaibleCharacterSet {
    NSCharacterSet *characterSet = nil;
    if (!characterSet) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    return characterSet;
}

- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentText = textField.text;
    NSCharacterSet *nonAvalaibleCharacterSet = [[self avalaibleCharacterSet] invertedSet];
    
    if (string.length == 0 && [[currentText substringWithRange:range] stringByTrimmingCharactersInSet:nonAvalaibleCharacterSet].length == 0) {
        // find non-whitespace character backward
        NSRange numberCharacterRange = [currentText rangeOfCharacterFromSet:[self avalaibleCharacterSet]
                                                                    options:NSBackwardsSearch
                                                                      range:NSMakeRange(0, range.location)];
        // adjust replace range
        if (numberCharacterRange.location != NSNotFound) {
            range = NSUnionRange(range, numberCharacterRange);
        }
    }
    
    // replace string
    return [textField.text stringByReplacingCharactersInRange:range withString:string];
}

@end
