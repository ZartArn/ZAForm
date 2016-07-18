//
//  ZAFormOptionsModalViewController.h
// ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormOptionsViewController.h"
#import "ZAFormRowSelector.h"

@interface ZAFormOptionsModalViewController : ZAFormOptionsViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;


@end
