//
//  ZAFormOptionsViewController.m
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormOptionsViewController.h"

@interface ZAFormOptionsViewController ()

@end

@implementation ZAFormOptionsViewController

- (instancetype)initWithZAFormRrowSelector:(ZAFormRowSelector *)formRow {
    if (self = [super init]) {
        _formRow = formRow;
    }
    return self;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
