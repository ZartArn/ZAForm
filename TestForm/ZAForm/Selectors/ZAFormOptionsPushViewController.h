//
//  ZAFormOptionsPushViewController.h
//  ZAForm
//
//  Created by ZartArn on 10.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAFormOptionsViewController.h"

@interface ZAFormOptionsPushViewController : ZAFormOptionsViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end
