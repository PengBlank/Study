//
//  HYAfterSaleHandleView.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleHandleView.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"
#import "HYAfterSaleDefines.h"

@implementation HYAfterSaleHandleView
{
    NSArray *_btns;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), .5)];
        line.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                     topCapHeight:0];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(.5);
        }];
        
//        UIImage *btnbg = [UIImage imageNamed:@"order_handle"];
//        btnbg = [btnbg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
//        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
//        [btn setBackgroundImage:btnbg forState:UIControlStateNormal];
//        [btn setTitle:@"登记快递" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(handelAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//        [self addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-20);
//            make.centerY.equalTo(self.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(75, 27));
//        }];
    }
    return self;
}

- (UIButton *)addHandleButton
{
    
    UIImage *btnbg = [UIImage imageNamed:@"order_handle"];
    btnbg = [btnbg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setBackgroundImage:btnbg forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn setTitleColor:[UIColor colorWithHexColor:@"494949" alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (_btns.count > 0)
    {
        UIButton *pre = [_btns lastObject];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pre.mas_left).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(75, 27));
        }];
    }
    else
    {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(75, 27));
        }];
    }
    if (!_btns) {
        _btns = [NSArray array];
    }
    _btns = [_btns arrayByAddingObject:btn];
    return btn;
}

- (void)handelAction:(UIButton *)btn
{
    if (self.delegate)
    {
        [self.delegate checkHandleType:btn.tag];
    }
}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        for (UIButton *btn in _btns)
        {
            [btn removeFromSuperview];
        }
        _btns = nil;
        switch (saleInfo.status.integerValue)
        {
            case HYAfterSaleReviewing: //审核中
            {
                UIButton *edit = [self addHandleButton];
                [edit setTitle:@"修改" forState:UIControlStateNormal];
                edit.tag = HYAfterSaleEdit;
                UIButton *cancel = [self addHandleButton];
                [cancel setTitle:@"取消申请" forState:UIControlStateNormal];
                cancel.tag = HYAfterSaleCancel;
            }
                break;
            case HYAfterSalePass: //通过
            {
                if (saleInfo.useDetail.status.integerValue == HYAfterSaleWaitHandling)
                {
                    UIButton *fill = [self addHandleButton];
                    [fill setTitle:@"登记快递" forState:UIControlStateNormal];
                    fill.tag = HYAfterSaleFillLogis;
                    UIButton *cancel = [self addHandleButton];
                    [cancel setTitle:@"取消申请" forState:UIControlStateNormal];
                    cancel.tag = HYAfterSaleCancel;
                }
                break;
            }
            case HYAfterSaleRefused:
            {
                if (saleInfo.useDetail.status.integerValue == HYAfterSaleWaitHandling)
                {
                    UIButton *cancel = [self addHandleButton];
                    [cancel setTitle:@"取消申请" forState:UIControlStateNormal];
                    cancel.tag = HYAfterSaleCancel;
                }
                break;
            }
            case HYAfterSaleCancelled: //已取消
            {
                UIButton *cancel = [self addHandleButton];
                [cancel setTitle:@"删除售后单" forState:UIControlStateNormal];
                cancel.tag = HYAfterSaleDelete;
                break;
            }
            case HYAfterSaleCompleted:
            {
                UIButton *cancel = [self addHandleButton];
                [cancel setTitle:@"删除售后单" forState:UIControlStateNormal];
                cancel.tag = HYAfterSaleDelete;
                break;
            }
            case HYAfterSaleRefunded:
            case HYAfterSaleRefunding:
            {
                if (saleInfo.useDetail.status.integerValue == HYAfterSaleWaitHandling)
                {
                    UIButton *fill = [self addHandleButton];
                    [fill setTitle:@"登记快递" forState:UIControlStateNormal];
                    fill.tag = HYAfterSaleFillLogis;
                }
                break;
            }
            default:
                break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
