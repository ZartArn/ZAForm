//
//  InfoCell.h
//  TestForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormBaseCell.h"

@interface InfoCell : ZAFormBaseCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@interface InfoCellViewModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *valueString;

@end