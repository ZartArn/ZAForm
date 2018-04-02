//
//  ZAFormRowTextView.m
//  Pods
//
//  Created by ZartArn on 26.09.16.
//
//

#import "ZAFormRowTextView.h"
#import "ZAFormTextViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

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
    
    @weakify(self);
    RACChannelTerminal *modelTerminal = RACChannelTo(self, value);
    RAC(cell.textView, text) = modelTerminal;
    [cell.textView.rac_textSignal subscribe:modelTerminal];

    [cell.textView.rac_textSignal
        subscribeNext:^(id x) {
            @strongify(self);
            [self textViewDidChange:nil];
        }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    CGRect textRect = cell.textView.frame;
    CGRect rect = [cell.textView.superview  convertRect:textRect toView:self.section.form.tableView];
    [self.section.form scrollToRect:rect];
    return YES;
}

// !: called only from textView.rac_textSignal subscriber
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidChange");
    UITableView *tableView = self.section.form.tableView;
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    
    CGPoint currentOffset = tableView.contentOffset;
    CGFloat oldCellHeight = cell.frame.size.height;


    
    
    
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];


    CGFloat newCellHeight = cell.frame.size.height;
//    CGFloat newCellHeight = [textView sizeThatFits:textView.frame.size].height;
    if (cell.textView.isFirstResponder && (oldCellHeight > 0) && oldCellHeight != newCellHeight) {
        
        CGFloat newOffsetY = currentOffset.y + newCellHeight - oldCellHeight;
        UIEdgeInsets contentInsets;
        if (@available(iOS 11.0, *)) {
            contentInsets = tableView.adjustedContentInset;
        } else {
            contentInsets = tableView.contentInset;
        }
//        NSLog(@"frame :: %@", NSStringFromCGRect(tableView.frame));
//        NSLog(@"content insets :: %@", NSStringFromUIEdgeInsets(contentInsets));
//        NSLog(@"content size :: %@", NSStringFromCGSize(tableView.contentSize));
//        NSLog(@"old offset :: %@", NSStringFromCGPoint(currentOffset));
//        NSLog(@"new y :: %@", @(newOffsetY));
//        NSLog(@".............\n\n");
 
        if (tableView.contentSize.height > tableView.frame.size.height - contentInsets.top - contentInsets.bottom) {
            currentOffset.y = newOffsetY;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tableView setContentOffset:currentOffset animated:YES];
            });
        }
    }

 }

#pragma mark - responders

- (BOOL)canBeFirstResponder {
    return YES;
}

- (BOOL)isFirstResponder {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    return (cell.textView.isFirstResponder);
}

- (void)becomeFirstResponder {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    [cell.textView becomeFirstResponder];
}

- (void)resignFirstResponder {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    [cell.textView resignFirstResponder];
}

#pragma mark -

- (UITextView *)textView {
    ZAFormTextViewCell *cell = (ZAFormTextViewCell *)self.cell;
    return cell.textView;
}

@end
