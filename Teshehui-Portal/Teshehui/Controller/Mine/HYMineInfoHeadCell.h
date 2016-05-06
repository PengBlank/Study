//
//  HYMineInfoHeadCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYUserInfo.h"

typedef enum
{
    MyCard =  1000,
    Xubao,
    Fuli,
    Upgrade,
    Member
}HYMineInfoMenuType;

@protocol HYMineInfoHeadCellDelegate <NSObject>
@optional
//菜单回调，点击我的名片、续保、升级等按钮时调用
- (void)headCellDidClickWithMenuType:(HYMineInfoMenuType)menuType;
- (void)headCellDidClickLogin;
- (void)headCellDidClickPhoto;
- (void)headCellDidClickUserName;

@end

/**
 *  @brief “我的”首页，头像cell
 */
@interface HYMineInfoHeadCell : HYBaseLineCell

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) HYUserInfo *userinfo;

@property (nonatomic, weak) id<HYMineInfoHeadCellDelegate> delegate;

@end
