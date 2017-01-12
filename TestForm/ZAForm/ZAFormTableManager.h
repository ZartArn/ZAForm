//
//  ZAFormTableManager.h
//  ZartArn
//
//  Created by ZartArn on 06.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZAFormSection, ZAFormRow;

@interface ZAFormTableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

/// tableView for managing
@property (assign, nonatomic) UITableView *tableView;

/// proxy delegate UITableViewDelegate
@property (assign, nonatomic) id<UITableViewDelegate> proxyTableDelegate;

/// accessoryView
@property (strong, nonatomic) UIView *accessoryView;

/// viewController for presenting
@property (assign, nonatomic) UIViewController *presenterViewController;

/// items array
@property (strong, nonatomic) NSMutableArray *sections;

/// section header height
@property (nonatomic) NSNumber *sectionHeight;

/// row height
@property (nonatomic) NSNumber *rowHeight;

/// initialize
- (instancetype)initWithTableView:(UITableView *)tableView proxyDelegate:(id<UITableViewDelegate>)proxyDelegate;

/// add Section Item
- (ZAFormSection *)createAndAddSection:(NSString *)title;
- (void)addSection:(ZAFormSection *)sectionItem;
- (void)addSections:(NSArray *)sectionsArray;

/// reload form
- (void)reloadForm;

/// update Row Item
- (void)upgradeRow:(ZAFormRow *)row;

/// reload Row Item
- (void)reloadRow:(ZAFormRow *)row;

/// reload rows
- (void)reloadRows:(NSArray *)rows;

/// lazy all rows
- (NSArray *)allRows;

/// reset
- (void)reset;

/// next input
- (void)nextInput;

/// checkPreviousResponder
- (BOOL)checkPreviousResponderFor:(ZAFormRow *)row;

/// checkNextResponder
- (BOOL)checkNextResponderFor:(ZAFormRow *)row;

/// update accessoryView when new row begin editing
- (void)updateAccessoryView:(ZAFormRow *)row;

/// insert row
- (void)addRow:(ZAFormRow *)newRow afterRow:(ZAFormRow *)afterRow animation:(BOOL)animation;

/// insert row first in section
- (void)insertRow:(ZAFormRow *)newRow inSection:(ZAFormSection *)section animation:(BOOL)animation;

/// delete row
- (void)removeRow:(ZAFormRow *)oldRow animation:(BOOL)animation;

@end
