//
//  ZAFormBaseCell.h
// ZAForm
//
//  Created by ZartArn on 07.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZAFormRow;

@interface ZAFormBaseCell : UITableViewCell

@property (assign, nonatomic) ZAFormRow *formRow;

/// config on create
- (void)configure;

/// update
- (void)update;

/// update data
- (void)updateWithViewModel:(id)viewModel;

@end




@interface ZAFormBaseCellViewModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *imageName;

@end