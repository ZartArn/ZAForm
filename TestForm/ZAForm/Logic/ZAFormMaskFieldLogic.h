//
//  ZAFormMaskFieldLogic.h
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAFormTextFieldLogic.h"

@protocol ZAFormFormatterLogicable;

@interface ZAFormMaskFieldLogic : NSObject <ZAFormTextFieldLogic>

/// text formatter
@property (assign, nonatomic) NSFormatter<ZAFormFormatterLogicable> *textFormatter;

@end
