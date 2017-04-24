//
//  ZASegmentedRow.h
//  Pods
//
//  Created by ZartArn on 24.04.17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZASegmentedRow : NSObject

/// segmented control
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

/// value
@property (strong, nonatomic) id value;

/// configure
- (void)configure;

/// start
- (void)start;

@end
