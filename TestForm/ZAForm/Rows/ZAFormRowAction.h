//
//  ZAFormRowWithViewModel.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"

@class RACCommand;

@interface ZAFormRowAction : ZAFormRow

/// action command
@property (strong, nonatomic) RACCommand *actionCommand;

@end
