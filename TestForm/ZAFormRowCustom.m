//
//  ZAFormRowCustom.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRowCustom.h"
#import "ZAFormCustomCell.h"
#import "TestObject.h"

@implementation ZAFormRowCustom

+ (Class)defaultCellClass {
    return [ZAFormCustomCell class];
}

- (id)viewModelForValue {
    TestObjectViewModel *viewModel = [TestObjectViewModel new];
    TestObject *objectValue = (TestObject *)self.value;
    
    viewModel.title = [NSString stringWithFormat:@"Z-%@", objectValue.title];
    viewModel.subTitle = objectValue.subTitle;
    
    return viewModel;
}

@end
