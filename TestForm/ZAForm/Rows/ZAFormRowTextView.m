//
//  ZAFormRowTextView.m
//  Pods
//
//  Created by ZartArn on 26.09.16.
//
//

#import "ZAFormRowTextView.h"
#import "ZAFormTextViewCell.h"
#import <ReactiveCocoa.h>

@implementation ZAFormRowTextView

#pragma mark - cell

+ (Class)defaultCellClass {
    return [ZAFormTextViewCell class];
}

- (void)configureCell:(ZAFormBaseCell *)aCell {
    NSAssert(aCell, @"Cell not defined");
    NSAssert([aCell isKindOfClass:[ZAFormTextViewCell class]], @"Cell Class must be subclass of ZAFormTextViewCell");
    
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)aCell;
    cell.textView.delegate = self;
    
    RAC(self, value) = cell.textView.rac_textSignal;
}

#pragma mark -

- (BOOL)isFirstResponder {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    return (cell.textView.isFirstResponder);
}

- (UITextView *)textView {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    return cell.textView;
}

@end
