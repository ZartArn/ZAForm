//
//  ZAFormRowWithViewModel.h
// ZAForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import "ZAFormRow.h"

@interface ZAFormRowWithViewModel : ZAFormRow

- (id)viewModelForValue;
- (id)viewModelForValue:(id)value;

@end
