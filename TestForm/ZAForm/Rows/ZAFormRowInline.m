//
//  ZAFormRowInline.m
//  Pods
//
//  Created by ZartArn on 15.12.16.
//
//

#import "ZAFormRowInline.h"

@implementation ZAFormRowInline

- (BOOL)canBeFirstResponder {
//    return [self.inlineRow canBeFirstResponder];
    return NO;
}

- (BOOL)becomeFirstResponder {
    
    return NO;
}

- (void)didSelect:(NSIndexPath *)indexPath {
    [super didSelect:indexPath];

    if (!_showed) {
        _showed = YES;
        self.inlineRow.value = self.value;
        [self.section.form addRow:self.inlineRow afterRow:self animation:YES];
    } else {
        _showed = NO;
        [self.section.form removeRow:self.inlineRow animation:YES];
    }
}

/*
- (void)configureRow {
    [super configureRow];
    
    RACChannelTo(self, value) = RACChannelTo(self.inlineRow, value);
    
    @weakify(self);
    [[RACObserve(self, value) distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"inline row :: %@", x);
            [self.cell update];
        }];
}
*/

@end
