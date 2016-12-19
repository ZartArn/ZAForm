//
//  ZAFormCellSegmented.h
//  Pods
//
//  Created by ZartArn on 15.12.16.
//
//

#import <ZAForm/ZAForm.h>

@interface ZAFormCellSegmented : ZAFormBaseCell

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

/// create and add in superview segmented control
- (void)createSC:(NSArray *)items;

/// for style segmentedcontrol
- (void)configureSC;

@end
