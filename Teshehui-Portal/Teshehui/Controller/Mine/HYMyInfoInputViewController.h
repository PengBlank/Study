//
//  HYMyInfoInputViewController.h
//  Teshehui
//
//  Created by HYZB on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/*
 *输入用户昵称或者邮箱的界面
 */

typedef NS_ENUM(NSInteger, MyInfoEditType)
{
    NickNameEdit,
    EmailEdit,
};

#import "HYMallViewBaseController.h"

@protocol HYMyInfoInputViewControllerDelegate <NSObject>

@optional
- (void)didEditFinished:(NSString *)text type:(MyInfoEditType)type;

@end

@interface HYMyInfoInputViewController : HYMallViewBaseController

@property (nonatomic, weak) id<HYMyInfoInputViewControllerDelegate> delegate;
@property (nonatomic, assign) MyInfoEditType editType;
@property (nonatomic, copy) NSString *text;

@end
