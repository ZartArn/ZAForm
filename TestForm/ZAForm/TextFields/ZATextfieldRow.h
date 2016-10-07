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

/// validators
@property (strong, nonatomic) NSMutableArray *validators;

/// combine validator
@property (strong, nonatomic) RACSignal *validateSignal;

/// warning signal for cell
@property (strong, nonatomic) RACSignal *warningSignal;

/// fix length then need show warning
@property (strong, nonatomic) NSNumber *warningLength;

/// register validator
- (void)addValidator:(RACSignal *)validator;

/// launch validate process, not can add validator after(?)
- (void)launchValidate;

/// configure
- (void)configure;

@end
