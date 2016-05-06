//
//  HYLoginViewBaseCell.h
//  Teshehui
//
//  Created by HYZB on 16/2/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


// 登录方式
typedef NS_ENUM(NSUInteger, LoginType)
{
    kLoginTypeQuicklyLogin,
    kLoginTypeKeyLogin
};

@interface HYLoginViewBaseCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat cellHeight;

@end
