//
//  HYLoginViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  登陆界面
 */
@interface HYLoginViewController : UIViewController
<
UIGestureRecognizerDelegate,
UITextFieldDelegate
>
{
    
}

- (void)rememberNameBtnClicked:(UIButton *)btn;
- (void)rememberPassBtnClicked:(UIButton *)btn;

//Use for Test
- (CGFloat)getAppropriateOffset;
- (void)xMoveViewWithOffset:(CGFloat)offset;
@end
