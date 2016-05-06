//
//  HYEmployeeFlowerOrderCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeFlowerOrderCell.h"
#import "NSDate+Addition.h"

@interface HYEmployeeFlowerOrderCell ()

@property (nonatomic, strong) UILabel *flowerNameLabel;
@property (nonatomic, strong) UILabel *recieverLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation HYEmployeeFlowerOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat x = 20;
        CGFloat y = 12;
        CGFloat h = 15;
        CGFloat w = ScreenRect.size.width - 2 * x;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.flowerNameLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_flowerNameLabel];
        [self.contentView addSubview:_flowerNameLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.recieverLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_recieverLabel];
        [self.contentView addSubview:_recieverLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.sendTimeLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_sendTimeLabel];
        [self.contentView addSubview:_sendTimeLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 8;
        rect.size.width = 200;
        self.priceLabel = [[UILabel alloc] initWithFrame:rect];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLabel];
        
        //按钮右下角浮动
        w = 80;
        h = 20;
        x = ScreenRect.size.width - 8 - w;
        y = CGRectGetHeight(self.frame) - 5 - h;
        rect = CGRectMake(x, y, w, h);
        self.statusLabel = [[UILabel alloc] initWithFrame:rect];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _statusLabel.font = [UIFont systemFontOfSize:14.0];
        _statusLabel.backgroundColor = [UIColor redColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
    }
    return self;
}

- (void)configureLabel:(UILabel *)label
{
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark setter/getter
- (void)setOrder:(HYFlowerOrderSummary *)order
{
    //order.order_status = @"100";
    if (order != _order)
    {
        _order = order;
        
        HYFlowerOrderItem *item = [order.orderItemPOList lastObject];
        
        self.flowerNameLabel.text = [NSString stringWithFormat:@"花名：%@",
                                     item.productName];
        self.recieverLabel.text = [NSString stringWithFormat:@"收花人：%@",
                                   order.address.realName];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[order.deliveryTime floatValue]];
        self.sendTimeLabel.text = [NSString stringWithFormat:@"送花时间: %@",
                                   [date timeDescription]];
        
        NSNumber *nPrice = [NSNumber numberWithFloat:order.orderPayAmount.floatValue];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@", nPrice];
        
        _statusLabel.text = order.orderShowStatus;
        _statusLabel.hidden = order.orderShowStatus.length > 0 ? NO : YES;
    }
}

#pragma mark - Selection configure
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.statusLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setSelected:highlighted animated:animated];
    if (highlighted)
    {
        self.statusLabel.backgroundColor = [UIColor redColor];
    }
}

@end
