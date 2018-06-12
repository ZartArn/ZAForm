//
//  ZAFormRowWithViewModel.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"
#import "ZAFormSection.h"
#import "ZAFormRowTextField.h"
#import "ZAFormTextFieldCell.h"
#import "ZAFormTableManager.h"
#import "ZAFormPhoneLogic.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZAFormRowTextField()

//@property (strong, nonatomic) NSMutableDictionary *errorMessages;
//@property (strong, nonatomic) NSMutableArray *errorMessageSignals;
//@property (strong, nonatomic) NSMutableArray *errMessages;

@property (strong, nonatomic) NSMutableArray *rowValidators;

@end

@implementation ZAFormRowTextField

- (void)configureRow {
    [super configureRow];
    self.validators = [NSMutableArray array];
//    self.errorMessageSignals = [NSMutableArray array];
//    self.errMessages = [NSMutableArray array];
    self.rowValidators = [NSMutableArray array];
}

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormTextFieldCell class];
}

- (void)configureCell:(ZAFormBaseCell *)aCell {
    NSAssert(aCell, @"Cell not defined");
    NSAssert([aCell isKindOfClass:[ZAFormTextFieldCell class]], @"Cell Class must be subclass of ZAFormTextFieldCell");
    
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)aCell;
    
//    cell.textField.inputAccessoryView = self.form.accessoryView;
    
    // text field delegate
    cell.textField.delegate = self;
    if ([self.logicDelegate isKindOfClass:[ZAFormPhoneLogic class]] && [self.valueFormatter conformsToProtocol:@protocol(ZAFormFormatterLogicable)]) {
        ZAFormPhoneLogic *logic = (ZAFormPhoneLogic *)self.logicDelegate;
        logic.textFormatter = self.valueFormatter;
    }

    // placeholder
    if (_placeholderValue) {
        cell.textField.placeholder = _placeholderValue; // [self.valueFormatter stringForObjectValue:self.placeholderValue];
    }

    // channel value <-> textField.text
    
    @weakify(self);
    RACChannelTerminal *fieldTerminal;
    if (cell.textField.secureTextEntry) {
        fieldTerminal = [cell.textField rac_newTextChannel];
    } else {
        fieldTerminal = RACChannelTo(cell.textField, text);
    }
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
    
    // text input traits proxy
    if (_manualInputTraits) {
        cell.textField.keyboardType = self.keyboardType;
        cell.textField.returnKeyType = self.returnKeyType;
    }
    
    // launch on change validate
    [self launchRowValidate];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string  {

    if (self.logicDelegate) {
        [self.logicDelegate textField:textField willChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    
    // no logic delegate
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *cursorLocation = [textField positionFromPosition:beginning offset:(range.location + string.length)];
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.valueFormatter) {
        //
        NSString *obj;
        [self.valueFormatter getObjectValue:&obj forString:newString errorDescription:nil];
        
        textField.text = [self.valueFormatter stringForObjectValue:obj];
    } else {
        textField.text = newString;
        if (cursorLocation) {
            [textField setSelectedTextRange:[textField textRangeFromPosition:cursorLocation toPosition:cursorLocation]];
        }
    }

    
/*
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
*/
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.form nextInput];
    });
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
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
    if (textField.inputAccessoryView) {
        [self.form updateAccessoryView:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.logicDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.logicDelegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
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

//- (void)addValidator:(id<ZAFormValidator>)validator {
- (void)addValidator:(RACSignal *)validator {
    [self.validators addObject:validator];
}

//- (void)addValidator:(RACSignal *)validator errorMessage:(NSString *)errorMessage {
//    
//    static NSInteger keyInt = 1;
//    [self.validators addObject:validator];
//    NSNumber *keyCode = @(keyInt++);
//    [self.errorMessages setObject:[NSNull null] forKey:keyCode];
//    
//    @weakify(self);
//    [[validator distinctUntilChanged]
//        subscribeNext:^(NSNumber *x) {
//            @strongify(self);
//            self.errorMessages[keyCode] = x.boolValue ? [NSNull null] : errorMessage;
//        }];
//}

- (void)launchValidate {
    
    if (self.validators.count > 1) {
        self.validateSignal = [[[RACSignal combineLatest:[self.validators copy]]
                                map:^(RACTuple *signalValues) {
                                    return @([signalValues.rac_sequence all:^BOOL(NSNumber *value) {
                                        return value.boolValue;
                                    }]);
                                }] distinctUntilChanged];
    } else if (self.validators.count == 1) {
        self.validateSignal = self.validators.firstObject;
    }

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

    RAC(self, isValid) = self.validateSignal;
}

//- (NSString *)errorMessage {
//    if (_errorMessages == nil) {
//        return nil;
//    }
//    NSArray *messages = [self.errorMessages allValues];
//    NSPredicate *p = [NSPredicate predicateWithFormat:@"self != %@", [NSNull null]];
//    NSArray *filterMessages = [messages filteredArrayUsingPredicate:p];
//    
//    return [filterMessages componentsJoinedByString:@"\n"];
//}

#pragma mark - validators new

- (void)addRowValidator:(id<ZAFormValidator>)validator {
    [self.rowValidators addObject:validator];
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
    
    ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)self.cell;

    // on focus + on change
    NSPredicate *p = [NSPredicate predicateWithFormat:@"showOnChange = %@", @YES];
    NSArray *validators = [[self.rowValidators copy] filteredArrayUsingPredicate:p];

    @weakify(self);

    if (validators.count > 0) {
        
        [[cell.textField rac_signalForControlEvents:UIControlEventEditingDidBegin]
            subscribeNext:^(id x) {
                @strongify(self);
                [[[self validateErrorSignal:validators]
                    takeUntil:[cell.textField rac_signalForControlEvents:UIControlEventEditingDidEnd]]
                    subscribeNext:^(RACTuple *x) {
                        NSString *message = x.last;
                        @strongify(self);
                        NSError *error = nil;
                        if (message != nil) {
                            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
                            error = [NSError errorWithDomain:@"111" code:1 userInfo:userInfo];
                        }
                        [self.section.form.tableView beginUpdates];
                        [cell.textField performSelector:@selector(setError:animated:) withObject:error withObject:@NO];
                        [self.section.form.tableView endUpdates];
                    }];
            }];
    }
    
    // on blur
    [[cell.textField rac_signalForControlEvents:UIControlEventEditingDidEnd]
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
                         [self.section.form.tableView beginUpdates];
                         [cell.textField performSelector:@selector(setError:animated:) withObject:error withObject:@NO];
                         [self.section.form.tableView endUpdates];
                     }];
        }];
}

#pragma mark - lazy

//- (NSMutableDictionary *)errorMessages {
//    if (_errorMessages == nil) {
//        _errorMessages = [NSMutableDictionary dictionary];
//    }
//    return _errorMessages;
//}

@end
