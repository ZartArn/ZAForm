//
//  ZAFormTextViewCell.m
//  Pods
//
//  Created by ZartArn on 26.09.16.
//
//

#import "ZAFormTextViewCell.h"
#import "ZAFormRow.h"

@implementation ZAFormTextViewCell

- (void)update {
    self.titleLabel.text = self.formRow.title;
}

@end
