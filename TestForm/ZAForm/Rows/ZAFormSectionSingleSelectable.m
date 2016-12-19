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
