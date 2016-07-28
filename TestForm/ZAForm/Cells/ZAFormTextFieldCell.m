//
//  ZAFormTextFieldCell.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormTextFieldCell.h"
#import "ZAFormRow.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

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

#pragma mark -

- (void)configure {
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    [self update];

    @weakify(self);
    RAC(self.formRow, value) = [RACObserve(self.textField, text)
                                map:^id(NSString *text) {
                                    @strongify(self);
                                    id objectValue = nil;
                                    BOOL res = [self.formRow.valueFormatter getObjectValue:&objectValue forString:text errorDescription:nil];
                                    return (res ? objectValue : nil);
                                }];
}

- (void)update {
    self.titleLabel.text = self.formRow.title;
    self.textField.text = [self.formRow.valueFormatter stringForObjectValue:self.formRow.value];
}

@end
