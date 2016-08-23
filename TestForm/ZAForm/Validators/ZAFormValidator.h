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

- (RACSignal *)validateSignal;

@end
