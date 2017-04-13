//
//  ZAFormCellSegmented.m
//  Pods
//
//  Created by ZartArn on 15.12.16.
//
//

#import "ZAFormCellSegmented.h"
#import <Masonry/Masonry.h>

@implementation ZAFormCellSegmented

- (void)createSC:(NSArray *)items {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [self.contentView addSubview:_segmentedControl];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}

- (void)configureSC {
    
}

@end
