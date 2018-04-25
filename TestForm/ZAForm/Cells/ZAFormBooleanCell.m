//
//  ZAFormBooleanCell.m
//  Pods
//
//  Created by ZartArn on 17.08.16.
//
//

#import "ZAFormBooleanCell.h"
#import "ZAFormRow.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ZAFormBooleanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

- (void)configure {
    RACChannelTerminal *t1 = [self.valueSwitch rac_newOnChannel];
    RACChannelTerminal *t2 = RACChannelTo(self.formRow, value, @NO);
    [t2 subscribe:t1];
    [t1 subscribe:t2];
}

- (void)update {
    self.titleLabel.text = self.formRow.title;
}

#pragma mark -

- (void)configureViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.f];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisHorizontal];
    [_valueSwitch setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    [_valueSwitch setContentCompressionResistancePriority:900 forAxis:UILayoutConstraintAxisHorizontal];
    
    self.valueSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_valueSwitch];
    
    // layouts
    [self configureLayouts];
}

- (void)configureLayouts {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.valueSwitch.mas_leading);
        make.top.bottom.equalTo(@0);
    }];
    
    [self.valueSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailingMargin).offset(5.f);
        make.width.equalTo(@60);
        make.centerY.equalTo(@0);
    }];
}

@end
