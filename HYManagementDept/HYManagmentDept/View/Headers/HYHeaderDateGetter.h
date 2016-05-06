//
//  HYHeaderDateDelegate.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYHeaderDateGetter;
@protocol HYHeaderDateDelegate <NSObject>
@optional
- (void)dateGetterDidGetDate:(NSDate *)getDate;

@end

@interface HYHeaderDateGetter : NSObject
{
    __weak UITextField *_activeField;
}

@property (nonatomic, weak) UITextField *activeField;

@property (nonatomic, weak) id<HYHeaderDateDelegate> delegate;

//- (instancetype)initWithDelegate:(id)delegate;

- (void)beginGetDateWithField:(UITextField *)field
             inViewController:(UIViewController *)vc
                     miniDate:(NSDate *)miniDate;

- (NSDate*)getMiniDateFromDate:(NSDate *)date;
- (NSDate *)getPreMiniDateFromDate:(NSDate *)date;

@end
