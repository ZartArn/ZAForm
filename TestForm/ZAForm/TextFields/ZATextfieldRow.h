//
//  ZATextfieldRow.h
//  Pods
//
//  Created by ZartArn on 06.10.16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZAFormTextFieldLogic.h"
#import "ZAFormValidator.h"
#import "ZAFormValidator.h"

@class RACSignal;

@interface ZATextfieldRow : NSObject <UITextFieldDelegate>

/// text field
@property (strong, nonatomic) UITextField *textField;

/// value
@property (strong, nonatomic) id value;

/// placeholder value
@property (strong, nonatomic) id placeholdeValue;

/// placeholder (without formatter)
@property (strong, nonatomic) NSString *placeholder;

/// textfield some methods delegate logic
@property (strong, nonatomic) id<ZAFormTextFieldLogic> logicDelegate;

/// value formatter
@property (strong, nonatomic) NSFormatter *valueFormatter;

/// select block
@property (copy, nonatomic) void(^didSelectBlock)(ZATextfieldRow *row);

/// validators
@property (strong, nonatomic) NSMutableArray *validators DEPRECATED_ATTRIBUTE;

/// combine validator
@property (strong, nonatomic) RACSignal *validateSignal DEPRECATED_ATTRIBUTE;

/// warning signal for cell
@property (strong, nonatomic) RACSignal *warningSignal DEPRECATED_ATTRIBUTE;

/// fix length then need show warning
@property (strong, nonatomic) NSNumber *warningLength DEPRECATED_ATTRIBUTE;

/// register validator (deprecated)
/// @see -addRowValidator:validator
- (void)addValidator:(RACSignal *)validator DEPRECATED_ATTRIBUTE;

/// launch validate process, not can add validator after(?) (deprecated)
/// @see -launchRowValidate
- (void)launchValidate DEPRECATED_ATTRIBUTE;

/// register validator
- (void)addRowValidator:(id<ZAFormValidator>)validator;
- (void)addRowValidators:(NSArray<id<ZAFormValidator>> *)validators;

/// configure
- (void)configure;

/// start (configure)
- (void)start;

/// launch row validate, need call after method start
- (void)launchRowValidate;

@end
