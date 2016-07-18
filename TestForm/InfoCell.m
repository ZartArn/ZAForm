//
//  InfoCell.m
//  TestForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "InfoCell.h"
#import "ZAFormRow.h"
#import <Masonry.h>

@implementation InfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

#pragma mark -

- (void)update {
    self.titleLabel.text = self.formRow.title;
    if (self.formRow.valueFormatter) {
        self.valueLabel.text = [self.formRow.valueFormatter stringForObjectValue:self.formRow.value];
    } else if ([self.formRow.value isKindOfClass:[NSNumber class]]) {
        self.valueLabel.text = [self.formRow.value stringValue];
    } else if ([self.formRow.value isKindOfClass:[NSString class]]) {
        self.valueLabel.text= self.formRow.value;
    } else {
        self.valueLabel.text = nil;
    }
}

#pragma mark -

- (void)configureViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:12.f];
    _titleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    _valueLabel.font = [UIFont systemFontOfSize:14.f];
    _valueLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_valueLabel];
    
    // layouts
    [self configureLayouts];
}

- (void)configureLayouts {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.top.equalTo(self.contentView.mas_topMargin);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leadingMargin);
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
//        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottomMargin);
    }];
}

@end


@implementation InfoCellViewModel

@end