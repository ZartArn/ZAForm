//
//  ZAFormSection.h
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZAFormTableManager, ZAFormRow, ZAFormBaseSectionCell, ZAFormSectionHeader;

@interface ZAFormSection : NSObject

@property (assign, nonatomic) ZAFormTableManager *form;

/// cell
@property (nonatomic) Class sectionCellClass;
@property (strong, nonatomic) ZAFormBaseSectionCell *sectionCell;
@property (nonatomic) CGFloat cellHeight;


/// title
@property (copy, nonatomic) NSString *title;

/// icon
@property (copy, nonatomic) NSString *iconName;

/// tint color
@property (strong, nonatomic) UIColor *tintColor;

/// backgroung coloe
@property (strong, nonatomic) UIColor *bgColor;

/// header (title or view)
@property (strong, nonatomic) ZAFormSectionHeader *header;

/// footer (title or view)
@property (strong, nonatomic) ZAFormSectionHeader *footer;

/// viewModel
@property (strong, nonatomic) id viewModel;

/// items array
@property (strong, nonatomic) NSMutableArray *rowItems;

/// initialize
- (instancetype)initWithTitle:(NSString *)title;

/// add Row Item
- (void)addRow:(ZAFormRow *)rowItem;

/// add Rows
- (void)addRows:(NSArray *)rowsArray;

/// create section for form
- (ZAFormBaseSectionCell *)sectionCellForForm;

/// on cell selection
- (void)didSelectRow:(ZAFormRow *)row;

@end
