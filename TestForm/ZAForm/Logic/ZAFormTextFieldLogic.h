//
//  ZAFormTextFieldLogic.h
//  TestForm
//
//  Created by ZartArn on 22.08.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZAFormTextFieldLogic <NSObject>

/// formatted string and sace in field
- (void)applyFormatTo:(UITextField *)textField forText:(NSString *)text;

/// input text handler. return new string
- (NSString *)textField:(UITextField *)textField willChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
