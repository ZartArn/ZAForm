//
//  ZAFormSectionSingleSelectable.h
//  Pods
//
//  Created by ZartArn on 14.12.16.
//
//

#import "ZAFormSection.h"

@class ZAFormRow;

@protocol ZAFormRowSelectableProtocol <NSObject>
@property (strong, nonatomic) id optionValue;
@end

@interface ZAFormSectionSingleSelectable : ZAFormSection

/// enable deselection
@property (nonatomic) BOOL enableDeselection;

/// selectableRow
@property (assign, nonatomic) ZAFormRow<ZAFormRowSelectableProtocol> *selectableRow;

/// on cell select
- (void)didSelectRow:(ZAFormRow<ZAFormRowSelectableProtocol> *)row;

@end



@interface ZAFormSectionMultipleSelectable : ZAFormSection

/// enable deselection
@property (nonatomic) BOOL enableDeselection;

/// selectable rows
@property (strong, nonatomic) NSArray *selectableRows;

/// on cell select
- (void)didSelectRow:(ZAFormRow<ZAFormRowSelectableProtocol> *)row;

/// clear all
- (void)setZeroSelected;

/// fill all
- (void)setAllSelected;

@end







@protocol ZAFormRowTagSelectableProtocol <NSObject>

@property (strong, nonatomic) id optionValue;
@property (nonatomic) NSInteger tag;

@end


@interface ZAFormSectionMultiTagsSingleSelectable : ZAFormSection

/// enable deselection
@property (nonatomic) BOOL enableDeselection;

/// selectable rows
//@property (assign, nonatomic) ZAFormRow<ZAFormRowSelectableProtocol> *selectableRow;
@property (strong, nonatomic) NSArray *selectableRows;

/// on cell select
- (void)didSelectRow:(ZAFormRow<ZAFormRowTagSelectableProtocol> *)row;

@end



