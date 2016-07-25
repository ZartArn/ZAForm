//
//  ZAFormOptionsViewController.m
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormOptionsPushViewController.h"
#import "ZAFormRowSelector.h"
#import "ZAFormWithViewModelCell.h"

@interface ZAFormOptionsPushViewController ()

@end

@implementation ZAFormOptionsPushViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

    // add subview
    [self configureViews];
    
    // settings
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[self.formRow cellClass] forCellReuseIdentifier:@"Cell"];
    
    __block NSInteger selectedIndex = NSNotFound;
    [self.formRow.selectorOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == self.formRow.value) {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    if (selectedIndex != NSNotFound) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - create subviews

- (void)configureViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formRow.selectorOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZAFormWithViewModelCell *cell = (ZAFormWithViewModelCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id option = [self.formRow.selectorOptions objectAtIndex:indexPath.row];
    id viewModel = [self.formRow viewModelForValue:option];
    [cell updateWithViewModel:viewModel];
    cell.accessoryType = cell.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.formRow.title;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.formRow.cellHeight ?: 42.f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id option = [self.formRow.selectorOptions objectAtIndex:indexPath.row];
    [self _done:option];
}

#pragma mark - actions

- (void)_cancel:(id)sender {
    [self _back:nil];
}

- (void)_done:(id)sender {
    self.formRow.value = sender;
    if ([self.delegate performSelector:@selector(optionsViewControllerDone:) withObject:nil]) {
        [self.delegate optionsViewControllerDone:self];
    }
    [self _back:nil];
}

- (void)_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
