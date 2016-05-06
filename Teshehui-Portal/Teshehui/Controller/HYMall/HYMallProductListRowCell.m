//
//  HYMallProductListRowCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/14.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallProductListRowCell.h"
#import "Masonry.h"
#import "HYMallHomeItem.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Addition.h"

@implementation HYMallProductListRowCell
{
    UIImageView *_img;
    UILabel *_title;
    UILabel *_price;
    UIButton *_video;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectZero];
        img.layer.borderColor = [UIColor colorWithWhite:.6 alpha:1].CGColor;
        img.layer.borderWidth = .5;
        img.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:img];
        _img = img;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = [UIFont systemFontOfSize:15.0];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.numberOfLines = 2;
        [self.contentView addSubview:title];
        _title = title;
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
        price.font = [UIFont systemFontOfSize:14.0];
        price.textColor = [UIColor colorWithWhite:.6 alpha:1];
        price.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:price];
        _price = price;
        
        UIImage *videoi = [UIImage imageNamed:@"home_video2"];
        videoi = [videoi imageWithSize:CGSizeMake(videoi.size.width*1.5, videoi.size.height*1.5)];
        UIButton *video = [[UIButton alloc] initWithFrame:CGRectZero];
        [video setImage:videoi forState:UIControlStateNormal];
        [video addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:video];
        _video = video;
        
        //layout
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(67, 67));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img.mas_right).offset(20);
            make.top.equalTo(img.mas_top);
            make.right.mas_equalTo(-20);
        }];
        
        [video mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(price.mas_centerY);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [price mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(img.mas_right).offset(20);
             make.bottom.equalTo(img.mas_bottom).offset(-10);
             make.right.equalTo(video.mas_left);
         }];
        [video setContentHuggingPriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

- (void)setItem:(HYProductListSummary *)item
{
    if (_item != item)
    {
        _item = item;
        if ([item isKindOfClass:[HYProductListSummary class]])
        {
            HYProductListSummary *summaryData = (HYProductListSummary *)item;
            [self setWithProductListSummaryData:summaryData];
        }
        else if ([item isKindOfClass:[HYMallHomeItem class]])
        {
            HYMallHomeItem *itemData = (HYMallHomeItem *)item;
            [self setWithHomeItem:itemData];
        }
    }
}

- (void)setWithProductListSummaryData:(HYProductListSummary *)data
{
    [_img sd_setImageWithURL:[NSURL URLWithString:data.productPicUrl]
                  placeholderImage:[UIImage imageNamed:@"logo_loading"]];
    _title.text = data.productName;
    
//    if (data.stock < 10)
//    {
//        [self.stockView setHidden:NO];
//        
//        if (data.stock > 0)
//        {
//            self.stockView.image = [UIImage imageNamed:@"stock_icon"];
//            _stockLabel.textColor = [UIColor whiteColor];
//            _stockLabel.text = [NSString stringWithFormat:@"剩余%ld件", data.stock];
//        }
//        else
//        {
//            self.stockView.image = [UIImage imageNamed:@"stock_icon_gray"];
//            _stockLabel.textColor = [UIColor blackColor];
//            _stockLabel.text = @"卖光了";//@"售罄";
//        }
//    }
//    else
//    {
//        [_stockView setHidden:YES];
//    }
    NSString *price = [NSString stringWithFormat:@"￥%@", data.price];
    NSString *point = [NSString stringWithFormat:@" + %ld现金券", (long)data.points];
    NSString *disp = [NSString stringWithFormat:@"%@%@", price, point];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:disp];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:230/255.0 green:0/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(0, price.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.43 alpha:1] range:NSMakeRange(price.length, point.length)];
    _price.attributedText = attr;
    
    if ([data.productVideoUrl length] > 0)
    {
        _video.hidden = NO;
    }else _video.hidden = YES;
}

- (void)setWithHomeItem:(HYMallHomeItem *)data
{
    [_img sd_setImageWithURL:[NSURL URLWithString:data.pictureUrl]
                  placeholderImage:[UIImage imageNamed:@"logo_loading"]];
    _title.text = data.name;
    
    //    if (data.stock < 10)
    //    {
    //        [self.stockView setHidden:NO];
    //
    //        if (data.stock > 0)
    //        {
    //            self.stockView.image = [UIImage imageNamed:@"stock_icon"];
    //            _stockLabel.textColor = [UIColor whiteColor];
    //            _stockLabel.text = [NSString stringWithFormat:@"剩余%d件", data.stock];
    //        }
    //        else
    //        {
    //            self.stockView.image = [UIImage imageNamed:@"stock_icon_gray"];
    //            _stockLabel.textColor = [UIColor blackColor];
    //            _stockLabel.text = @"卖光了";//@"售罄";
    //        }
    //    }
    //    else
    //    {
    //        [_stockView setHidden:YES];
    //    }
    if (data.marketPrice)
    {
        NSString *price = [NSString stringWithFormat:@"原价:￥%@", data.marketPrice];
        NSString *point = [NSString stringWithFormat:@" 现金券可抵%ld元", (long)data.points.integerValue];
        NSString *disp = [NSString stringWithFormat:@"%@%@", price, point];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:disp];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:230/255.0 green:0/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(0, price.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.43 alpha:1] range:NSMakeRange(price.length, point.length)];
        _price.attributedText = attr;
    }
    else
    {
        _price.attributedText = nil;
    }
    
    [_video setHidden:!(data.vidoUrl)];
}

- (void)videoAction:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(checkVideoWithURL:)]) {
        [_delegate checkVideoWithURL:[(HYMallHomeItem*)_item vidoUrl]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
