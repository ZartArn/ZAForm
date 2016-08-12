//
//  ZAFormTableManager.m
//  ZartArn
//
//  Created by ZartArn on 06.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormTableManager.h"
#import "ZAFormSection.h"
#import "ZAFormRow.h"
#import "ZAFormRowSelector.h"
#import "ZAFormBaseCell.h"
#import "ZAFormBaseSectionCell.h"
#import "ZAFormTextFieldCell.h"

@implementation ZAFormTableManager

- (instancetype)initWithTableView:(UITableView *)tableView proxyDelegate:(id<UITableViewDelegate>)proxyDelegate {
    if (self = [super init]) {
        _tableView = tableView;
        _proxyTableDelegate = proxyDelegate;
        [self configure];
    }
    return self;
}

- (void)configure {
    self.sections = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark -

- (ZAFormSection *)createAndAddSection:(NSString *)title {
    ZAFormSection *section = [[ZAFormSection alloc] initWithTitle:title];
    [self addSection:section];
    return section;
}

- (void)addSection:(ZAFormSection *)sectionItem {
    [self.sections addObject:sectionItem];
}

- (void)addSections:(NSArray *)sectionsArray {
    [self.sections addObjectsFromArray:sectionsArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZAFormSection *sectionItem = [self.sections objectAtIndex:section];
    return [sectionItem.rowItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZAFormSection *sectionItem = [self.sections objectAtIndex:indexPath.section];
    ZAFormRow *rowItem = [sectionItem.rowItems objectAtIndex:indexPath.row];
    ZAFormBaseCell *cell = [rowItem cellForForm];
    if ([rowItem isKindOfClass:[ZAFormRowSelector class]]) {
        [cell updateWithViewModel:rowItem.viewModel];        
    } else {
        [cell update];
    }
    [cell layoutIfNeeded];
//    [cell needsUpdateConstraints];
    
    return cell;
}

#pragma mark - UITableViewDelegate SectionView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZAFormSection *sectionItem = [self.sections objectAtIndex:section];
    if (sectionItem.title) {
        ZAFormBaseSectionCell *headerView = [sectionItem sectionCellForForm];
        [headerView update];
        return (UIView *)headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.proxyTableDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.proxyTableDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZAFormSection *sectionItem = [self.sections objectAtIndex:section];
    if (!sectionItem.title) {
        return 0;
    }
    if (self.sectionHeight) {
        return self.sectionHeight.integerValue;
    }
    return 28.f;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    ZAFormSection *sectionItem = [self.sections objectAtIndex:section];
//    return sectionItem.title;
//}


#pragma mark - UITableViewDelegate Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // row height set same in form
    if (self.rowHeight) {
        return self.rowHeight.integerValue;
    }
    ZAFormSection *sectionItem = [self.sections objectAtIndex:indexPath.section];
    ZAFormRow *rowItem = [sectionItem.rowItems objectAtIndex:indexPath.row];
    // row height set fix in row
    if (rowItem.cellHeight) {
        return rowItem.cellHeight;
    }
    // row height calculated
    if ([rowItem.cellClass isSubclassOfClass:[ZAFormBaseCell class]]) {
        return [[rowItem.cellClass prefferedHeightForViewModel:rowItem.viewModel forWidth:@(self.tableView.bounds.size.width)] doubleValue];
    }
    return 42.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZAFormSection *sectionItem = [self.sections objectAtIndex:indexPath.section];
    ZAFormRow *rowItem = [sectionItem.rowItems objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // textfield
    if ([[rowItem cellForForm] isKindOfClass:[ZAFormTextFieldCell class]]) {
        ZAFormTextFieldCell *cell = (ZAFormTextFieldCell *)[rowItem cellForForm];
        if (![cell.textField isFirstResponder]) {
            [cell.textField becomeFirstResponder];
        }
        return;
    }
    
    // select options
    if ([rowItem isKindOfClass:[ZAFormRowSelector class]]) {
        ZAFormRowSelector *rowItemSelector = (ZAFormRowSelector *)rowItem;
        
        if (rowItemSelector.typeSelector == ZAFormTypeSelectorModalCustomController && (rowItemSelector.selectorOptions.count > 0)) {
            ZAFormOptionsViewController *vc = [(ZAFormOptionsViewController *)[rowItemSelector.optionsViewControllerClass alloc] initWithZAFormRrowSelector:rowItemSelector];
            vc.delegate = rowItemSelector;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            self.presenterViewController.providesPresentationContextTransitionStyle = YES;
            self.presenterViewController.definesPresentationContext = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.presenterViewController presentViewController:vc animated:YES completion:nil];
            });
            return;
        }
        
        if (rowItemSelector.typeSelector == ZAFormTypeSelectorPush && (rowItemSelector.selectorOptions.count > 0)) {
            ZAFormOptionsViewController *vc = [(ZAFormOptionsViewController *)[rowItemSelector.optionsViewControllerClass alloc] initWithZAFormRrowSelector:rowItemSelector];
            vc.delegate = rowItemSelector;
            [rowItemSelector.presenterController.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

#pragma mark - proxy UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.proxyTableDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.proxyTableDelegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark -

- (void)upgradeRow:(ZAFormRow *)row {
//    [self.tableView beginUpdates];
    [row updateCell];
//    [self.tableView endUpdates];
}

- (void)reset {
    [self.sections removeAllObjects];
    [self.tableView reloadData];
}

@end
