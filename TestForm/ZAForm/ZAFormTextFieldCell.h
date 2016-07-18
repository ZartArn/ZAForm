//
//  ZAFormTextFieldCell.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormBaseCell.h"

@interface ZAFormTextFieldCell : ZAFormBaseCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textField;

@end


@protocol ZAFormTextFieldCellViewModel <NSObject>

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) id value;

@end