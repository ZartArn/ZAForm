//
//  ZAFormRowSegmented.m
//  Pods
//
//  Created by ZartArn on 15.12.16.
//
//

#import "ZAFormRowSegmented.h"
#import "ZAFormCellSegmented.h"


@implementation ZAFormRowSegmented

- (void)configureCell:(ZAFormBaseCell *)aCell {
    
    ZAFormCellSegmented *cell = (ZAFormCellSegmented *)aCell;
    [cell createSC:self.titles];
    
    RACChannelTerminal *fieldT = [[cell.segmentedControl rac_newSelectedSegmentIndexChannelWithNilValue:nil] startWith:nil];
    RACChannelTerminal *valueT = RACChannelTo(self, value);
    [fieldT subscribe:valueT];
    
    [cell configureSC];
}

@end
