//
//  ZAFormPickerCell.m
//  ZAForm
//
//  Created by ZartArn on 24.05.2018.
//

#import "ZAFormPickerCell.h"
#import "ZAFormRow.h"
#import <Masonry/Masonry.h>

@implementation ZAFormPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    self.pickerView = [[UIPickerView alloc] init];
    [self.contentView addSubview:_pickerView];
    
    // --
    [self configureLayouts];
}

- (void)configureLayouts {
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5.f);
        make.bottom.equalTo(@-5.f);
        make.centerX.equalTo(@0);
    }];
}

#pragma mark -

// configure
- (void)update {
    if (self.formRow.value) {
    } else {
    }
}

@end
