//
//  HYEmployeeHotelOrderCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeHotelOrderCell.h"
#import "NSDate+Addition.h"

@interface HYEmployeeHotelOrderCell ()

@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UILabel *customersLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation HYEmployeeHotelOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat x = 20;
        CGFloat y = 12;
        CGFloat h = 15;
        CGFloat w = ScreenRect.size.width - 2 * x;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.hotelNameLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_hotelNameLabel];
        [self.contentView addSubview:_hotelNameLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.customersLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_customersLabel];
        [self.contentView addSubview:_customersLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.dateLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_dateLabel];
        [self.contentView addSubview:_dateLabel];
        
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
- (void)setOrder:(HYHotelOrderDetail *)order
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotel" ofType:@"json"];
//    NSData *jd = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jd options:0 error:NULL];

    if (order != _order)
    {
        _order = order;
        
        //酒店名
        self.hotelNameLabel.text = [NSString stringWithFormat:@"%@",
                                    [order hotelName]];
        
        //入住人
        self.customersLabel.text = [NSString stringWithFormat:@"入住人:%@",
                                    [_order personName]];
        //日期
        NSString *date = [NSString stringWithFormat:@"入住日期:%@ - %@",
                          [_order startTimeSpanDate],
                          [_order endTimeSpanDate]];
        self.dateLabel.text = date;
        
        _statusLabel.text = _order.orderStatusDesc;
        
        //价格
        self.priceLabel.text = [NSString stringWithFormat:@"¥%0.0f",
                                _order.orderTotalAmount.floatValue];
        
        _statusLabel.text = order.orderStatusDesc;
        _statusLabel.hidden = order.orderStatusDesc.length > 0 ? NO : YES;
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
