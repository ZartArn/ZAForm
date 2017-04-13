//
//  ZAFormRow.m
//  ZartArn
//
//  Created by ZartArn on 06.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"
#import "ZAFormBaseCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ZAFormRow

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title value:nil cellClass:nil];
}

- (instancetype)initWithValue:(id)value {
    return [self initWithTitle:nil value:value cellClass:nil];
}

- (instancetype)initWithValue:(id)value cellClass:(Class)cellClass {
    return [self initWithTitle:nil value:value cellClass:cellClass];
}

- (instancetype)initWithTitle:(NSString *)title cellClass:(Class)cellClass {
    return [self initWithTitle:title value:nil cellClass:cellClass];
}

- (instancetype)initWithTitle:(NSString *)title value:(id)value {
    return [self initWithTitle:title value:value cellClass:nil];
}

- (instancetype)initWithTitle:(NSString *)title value:(id)value cellClass:(Class)cellClass {
    if (self = [super init]) {
        _title = title;
        _value = value;
        _cellClass = cellClass;
        [self configureRow];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configureRow];
    }
    return self;
}

- (void)configureRow {
    _editable = YES;
}

#pragma mark - lazy

- (id)viewModel {
    if (!_viewModel) {
        ZAFormTitleValueViewModel *viewModel = [ZAFormTitleValueViewModel new];
        viewModel.title = self.title;
        viewModel.value = [self.value isKindOfClass:[NSString class]] ? self.value : nil;
        _viewModel = viewModel;
    }
    return _viewModel;
}

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormBaseCell class];
}

- (void)registerClassForCell:(Class)cellClass {
    _cellClass = cellClass;
}

- (ZAFormBaseCell *)cellForForm {
    if (!_cell) {
        if (!_cellClass) {
            _cellClass = [[self class] defaultCellClass];
        }
        _cell = (ZAFormBaseCell *)[[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _cell.formRow = self;
        [_cell configure];
        [self configureCell:_cell];
        RAC(self.cell, userInteractionEnabled) = RACObserve(self, editable);
        _cell.userInteractionEnabled = self.editable;
    }
    return _cell;
}

- (void)configureCell:(ZAFormBaseCell *)cell {
//    NSLog(@"%@ :: %@", _cell, cell);
}

- (void)updateCell {
    [self.cell update];
//    [self.cell updateWithViewModel:self.viewModel];
}

- (void)clearCell {
    self.cell = nil;
}

- (void)didSelect:(NSIndexPath *)indexPath {
    if (self.didSelectBlock) {
        self.didSelectBlock(self, indexPath);
        return;
    }
}

#pragma mark -

- (BOOL)canBeFirstResponder {
    return NO;
}

- (BOOL)isFirstResponder {
    return NO;
}

- (BOOL)becomeFirstResponder {
    
}

- (void)resignFirstResponder {
    
}

@end
