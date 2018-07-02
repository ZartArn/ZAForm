//
//  ZAFormRowPicker.m
//  ZAForm
//
//  Created by ZartArn on 24.05.2018.
//

#import "ZAFormRowPicker.h"
#import "ZAFormPickerCell.h"

@interface ZAFormRowPicker() <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation ZAFormRowPicker

- (void)configureCell:(ZAFormBaseCell *)aCell {
    NSAssert([aCell isKindOfClass:[ZAFormPickerCell class]], @"Cell Class must be subclass of ZAFormPickerCell");
    NSAssert(self.pickerData, @"data for picker must be not null");
    NSAssert(self.pickerValues, @"values for picker must be not null");
    NSAssert(self.pickerData.count == self.pickerValues.count, @"data and values must have equals count");
    
    ZAFormPickerCell *cell = (ZAFormPickerCell *)aCell;
    cell.pickerView.dataSource = self;
    cell.pickerView.delegate = self;

    id currentValue = self.value; // ?: self.defaultValue ?: nil;
    if (!currentValue && self.defaultValue) {
        currentValue = self.value = self.defaultValue;
    }
    if (currentValue) {
        NSInteger idx = [self.pickerValues indexOfObject:currentValue];
        if (idx != NSNotFound) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell.pickerView selectRow:idx inComponent:0 animated:YES];
            });
        }
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}



#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.value = [self.pickerValues objectAtIndex:row];
}

@end
