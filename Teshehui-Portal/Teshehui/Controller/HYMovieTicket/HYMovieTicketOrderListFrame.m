//
//  HYMovieTicketOrderListFrame.m
//  Teshehui
//
//  Created by HYZB on 16/3/10.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderListFrame.h"
#import "HYMovieTicketOrderListModel.h"

#define kMargin 5

@implementation HYMovieTicketOrderListFrame

- (void)setModel:(HYMovieTicketOrderListModel *)model
{
    _model = model;
    
    self.topViewFrame = CGRectMake(0, 0, TFScalePoint(320), 5);
    
    self.picImageViewFrame = CGRectMake(10, 40, 40, 40);
    
    CGFloat x = CGRectGetMaxX(self.picImageViewFrame)+10;
    CGFloat width = 170;
    self.orderCodeLabelFrame = CGRectMake(x, 10+kMargin, TFScalePoint(230), 15);
    
    self.cityLabelFrame = CGRectMake(x, CGRectGetMaxY(self.orderCodeLabelFrame)+kMargin, width, 15);
    
    
    self.addressLabelFrame = CGRectMake(CGRectGetMinX(self.orderCodeLabelFrame), CGRectGetMaxY(self.cityLabelFrame)+kMargin, 70, 15);
    
    CGSize size = [model.cinemaName sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(TFScalePoint(110), 40) lineBreakMode:NSLineBreakByTruncatingTail];
    self.addressFrame = CGRectMake(CGRectGetMaxX(self.addressLabelFrame), CGRectGetMaxY(self.cityLabelFrame)+kMargin, TFScalePoint(110), size.height);
    
    self.priceLabelFrame = CGRectMake(CGRectGetMinX(self.orderCodeLabelFrame), CGRectGetMaxY(self.addressFrame)+kMargin, width, 15);
    
    self.countsLabelFrame = CGRectMake(CGRectGetMinX(self.orderCodeLabelFrame), CGRectGetMaxY(self.priceLabelFrame)+kMargin, width, 15);
    
    if (model.cashCoupon.length > 0)
    {
        self.pointLabelFrame = CGRectMake(CGRectGetMinX(self.orderCodeLabelFrame), CGRectGetMaxY(self.countsLabelFrame)+kMargin, width, 15);
    }
    
    self.PayStatusLabelFrame = CGRectMake(TFScalePoint(250), CGRectGetMaxY(self.cityLabelFrame), 80, 30);
    
    self.cellHeight = model.cashCoupon.length > 0 ? CGRectGetMaxY(self.pointLabelFrame) : CGRectGetMaxY(self.countsLabelFrame);
}


@end
