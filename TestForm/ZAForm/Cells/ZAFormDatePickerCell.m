//
//  ZAFormDatePickerCell.m
//  Pods
//
//  Created by ZartArn on 27.12.16.
//
//

#import "ZAFormDatePickerCell.h"
#import <Masonry/Masonry.h>

@implementation ZAFormDatePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    
    self.datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.date = [NSDate date];
    
    [self.contentView addSubview:_datePicker];
    
    // --
    [self configureLayouts];
}

- (void)configureLayouts {
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5.f);
        make.bottom.equalTo(@-5.f);
        make.centerX.equalTo(@0);
    }];
}

#pragma mark -

// configure
- (void)update {
    if (self.formRow.value) {
        self.datePicker.date = self.formRow.value;
    } else {
        self.datePicker.date = [NSDate date];
    }
}

@end
