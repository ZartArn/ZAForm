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
    
    RAC(self.formRow, value) = [RACObserve(self.textField, text)
        map:^id(NSString *text) {
            NSLog(@"form %@", text);
            id objectValue = nil;
            BOOL res = [self.formRow.valueFormatter getObjectValue:&objectValue forString:text errorDescription:nil];
            return (res ? objectValue : nil);
        }];
    
    
    ZAFormRowAmount *row = (ZAFormRowAmount *)self.formRow;
    RAC(self.textField, enabled) = row.enabledSignal;
}

- (void)update {
    self.titleLabel.text = self.formRow.title;
    self.textField.text = [self.formRow.valueFormatter stringForObjectValue:self.formRow.value];
}

@end
