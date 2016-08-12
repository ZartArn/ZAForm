//
//  ZAFormBaseSectionCell.m
//  Pods
//
//  Created by ZartArn on 08.08.16.
//
//

#import "ZAFormBaseSectionCell.h"
#import "ZAFormSection.h"

@implementation ZAFormBaseSectionCell

- (void)configure {
}

- (void)update {
    self.textLabel.text = self.formSection.title;
}

- (void)updateWithViewModel:(id)viewModel {
}

@end
