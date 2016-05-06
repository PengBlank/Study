//
//  HYCommentsGoodsCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddCommentsGoodsCell.h"
#import "UIView+Style.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"

@interface HYAddCommentsGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) UILabel *goodsSizeLab;

@end

@implementation HYAddCommentsGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat x = 20;
        CGFloat w = 60;
        CGFloat y = 14;
        CGFloat border_width = .5;
        UIView *imageFrame = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        [imageFrame addBorder:border_width borderColor:[UIColor grayColor]];
        [self.contentView addSubview:imageFrame];
        //self.imageFrame = imageFrame;
        
        UIImageView *productView = [[UIImageView alloc] initWithFrame:CGRectMake(border_width, border_width, w-border_width*2, w-border_width*2)];
        [imageFrame addSubview:productView];
        self.goodsImage = productView;
        
        //各种文字信息
        x = CGRectGetMaxX(imageFrame.frame) + 5;
        y = CGRectGetMinY(imageFrame.frame) + 4;
        CGFloat max_w = CGRectGetWidth(ScreenRect) - x - 20;
        CGFloat h = 25;
        
        //名称
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, max_w, h)];
        nameLab.font = [UIFont systemFontOfSize:13.0];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.numberOfLines = 0;
        //nameLab.text = @"Hermes爱马什全能塑胶 冰冰型 人体橡胶充气娃娃";
        [self.contentView addSubview:nameLab];
        self.goodsNameLab = nameLab;
        
        y = CGRectGetMaxY(nameLab.frame);
        UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, max_w, 15)];
        sizeLab.font = [UIFont systemFontOfSize:12.0];
        sizeLab.backgroundColor = [UIColor clearColor];
        sizeLab.textColor = [UIColor grayColor];
        //sizeLab.text = @"充气型 润滑型 真人发声";
        [self.contentView addSubview:sizeLab];
        self.goodsSizeLab = sizeLab;
        
        y = 89;
        x = 20;
        w = CGRectGetWidth(ScreenRect) - 2*x;
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, 1)];
        line.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                topCapHeight:0];
        [self addSubview:line];

    }
    return self;
}

- (void)setGoodsInfo:(HYMallOrderItem *)goodsInfo
{
    _goodsInfo = goodsInfo;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsInfo.pictureBigUrl]];
    self.goodsNameLab.text = _goodsInfo.productName;
    self.goodsSizeLab.text = _goodsInfo.specification;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
