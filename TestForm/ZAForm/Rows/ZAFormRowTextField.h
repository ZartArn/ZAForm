//
//  ZAFormRowWithViewModel.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"
#import "ZAFormTextFieldLogic.h"
#import "ZAFormValidator.h"

@class RACSignal;

@interface ZAFormRowTextField : ZAFormRow <UITextFieldDelegate, UITextInputTraits>

/// fix length then need show warning
@property (strong, nonatomic) NSNumber *warningLength;

/// textfield some methods delegate logic
@property (strong, nonatomic) id<ZAFormTextFieldLogic> logicDelegate;

/// enabled signal
@property (strong, nonatomic) RACSignal *enabledSignal;

/// placeholder value
@property (strong, nonatomic) id placeholderValue;

/// set manual TextInputTraits, default NO
@property (nonatomic) BOOL manualInputTraits;

/// resign first responder
- (void)resignFirstResponder;

/// combine validator
@property (strong, nonatomic) RACSignal *validateSignal;

/// warning signal for cell
@property (strong, nonatomic) RACSignal *warningSignal;

/// validators
@property (strong, nonatomic) NSMutableArray *validators;

/// is row valid. nil - field not under validation
@property (strong, nonatomic) NSNumber *isValid;

/// error message (from validators)
//@property (copy, nonatomic) NSString *errorMessage;

/// register validator
- (void)addValidator:(RACSignal *)validator;

/// register validator with error message
//- (void)addValidator:(RACSignal *)validator errorMessage:(NSString *)errorMessage;

/// launch validate process, not can add validator after(?)
- (void)launchValidate;

#pragma mark - validators

//@property (strong, nonatomic) RACSignal *flyErrorMessageSignal;

- (void)addRowValidator:(id<ZAFormValidator>)validator;
- (void)addRowValidators:(NSArray<id<ZAFormValidator>> *)validators;

//- (void)launchRowValidate;


#pragma mark - UITextInputTraits

@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;

@end
