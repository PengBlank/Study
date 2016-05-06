//
//  TicketPaySuccessTableViewCell.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketPaySuccessTableViewCell.h"

#define CellCSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation TicketPaySuccessTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _viewBack.layer.borderColor = CellCSS_ColorFromRGB(0xc7c7c7).CGColor;
    _viewBack.layer.borderWidth = .6f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) configureCell:(TravelSightInfo *)tInfo TicketCount:(TYTicketCountModel *)countModel atIndexPath:(NSIndexPath *)indexPath{
    
    self.lblTicketName.text = tInfo.ticketName;
    self.lblTicketDays.text = [NSString stringWithFormat:@"使用天数:%@天",tInfo.days];
    
    NSMutableAttributedString *attAdilt;
    
    // 成人票
    if (countModel.countAdilt > 0) {
        NSString *adilt = [NSString stringWithFormat:@"%@张",@(countModel.countAdilt)];
        attAdilt = [[NSMutableAttributedString alloc]initWithString:@"成人票"
                                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        // 设置红色
        NSAttributedString *aditCount = [[NSAttributedString alloc]initWithString:adilt
                                                                       attributes:@{NSForegroundColorAttributeName:CellCSS_ColorFromRGB(0xB80000)}];
        [attAdilt appendAttributedString:aditCount];
    }
    
    // 儿童票
    if (countModel.countChild > 0) {
        NSString *child = [NSString stringWithFormat:@"%@张",@(countModel.countChild)];
        NSAttributedString *attChild = [[NSAttributedString alloc]initWithString:@"+儿童票"
                                                                      attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        // 设置红色
        NSAttributedString *childCount = [[NSAttributedString alloc]initWithString:child
                                                                        attributes:@{NSForegroundColorAttributeName:CellCSS_ColorFromRGB(0xB80000)}];
        if (attAdilt) {
            [attAdilt appendAttributedString:attChild];
        }else{
            attAdilt = [[NSMutableAttributedString alloc]initWithString:@"儿童票"
                                                             attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        }
        [attAdilt appendAttributedString:childCount];
    }
    
    self.lblTicketCount.attributedText = attAdilt;

}
@end
