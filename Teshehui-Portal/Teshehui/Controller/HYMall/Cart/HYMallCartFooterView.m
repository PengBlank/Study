//
//  HYMallCartFooterView.m
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartFooterView.h"
#import "HYShengView.h"
#import "Masonry.h"

@interface HYMallCartFooterView ()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *totalPriceLab;
@property (nonatomic, strong) UILabel *select;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) HYMallCartSecFooter *footer;
@property (nonatomic, strong) HYShengView *shengV;

@end

@implementation HYMallCartFooterView

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(frame.size.width, 44);
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        CGFloat h = CGRectGetHeight(frame);
        CGFloat w = 0;
        CGFloat btn_w = 80;
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
        [checkBtn setImage:[UIImage imageNamed:@"check_no"]
                  forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateSelected];
        [checkBtn addTarget:self
                     action:@selector(checkBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkBtn];
        self.checkBtn = checkBtn;
        
        UIFont *font1 = [UIFont systemFontOfSize:13.0];
        //全选
        _select = [[UILabel alloc] initWithFrame:CGRectMake(44, 22-font1.lineHeight/2, 28, font1.lineHeight)];
        _select.backgroundColor = [UIColor clearColor];
        _select.text = @"全选";
        _select.font = font1;
        [self addSubview:_select];
        
        //羊
//        u.text = @"¥";
        
        //128900.00
        w = frame.size.width - 75 - btn_w;
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(75, 6, w, 16)];
        t.backgroundColor = [UIColor clearColor];
        t.textColor = [UIColor grayColor];
        t.font = [UIFont boldSystemFontOfSize:18.0];
        //t.text = @"128900.00";
        [self addSubview:t];
        self.totalPriceLab = t;
        
        
        self.shengV = [[HYShengView alloc] initWithDirection:HYShengLeft height:20];
        [_shengV setPoint:CGPointMake(CGRectGetMaxX(_totalPriceLab.frame), 28) maxWidth:60];
        [self addSubview:_shengV];
        
        //结算按钮
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-btn_w, 1, btn_w, h)];
        [buyBtn setBackgroundImage:[UIImage imageNamed:@"jiesuan"]
                          forState:UIControlStateNormal];
        buyBtn.clipsToBounds = YES;
        [buyBtn addTarget:self
                   action:@selector(buyBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitle:@"去结算" forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:buyBtn];
        self.buyBtn = buyBtn;
        
        //顶部横线
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
        [self addSubview:line];
        
        [self setupSecFooter];
    }
    return self;
}

#pragma mark private methods
- (void)checkBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(footerViewDidClickCheckButton:)])
    {
        [self.delegate footerViewDidClickCheckButton:btn.selected];
    }
}

- (void)buyBtnAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(footerViewDidClickBuyButton)])
    {
        [self.delegate footerViewDidClickBuyButton];
    }
}

- (void)updatePriceInfo
{
    NSString *t1 = @"合计:";
    NSString *t2 = [NSString stringWithFormat:@"¥%.2f", _price.doubleValue];
    NSString *t3 = [NSString stringWithFormat:@"+%@现金券", _points];
    NSString *t = [NSString stringWithFormat:@"%@%@%@", t1, t2, t3];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:t];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0],
                          NSForegroundColorAttributeName: [UIColor grayColor]}
                  range:NSMakeRange(0, t1.length)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0],
                          NSForegroundColorAttributeName: [UIColor redColor]}
                  range:NSMakeRange(t1.length, t2.length)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                          NSForegroundColorAttributeName: [UIColor grayColor]}
                  range:NSMakeRange(t1.length+t2.length, t3.length)];
    _totalPriceLab.attributedText = attr;
    
    CGSize priceSize =  [_totalPriceLab sizeThatFits:_totalPriceLab.frame.size];
    [_shengV setPoint:CGPointMake(CGRectGetMinX(_totalPriceLab.frame)+priceSize.width, CGRectGetMaxY(_totalPriceLab.frame)+1)
             maxWidth:_totalPriceLab.frame.size.width];
    _shengV.sheng = [NSString stringWithFormat:@"%@", _spare];
}

- (void)showNewFooter:(BOOL)status
{
    _footer.hidden = !status;
}

- (void)setupSecFooter
{
    _footer = [[HYMallCartSecFooter alloc]init];
    [self addSubview:_footer];
    WS(weakSelf);
    
    [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.select.mas_right).with.offset(0);
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(0);
    }];
    
    _footer.hidden = YES;
}

#pragma mark setter and getter
- (void)setCheckBtnSelected:(BOOL)status
{
    _checkBtn.selected = status;
}


- (void)setPrice:(NSString *)price
{
    _price = price;
    [self updatePriceInfo];
}

- (void)setPoints:(NSString *)points
{
    _points = points;
    [self updatePriceInfo];
}

- (void)setSpare:(NSString *)spare
{
    _spare = spare;
    [self updatePriceInfo];
}

- (void)setPrice:(NSString *)price points:(NSString *)points spare:(NSString *)spare
{
    _price = price;
    _points = points;
    _spare = spare;
    [self updatePriceInfo];
}

@end
