//
//  HYGoodsRetGrayCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetGrayCell.h"
#import "UIView+Style.h"

@interface HYGoodsRetGrayCell ()



@end

@implementation HYGoodsRetGrayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(ScreenRect), 42);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectable = YES;
        self.nessary = YES;
        self.isGray = YES;
        
        CGFloat x = 15;
        CGFloat h = 40;
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, CGRectGetWidth(ScreenRect)-2*x, h)];
        [grayView addCorner:3];
        grayView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [self.contentView addSubview:grayView];
        self.grayView = grayView;
        
        //红星
        UIImage *nesImage = [UIImage imageNamed:@"g_ret_nes.png"];
        x = CGRectGetMinX(grayView.frame) + 3;
        CGFloat y = CGRectGetMidY(grayView.bounds) - nesImage.size.height/2;
        UIImageView *nessaryImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, nesImage.size.width, nesImage.size.height)];
        nessaryImage.image = nesImage;
        [self.contentView addSubview:nessaryImage];
        self.nessaryImage = nessaryImage;
        
        x = CGRectGetMaxX(nessaryImage.frame) + 2;
        y = 0;
        UILabel *keyLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, CGRectGetHeight(grayView.bounds))];
        keyLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:keyLab];
        self.keyLab = keyLab;
        
        x = CGRectGetMaxX(keyLab.frame) + 5;
        y = 0;
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150, CGRectGetHeight(grayView.bounds))];
        valueLab.backgroundColor = [UIColor clearColor];
        valueLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:valueLab];
        self.valueLab = valueLab;
        
        UIImage *indicator = [UIImage imageNamed:@"cell_indicator"];
        x = CGRectGetMaxX(grayView.frame) - indicator.size.height - 5;
        y = CGRectGetMidY(grayView.bounds) - indicator.size.width/2;
        UIImageView *indicatorV = [[UIImageView alloc] initWithImage:indicator];
        indicatorV.transform = CGAffineTransformMakeRotation(M_PI_2);
        indicatorV.frame = CGRectMake(x, y, indicator.size.height, indicator.size.width);
        [self.contentView addSubview:indicatorV];
        self.indicator = indicatorV;
    }
    return self;
}

- (void)setIsGray:(BOOL)isGray
{
    if (_isGray != isGray) {
        _isGray = isGray;
        if (isGray) {
            self.grayView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        else
        {
            self.grayView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setNessary:(BOOL)nessary
{
    if (nessary!= _nessary) {
        _nessary = nessary;
        if (nessary)
        {
            self.nessaryImage.hidden = NO;
            CGRect frame = self.keyLab.frame;
            frame.origin.x = CGRectGetMaxX(_nessaryImage.frame) + 2;
            self.keyLab.frame = frame;
        }
        else
        {
            self.nessaryImage.hidden = YES;
            CGRect frame = self.keyLab.frame;
            frame.origin.x = CGRectGetMinX(_nessaryImage.frame);
            self.keyLab.frame = frame;
        }
    }
}

- (void)setSelectable:(BOOL)selectable
{
    if (_selectable != selectable)
    {
        _selectable = selectable;
        self.indicator.hidden = !selectable;
        CGRect frame = _valueLab.frame;
        CGFloat xoff = selectable ? CGRectGetMinX(_indicator.frame) :
                            CGRectGetMaxX(_grayView.frame);
        frame.size.width = xoff - CGRectGetMinX(frame);
        _valueLab.frame = frame;
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_isGray && _selectable)
    {
        __weak HYGoodsRetGrayCell *b_self = self;
        if (selected) {
            [UIView animateWithDuration:.3 animations:^{
                b_self.grayView.backgroundColor = [UIColor darkGrayColor];
            }];
        }
        else
        {
            [UIView animateWithDuration:.3 animations:^{
                b_self.grayView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:235/255.0 alpha:1];;
            }];
        }
    }
    
}

@end
