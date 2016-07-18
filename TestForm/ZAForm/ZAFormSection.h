//
//  ZAFormSection.h
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZAFormRow;

@interface ZAFormSection : NSObject

@property (copy, nonatomic) NSString *title;

/// items array
@property (strong, nonatomic) NSMutableArray *rowItems;

/// initialize
- (instancetype)initWithTitle:(NSString *)title;

/// add Row Item
- (void)addRow:(ZAFormRow *)rowItem;

/// add Rows
- (void)addRows:(NSArray *)rowsArray;

@end
