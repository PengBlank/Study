//
//  LoadNullView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadNullView : UIView
@property (nonatomic, strong) UILabel       *desLabel;
@property (nonatomic, strong) UILabel       *secondLabel;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text secondText:(NSString *)secondText offsetY:(CGFloat)offsetY;

- (void)updateText:(NSString *)text secondText:(NSString *)secondText;
@end
