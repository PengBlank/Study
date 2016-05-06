//
// Created by shiweifu on 12/9/14.
// Copyright (c) 2014 shiweifu. All rights reserved.
//
/*wfl
  用于 包含景点 的名称标签
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFTag : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, assign) CGFloat cornerRadius;   // 变宽弧度半径

@property (nonatomic, strong) UIFont *font;

//上下左右的缝隙
@property (nonatomic) CGFloat inset;

@property (nonatomic, strong) id target;

@property (nonatomic) SEL action;

- (instancetype)initWithText:(NSString *)text;

+ (instancetype)tagWithText:(NSString *)text;


@end
