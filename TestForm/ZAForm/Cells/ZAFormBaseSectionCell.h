//
//  ZAFormBaseSectionCell.h
//  Pods
//
//  Created by ZartArn on 08.08.16.
//
//

#import <UIKit/UIKit.h>

@class ZAFormSection;

@interface ZAFormBaseSectionCell : UITableViewHeaderFooterView

@property (assign, nonatomic) ZAFormSection *formSection;

/// config on create
- (void)configure;

/// update
- (void)update;

/// update data
- (void)updateWithViewModel:(id)viewModel;

@end
