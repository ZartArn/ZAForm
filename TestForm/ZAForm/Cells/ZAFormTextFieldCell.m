//
//  ZAFormTextFieldCell.m
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormTextFieldCell.h"
#import "ZAFormRow.h"
#import "ZAFormRowTextField.h"
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
    if (!self.formRow.editable) {
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    }
    [self update];

    // set warning color
    if ([self.formRow isKindOfClass:[ZAFormRowTextField class]]) {
        ZAFormRowTextField *row = (ZAFormRowTextField *)self.formRow;
        RAC(self.textField, textColor) = [row.warningSignal
            map:^id(NSNumber *value) {
                return value.boolValue ? [UIColor redColor] : [UIColor blackColor];
            }];
    }
}

- (void)update {
    self.titleLabel.text = self.formRow.title;
//    if (self.formRow.valueFormatter) {
//        self.textField.text = [self.formRow.valueFormatter stringForObjectValue:self.formRow.value];
//    } else {
//        self.textField.text = self.formRow.value;
//    }
}


@end
