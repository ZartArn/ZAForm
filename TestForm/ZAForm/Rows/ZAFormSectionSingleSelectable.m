//
//  ZAFormSectionSingleSelectable.m
//  Pods
//
//  Created by ZartArn on 14.12.16.
//
//

#import "ZAFormSectionSingleSelectable.h"
#import "ZAFormRow.h"
#import "ZAFormTableManager.h"

@implementation ZAFormSectionSingleSelectable

- (void)didSelectRow:(ZAFormRow<ZAFormRowSelectableProtocol> *)row {
    
    NSMutableArray *updateItems = [NSMutableArray array];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"value != nil AND self != %@", row];
    NSArray *f = [self.rowItems filteredArrayUsingPredicate:p];
    for (ZAFormRow *wrongRow in f) {
        wrongRow.value = nil;
        [updateItems addObject:wrongRow];
    }
    
    if (_enableDeselection || row.value == nil) {
        row.value = (row.value == nil ? row.optionValue : nil);
        [updateItems addObject:row];
    }
    
    self.selectableRow = (row.value == nil ? nil : row);

    // update
    [self.form.tableView beginUpdates];
    for (ZAFormRow *r in updateItems) {
        [self.form upgradeRow:r];
    }
    [self.form.tableView endUpdates];
}

@end



@implementation ZAFormSectionMultipleSelectable

- (void)configure {
    [super configure];
    self.selectableRows = [NSArray array];
}

- (void)didSelectRow:(ZAFormRow<ZAFormRowSelectableProtocol> *)row {
    
    NSMutableArray *updateItems = [NSMutableArray array];
    BOOL rowSelected = (row.value != nil);

    if (_enableDeselection || row.value == nil) {
        row.value = (row.value == nil ? row.optionValue : nil);
        [updateItems addObject:row];
    }
    
    BOOL nowSelected = (row.value != nil);

    NSMutableArray *arr = [self.selectableRows mutableCopy];
    if (rowSelected && !nowSelected) {
        [arr removeObject:row];
    } else if (!rowSelected && nowSelected) {
        [arr addObject:row];
    }
    
    self.selectableRows = [arr copy];
    
    // update
    [self.form.tableView beginUpdates];
    for (ZAFormRow *r in updateItems) {
        [self.form upgradeRow:r];
    }
    [self.form.tableView endUpdates];
}

- (void)setZeroSelected {
    for (ZAFormRow *row in self.selectableRows) {
        row.value = nil;
    }
    NSArray *updateItems = [NSArray arrayWithArray:self.selectableRows];
    self.selectableRows = @[];
    
    // update
    [self.form.tableView beginUpdates];
    for (ZAFormRow *r in updateItems) {
        [self.form upgradeRow:r];
    }
    [self.form.tableView endUpdates];
}

- (void)setAllSelected {
    
    NSMutableArray *updateItems = [NSMutableArray array];
    
    for (ZAFormRow<ZAFormRowSelectableProtocol> *row in self.rowItems) {
        if (row.value == nil) {
            row.value = row.optionValue;
            [updateItems addObject:row];
        }
    }
    
    self.selectableRows = [NSArray arrayWithArray:self.rowItems];
    
    // update
    [self.form.tableView beginUpdates];
    for (ZAFormRow *r in updateItems) {
        [self.form upgradeRow:r];
    }
    [self.form.tableView endUpdates];
}

@end




@implementation ZAFormSectionMultiTagsSingleSelectable

- (void)configure {
    [super configure];
    self.selectableRows = [NSArray array];
}

- (void)didSelectRow:(ZAFormRow<ZAFormRowTagSelectableProtocol> *)row {
    
    NSMutableArray *updateItems = [NSMutableArray array];
    BOOL rowSelected = (row.value != nil);
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"value != nil AND tag == %@ AND self != %@", @(row.tag), row];
    NSArray *f = [self.rowItems filteredArrayUsingPredicate:p];
    for (ZAFormRow *wrongRow in f) {
        wrongRow.value = nil;
        [updateItems addObject:wrongRow];
    }
    
    if (_enableDeselection || row.value == nil) {
        row.value = (row.value == nil ? row.optionValue : nil);
        [updateItems addObject:row];
    }
    
    BOOL nowSelected = (row.value != nil);
    
    NSMutableArray *arr = [self.selectableRows mutableCopy];
    [arr removeObjectsInArray:f];
    
    if (rowSelected && !nowSelected) {
        [arr removeObject:row];
    } else if (!rowSelected && nowSelected) {
        [arr addObject:row];
    }
    
    self.selectableRows = [arr copy];
    
    // update
    [self.form.tableView beginUpdates];
    for (ZAFormRow *r in updateItems) {
        [self.form upgradeRow:r];
    }
    [self.form.tableView endUpdates];
}

@end
