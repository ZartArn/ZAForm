//
//  ZAFormRowWithViewModel.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"
#import "ZAFormRowTextField.h"
#import "ZAFormTextFieldCell.h"
#import <ReactiveCocoa.h>

@interface ZAFormRowTextField() <UITextFieldDelegate>

@end

@implementation ZAFormRowTextField

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormRowTextField class];
}

- (void)configureCell:(ZAFormBaseCell *)cell {
    NSAssert(cell, @"Cell not defined");
    NSAssert([cell isKindOfClass:[ZAFormTextFieldCell class]], @"Cell Class must be subclass of ZAFormTextFieldCell");
    
    ZAFormTextFieldCell *ccell = (ZAFormTextFieldCell *)cell;
    ccell.textField.delegate = self;
    if (_placeholderValue) {
        ccell.textField.placeholder = _placeholderValue; // [self.valueFormatter stringForObjectValue:self.placeholderValue];
    }

//    @weakify(self);
//    self.value = [ccell.textField.rac_textSignal
//                                map:^id(NSString *text) {
//                                    @strongify(self);
//                                    id objectValue = nil;
//                                    BOOL res = [self.valueFormatter getObjectValue:&objectValue forString:text errorDescription:nil];
//                                    return (res ? objectValue : nil);
//                                }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string  {
    
    // replace string
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (self.valueFormatter) {
        //
        NSString *obj;
        [self.valueFormatter getObjectValue:&obj forString:newString errorDescription:nil];
        
        textField.text = [self.valueFormatter stringForObjectValue:obj];
    } else {
        textField.text = newString;
    }
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = nil;
    return YES;
}

@end
