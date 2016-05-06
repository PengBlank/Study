//
//  HYMallFullOrderSectionView.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallFullOrderSectionView.h"

@interface HYMallFullOrderSectionView ()
{
    UILabel *_storeNameLab;
    UILabel *_quantityLab;
    UILabel *_priceLab;
    UILabel *_pointLab;
    
    UIImageView *_asscessView;
}
@end

@implementation HYMallFullOrderSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-1)];
        bgView.backgroundColor = [UIColor colorWithRed:235.0/255.0
                                                 green:235.0/255.0
                                                  blue:241.0/255.0
                                                 alpha:1.0];
        [self addSubview:bgView];
        
        UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 30, 30)];
        [storeIcon setImage:[UIImage imageNamed:@"icon_shop_60"]];
        [self addSubview:storeIcon];
        
        _asscessView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, 24, 7, 12)];
        _asscessView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_asscessView setImage:[UIImage imageNamed:@"cell_indicator"]];
        [self addSubview:_asscessView];
        
        _storeNameLab = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 156, 20)];
        _storeNameLab.font = [UIFont systemFontOfSize:15];
        _storeNameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _storeNameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_storeNameLab];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(54, 30, 120, 20)];
        _quantityLab.font = [UIFont systemFontOfSize:13];
        _quantityLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _quantityLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_quantityLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-110, 10, 80, 20)];
        _priceLab.font = [UIFont systemFontOfSize:14];
        _priceLab.textColor = [UIColor colorWithRed:161.0/255.0
                                              green:0
                                               blue:0
                                              alpha:1.0];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-140, 30, 110, 20)];
        _pointLab.font = [UIFont systemFontOfSize:13];
        _pointLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_pointLab];
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expandBtn.frame = CGRectMake(0, 0, ScreenRect.size.width, 60);
        [expandBtn addTarget:self
                      action:@selector(expandCell:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:expandBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private methods
- (void)expandCell:(id)sender
{
    self.isExpend = !self.isExpend;
    
    if ([self.delegate respondsToSelector:@selector(didExpandCellWithSection:)])
    {
        [self.delegate didExpandCellWithSection:self.tag];
    }
}

#pragma mark setter/getter
- (void)setIsExpend:(BOOL)isExpend
{
    if (isExpend != _isExpend)
    {
        _isExpend = isExpend;
        
        self.store.isSelect = _isExpend;
        
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat rad = self.store.isSelect ?  M_PI/2 : -M_PI/2;
            _asscessView.transform = CGAffineTransformMakeRotation(rad);
        }];
    }
}

- (void)setStore:(HYMallCartShopInfo *)store
{
    if (store != _store)
    {
        _store = store;
        _storeNameLab.text = store.store_name;
        
        NSInteger count = 0;
        CGFloat price = 0;
        NSInteger point = 0;
        for (HYMallCartProduct *goods in store.goods)
        {
            count += goods.quantity.integerValue;
            price += (goods.salePrice.floatValue * goods.quantity.integerValue);
            point += (goods.salePoints.integerValue * goods.quantity.integerValue);
        }
        
        _quantityLab.text = [NSString stringWithFormat:@"共%ld件", count];
        _priceLab.text = [NSString stringWithFormat:@"¥%0.02f", price];
        _pointLab.text = [NSString stringWithFormat:@"消费%ld现金券", point];
    }
    
    CGFloat rad = self.store.isSelect ?  M_PI/2 : -M_PI/2;
    _asscessView.transform = CGAffineTransformMakeRotation(rad);
}

@end
