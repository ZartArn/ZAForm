//
//  ZATextfieldRow.m
//  Pods
//
//  Created by ZartArn on 06.10.16.
//
//

#import "ZATextfieldRow.h"
#import "ZAFormPhoneLogic.h"


@interface ZATextfieldRow()

@property (strong, nonatomic) NSMutableArray *rowValidators;

@end

@implementation ZATextfieldRow

- (instancetype)init {
    if (self = [super init]) {
        _rowValidators = [NSMutableArray array];
    }
    return self;
}

#pragma mark - configure

- (void)start {
    [self configure];
}

- (void)configure {
    
    // init
//    self.validators = [NSMutableArray array];
    
    // set delegate
    self.textField.delegate = self;
    if (self.logicDelegate) {
        if ([self.logicDelegate isKindOfClass:[ZAFormPhoneLogic class]] && [self.valueFormatter conformsToProtocol:@protocol(ZAFormFormatterLogicable)]) {
            ZAFormPhoneLogic *logic = (ZAFormPhoneLogic *)self.logicDelegate;
            logic.textFormatter = (NSFormatter <ZAFormFormatterLogicable> *)self.valueFormatter;
        } else if ([self.logicDelegate respondsToSelector:@selector(setTextFormatter:)]) {
            [self.logicDelegate performSelector:@selector(setTextFormatter:) withObject:self.valueFormatter];
        }
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
    RACChannelTerminal *fieldTerminal;
    if (self.textField.secureTextEntry) {
        fieldTerminal = [self.textField rac_newTextChannel];
    } else {
        fieldTerminal = RACChannelTo(self.textField, text);
    }
    RACChannelTerminal *valueTerminal = RACChannelTo(self, value);
    
    RACSignal *valueChangedSignal = [valueTerminal
                                       map:^id(id value) {
                                           NSLog(@"value terminal :: %@", value);
                                           @strongify(self);
                                           if (value && self.valueFormatter) {
                                               return [self.valueFormatter stringForObjectValue:value];
                                           }
                                           return value;
                                       }];
    [valueChangedSignal subscribe:fieldTerminal];
    
    RACSignal *fieldChangedSignal = [fieldTerminal
                                       map:^id(NSString *text) {
                                           NSLog(@"field terminal :: %@", text);
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

    // secure field
    if (textField.secureTextEntry) {
        return YES;
    }
    
    
    if (self.logicDelegate) {
        [self.logicDelegate textField:textField willChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    
    // no logic delegate
    NSString *newString;
    newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.didSelectBlock) {
        self.didSelectBlock(self);
        return NO;
    }
    if ([self.logicDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        [self.logicDelegate performSelector:@selector(textFieldShouldBeginEditing:) withObject:textField];
    }
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"textFieldShouldClear");
    if ([self.logicDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.logicDelegate performSelector:@selector(textFieldShouldClear:) withObject:textField];
    } else {
        textField.text = nil;
        return YES;
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

#pragma mark - validators (old)

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

#pragma mark - validators

- (void)addRowValidator:(id<ZAFormValidator>)validator {
    [self.rowValidators addObject:validator];
}

- (void)addRowValidators:(NSArray<id<ZAFormValidator>> *)validators {
    [self.rowValidators addObjectsFromArray:validators];
}

- (RACSignal *)validateErrorSignal:(NSArray *)validators {
    return
        [[RACSignal combineLatest:[validators.rac_sequence
                                   map:^id(id<ZAFormValidator> validator) {
                                       return  [validator.validateSignal
                                                map:^id(id value) {
                                                    RACTuple *tuple = RACTuplePack(value, validator.errorMessage);
                                                    return tuple;
                                                }];
                                   }]]
         
         map:^id(RACTuple *signalValues) {
             return [signalValues.rac_sequence objectPassingTest:^BOOL(RACTuple *value) {
                 NSNumber *isValid = value.first;
                 return !isValid.boolValue;
             }];
         }];
}

- (void)launchRowValidate {
    // on focus + on change
    NSPredicate *p = [NSPredicate predicateWithFormat:@"showOnChange = %@", @YES];
    NSArray *validators = [[self.rowValidators copy] filteredArrayUsingPredicate:p];
    
    @weakify(self);
    
    if (validators.count > 0) {
        [[self.textField rac_signalForControlEvents:UIControlEventEditingDidBegin]
         subscribeNext:^(id x) {
             @strongify(self);
             [[[self validateErrorSignal:validators]
               takeUntil:[self.textField rac_signalForControlEvents:UIControlEventEditingDidEnd]]
              subscribeNext:^(RACTuple *x) {
                  NSString *message = x.last;
                  @strongify(self);
                  NSError *error = nil;
                  if (message != nil) {
                      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
                      error = [NSError errorWithDomain:@"111" code:1 userInfo:userInfo];
                  }
                  [self.textField performSelector:@selector(setError:animated:) withObject:error withObject:@YES];
              }];
         }];
    }
    
    // on blur
    [[self.textField rac_signalForControlEvents:UIControlEventEditingDidEnd]
     subscribeNext:^(id x) {
         @strongify(self);
         NSArray *validators = [self.rowValidators copy];
         
         [[[self validateErrorSignal:validators] take:1]
          subscribeNext:^(RACTuple *x) {
              NSString *message = x.last;
              NSLog(@"validate message subscriber :: %@", x);
              @strongify(self);
              NSError *error = nil;
              if (message != nil) {
                  NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
                  error = [NSError errorWithDomain:@"111" code:1 userInfo:userInfo];
              }
              [self.textField performSelector:@selector(setError:animated:) withObject:error withObject:@YES];
          }];
     }];
}

@end
