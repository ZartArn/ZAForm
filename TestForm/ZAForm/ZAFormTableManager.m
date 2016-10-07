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
#import <ReactiveCocoa.h>

@interface ZAFormTableManager()

@property (strong, nonatomic) NSArray *allRows;
@property (strong, nonatomic) UIBarButtonItem *prevBBtn;
@property (strong, nonatomic) UIBarButtonItem *nextBBtn;

@end

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
    
    [self createAccessoryView];
}

#pragma mark -

- (ZAFormSection *)createAndAddSection:(NSString *)title {
    ZAFormSection *section = [[ZAFormSection alloc] initWithTitle:title];
    [self addSection:section];
    return section;
}

- (void)addSection:(ZAFormSection *)sectionItem {
    sectionItem.form = self;
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
        if (![cell.textField isFirstResponder] && [rowItem canBeFirstResponder]) {
            [cell.textField becomeFirstResponder];
        }
        return;
    }
    
    // did select block
    if (rowItem.didSelectBlock) {
        rowItem.didSelectBlock(rowItem, indexPath);
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
            return;
        }
        
        if (rowItemSelector.typeSelector == ZAFormTypeSelectorAlert && (rowItemSelector.selectorOptions.count > 1)) {
            [self showAlertOptions:rowItemSelector];
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

- (void)reloadForm {
    [self.tableView reloadData];
}

- (void)upgradeRow:(ZAFormRow *)row {
//    [self.tableView beginUpdates];
    [row updateCell];
//    [self.tableView endUpdates];
}

- (void)reset {
    [self.sections removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - insert\remove

- (void)addRow:(ZAFormRow *)newRow afterRow:(ZAFormRow *)afterRow animation:(BOOL)animation {
    NSIndexPath *indexPath = [self pathForRow:afterRow];
    
    [self.tableView beginUpdates];
    ZAFormSection *section = [self.sections objectAtIndex:indexPath.section];
    [section.rowItems insertObject:newRow atIndex:(indexPath.row + 1)];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

- (void)removeRow:(ZAFormRow *)oldRow animation:(BOOL)animation {
    NSIndexPath *indexPath = [self pathForRow:oldRow];
    if (!indexPath) {
        return;
    }
    
    [self.tableView beginUpdates];
    ZAFormSection *section = [self.sections objectAtIndex:indexPath.section];
    [section.rowItems removeObject:oldRow];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

#pragma mark - Accessory View

- (void)createAccessoryView {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:(CGRect){0.f, 0.f, 320.f, 44.f}];

    UIBarButtonItem *bbPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleDone target:self action:@selector(_prevInput:)];

    UIBarButtonItem *bbNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(_nextInput:)];
    
    UIBarButtonItem *bbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[bbPrev, bbSpace, bbNext];
    self.prevBBtn = bbPrev;
    self.nextBBtn = bbNext;
    
    self.accessoryView = toolBar;
}

- (void)scrollToRowIfNeeded:(ZAFormRow *)row {
    NSIndexPath *indexPath = [self pathForRow:row];
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSSet *visibleSet = [NSSet setWithArray:visiblePaths];
    
    if (![visibleSet containsObject:indexPath]) {
//        [self.tableView rectForRowAtIndexPath:indexPath];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [row becomeFirstResponder];
        });
    } else {
        [row becomeFirstResponder];
    }
}

- (void)_prevInput:(id)sender {
    
    ZAFormRow *currentRow = [self findCurrentResponder];
    if (!currentRow) {
        return;
    }
    
    
    NSInteger currentRowIdx = [self.allRows indexOfObject:currentRow];
    if (currentRowIdx == NSNotFound) {
        return;
    }
    
    if (self.allRows.count == 0) {
        [currentRow resignFirstResponder];
        return;
    }
    
    NSInteger prevRowIdx = NSNotFound;
    for (NSInteger i = currentRowIdx - 1; i >= 0; i--) {
        ZAFormRow *prevRow = self.allRows[i];
        if ([prevRow canBeFirstResponder]) {
            prevRowIdx = i;
            break;
        }
    }
    
    if (prevRowIdx == NSNotFound) {
        [currentRow resignFirstResponder];
        return;
    }
    
    ZAFormRow *nextRow = self.allRows[prevRowIdx];
    [self scrollToRowIfNeeded:nextRow];
//    [nextRow becomeFirstResponder];
}

- (void)_nextInput:(id)sender {
    
    ZAFormRow *currentRow = [self findCurrentResponder];
    if (!currentRow) {
        return;
    }
    
    NSInteger currentRowIdx = [self.allRows indexOfObject:currentRow];
    if (currentRowIdx == NSNotFound) {
        return;
    }
    
    if (self.allRows.count == 0) {
        [currentRow resignFirstResponder];
        return;
    }
    
    NSInteger nextRowIdx = NSNotFound;
    for (NSInteger i = currentRowIdx + 1; i < self.allRows.count; i++) {
        ZAFormRow *nextRow = self.allRows[i];
        if ([nextRow canBeFirstResponder]) {
            nextRowIdx = i;
            break;
        }
    }
    
    if (nextRowIdx == NSNotFound) {
        [currentRow resignFirstResponder];
        return;
    }
    
    ZAFormRow *nextRow = self.allRows[nextRowIdx];
    [self scrollToRowIfNeeded:nextRow];
//    [nextRow becomeFirstResponder];
}

- (ZAFormRow *)findCurrentResponder {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"isFirstResponder = %@", @YES];
    ZAFormRow *row = [self.allRows filteredArrayUsingPredicate:p].firstObject;
    return row;
}

- (NSIndexPath *)pathForRow:(ZAFormRow *)row {
    __block NSIndexPath *indexPath = nil;
    [self.sections enumerateObjectsUsingBlock:^(ZAFormSection *section, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger jdx = NSNotFound;
        jdx = [section.rowItems indexOfObject:row];
        if (jdx != NSNotFound) {
            indexPath = [NSIndexPath indexPathForRow:jdx inSection:idx];
            *stop = YES;
        }
    }];
    return indexPath;
}

// do next
- (void)nextInput {
    return [self _nextInput:nil];
}

// check
- (BOOL)checkPreviousResponderFor:(ZAFormRow *)row {
    NSInteger currentRowIdx = [self.allRows indexOfObject:row];
    if (currentRowIdx == NSNotFound) {
        return NO;
    }
    NSInteger nextRowIdx = NSNotFound;
    for (NSInteger i = currentRowIdx - 1; i >= 0; i--) {
        ZAFormRow *nextRow = self.allRows[i];
        if ([nextRow canBeFirstResponder]) {
            nextRowIdx = i;
            break;
        }
    }
    return (nextRowIdx != NSNotFound);
}

- (BOOL)checkNextResponderFor:(ZAFormRow *)row {
    NSInteger currentRowIdx = [self.allRows indexOfObject:row];
    if (currentRowIdx == NSNotFound) {
        return NO;
    }
    NSInteger nextRowIdx = NSNotFound;
    for (NSInteger i = currentRowIdx + 1; i < self.allRows.count; i++) {
        ZAFormRow *nextRow = self.allRows[i];
        if ([nextRow canBeFirstResponder]) {
            nextRowIdx = i;
            break;
        }
    }
    return (nextRowIdx != NSNotFound);
}

// update accessory view
- (void)updateAccessoryView:(ZAFormRow *)row {
    self.prevBBtn.enabled = [self checkPreviousResponderFor:row];
    self.nextBBtn.enabled = [self checkNextResponderFor:row];
}

#pragma mark - alert options

- (void)showAlertOptions:(ZAFormRowSelector *)rowSelector {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    if (rowSelector.tintColor) {
        alert.view.tintColor = rowSelector.tintColor;
    }
    
    [rowSelector.selectorOptions enumerateObjectsUsingBlock:^(id option, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = nil;
        if (rowSelector.valueFormatter) {
            title = [rowSelector.valueFormatter stringForObjectValue:option];
        } else if ([option isKindOfClass:[NSString class]]) {
            title = option;
        } else if ([option isKindOfClass:[NSNumber class]]) {
            title = [option stringValue];
        } else {
            title = [@(idx) stringValue];
        }
        
        UIAlertAction *rowAction = [UIAlertAction actionWithTitle:title
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              rowSelector.value = option;
                                                              [rowSelector optionsViewControllerDone:nil];
                                                          }];
        [alert addAction:rowAction];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    UIViewController *presenter = rowSelector.presenterController;
    
    UIPopoverPresentationController *popup = alert.popoverPresentationController;
    if (popup) {
        popup.sourceView = presenter.view;
        popup.sourceRect = (CGRect){presenter.view.center, {0.f, 0.f}};
        popup.permittedArrowDirections = 0;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [presenter presentViewController:alert animated:YES completion:^{
            if (rowSelector.tintColor) {
                alert.view.tintColor = rowSelector.tintColor;
            }
        }];
    });
}

#pragma mark - lazy

- (NSArray *)allRows {
    if (!_allRows) {
        _allRows = [self.sections.rac_sequence
                            flattenMap:^RACStream *(ZAFormSection *value) {
                                return value.rowItems.rac_sequence;
                            }].array;
    }
    return _allRows;
}

@end
