//
//  ZAFormSection.m
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormSection.h"
#import "ZAFormRow.h"
#import "ZAFormBaseSectionCell.h"

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
    rowItem.form = self.form;
    rowItem.section = self;
    [self.rowItems addObject:rowItem];
}

- (void)addRows:(NSArray *)rowsArray {
//    [self.rowItems addObjectsFromArray:rowsArray];
    for (ZAFormRow *row in rowsArray) {
        [self addRow:row];
    }
}

// override in subclass
- (void)didSelectRow:(ZAFormRow *)row {
    
}

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormBaseSectionCell class];
}

- (ZAFormBaseSectionCell *)sectionCellForForm {
    if (!_sectionCell) {
        if (!_sectionCellClass) {
            _sectionCellClass = [[self class] defaultCellClass];
        }
        _sectionCell = [[_sectionCellClass alloc] initWithReuseIdentifier:nil];
        _sectionCell.formSection = self;
        [_sectionCell configure];
    }
    return _sectionCell;
}


@end
