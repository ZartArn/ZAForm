//
//  ZATextfieldRow.m
//  Pods
//
//  Created by ZartArn on 06.10.16.
//
//

#import "ZATextfieldRow.h"
#import <ReactiveCocoa.h>

@interface ZATextfieldRow()

@end

@implementation ZATextfieldRow

- (void)configure {
    
    // init
    self.validators = [NSMutableArray array];
    
    // set delegate
    self.textField.delegate = self;
    
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
    // replace string
    NSString *newString;
    
    if (self.logicDelegate) {
        newString = [self.logicDelegate textField:textField willChangeCharactersInRange:range replacementString:string];
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
