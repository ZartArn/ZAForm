//
//  ZAFormValidator.h
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@protocol ZAFormValidator <NSObject>

/// validate signal
@property (strong, nonatomic) RACSignal *validateSignal;

/// error message
@property (copy, nonatomic) NSString *errorMessage;

/// show on change
@property (nonatomic) BOOL showOnChange;

/// show on blur
@property (nonatomic) BOOL showOnBlur;

@end
