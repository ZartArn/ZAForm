//
//  ZAFormRowAmount.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"
#import "ZAFormRowTextField.h"

@class RACSignal;

@interface ZAFormRowAmount : ZAFormRowTextField

/// enabled signal
@property (strong, nonatomic) RACSignal *enabledSignal;

/// currency code for formatter
@property (copy, nonatomic) NSString *currencyCode;

/// placeholder
@property (copy, nonatomic) NSString *placeholder;

/// placeholder value
@property (strong, nonatomic) id placeholderValue;

/// resign first responder
- (void)resignFirstResponder;

@end
