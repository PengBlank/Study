//
//  PaymentConfirmTableViewCell.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "PaymentConfirmTableViewCell.h"

#define CellCSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation PaymentConfirmTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _vieWhitewBackground.layer.borderColor = CellCSS_ColorFromRGB(0xc7c7c7).CGColor;
    _vieWhitewBackground.layer.borderWidth = .6f;
//        self.vieWhitewBackground.layer.cornerRadius = 15.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(TravelSightInfo *)tInfo TicketCount:(TYTicketCountModel *)countModel atIndexPath:(NSIndexPath *)indexPath isOriginal:(BOOL)original{
    self.selectionStyle     = UITableViewCellSelectionStyleNone;
    self.lblTicketName.text = tInfo.ticketName;
    self.lblDays.text       = [NSString stringWithFormat:@"使用天数:%@天",tInfo.days];
    self.lblCountAdult.text = [NSString stringWithFormat:@"%@ 张",@(countModel.countAdilt)];
    self.lblCountChild.text = [NSString stringWithFormat:@"%@ 张",@(countModel.countChild)];

    //　原价
    if (original) {
        CGFloat price         = ([tInfo.adultPrice floatValue] * countModel.countAdilt) + ([tInfo.childPrice floatValue] * countModel.countChild);
        self.lblSubtotal.text = [NSString stringWithFormat:@"￥%.2f",price];
    }else{
        CGFloat price         = ([tInfo.tshAdultPrice floatValue] * countModel.countAdilt) + ([tInfo.tshChildPrice floatValue] * countModel.countChild);
        CGFloat coupon        = ([tInfo.tshAdultCoupon floatValue] * countModel.countAdilt) + ([tInfo.tshChildCoupon floatValue] * countModel.countChild);
        self.lblSubtotal.text = [NSString stringWithFormat:@"￥%.2f+%@现金券",price,@(coupon)];
    }
}

@end
