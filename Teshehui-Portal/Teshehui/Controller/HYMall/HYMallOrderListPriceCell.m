//
//  HYMallOrderListPriceCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListPriceCell.h"
#import "HYMallOrderSummary.h"
#import "HYShengView.h"
#import "HYMeiWeiQiQiOrderListModel.h"

@interface HYMallOrderListPriceCell ()
{
    UILabel *_creationTime;
}

@property (nonatomic, strong) UILabel *quantityLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *shengLab;
@property (nonatomic, strong) HYShengView *shengView;

@end

@implementation HYMallOrderListPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *qlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        qlabel.font = [UIFont systemFontOfSize:14];
        qlabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        qlabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:qlabel];
        self.quantityLab = qlabel;
        
        UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectZero];
        plabel.font = [UIFont systemFontOfSize:14];
        plabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        plabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:plabel];
        self.priceLab = plabel;
        
        HYShengView *sheng = [[HYShengView alloc] initWithDirection:HYShengLeft height:20];
        [self addSubview:sheng];
        self.shengView = sheng;
        
        UILabel *slabel = [[UILabel alloc] initWithFrame:CGRectZero];
        slabel.font = [UIFont boldSystemFontOfSize:16.0];
        slabel.textColor = [UIColor grayColor];
        slabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:slabel];
        self.shengLab = slabel;
        
        _indicator = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-17, 25, 7, 12)];
        _indicator.image = [UIImage imageNamed:@"cell_indicator"];
        [self.contentView addSubview:_indicator];
        
        _creationTime = [UILabel new];
        [self addSubview: _creationTime];
    }
    return self;
}

- (void)setOrder:(HYMallOrderSummary *)order
{
    if (_order != order)
    {
        CGFloat xmargin = 12;
        CGFloat ymargin = 12;
        
        
        
        NSInteger count = 0;
        CGFloat price = 0;
        NSInteger point = 0;
        
        for (HYMallOrderItem *goods in order.orderItem)
        {
            count += goods.quantity;
        }
        
        price = order.orderActualAmount.floatValue;
        point = order.orderTbAmount.integerValue;
        
        //总的父订单金额
        self.quantityLab.text = [NSString stringWithFormat:@"订单金额："];
        [_quantityLab sizeToFit];
        self.quantityLab.frame = CGRectMake(xmargin,
                                            ymargin,
                                            _quantityLab.frame.size.width,
                                            _quantityLab.frame.size.height);
        
        //省...
        [_shengView setPoint:CGPointMake(300, 9) maxWidth:320];
        _shengView.sheng = [NSString stringWithFormat:@"%ld", (long)point];
        
        //价格
        CGFloat maxWidth = CGRectGetMinX(_shengView.frame) - CGRectGetMaxX(_quantityLab.frame) - 15;
        _priceLab.frame = CGRectMake(CGRectGetMaxX(_quantityLab.frame),
                                     ymargin,
                                     maxWidth,
                                     _priceLab.font.lineHeight);
        _priceLab.text = [NSString stringWithFormat:@"¥%0.2f+%d现金券", price,  (int)point];
        
        //下单时间
        _creationTime.text = [NSString stringWithFormat:@"下单时间：%@",order.creationTime];
        _creationTime.frame = CGRectMake(xmargin, ymargin + 20, 250, 30);
        _creationTime.font = [UIFont systemFontOfSize:14];
        _creationTime.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
}

- (void)setExpand:(BOOL)expand
{
    if (_expand != expand)
    {
        _expand = expand;
        if (expand)
        {
            _indicator.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else
        {
            _indicator.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)setModel:(HYMeiWeiQiQiOrderListModel *)model
{
    if (_model != model)
    {
        CGFloat xmargin = 12;
        CGFloat ymargin = 12;
        
        CGFloat price = 0;
        
        price = model.orderTotalAmount.floatValue;
        
        //总的父订单金额
        self.quantityLab.text = [NSString stringWithFormat:@"订单金额："];
        [_quantityLab sizeToFit];
        self.quantityLab.frame = CGRectMake(xmargin,
                                            ymargin,
                                            _quantityLab.frame.size.width,
                                            _quantityLab.frame.size.height);
        
        //价格
        _priceLab.frame = CGRectMake(CGRectGetMaxX(_quantityLab.frame),
                                     ymargin,
                                     10,
                                     _priceLab.font.lineHeight);
        _priceLab.text = [NSString stringWithFormat:@"¥%0.2f", price];
        [_priceLab sizeToFit];
        
        //下单时间
        _creationTime.text = [NSString stringWithFormat:@"下单时间：%@",model.creationTime];
        _creationTime.frame = CGRectMake(xmargin, ymargin + 20, 250, 30);
        _creationTime.font = [UIFont systemFontOfSize:14];
        _creationTime.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
}


@end
