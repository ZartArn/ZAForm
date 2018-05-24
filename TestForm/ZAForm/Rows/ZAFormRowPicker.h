//
//  ZAFormRowPicker.h
//  ZAForm
//
//  Created by ZartArn on 24.05.2018.
//

#import "ZAFormRow.h"

@interface ZAFormRowPicker : ZAFormRow

@property (strong, nonatomic) NSArray<NSString *> *pickerData;
@property (strong, nonatomic) NSArray *pickerValues;

@property (strong, nonatomic) id defaultValue;

@end
