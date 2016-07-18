//
//  ZAFormOptionsModalViewController.m
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormOptionsModalViewController.h"
#import "ZAFormWithViewModelCell.h"
#import <Masonry.h>

@interface ZAFormOptionsModalViewController ()

@property (strong, nonatomic) UIControl *backControl;
@property (nonatomic) CGSize currentSize;

@end

@implementation ZAFormOptionsModalViewController

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
    
    [self.backControl addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchDown];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    if (!CGSizeEqualToSize(_currentSize, self.view.bounds.size)) {
    
        NSLog(@"ReDraw");
        _currentSize = self.view.bounds.size;
        
        CGFloat th = self.tableView.bounds.size.height;
        CGFloat ts = self.tableView.contentSize.height;
        
        if (ts < th) {
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.bottom.equalTo(@0);
                make.height.equalTo(@(ts));
            }];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [UIView animateWithDuration:0.1f animations:^{
//        self.backControl.alpha = 1.f;
//    }];
}

#pragma mark - create subviews

- (void)configureViews {
    
    self.backControl = [UIControl new];
    _backControl.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
//    _backControl.alpha = 0.f;
    [self.view addSubview:_backControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [self.backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(self.view.mas_height).multipliedBy(.6f);
    }];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.formRow.title;
}

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
