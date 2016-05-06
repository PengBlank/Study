//
//  HYAbroadBuyAlertView.h
//  Teshehui
//
//  Created by HYZB on 16/4/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYAbroadBuyAlertViewDelegate <NSObject>


- (void)commitBtnActionWithIdentification:(NSString *)identification
                                 realName:(NSString *)realName;

@end


/**
 * 海淘提示窗口
 */
@interface HYAbroadBuyAlertView : UIView

@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextField *consigneeTF;
@property (nonatomic, strong) UITextField *identificationTF;
@property (nonatomic, weak) id <HYAbroadBuyAlertViewDelegate>delegate;

- (void)show;

- (void)dismiss;

@end
