//
//  ZAFormOptionsViewController.h
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZAFormRowSelector.h"

@class ZAFormRowSelector;

@protocol ZAFormOptionsViewControllerDelegate;

@interface ZAFormOptionsViewController : UIViewController

@property (assign, nonatomic) id<ZAFormOptionsViewControllerDelegate> delegate;
@property (assign, nonatomic) ZAFormRowSelector *formRow;

- (instancetype)initWithZAFormRrowSelector:(ZAFormRowSelector *)formRow;

@end


@protocol ZAFormOptionsViewControllerDelegate <NSObject>

- (void)optionsViewControllerDone:(ZAFormOptionsViewController *)optionsViewController;

@optional
- (id)optionsViewController:(ZAFormOptionsViewController *)optionsViewController didSelectValue:(id)value;

@end