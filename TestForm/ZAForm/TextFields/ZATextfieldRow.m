//
//  ZATextfieldRow.m
//  Pods
//
//  Created by ZartArn on 06.10.16.
//
//

#import "ZATextfieldRow.h"
#import "ZAFormPhoneLogic.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZATextfieldRow()

@end

@implementation ZATextfieldRow

- (void)start {
    [self configure];
}

- (void)configure {
    
    // init
//    self.validators = [NSMutableArray array];
    
    // set delegate
    self.textField.delegate = self;
    if ([self.logicDelegate isKindOfClass:[ZAFormPhoneLogic class]] && [self.valueFormatter conformsToProtocol:@protocol(ZAFormFormatterLogicable)]) {
        ZAFormPhoneLogic *logic = (ZAFormPhoneLogic *)self.logicDelegate;
        logic.textFormatter = self.valueFormatter;
    }
    
    // placeholder
    if (self.placeholdeValue) {
        if (self.valueFormatter) {
            self.textField.placeholder = [self.valueFormatter stringForObjectValue:_placeholdeValue];
        } else if ([_placeholdeValue isKindOfClass:[NSString class]]) {
            self.textField.placeholder = _placeholdeValue;
        }
    } else if (self.placeholder) {
        self.textField.placeholder = _placeholder;
    }
    
    // channel value <-> textField.text
    
    @weakify(self);
    RACChannelTerminal *fieldTerminal = RACChannelTo(self.textField, text);
    RACChannelTerminal *valueTerminal = RACChannelTo(self, value);
    
    RACSignal *valueChangedSignal = [valueTerminal
                                       map:^id(id value) {
                                           @strongify(self);
                                           if (value && self.valueFormatter) {
                                               return [self.valueFormatter stringForObjectValue:value];
                                           }
                                           return value;
                                       }];
    [valueChangedSignal subscribe:fieldTerminal];
    
    RACSignal *fieldChangedSignal = [fieldTerminal
                                       map:^id(NSString *text) {
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
    
    if (self.logicDelegate) {
        [self.logicDelegate textField:textField willChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    
    // no logic delegate
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.logicDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        [self.logicDelegate performSelector:@selector(textFieldShouldClear:) withObject:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.logicDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.logicDelegate performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.logicDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.logicDelegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
    }
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
