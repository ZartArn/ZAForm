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
#import "ZAFormTableManager.h"
#import <ReactiveCocoa.h>

@interface ZAFormRowTextField() <UITextFieldDelegate>

@end

@implementation ZAFormRowTextField

- (void)configureRow {
    [super configureRow];
    self.validators = [NSMutableArray array];
}

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormTextFieldCell class];
}

- (void)configureCell:(ZAFormBaseCell *)aCell {
    NSAssert(aCell, @"Cell not defined");
    NSAssert([aCell isKindOfClass:[ZAFormTextFieldCell class]], @"Cell Class must be subclass of ZAFormTextFieldCell");
    
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)aCell;
    cell.textField.delegate = self;
    cell.textField.inputAccessoryView = self.form.accessoryView;
    
    if (_placeholderValue) {
        cell.textField.placeholder = _placeholderValue; // [self.valueFormatter stringForObjectValue:self.placeholderValue];
    }

    @weakify(self);
    RACChannelTerminal *fieldTerminal = RACChannelTo(cell.textField, text);
    RACChannelTerminal *valueTerminal = RACChannelTo(self, value);

    RACSignal *valueChangedSignal = [valueTerminal
        map:^id(id value) {
//            NSLog(@"value changed %@", value);
            @strongify(self);
            if (value && self.valueFormatter) {
                return [self.valueFormatter stringForObjectValue:value];
            }
            return value;
        }];
    [valueChangedSignal subscribe:fieldTerminal];
    
    RACSignal *fieldChangedSignal = [fieldTerminal
        map:^id(NSString *text) {
//            NSLog(@"field changed %@", text);
            @strongify(self);
            if (self.valueFormatter) {
                id objectValue = nil;
                BOOL res = [self.valueFormatter getObjectValue:&objectValue forString:text errorDescription:nil];
                return (res ? objectValue : nil);
            } else {
                return text;
            }
        }];
    
    [[fieldChangedSignal skip:1] subscribe:valueTerminal];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string  {
    // replace string
    NSString *newString;
    
    if (_logicDelegate) {
        newString = [_logicDelegate textField:textField willChangeCharactersInRange:range replacementString:string];
    } else {
        newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.form nextInput];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.inputAccessoryView) {
        [self.form updateAccessoryView:self];
    }
}

#pragma mark - lazy

#pragma mark - responders

- (BOOL)canBeFirstResponder {
    return YES;
}

- (BOOL)isFirstResponder {
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)self.cell;
    return (cell.textField.isFirstResponder);
}

- (void)becomeFirstResponder {
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)self.cell;
    [cell.textField becomeFirstResponder];
}

- (void)resignFirstResponder {
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)self.cell;
    [cell.textField resignFirstResponder];
}

#pragma mark - validators

- (void)addValidator:(id<ZAFormValidator>)validator {
    [self.validators addObject:validator];
}

- (void)launchValidate {
    
    self.validateSignal = [[[RACSignal combineLatest:[self.validators copy]]
                            map:^(RACTuple *signalValues) {
                                return @([signalValues.rac_sequence all:^BOOL(NSNumber *value) {
                                    return value.boolValue;
                                }]);
                            }] distinctUntilChanged];

    if (self.warningLength) {
        // value must be NSString (!)
        RACSignal *needShowWarningSignal = [[RACObserve(self, value)
            map:^id(NSString *value) {
                return @(value.length >= self.warningLength.integerValue);
            }] distinctUntilChanged];
    
        // warning signal for cell
        self.warningSignal = [RACSignal
                                if:needShowWarningSignal
                              then:[self.validateSignal not]
                              else:[RACSignal return:@0]];
    }

}

@end
