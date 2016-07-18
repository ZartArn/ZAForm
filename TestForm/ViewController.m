//
//  ViewController.m
//  TestForm
//
//  Created by ZartArn on 07.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ViewController.h"
#import "ZAFormTableManager.h"
#import "ZAFormSection.h"
#import "ZAFormRow.h"
#import "ZAFormRowAmount.h"
//#import "ZAFormRowCustom.h"
#import "ZAFormRowSelector.h"
#import "ZAFormBaseCell.h"
#import "ZAFormAmountCell.h"
//#import "ZAFormCustomCell.h"
#import "ZAFormOptionsModalViewController.h"

#import "InfoCell.h"
#import "AccNumberFormatter.h"
#import "MoneyNumberFormatter.h"

#import "TestObject.h"

#import <ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ZAFormTableManager *formManager;

@property (strong, nonatomic) NSFormatter *currencyFormatter;
@property (strong, nonatomic) ZAFormRow *row1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.f;
    
    MoneyNumberFormatter *mf = [[MoneyNumberFormatter alloc] init];
    NSString *aString = @"102856.01";
    NSNumber *money = [mf numberFromString:aString];
    NSLog(@"%@", money);
    
    [self createForm];
    
    // binding
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"Update" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    btn.frame = (CGRect){0.f, 0.f, 150.f, 40.f};
    btn.center = (CGPoint){self.view.center.x, self.view.bounds.size.height - 100.f};
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            static NSInteger i = 0;
            ZAFormBaseCellViewModel *vm1 = [ZAFormBaseCellViewModel new];
            vm1.title = [NSString stringWithFormat:@"ZZZ %@", @(i++)];
            self.row1.viewModel = vm1;
            [self.formManager upgradeRow:self.row1];
        }];
    
}

- (void)createForm {
    self.formManager = [[ZAFormTableManager alloc] initWithTableView:self.tableView proxyDelegate:nil];
    _formManager.presenterViewController = self;
    
    TestObject *object1 = [TestObject new];
    object1.title = @"1. Title";
    object1.subTitle = @"Subtitle";
    
    TestObject *object2 = [TestObject new];
    object2.title = @"2. Title";
    object2.subTitle = @"Subtitle";
    
    // --
    
    ZAFormSection *section = [self.formManager createAndAddSection:@"Common"];
    
    ZAFormRowSelector *row1 = [[ZAFormRowSelector alloc] initWithTitle:@"Selector" value:object1];
    row1.selectorOptions = @[object1, object2];
    row1.typeSelector = ZAFormTypeSelectorModalCustomController;
//    [row1 registerClassForCell:[ZAFormCustomCell class]];
//    row1.cellHeight = 60.f;
    row1.presenterController = self;
    row1.optionsViewControllerClass = [ZAFormOptionsModalViewController class];
    
    
    ZAFormRow *row2 = [[ZAFormRow alloc] initWithTitle:@"Name" value:@"LNS" cellClass:[InfoCell class]];
    row2.cellHeight = 60.f;

    ZAFormRow *row21 = [[ZAFormRow alloc] initWithTitle:@"Date" value:[NSDate date] cellClass:[InfoCell class]];
    row21.cellHeight = 60.f;
    row21.valueFormatter = [self dateFormatter];
    
    ZAFormRow *row22 = [[ZAFormRow alloc] initWithTitle:@"CCC" value:@"20310A98100000000178" cellClass:[InfoCell class]];
    row22.cellHeight = 60.f;
    AccNumberFormatter *f = [AccNumberFormatter new];
    f.mask = @"#### #### #### #### ####";
    row22.valueFormatter = f;
    
    ZAFormRow *row23 = [[ZAFormRow alloc] initWithTitle:@"Name" value:@(145.67) cellClass:[InfoCell class]];
    row23.cellHeight = 60.f;
    
    
    ZAFormRowAmount *row3 = [[ZAFormRowAmount alloc] initWithTitle:@"Amount Row" value:@(500)];
    row3.cellHeight = 60;
    
    [section addRows:@[
                       row1,
                       row2,
                       row21,
                       row22,
                       row23,
                       row3
                       ]];
    
    // binding
    
    [RACObserve(row3, value) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *df = nil;
    
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"dd.MM.YYYY HH:mm:ss";
    }
    
    return df;
}

@end
