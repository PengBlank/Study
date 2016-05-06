//
//  HYGoodsReturnNumberCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetNumCell.h"

@interface HYGoodsRetNumCell ()

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *remainder;

@end

@implementation HYGoodsRetNumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isGray = NO;
        self.selectable = NO;
        self.keyLab.text = @"提交数量";
        
        CGFloat x = CGRectGetMinX(self.valueLab.frame);
        [self.valueLab removeFromSuperview];
        
        UIImage *minusImg = [UIImage imageNamed:@"g_ret_minus.png"];
        CGFloat btnWidth = 44;
        CGFloat off = btnWidth/2 - minusImg.size.width / 2;
        x = x - off;
        UIButton *minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, btnWidth, CGRectGetHeight(self.grayView.bounds))];
        [minusBtn setImage:minusImg forState:UIControlStateNormal];
        //minusBtn.autoresizingMask = UIViewAutoresizingVerticlCenter;
        [minusBtn addTarget:self action:@selector(minusAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:minusBtn];
        
        UIImage *num_bg = [UIImage imageNamed:@"g_ret_num_bg.png"];
        x = CGRectGetMaxX(minusBtn.frame) - off;
        CGFloat y = CGRectGetMidY(self.grayView.bounds) - num_bg.size.height/2;
        UIImageView *numBgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, num_bg.size.width, num_bg.size.height)];
        numBgView.image = num_bg;
        [self.contentView insertSubview:numBgView belowSubview:minusBtn];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:numBgView.frame];
        numLab.font = [UIFont systemFontOfSize:14.0];
        numLab.backgroundColor = [UIColor clearColor];
        numLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView insertSubview:numLab aboveSubview:numBgView];
        self.numLab = numLab;
        
        UIImage *plusImg = [UIImage imageNamed:@"g_ret_plus.png"];
        x = CGRectGetMaxX(numBgView.frame) - off;
        UIButton *plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, btnWidth, CGRectGetHeight(self.grayView.bounds))];
        [plusBtn setImage:plusImg forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusAction:)
          forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:plusBtn];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)minusAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(goodsRetNumberCellDidMinusNumber:)])
    {
        [self.delegate goodsRetNumberCellDidMinusNumber:self];
    }
}

- (void)plusAction:(UIButton *)btn
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(goodsRetNumberCellDidAddNumber:)])
    {
        [self.delegate goodsRetNumberCellDidAddNumber:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
