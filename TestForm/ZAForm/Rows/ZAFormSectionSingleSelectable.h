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
