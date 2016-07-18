//
//  AccNumberFormatter.h
//  ZAForm
//
//  Created by ZartArn on 14.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccNumberFormatter : NSFormatter

/// example '####-####-####-####'
@property (copy, nonatomic) NSString *mask;

- (instancetype)initWithMask:(NSString *)maskString;

@end
