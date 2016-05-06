//
//  HYActivityGoodsCell.m
//  Teshehui
//
//  Created by RayXiang on 14-8-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityGoodsCell.h"
#import "UIImageView+WebCache.h"

@interface HYActivityGoodsCell ()
{
    UILabel *_originalPriceLabel;//原价
}

@end

@implementation HYActivityGoodsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,100,100)];
        _headImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headImg];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(132, 5, ScreenRect.size.width-142, 40)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.numberOfLines = 0;
        _nameLab.textColor = [UIColor colorWithRed:16.0/255.0
                                             green:16.0/255.0
                                              blue:16.0/255.0
                                             alpha:1.0];
        _nameLab.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_nameLab];
        
        /*
        _activityPriceLbl = [[UILabel alloc] initWithFrame:
                             CGRectMake(132,
                                        CGRectGetMaxY(_nameLab.frame),
                                        CGRectGetWidth(_nameLab.frame),
                                        16)];
        _activityPriceLbl.backgroundColor = [UIColor clearColor];
        _activityPriceLbl.textColor = [UIColor colorWithRed:237.0/255.0
                                                    green:86.0/255.0
                                                     blue:101.0/255.0
                                                    alpha:1.0];
        _activityPriceLbl.font = [UIFont systemFontOfSize:12.0];
        _activityPriceLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_activityPriceLbl];
        */
        _originalPriceLabel = [[UILabel alloc] initWithFrame:
                             CGRectMake(132,
                                        CGRectGetMaxY(_nameLab.frame)+3,
                                        CGRectGetWidth(_nameLab.frame),
                                        16)];
        _originalPriceLabel.backgroundColor = [UIColor clearColor];
        _originalPriceLabel.textColor = [UIColor colorWithRed:47.0/255.0
                                                        green:46.0/255.0
                                                         blue:46.0/255.0
                                                        alpha:1.0];
        _originalPriceLabel.font = [UIFont systemFontOfSize:15.0];
        _originalPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_originalPriceLabel];
        
        /*
        _marketPriceLbl = [[HYStrikeThroughLabel alloc] initWithFrame:
                           CGRectMake(132,
                                      CGRectGetMaxY(_activityPriceLbl.frame),
                                      CGRectGetWidth(_activityPriceLbl.frame),
                                      16)];
        [_marketPriceLbl setStrikeThroughEnabled:YES];
        _marketPriceLbl.backgroundColor = [UIColor clearColor];
        _marketPriceLbl.font = [UIFont systemFontOfSize:12.0];
        _marketPriceLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_marketPriceLbl];
        
        UILabel *discountLab = [[UILabel alloc] initWithFrame:
                                CGRectMake(132,
                                           CGRectGetMaxY(_marketPriceLbl.frame),
                                           CGRectGetWidth(_marketPriceLbl.frame),
                                           16.0)];
        discountLab.backgroundColor = [UIColor clearColor];
        discountLab.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:discountLab];
        self.discountLab = discountLab;
         */
        
        _pointLab = [[UILabel alloc]initWithFrame:CGRectMake(132, CGRectGetMaxY(_originalPriceLabel.frame)+3, ScreenRect.size.width-142, 16)];
//        _pointLab.backgroundColor = [UIColor colorWithRed:246.0/255.0
//                                                    green:248.0/255.0
//                                                     blue:242.0/255.0
//                                                    alpha:1.0];
        _pointLab.textColor = [UIColor colorWithRed:237.0/255.0
                                              green:86.0/255.0
                                               blue:101.0/255.0
                                              alpha:1.0];
        _pointLab.font = [UIFont systemFontOfSize:14.0f];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
        
        self.separatorLeftInset = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setGoods:(HYActivityGoods *)goods
{
    if (_goods != goods)
    {
        _goods = goods;
        [_headImg sd_setImageWithURL:[NSURL URLWithString:goods.productPicUrl]
                    placeholderImage:[UIImage imageNamed:@"loading"]];
        _nameLab.text = goods.productName;
//        NSNumber *pPrice = [NSNumber numberWithFloat:goods.price];
//        NSString *activity_price_t = [NSString stringWithFormat:@"活动价: ¥%@", pPrice];
        /*CGSize size = [activity_price_t sizeWithFont:_marketPriceLbl.font
         constrainedToSize:CGSizeMake(1000, 100)];
         CGRect f = _activityPriceLbl.frame;
         f.size.width = size.width;
         _activityPriceLbl.frame = f;*/
        
        _originalPriceLabel.text = [NSString stringWithFormat:@"原价: ¥%@", goods.marketPrice];
        NSInteger point = goods.points;
        _pointLab.text = [NSString stringWithFormat:@"活动力度: 现金券可抵%ld元",(long)point];
        
        //折扣
//        NSNumber *discount_f = [NSNumber numberWithFloat:goods.discount.floatValue];
//        self.discountLab.text = [NSString stringWithFormat:@"折扣: %@", discount_f];
    }
}

/*s
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
