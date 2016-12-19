//
//  ZAFormSectionHeader.h
//  Pods
//
//  Created by ZartArn on 16.12.16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZAFormSectionHeader : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UITableViewHeaderFooterView *aView;
@property (nonatomic) CGFloat height;

@end
