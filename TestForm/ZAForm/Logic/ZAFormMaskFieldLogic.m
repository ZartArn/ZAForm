//
//  ZAFormMaskFieldLogic.m
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormMaskFieldLogic.h"

@implementation ZAFormMaskFieldLogic

- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [textField.text stringByReplacingCharactersInRange:range withString:string];
}

@end
