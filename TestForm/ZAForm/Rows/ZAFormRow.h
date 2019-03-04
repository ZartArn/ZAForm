//
//  ZAFormRow.h
//  ZartArn
//
//  Created by ZartArn on 06.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZAFormTableManager, ZAFormSection, ZAFormBaseCell;

@interface ZAFormRow : NSObject {
    ZAFormBaseCell *_cell;
}

@property (assign, nonatomic) ZAFormTableManager *form;

@property (assign, nonatomic) ZAFormSection *section;

/// cell
@property (nonatomic) Class cellClass;
@property (strong, nonatomic) ZAFormBaseCell *cell;
@property (nonatomic) CGFloat cellHeight;

/// title
@property (copy, nonatomic) NSString *title;

/// value
@property (strong, nonatomic) id value;

/// editable
@property (nonatomic) BOOL editable;

/// required
@property (nonatomic) BOOL required;

/// viewModel
@property (strong, nonatomic) id viewModel;

/// formatter
@property (strong, nonatomic) NSFormatter *valueFormatter;

/// initialize
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title cellClass:(Class)cellClass;
- (instancetype)initWithValue:(id)value;
- (instancetype)initWithValue:(id)value cellClass:(Class)cellClass;
- (instancetype)initWithTitle:(NSString *)title value:(id)value;
- (instancetype)initWithTitle:(NSString *)title value:(id)value cellClass:(Class)cellClass;

/// select cell block
@property (copy, nonatomic) void(^didSelectBlock)(ZAFormRow *row, NSIndexPath *indexPath);

/// did row configureCell block. call before [self.cell configure]
@property (copy, nonatomic) void(^willRowConfigureCellBlock)(ZAFormRow *row);

/// did row configureCell block. call after [self.cell configure]
@property (copy, nonatomic) void(^didRowConfigureCellBlock)(ZAFormRow *row);

/// register cell
- (void)registerClassForCell:(Class)cellClass;

/// default cell class
+ (Class)defaultCellClass;

/// cell
- (ZAFormBaseCell *)cellForForm;

/// cell reload
- (void)updateCell;

/// for override
- (void)configureRow;

/// for override
- (void)configureCell:(ZAFormBaseCell *)cell;

/// on select cell
- (void)didSelect:(NSIndexPath *)indexPath;

/// clear cell
- (void)clearCell;

/// can be first responder
- (BOOL)canBeFirstResponder;

/// is first responder
- (BOOL)isFirstResponder;

/// --
- (void)becomeFirstResponder;

- (void)resignFirstResponder;

@end
