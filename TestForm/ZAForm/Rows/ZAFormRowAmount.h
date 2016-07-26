//
//  ZAFormRowAmount.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"

@class RACSignal;

@interface ZAFormRowAmount : ZAFormRow

/// enabled signal
@property (strong, nonatomic) RACSignal *enabledSignal;

/// currency code for formatter
@property (copy, nonatomic) NSString *currencyCode;

/// placeholder value
@property (strong, nonatomic) id placeholderValue;

/// redign first responder
- (void)resignFirstResponder;

@end
