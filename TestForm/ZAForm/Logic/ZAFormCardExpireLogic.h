//
//  ZAFormCardExpireLogic.h
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAFormTextFieldLogic.h"

@interface ZAFormCardExpireLogic : NSObject <ZAFormTextFieldLogic>

@property (strong, nonatomic) NSFormatter *textFormatter;

@end
