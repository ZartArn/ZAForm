//
//  ZAFormRowWithViewModel.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRowWithViewModel.h"

@implementation ZAFormRowWithViewModel

- (id)viewModelForValue {
    return [self viewModelForValue:self.value];
}

- (id)viewModelForValue:(id)value {
    return nil;
}

@end
