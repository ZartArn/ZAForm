//
//  ZAFormRowAmount.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRowAmount.h"
#import "ZAFormAmountCell.h"

@interface ZAFormRowAmount() <UITextFieldDelegate>

@end

@implementation ZAFormRowAmount

@synthesize cell = _cell;

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormAmountCell class];
}

- (void)configureCell:(ZAFormBaseCell *)cell {
    NSLog(@"%@ :: %@", _cell, cell);
    
    NSAssert(cell, @"Cell not defined");
    NSAssert([cell isKindOfClass:[ZAFormAmountCell class]], @"Cell Class must be subclass of ZAFormAmountCell");
    ZAFormAmountCell *ccell = (ZAFormAmountCell *)cell;
    
    ccell.textField.delegate = self;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setTextPositionBeforeSuffix:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string  {
    
    NSString *value = textField.text;
    NSNumberFormatter *formatter = (NSNumberFormatter *)self.valueFormatter;
    
    // find decimal separator
    NSString *decSep = [formatter decimalSeparator];
    if ([value containsString:decSep]) {
        string = [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    } else {
        string = [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789.,"] invertedSet]] componentsJoinedByString:@""];
        // change comma or point to decimal separator
        string = [string stringByReplacingOccurrencesOfString:@"[.,]" withString:decSep options:NSRegularExpressionSearch range:(NSRange){0, string.length}];
    }
    
    // replace string
    value = [value stringByReplacingCharactersInRange:range withString:string];
    
    // convert to number
    NSNumber *n = [formatter numberFromString:value];
    
    // convert to str
    NSString *res = [formatter stringFromNumber:n];
    
    // find valute suffix index
    NSString *curSymbol = [formatter positiveSuffix];
    NSRange rrr = [res rangeOfString:curSymbol];
    
    // add decimal separator before valute suffix if need
    
    BOOL needAdd = [string hasSuffix:decSep];
    if (!needAdd) {
        // try find last separate in previous value
        NSString *str = [value stringByReplacingOccurrencesOfString:curSymbol withString:@""];
        needAdd = [str hasSuffix:decSep];
    }
    
    if (needAdd) {
        res = [res stringByReplacingCharactersInRange:(NSRange){rrr.location, 0} withString:decSep];
    }
    
    // set formatted text
    textField.text = res;
    
    // move cursor before valute suffix
    NSInteger symbLength = curSymbol.length;
    
    if (res.length > symbLength) {
        [self setTextPositionBeforeSuffix:textField];
    }
    
    return NO;
}

#pragma mark -

- (void)setTextPositionBeforeSuffix:(UITextField *)textField {
    NSString *curSymbol = [(NSNumberFormatter *)self.valueFormatter positiveSuffix];
    NSInteger symbLength = curSymbol.length;
    
    if (textField.text.length > symbLength) {
        UITextPosition *newCursorPosition = [textField positionFromPosition:textField.endOfDocument offset:-symbLength];
        UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
        [textField setSelectedTextRange:newSelectedRange];
    }
}

#pragma mark -

- (NSFormatter *)valueFormatter {
    static NSNumberFormatter *numberFormatter = nil;
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
        numberFormatter.minimumFractionDigits = 0;
        numberFormatter.maximumFractionDigits = 2;
        numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
        [numberFormatter setLenient:YES];
        NSString *currencyCode = _currencyCode ? _currencyCode : @"RUB";
        numberFormatter.currencyCode = currencyCode;
    }
    return numberFormatter;
}

@end
