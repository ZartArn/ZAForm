//
//  ZAFormRowValidator.h
//  ZAForm
//
//  Created by ZartArn on 26.04.2018.
//

#import <Foundation/Foundation.h>
#import "ZAFormValidator.h"

@interface ZAFormRowValidator : NSObject <ZAFormValidator>

@property (strong, nonatomic) RACSignal *validateSignal;
@property (copy, nonatomic) NSString *errorMessage;
@property (nonatomic) BOOL showOnChange;
@property (nonatomic) BOOL showOnBlur;

@end
