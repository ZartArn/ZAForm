//
//  ZAFormRowSelector.h
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

//#import "ZAFormRow.h"
#import "ZAFormRowWithViewModel.h"
#import "ZAFormOptionsViewController.h"

typedef NS_ENUM(NSInteger, ZAFormTypeSelector) {
    ZAFormTypeSelectorPush,
    ZAFormTypeSelectorSheet,
    ZAFormTypeSelectorAlert,
    ZAFormTypeSelectorPickerView,
    ZAFormTypeSelectorModalCustomController
};

@interface ZAFormRowSelector : ZAFormRowWithViewModel <ZAFormOptionsViewControllerDelegate>

@property (strong, nonatomic) NSArray *selectorOptions;
@property (nonatomic) ZAFormTypeSelector typeSelector;

@property (copy, nonatomic) id(^didSelectBlock)(id value);

/// for ZAFormTypeSelectorModalCustomController
@property (assign, nonatomic) UIViewController *presenterController;
@property (nonatomic) Class optionsViewControllerClass;

@end
