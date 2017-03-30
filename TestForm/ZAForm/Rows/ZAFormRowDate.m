//
//  ZAFormRowDate.m
//  Pods
//
//  Created by ZartArn on 27.12.16.
//
//

#import "ZAFormRowDate.h"
#import "ZAFormDatePickerCell.h"

@implementation ZAFormRowDate

- (void)configureCell:(ZAFormBaseCell *)aCell {
    NSAssert([aCell isKindOfClass:[ZAFormDatePickerCell class]], @"Cell Class must be subclass of ZAFormDatePickerCell");
    
    ZAFormDatePickerCell *cell = (ZAFormDatePickerCell *)aCell;
    cell.datePicker.minimumDate = self.minDate;
    cell.datePicker.maximumDate = self.maxDate;
    
    @weakify(self);
    RACChannelTerminal *fieldTerminal =  [cell.datePicker rac_newDateChannelWithNilValue:[NSDate date]];
    RACChannelTerminal *valueTerminal = RACChannelTo(self, value);
    
    [valueTerminal subscribe:fieldTerminal];
    [fieldTerminal subscribe:valueTerminal];
    
    if (self.value == nil) {
        self.value = self.defaultDate;
    }
}

@end
