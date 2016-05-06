//
//  HYComparePriceCell.m
//  Teshehui
//
//  Created by Kris on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYComparePriceCell.h"
#import "UIImageView+WebCache.h"

@interface HYComparePriceCell ()

@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *summary;

@end

@implementation HYComparePriceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _price = [UILabel new];
        _price.frame = TFRectMake(70, 10, 150, 20);
        _price.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
        _price.textColor = [UIColor colorWithRed:0.97f green:0.51f blue:0.04f alpha:1.0f];
        [self.contentView addSubview:_price];
        
        _summary = [UILabel new];
        _summary.frame = TFRectMake(70, 35, 220, 30);
        _summary.font = [UIFont systemFontOfSize:TFScalePoint(11)];
        _summary.numberOfLines = 2;
        [self.contentView addSubview:_summary];
        
        [self.imageView setFrame:TFRectMake(10, 10, 50, 50)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:TFRectMake(10, 10, 50, 50)];
}

#pragma mark getter and setter
-(void)setData:(HYProductSKUWebPriceArrayModel *)data
{
    _data = data;
    
    if (_data)
    {
        if ([_data.price length] > 0)
        {
            if (_data.typeName || _data.price)
            {
                _price.text = [NSString stringWithFormat:@"%@ ￥%.1f",_data.typeName,[_data.price floatValue]];
            }
        }
        if ([_data.title length] > 0)
        {
            _summary.text = [NSString stringWithFormat:@"%@",_data.title];
            //            CGSize size = [_summary.text sizeWithFont:_summary.font constrainedToSize:CGSizeMake(TFScalePoint(250), MAXFLOAT) ];
        }
        if ([_data.imageUrl length] > 0)
        {
//            __weak __typeof(self) weakSelf = self;
//            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:_data.imageUrl] options:SDWebImageHandleCookies | SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakSelf.imageView.image = image;
//                });
//            }];
            NSURL *url = [NSURL URLWithString:_data.imageUrl];
            [self.imageView sd_setImageWithURL:url];
        }
    }
    
}

@end
