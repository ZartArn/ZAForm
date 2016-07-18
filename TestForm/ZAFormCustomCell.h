//
//  ZAFormCustomCell.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormBaseCell.h"

@interface ZAFormCustomCell : ZAFormBaseCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end


@protocol ZAFormCustomCellViewModelProtocol <NSObject>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;

@end