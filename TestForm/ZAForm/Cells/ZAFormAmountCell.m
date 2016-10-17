//
//  ZAFormAmountCell.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormAmountCell.h"
#import "ZAFormRowAmount.h"
#import <ReactiveCocoa.h>

@implementation ZAFormAmountCell

- (void)configure {
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    if (!self.formRow.editable) {
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    }
    [self update];
    
    ZAFormRowAmount *row = (ZAFormRowAmount *)self.formRow;
    RAC(self.textField, enabled) = row.enabledSignal;

    // set warning color
    if ([self.formRow isKindOfClass:[ZAFormRowTextField class]]) {
        ZAFormRowTextField *row = (ZAFormRowTextField *)self.formRow;
        RAC(self.textField, textColor) = [row.warningSignal
                                          map:^id(NSNumber *value) {
                                              return value.boolValue ? [UIColor redColor] : [UIColor blackColor];
                                          }];
    }
}

- (void)update {
    self.titleLabel.text = self.formRow.title;
//    self.textField.text = [self.formRow.valueFormatter stringForObjectValue:self.formRow.value];
}

@end
