//
//  ZAFormPhoneLogic.m
//  Pods
//
//  Created by ZartArn on 22.11.16.
//
//

#import "ZAFormPhoneLogic.h"

@implementation ZAFormPhoneLogic

- (NSCharacterSet *)avalaibleCharacterSet {
    NSCharacterSet *characterSet = nil;
    if (!characterSet) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    return characterSet;
}

- (void)applyFormatTo:(UITextField *)textField forText:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    NSString *resultString = [self.textFormatter valuesForString:text];
    textField.text = resultString;
}

- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.textFormatter.prefix.length && range.location < self.textFormatter.prefix.length) {
        return nil;
    }
    
    NSInteger caretPosition = [self pushCaretPosition:textField range:range];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self applyFormatTo:textField forText:newString];
    
    [self popCaretPosition:textField range:range caretPosition:caretPosition];
    [textField sendActionsForControlEvents:UIControlEventValueChanged];
    
    return nil;
    
//    NSString *currentText = textField.text;
//    NSCharacterSet *nonAvalaibleCharacterSet = [[self avalaibleCharacterSet] invertedSet];
//    
//    if (string.length == 0 && [[currentText substringWithRange:range] stringByTrimmingCharactersInSet:nonAvalaibleCharacterSet].length == 0) {
//        // find non-whitespace character backward
//        NSRange numberCharacterRange = [currentText rangeOfCharacterFromSet:[self avalaibleCharacterSet]
//                                                                    options:NSBackwardsSearch
//                                                                      range:NSMakeRange(0, range.location)];
//        // adjust replace range
//        if (numberCharacterRange.location != NSNotFound) {
//            range = NSUnionRange(range, numberCharacterRange);
//        }
//    }
//    
//    // replace string
//    return [textField.text stringByReplacingCharactersInRange:range withString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length == 0 && self.textFormatter.prefix.length > 0) {
        textField.text = self.textFormatter.prefix;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == self.textFormatter.prefix.length) {
        textField.text = nil;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFormatter.prefix.length > 0) {
        [self applyFormatTo:textField forText:@""];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark Caret Control

- (NSInteger)pushCaretPosition:(UITextField *)textField range:(NSRange)range {
    NSString *subString = [textField.text substringFromIndex:range.location + range.length];
    return [self.textFormatter valuableCharCountIn:subString];
}

- (void)popCaretPosition:(UITextField *)textField range:(NSRange)range caretPosition:(NSInteger)caretPosition {
    if (range.length == 0) range.length = 1;
    
    NSString *text = textField.text;
    NSInteger lasts = caretPosition;
    NSInteger start = [text length];
    for (NSInteger index = [text length] - 1; index >= 0 && lasts > 0; index--) {
        unichar ch = [text characterAtIndex:index];
        if ([self.textFormatter isValuableChar:ch]) lasts--;
        if (lasts <= 0) {
            start = index;
            break;
        }
    }
    
    [self selectTextForInput:textField atRange:NSMakeRange(start, 0)];
}

- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location ];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

@end
