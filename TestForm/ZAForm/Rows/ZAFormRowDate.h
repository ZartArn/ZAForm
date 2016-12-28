//
//  ZAFormRowDate.h
//  Pods
//
//  Created by ZartArn on 27.12.16.
//
//

#import <ZAForm/ZAForm.h>

@interface ZAFormRowDate : ZAFormRow

@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;

@end
