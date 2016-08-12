//
//  ZAFormSection.h
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZAFormRow, ZAFormBaseSectionCell;

@interface ZAFormSection : NSObject

/// cell
@property (nonatomic) Class sectionCellClass;
@property (strong, nonatomic) ZAFormBaseSectionCell *sectionCell;
@property (nonatomic) CGFloat cellHeight;


/// title
@property (copy, nonatomic) NSString *title;

/// icon
@property (copy, nonatomic) NSString *iconName;

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

@end
