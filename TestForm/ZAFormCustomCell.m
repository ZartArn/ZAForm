//
//  ZAFormCustomCell.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormCustomCell.h"
#import "ZAFormRowCustom.h"
#import <Masonry.h>

@implementation ZAFormCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor purpleColor];
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    
    // subtitle
    self.subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:12.f];
    _subtitleLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.f];
    [self.contentView addSubview:_subtitleLabel];
    
    // layouts
    [self configureLayouts];
}

- (void)configureLayouts {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_topMargin);
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.bottom.equalTo(self.subtitleLabel.mas_top);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.bottom.equalTo(self.contentView.mas_bottomMargin);
    }];
}

#pragma mark -

- (void)updateWithViewModel:(id<ZAFormCustomCellViewModelProtocol>)viewModel {
    self.titleLabel.text = viewModel.title;
    self.subtitleLabel.text = viewModel.subTitle;
}

- (void)update {
    id<ZAFormCustomCellViewModelProtocol> viewModel = (id<ZAFormCustomCellViewModelProtocol>)[(ZAFormRowCustom *)self.formRow viewModelForValue];
    [self updateWithViewModel:viewModel];
}

@end
