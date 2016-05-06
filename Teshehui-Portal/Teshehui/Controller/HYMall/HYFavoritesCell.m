//
//  HYFavoritesCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFavoritesCell.h"
#import "UIImageView+WebCache.h"

@interface HYFavoritesCell ()
{
    UIImageView *_imageView;
    UILabel *_storeNameLab;
    UIButton *_deleteBtn;  //售后服务
}
@end

@implementation HYFavoritesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *_lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 38, ScreenRect.size.width-14, 1.0)];
        _lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                        topCapHeight:0];
        [self.contentView addSubview:_lineView];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 12, 14, 13)];
        iconView.image = [UIImage imageNamed:@"icon_shop"];
        [self.contentView addSubview:iconView];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imageView];
        
        _storeNameLab = [[UILabel alloc] initWithFrame:CGRectMake(32, 11, ScreenRect.size.width-100, 16)];
        _storeNameLab.font = [UIFont systemFontOfSize:14];
        _storeNameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _storeNameLab.backgroundColor = [UIColor clearColor];
        _storeNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_storeNameLab];
        
//        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteBtn.frame = CGRectMake(ScreenRect.size.width-50, 4, 50, 30);
//        [_deleteBtn setImage:[UIImage imageNamed:@"cart_drop"]
//                    forState:UIControlStateNormal];
//        [_deleteBtn addTarget:self
//                             action:@selector(deleteFavorite:)
//                   forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_deleteBtn];
        
        UIImageView *assView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-17, 75, 7, 12)];
        assView.image = [UIImage imageNamed:@"cell_indicator"];
        [self.contentView addSubview:assView];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
        
        [self.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
        self.detailTextLabel.textColor = [UIColor colorWithRed:161.0/255.0
                                                         green:0
                                                          blue:0
                                                         alpha:1.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *storeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)-50, 35)];
        storeBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //        storeBtn.backgroundColor = [UIColor redColor];
        [storeBtn addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:storeBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(84, 44, ScreenRect.size.width-104, 34);
    self.detailTextLabel.frame = CGRectMake(84, 80, ScreenRect.size.width-104, 20);

    if (self.editing)
    {
        [self setSelectImageView];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.editing)//仅仅在编辑状态的时候需要自己处理选中效果
    {
        if (selected)
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        [self setSelectImageView];
    }
}

- (void)setGoodsinfo:(HYMallFavouriteItem *)goodsinfo
{
    if (goodsinfo != _goodsinfo)
    {
        _goodsinfo = goodsinfo;
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsinfo.productPicUrl]
                      placeholderImage:nil];
        _storeNameLab.text = goodsinfo.storeName;
        self.textLabel.text = goodsinfo.productName;
        self.detailTextLabel.text = [NSString stringWithFormat:@"会员价：¥%0.2f+%ld现金券", goodsinfo.price, goodsinfo.points];
    }
}



#pragma mark - private methods
//- (void)deleteFavorite:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(didDeleteFavoriteWithGoods:)])
//    {
//        [self.delegate didDeleteFavoriteWithGoods:self.goodsinfo];
//    }
//}
/**
 * 左边的选择圆圈图片
 */
- (void)setSelectImageView
{
    for (UIControl *control in self.subviews)
    {
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")])
        {
            for (UIView *v in control.subviews)
            {
                control.backgroundColor = [UIColor whiteColor];
                if ([v isKindOfClass: [UIImageView class]])
                {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected)
                    {
                        img.image=[UIImage imageNamed:@"dot"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"dotNormal"];
                    }
                }
            }
        }
        else
        { // iOS7.1系统情况下
            for (UIView *v in control.subviews)
            {
                if ([v isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")])
                {
                    v.backgroundColor = [UIColor whiteColor];
                    for (UIView *imgV in v.subviews)
                    {
                        if ([imgV isKindOfClass:[UIImageView class]])
                        {
                            UIImageView *img=(UIImageView *)imgV;
                            if (self.selected)
                            {
                                img.image=[UIImage imageNamed:@"dot"];
                            }
                            else
                            {
                                img.image=[UIImage imageNamed:@"dotNormal"];
                            }
                        }
                    }
                    
                }
                
            }
            
        }
    }
}

- (void)storeAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSelectStoreWithGoods:)])
    {
        [self.delegate didSelectStoreWithGoods:self.goodsinfo];
    }
}

@end
