//
//  ZAFormSection.m
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormSection.h"
#import "ZAFormRow.h"

@implementation ZAFormSection

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
        [self configure];
    }
    return self;
}

- (void)configure {
    self.rowItems = [NSMutableArray array];
}

- (void)addRow:(ZAFormRow *)rowItem {
    [self.rowItems addObject:rowItem];
}

- (void)addRows:(NSArray *)rowsArray {
    [self.rowItems addObjectsFromArray:rowsArray];
}

@end
