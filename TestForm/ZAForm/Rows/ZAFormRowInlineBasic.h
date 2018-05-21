//
//  ZAFormRowInlineBasic.h
//  ZAForm
//
//  Created by ZartArn on 21.05.2018.
//

#import "ZAFormRow.h"

/**
 * on did select show\hide inline row
 * on change self.value call update self cell
 */

@interface ZAFormRowInlineBasic : ZAFormRow

@property (strong, nonatomic) ZAFormRow *inlineRow;
@property (nonatomic) BOOL showed;

@end
