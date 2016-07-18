//
//  ZAFormRowSelector.m
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRowSelector.h"
#import "ZAFormWithViewModelCell.h"

@implementation ZAFormRowSelector

+ (Class)defaultCellClass {
    return [ZAFormWithViewModelCell class];
}

- (id)viewModelForValue:(id)value {
    return nil;
//    TestObjectViewModel *viewModel = [TestObjectViewModel new];
//    TestObject *objectValue = (TestObject *)value;
//    
//    viewModel.title = [NSString stringWithFormat:@"Z-%@", objectValue.title];
//    viewModel.subTitle = objectValue.subTitle;
//    
//    return viewModel;
}

#pragma mark -

- (void)optionsViewControllerDone:(ZAFormOptionsViewController *)optionsViewController {
    [self.cell update];
}

@end
