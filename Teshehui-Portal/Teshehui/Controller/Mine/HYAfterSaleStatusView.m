//
//  HYAfterSaleStatusView.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleStatusView.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "HYAfterSaleDefines.h"
#import "MDHTMLLabel.h"

@interface HYAfterSaleStatusView ()
<MDHTMLLabelDelegate,UIActionSheetDelegate>
@end

@implementation HYAfterSaleStatusView

{
    MDHTMLLabel *_info;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexColor:@"366cbe" alpha:1];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"处理进度:";
        lab.textColor = [UIColor whiteColor];
        [self addSubview:lab];
        
        MDHTMLLabel *info = [[MDHTMLLabel alloc] initWithFrame:CGRectZero];
        info.font = [UIFont systemFontOfSize:13.0];
        info.backgroundColor = [UIColor clearColor];
        info.numberOfLines = 0;
        info.text = @"您的售后申请已成功,请耐心等待客服审核";
        info.textColor = [UIColor whiteColor];
        info.delegate = self;
        info.linkAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]};
        [self addSubview:info];
        _info = info;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        icon.image = [UIImage imageNamed:@"order_service_icon"];
        [self addSubview:icon];
        
        //Layout!
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(23);
            make.top.mas_equalTo(22);
            make.right.mas_lessThanOrEqualTo(-72);
        }];
        [info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_left);
            make.top.equalTo(lab.mas_bottom).offset(10);
            make.right.mas_lessThanOrEqualTo(-23);
        }];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
    }
    return self;
}

//- (void)setStatusDesc:(NSString *)statusDesc
//{
//    if (_statusDesc != statusDesc)
//    {
//        _statusDesc = statusDesc;
//        _info.text = statusDesc;
//    }
//}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        NSString *desc = nil;
        switch (saleInfo.status.integerValue)
        {
            case HYAfterSaleReviewing: //审核中
            {
                desc = @"您的售后申请已提交，请耐心等待客服审核。";
            }
                break;
            case HYAfterSaleRefunding:    //
            {
                desc = @"已申请退款, 请耐心等待。";
            }
                break;
            case HYAfterSalePass: //通过
            {
                if (saleInfo.useDetail.status.integerValue == HYAfterSaleWaitHandling)
                {
                    desc = @"您的售后申请已审核通过，请将商品寄回。";
                }
                else
                {
                    desc = @"您的售后申请已审核通过。";
                }
                break;
            }
            case HYAfterSaleRefused: //不通过
            {
                desc = @"您的售后申请审核不通过，若有疑问请<a>联系客服</a>。";
                break;
            }
            case HYAfterSaleCancelled: //已取消
            {
                desc = @"您的售后申请已取消。";
                break;
            }
            case HYAfterSaleDisputing: //进入纠份
            {
                desc = @"平台客服已介入，请耐心等待处理。";
                break;
            }
            case HYAfterSaleCompleted:
            case HYAfterSaleDisputed: //完成
            {
                desc = @"您的售后服务已完成。";
                break;
            }
            case HYAfterSaleRefunded:
            {
                desc = @"您的售后申请已经退款。";
                break;
            }
            default:
                desc = @"";
                break;
        }
//        desc = @"您的售后申请审核不通过，若有疑问请<a>联系客服</a>。若有疑问请<a>联系客服</";
        _info.htmlText = desc;
    }
}

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL
{
    [self didClickPhone];
}

- (void)didClickPhone
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"特奢汇客服竭诚为您服务"
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          destructiveButtonTitle:@"拨打电话 400-806-6528"
                                               otherButtonTitles:nil];
    [action showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
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
