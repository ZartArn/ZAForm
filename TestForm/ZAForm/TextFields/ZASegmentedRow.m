//
//  ZASegmentedRow.m
//  Pods
//
//  Created by ZartArn on 24.04.17.
//
//

#import "ZASegmentedRow.h"


@implementation ZASegmentedRow

- (void)start {
    [self configure];
}

- (void)configure {
    RACChannelTerminal *fieldT = [self.segmentedControl rac_newSelectedSegmentIndexChannelWithNilValue:@(-1)];
    RACChannelTerminal *valueT = RACChannelTo(self, value, @(-1));
    [fieldT subscribe:valueT];
    [[valueT skip:1] subscribe:fieldT];
}

@end
