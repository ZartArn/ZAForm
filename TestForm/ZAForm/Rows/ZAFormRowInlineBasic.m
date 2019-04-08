//
//  ZAFormRowInlineBasic.m
//  ZAForm
//
//  Created by ZartArn on 21.05.2018.
//

#import "ZAFormRowInlineBasic.h"
#import "ZAFormSection.h"
#import "ZAFormTableManager.h"


@implementation ZAFormRowInlineBasic

- (void)didSelect:(NSIndexPath *)indexPath {
    [super didSelect:indexPath];
    
    if (!_showed) {
        _showed = YES;
        [self.section.form addRow:self.inlineRow afterRow:self animation:YES];
    } else {
        _showed = NO;
        [self.section.form removeRow:self.inlineRow animation:YES];
    }
}


- (void)configureCell:(ZAFormBaseCell *)aCell {
    RACChannelTo(self.inlineRow, value) = RACChannelTo(self, value);
    @weakify(self);
    [RACObserve(self, value)
     subscribeNext:^(id x) {
         @strongify(self);
         [self.section.form upgradeRow:self];
     }];
}

@end
 
