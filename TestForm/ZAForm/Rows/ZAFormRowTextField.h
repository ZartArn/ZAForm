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

@interface ZAFormRowTextField : ZAFormRow

/// fix length then need show warning
@property (strong, nonatomic) NSNumber *warningLength;

/// textfield some methods delegate logic
@property (strong, nonatomic) id<ZAFormTextFieldLogic> logicDelegate;

/// enabled signal
@property (strong, nonatomic) RACSignal *enabledSignal;

/// placeholder value
@property (strong, nonatomic) id placeholderValue;

/// resign first responder
- (void)resignFirstResponder;

/// combine validator
@property (strong, nonatomic) RACSignal *validateSignal;

/// warning signal for cell
@property (strong, nonatomic) RACSignal *warningSignal;

/// validators
@property (strong, nonatomic) NSMutableArray *validators;

/// register validator
- (void)addValidator:(RACSignal *)validator;

/// launch validate process, not can add validator after(?)
- (void)launchValidate;

@end
