//
//  HYProducySKUSelectView.m
//  Teshehui
//
//  Created by HYZB on 15/9/2.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYProductSKUSelectView.h"
#import "HYProductParamInfoCell.h"
#import "HYQuantityControl.h"
#import "UIImageView+WebCache.h"
#import "METoast.h"

@interface HYProductSKUSelectView ()
<
UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate,
HYProductParamInfoCellDelegate
>
{
    UIView *_contentView;
    UIView *_iconBgView;
    UIImageView *_iconView;
    UILabel *_priceLab;
    UILabel *_stockLab;
    UILabel *_selectSKULab;
    UILabel *_pointLab;
    UIButton *_closeBtn;
    UITableView *_skuTableView;
    UIView *_toolView;
    UIButton *_doneBtn;
    HYQuantityControl *_quantityControl;
    
    UIImageView *_shengView;
    UILabel *_shengLab;
}

@end

@implementation HYProductSKUSelectView

- (id)initWithFrame:(CGRect)frame showDone:(BOOL)showDone
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, 0, CGRectGetWidth(bounds), bounds.size.height);
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                frame.size.height,
                                                                frame.size.width,
                                                                frame.size.height-TFScalePoint(230- (currentDeviceType()==iPhone4_4S)*80))];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(TFScalePoint(290), 10, TFScalePoint(18), TFScalePoint(18))];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"sheng_close"]
                             forState:UIControlStateNormal];
        [_closeBtn addTarget:self
                      action:@selector(closeView:)
            forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_closeBtn];
        
        _iconBgView = [[UIView alloc] initWithFrame:CGRectMake(14,
                                                               -24,
                                                               128,
                                                               128)];
        _iconBgView.layer.cornerRadius = 10;
        _iconBgView.layer.masksToBounds = YES;
        
        _iconBgView.backgroundColor = [UIColor whiteColor];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(4,
                                                                  4,
                                                                  120,
                                                                  120)];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        
        [_iconBgView addSubview:_iconView];
        
        [_contentView addSubview:_iconBgView];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconBgView.frame)+10,
                                                              20,
                                                              CGRectGetWidth(frame)-CGRectGetMaxX(_iconBgView.frame)-30,
                                                              22)];
        [_contentView addSubview:_priceLab];
        
        _stockLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_priceLab.frame), 44, CGRectGetWidth(_priceLab.frame), 18)];
        _stockLab.font = [UIFont systemFontOfSize:14];
        _stockLab.backgroundColor = [UIColor clearColor];
        _stockLab.textColor = [UIColor grayColor];
        [_contentView addSubview:_stockLab];
        
        _selectSKULab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_priceLab.frame),
                                                                  64,
                                                                  CGRectGetWidth(_priceLab.frame),
                                                                  18)];
        _selectSKULab.font = [UIFont systemFontOfSize:14];
        _selectSKULab.backgroundColor = [UIColor clearColor];
        _selectSKULab.textColor = [UIColor grayColor];
        [_contentView addSubview:_selectSKULab];
        
        frame.origin.x = 5;
        frame.origin.y = CGRectGetMaxY(_iconBgView.frame);
        frame.size.width -= 10;
        frame.size.height = 1;
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:frame];
        line1.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [_contentView addSubview:line1];
        
        frame.origin.y += 1;
        frame.size.height = CGRectGetHeight(_contentView.frame) - 144;
        _skuTableView = [[UITableView alloc] initWithFrame:frame
                                                     style:UITableViewStylePlain];
        _skuTableView.delegate = self;
        _skuTableView.dataSource = self;
        _skuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentView addSubview:_skuTableView];
        
        UIView *footerView = [[UIView alloc] initWithFrame:TFRectMake(0, 0, 320, 60)];
        
        //数量
        _quantityControl = [[HYQuantityControl alloc] initWithFrame:TFRectMake(190, 11, 114, 38)];
        [_quantityControl addTarget:self
                             action:@selector(quantityChange:)
                   forControlEvents:UIControlEventValueChanged];
        [footerView addSubview:_quantityControl];
        
        //省
        UIImage *sheng = [UIImage imageNamed:@"icon_sheng2"];
        sheng = [sheng resizableImageWithCapInsets:UIEdgeInsetsMake(0, 31, 0, 18)
                                      resizingMode:UIImageResizingModeStretch];
        _shengView = [[UIImageView alloc] initWithImage:sheng];
        [footerView addSubview:_shengView];
        
        UILabel *shengL = [[UILabel alloc] initWithFrame:CGRectZero];
        shengL.font = [UIFont boldSystemFontOfSize:TFScalePoint(20)];
        shengL.backgroundColor = [UIColor clearColor];
        shengL.textColor = [UIColor colorWithRed:1/255.0 green:123/255.0 blue:225/255.0 alpha:1];
        [footerView addSubview:shengL];
        _shengLab = shengL;
        [self updateShengView];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:TFRectMake(0, 59, 320, 1)];
        line2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [footerView addSubview:line2];
        
        _skuTableView.tableFooterView = footerView;
        
        if (!showDone)
        {
            UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetHeight(_contentView.frame)-44,
                                                                        self.frame.size.width,
                                                                        44)];
            
            UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resetBtn setFrame:CGRectMake(0, 0, self.frame.size.width/2, 44)];
            [resetBtn setBackgroundColor:[UIColor colorWithRed:235.0/255.0
                                                         green:155.0/255.0
                                                          blue:40.0/255.0
                                                         alpha:1.0]];
            [resetBtn setTitle:@"加入购物车"
                      forState:UIControlStateNormal];
            [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [resetBtn addTarget:self
                         action:@selector(addToShoppingCar:)
               forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:resetBtn];
            
            UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setFrame:CGRectMake(self.frame.size.width/2,
                                         0,
                                         self.frame.size.width/2,
                                         44)];
            [doneBtn setTitle:@"立即购买"
                     forState:UIControlStateNormal];
            [doneBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0
                                                        green:42.0/255.0
                                                         blue:46.0/255.0
                                                        alpha:1.0]];
            [doneBtn setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
            [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [doneBtn addTarget:self
                        action:@selector(buyNow:)
              forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:doneBtn];
            [_contentView addSubview:toolView];
        }
        else
        {
            _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_doneBtn setFrame:CGRectMake(0,
                                          CGRectGetHeight(_contentView.frame)-44,
                                          self.frame.size.width,
                                          44)];
            [_doneBtn setBackgroundColor:[UIColor redColor]];
            [_doneBtn setTitle:@"确定"
                      forState:UIControlStateNormal];
            [_doneBtn addTarget:self
                         action:@selector(selectSKUDone:)
               forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:_doneBtn];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame showDone:NO];
}

//更新"省"图标
- (void)updateShengView
{
    NSString *point = _goodsDetail.currentsSUK.totalPoint;
    NSString *spare = [NSString stringWithFormat:@"%@", point];
    CGSize size = [spare sizeWithAttributes:@{NSFontAttributeName: _shengLab.font}];
    CGFloat l = 32;     //省字内右边
    CGFloat r = 18;     //省字内左边距
    CGFloat left = 20;  //左边距
    CGFloat wid = CGRectGetMinX(_quantityControl.frame) - (l + r + left);
    wid = MIN(wid, size.width);
    _shengView.frame = CGRectMake(20, _quantityControl.frame.origin.y, (l + r + wid), _quantityControl.frame.size.height);
    _shengLab.frame = CGRectMake(CGRectGetMinX(_shengView.frame)+l,
                                 CGRectGetMinY(_shengView.frame),
                                 wid,
                                 CGRectGetHeight(_shengView.frame));
    _shengLab.text = spare;
}

#pragma mark pulice methods
- (void)updatePriceInfo
{
    NSString *money = self.goodsDetail.currentsSUK.totalMarketPrice;
    NSString *point = [NSString stringWithFormat:@"现金券可抵%@元", self.goodsDetail.currentsSUK.totalPoint];
    
    NSString *totalStr = [NSString stringWithFormat:@"%@ %@", money, point];
    
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [priceAttr addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                               NSForegroundColorAttributeName: [UIColor colorWithRed:239/255.0 green:0/255.0 blue:44/255.0 alpha:1]}
                       range:NSMakeRange(0, money.length)];
    [priceAttr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName: [UIColor grayColor]}
                       range:NSMakeRange(money.length+1, point.length)];
    
    _priceLab.attributedText = priceAttr;
    
    [self updateShengView];
}

- (void)showWithAnimation:(BOOL)animation
{
    if (![self superview])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    if (animation)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _contentView.frame = CGRectMake(0,
                                                             TFScalePoint(230- (currentDeviceType()==iPhone4_4S)*80),
                                                             _contentView.frame.size.width,
                                                             _contentView.frame.size.height);
                             self.alpha = 1.0;
                         }];
    }
    else
    {
        _contentView.frame = CGRectMake(0,
                                        TFScalePoint(230- (currentDeviceType()==iPhone4_4S)*80),
                                        _contentView.frame.size.width,
                                        _contentView.frame.size.height);
        self.alpha = 1.0;
    }
}

- (void)dismiss
{
    if ([self superview])
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0.0;
                             _contentView.frame = CGRectMake(0,
                                                             self.frame.size.height,
                                                             _contentView.frame.size.width,
                                                             _contentView.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                             if ([self.delegate respondsToSelector:@selector(didDismiss)])
                             {
                                 [self.delegate didDismiss];
                             }
                             
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view != self)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark private methods
- (void)handleSingleTap:(id)sender
{
    [self dismiss];
}

- (void)closeView:(id)sender
{
    [self dismiss];
}

- (void)quantityChange:(id)sender
{
    NSInteger quantity = [(HYQuantityControl *)sender quantity];
    
    if (quantity > self.goodsDetail.currentsSUK.stock.integerValue)
    {
        quantity = self.goodsDetail.currentsSUK.stock.integerValue;
        [(HYQuantityControl *)sender setQuantity:quantity];
        
        [METoast toastWithMessage:[NSString stringWithFormat:@"您最多只能购买%ld件",(long)self.goodsDetail.currentsSUK.stock.integerValue]];
    }
    else
    {
        if (quantity > 0)
        {
            if ([self.delegate respondsToSelector:@selector(quantityChange:callBack:)])
            {
                //颜色尺码选择面板-商品数量+、-
                [MobClick event:@"v430_shangcheng_shangpinxiangqing_yansechimaxuanzemianban_shangpinshuliangjiajian_jishu"];
                
                [(HYQuantityControl *)sender setEnabledAdd:NO];
                [(HYQuantityControl *)sender setEnabledMinus:NO];
                
                __weak typeof(_quantityControl) b_q = _quantityControl;
                [self.delegate quantityChange:quantity
                                     callBack:^(BOOL finished) {
                                         if (finished)
                                         {
                                             [b_q setEnabledAdd:YES];
                                             [b_q setEnabledMinus:YES];
                                         }
                                     }];
            }
        }
    }
}

- (void)addToShoppingCar:(id)sender
{
    // 颜色尺码选择面板-加入购物车
    if (self.goodsDetail.productId)
    {
        NSDictionary *dict = @{@"ProudctID":self.goodsDetail.productId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_yansechimaxuanzemianban_jiarugouwuche_jishu"
             attributes:dict];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishedSelectSKUToAddShoppingCar:)])
    {
        [self.delegate didFinishedSelectSKUToAddShoppingCar:YES];
    }
    
    [self dismiss];
}

- (void)buyNow:(id)sender
{
    if (self.goodsDetail.productId)
    {
        // 颜色尺码选择面板-立即购买
        if (self.goodsDetail.productId)
        {
            NSDictionary *dict = @{@"ProudctID":self.goodsDetail.productId};
            
            [MobClick event:@"v430_shangcheng_shangpinxiangqing_yansechimaxuanzemianban_lijigoumai_jishu" attributes:dict];
        }
        
        if ([self.delegate respondsToSelector:@selector(didFinishedSelectSKUToAddShoppingCar:)])
        {
            [self.delegate didFinishedSelectSKUToAddShoppingCar:NO];
        }
        
        [self dismiss];
    }
}

- (void)selectSKUDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didFinishedSelectSKUToAddShoppingCar:)])
    {
        [self.delegate didFinishedSelectSKUToAddShoppingCar:YES];
    }
    
    [self dismiss];
}

#pragma mark setter/getter
- (void)setGoodsDetail:(HYMallGoodsDetail *)goodsDetail
{
    if (goodsDetail != _goodsDetail)
    {
        _goodsDetail = goodsDetail;
        
        NSString *imgUrl = nil;
        if ([goodsDetail.currentsSUK.productSKUImagArray count] > 0)
        {
            HYImageInfo *imageInfo = [goodsDetail.currentsSUK.productSKUImagArray objectAtIndex:0];
            imgUrl = [imageInfo defaultURL];
        }
        else
        {
            imgUrl = [goodsDetail.smallImgList objectAtIndex:0];
        }
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                     placeholderImage:[UIImage imageNamed:@""]];
        
        if ([goodsDetail.currentsSUK.stock intValue] > 0)
        {
            _stockLab.text = [NSString stringWithFormat:@"库存%@件", goodsDetail.currentsSUK.stock];
        }
        else
        {
            _stockLab.text = @"卖光啦～";
        }
        
        _selectSKULab.text = [goodsDetail skuDesc];
    }
    
    /// 这里这行代码不知道是谁注释的，会导致在外面改数量后，弹出sku界面，数量没有带入。
    /// 现在被取消注释     by:成才
    _quantityControl.quantity = self.goodsDetail.currentsSUK.quantity;
    
    [self updatePriceInfo];
    
    [_skuTableView reloadData];
}

#pragma mark - HYProductParamInfoCellDelegate
- (void)didSelectProductSKU:(HYProductSKU *)sku
{
    self.goodsDetail.currentsSUK = sku;
    
    [_skuTableView reloadData];
    
    if ([sku.stock intValue] > 0)
    {
        _stockLab.text = [NSString stringWithFormat:@"库存%@件", sku.stock];
    }
    else
    {
        _stockLab.text = @"卖光啦～";
    }
    
    NSString *imgUrl = nil;
    if ([_goodsDetail.currentsSUK.productSKUImagArray count] > 0)
    {
        HYImageInfo *imageInfo = [_goodsDetail.currentsSUK.productSKUImagArray objectAtIndex:0];
        imgUrl = [imageInfo defaultURL];
    }
    else
    {
        imgUrl = [_goodsDetail.smallImgList objectAtIndex:0];
    }
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                 placeholderImage:[UIImage imageNamed:@""]];
    
    _selectSKULab.text = [self.goodsDetail skuDesc];
    _quantityControl.quantity = self.goodsDetail.currentsSUK.quantity;
    
    [self updatePriceInfo];
    
    //刷新
    if ([self.delegate respondsToSelector:@selector(didFinishedSelectSKU)])
    {
        [self.delegate didFinishedSelectSKU];
    }
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.goodsDetail attributeHeigth];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow-1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *productParamCellId = @"productParamCellId";
    HYProductParamInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:productParamCellId];
    if (!cell)
    {
        cell = [[HYProductParamInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:productParamCellId];
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setGoodDetaiInfo:self.goodsDetail];
    return cell;
}

@end
