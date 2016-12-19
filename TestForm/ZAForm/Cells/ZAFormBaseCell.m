//
//  ZAFormBaseCell.m
// ZAForm
//
//  Created by ZartArn on 07.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormBaseCell.h"
#import "ZAFormRow.h"

@implementation ZAFormBaseCell

- (void)configure {
//    [self update];
}

- (void)update {
    self.textLabel.text = self.formRow.title;
//    [self needsUpdateConstraints];
}

- (void)updateWithViewModel:(id)viewModel {
    ZAFormBaseCellViewModel *vm = (ZAFormBaseCellViewModel *)viewModel;
    self.textLabel.text = vm.title;
    self.imageView.image = vm.imageName ? [UIImage imageNamed:vm.imageName] : nil;
}

#pragma mark - auto height

+ (NSNumber *)prefferedHeightForViewModel:(id)viewModel forWidth:(NSNumber *)width {
    return nil; // @42.f;
}

#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation ZAFormBaseCellViewModel


@end

@implementation ZAFormTitleValueViewModel


@end
