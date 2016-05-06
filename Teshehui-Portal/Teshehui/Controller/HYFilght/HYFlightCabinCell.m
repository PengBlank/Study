//
//  HYFlightCabinCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightCabinCell.h"
#import "HYStrikeThroughLabel.h"

@interface HYFlightCabinCell ()
{
    UILabel *_discountLab;
    UILabel *_pointLab;
    UILabel *_priceLab;
    UILabel *_returnAmountLab;
    UILabel *_priceType;
    UILabel *_cabinsLab;
    UILabel *_ticketCountLab;
    
    UIImageView *_cabinTypeImageView;
}

@end

@implementation HYFlightCabinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cabinsLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(14, 10, 50, 18)];
        _cabinsLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_cabinsLab setFont:[UIFont systemFontOfSize:16]];
        _cabinsLab.backgroundColor = [UIColor clearColor];
        _cabinsLab.textAlignment = NSTextAlignmentLeft;
        [_cabinsLab setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:_cabinsLab];
        
        _discountLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(40, 10, 60, 18)];
        _discountLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_discountLab setFont:[UIFont systemFontOfSize:14]];
        _discountLab.backgroundColor = [UIColor clearColor];
        _discountLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_discountLab];
        
        _ticketCountLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(140, 16, 36, 18)];
        _ticketCountLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_ticketCountLab setFont:[UIFont systemFontOfSize:14]];
        _ticketCountLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_ticketCountLab];
        
        _priceType = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 10, 12, 18)];
        _priceType.textColor = [UIColor colorWithRed:176.0/255.0
                                              green:0/255.0
                                               blue:3.0/255.0
                                              alpha:1.0];
        [_priceType setFont:[UIFont systemFontOfSize:12]];
        _priceType.backgroundColor = [UIColor clearColor];
        _priceType.text = @"￥";
        [self.contentView addSubview:_priceType];
        
        _priceLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(222, 11, 68, 18)];
        _priceLab.textColor = [UIColor colorWithRed:176.0/255.0
                                              green:0/255.0
                                               blue:3.0/255.0
                                              alpha:1.0];
        [_priceLab setFont:[UIFont boldSystemFontOfSize:16]];
        _priceLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLab];
        
        _cabinTypeImageView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(14, 32, 44, 18)];
        [self.contentView addSubview:_cabinTypeImageView];
        
        _returnAmountLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 25, 90, 18)];
        _returnAmountLab.textColor = [UIColor colorWithRed:250.0/255.0
                                              green:113.0/255.0
                                               blue:17.0/255.0
                                              alpha:1.0];
        [_returnAmountLab setFont:[UIFont systemFontOfSize:11]];
        _returnAmountLab.backgroundColor = [UIColor clearColor];
        _returnAmountLab.textAlignment = NSTextAlignmentLeft;
        _returnAmountLab.text = @"返现:";
        [self.contentView addSubview:_returnAmountLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(210, 40, 90, 18)];
        _pointLab.textColor = [UIColor colorWithRed:250.0/255.0
                                              green:113.0/255.0
                                               blue:17.0/255.0
                                              alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:11]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
        
        UIImage *arrIcon = [UIImage imageNamed:@"icon_arrow"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(300, 23, 10, 10)];
        arrView1.image = arrIcon;
        [self.contentView addSubview:arrView1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark private methods

#pragma mark setter/getter
- (void)setCabin:(HYFlightSKU *)cabin
{
    if (cabin != _cabin)
    {
        _cabin = cabin;
        
        if (cabin.expandedResponse.discount.floatValue < 10)
        {
            NSNumber *nDic = [NSNumber numberWithFloat:cabin.expandedResponse.discount.floatValue];
            _discountLab.text = [NSString stringWithFormat:@"%@折", nDic] ;
        }
        else
        {
            _discountLab.text = @"全价";
        }
        
        _cabinsLab.text = cabin.expandedResponse.cabinName;
        if (cabin.stock.integerValue > 9)
        {
            _ticketCountLab.text = @">9张";
        }
        else
        {
            _ticketCountLab.text = [NSString stringWithFormat:@"%d张", cabin.stock.intValue];
        }
    }
    
    if (cabin.price > 0)
    {
        _priceType.text = @"¥";
        _priceLab.text = [NSString stringWithFormat:@"%0.2f", cabin.price.floatValue];
        
        int i = [cabin.returnAmount intValue];
        if (cabin.returnAmount && i != 0) {
            
            _returnAmountLab.hidden = NO;
            _returnAmountLab.text = [NSString stringWithFormat:@"返现:¥%@", cabin.returnAmount];
        } else {
            
            _returnAmountLab.hidden = YES;
            _pointLab.frame = _returnAmountLab.frame;
        }
        
        NSNumber *nPoint = [NSNumber numberWithFloat:cabin.points.floatValue];
        _pointLab.text = [NSString stringWithFormat:@"送%@现金券", nPoint];
        
    }
    else
    {
        _priceType.text = nil;
        _priceLab.text = nil;
        _pointLab.text = nil;
    }
    
    if (cabin.expandedResponse.sourceFrom ==1 || cabin.expandedResponse.sourceFrom==3)  //携程
    {
        _cabinTypeImageView.image = [UIImage imageNamed:@"xc_cabin_icon"];
    }
    else
    {
        _cabinTypeImageView.image = [UIImage imageNamed:@"teshehui_cabin_icon"];
    }
}
@end
