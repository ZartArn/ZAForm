//
//  ZAFormMaskFieldLogic.m
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormMaskFieldLogic.h"
#import "ZAFormPhoneLogic.h"

@implementation ZAFormMaskFieldLogic

- (void)applyFormatTo:(UITextField *)textField forText:(NSString *)text {
    NSString *resultString = [self.textFormatter valuesForString:text];
    textField.text = resultString;
}




- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger caretPosition = [self pushCaretPosition:textField range:range];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self applyFormatTo:textField forText:newString];
    
    [self popCaretPosition:textField range:range caretPosition:caretPosition];
    [textField sendActionsForControlEvents:UIControlEventValueChanged];
    
    return nil;
}


#pragma mark Caret Control

- (NSInteger)pushCaretPosition:(UITextField *)textField range:(NSRange)range {
    NSString *subString = [textField.text substringFromIndex:range.location + range.length];
    return [self.textFormatter valuableCharCountIn:subString];
}

- (void)popCaretPosition:(UITextField *)textField range:(NSRange)range caretPosition:(NSInteger)caretPosition {
//    if (range.length == 0) range.length = 1;
    
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
