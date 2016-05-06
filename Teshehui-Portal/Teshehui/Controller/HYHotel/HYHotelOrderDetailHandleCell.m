//
//  HYHotelOrderDetailHandleCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetailHandleCell.h"
#import "Masonry.h"
#import "HYHotelOrderDetail.h"
#import "HYUserInfo.h"

@implementation HYHotelOrderDetailHandleCell

@synthesize handelBtn = _handleBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _handleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *img = [UIImage imageNamed:@"flght_cancelOrder"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
//        UIImage *imgh = [UIImage imageNamed:@"icon_list7"];
//        imgh = [imgh resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
        [_handleBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_handleBtn setTitleColor:[UIColor colorWithRed:255.0f/255.0
                                                  green:154.0f/255.0f
                                                   blue:64.0f/255.0f
                                                  alpha:1.0] forState:UIControlStateNormal];
        _handleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_handleBtn];
        [_handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.23);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setOrderDetail:(HYHotelOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    NSString *title = @"";
    if (self.userInfo.userType == Enterprise_User)
    {
        title = @"取消订单";
    }
    else
    {
        /*
         //预付得暂时不支持取消 9.26
         if (self.orderDetail.status!=Unpaid &&
         (self.orderDetail.status == Failed || self.orderDetail.status >= Cancel))  //删除订单
         */
        if (self.orderDetail.status == Failed || self.orderDetail.status >= Cancel)
        {
            title = @"删除订单";
        }
        else
        {
            title = @"取消订单";
        }
    }
    [_handleBtn setTitle:title forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
