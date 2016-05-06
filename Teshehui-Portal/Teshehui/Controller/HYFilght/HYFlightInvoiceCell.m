//
//  HYFlightInvoiceCell.m
//  Teshehui
//
//  Created by Kris on 15/9/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightInvoiceCell.h"

@implementation HYFlightInvoiceCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.frame = TFRectMakeFixWidth(90, 15, 100, 20);
}

@end
