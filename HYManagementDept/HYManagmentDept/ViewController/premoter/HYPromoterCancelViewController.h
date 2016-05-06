//
//  HYPromoterCancelViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-1.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYCustomModalPresentDelegate <NSObject>

- (void)customModalDismiss:(BOOL)success;

@end

#import "HYPromoters.h"

/**
 *  取消操作员
 */
@interface HYPromoterCancelViewController : UIViewController
{
    UIView *_maskView;
    UIView *_contentView;
}

@property (nonatomic, strong) HYPromoters *promoters;   //数据传入点

@property (nonatomic, weak) id<HYCustomModalPresentDelegate> delegate;

- (void)adjustViewFrame;
- (void)show;
- (void)dismiss;

@end
