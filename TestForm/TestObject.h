//
//  TestObject.h
//  TestForm
//
//  Created by ZartArn on 09.07.16.
//  Copyright © 2016 ZartArn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;

@end

@interface TestObjectViewModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;

@end