//
//  ZAFormTextFieldCell.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormTextFieldCell.h"
#import <Masonry.h>

@implementation ZAFormTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    
    // text field
    self.textField = [[UITextField alloc] init];
    [self.contentView addSubview:_textField];

    // layouts
    [self configureLayouts];
}

- (void)configureLayouts {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_topMargin);
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.bottom.equalTo(self.textField.mas_top);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.bottom.equalTo(self.contentView.mas_bottomMargin);
    }];
}

@end
