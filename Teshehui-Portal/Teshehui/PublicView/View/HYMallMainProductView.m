//
//  HYMallMainProductView.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMainProductView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Style.h"
#import "UIColor+hexColor.h"

@interface HYMallMainProductView ()
{
    UIImageView *_imageView;
    UILabel *_priceLab;
    UILabel *_titleLab;
}

@end

@implementation HYMallMainProductView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addCorner:3.0];
        [self addBorder:0.5*0.5 borderColor:[UIColor colorWithWhite:0.8 alpha:1]];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        CAShapeLayer *styleLayer = [CAShapeLayer layer];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                               cornerRadii:CGSizeMake(3.0, 3.0)];
        
        styleLayer.path = shadowPath.CGPath;
        _imageView.layer.mask = styleLayer;
        [self addSubview:_imageView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.width+8, self.frame.size.width-16, 30)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLab.numberOfLines = 2;
        _titleLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self addSubview:_titleLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-24, frame.size.width-20, 20)];
        _priceLab.font = [UIFont systemFontOfSize:14];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_priceLab];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //获取上下文
//    CGContextSaveGState(ctx);
    CGFloat dash[] = {2,1};
    CGContextSetLineDash(ctx, 2, dash, 2);
    CGContextSetLineWidth(ctx, 0.5*0.5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ctx, 8, rect.size.height-30);
    CGContextAddLineToPoint(ctx, rect.size.width-8, rect.size.height-30);
//    CGContextSetLineDash(ctx, 0.0, NULL, 0); //要画其他的线的话记得清理一下
    CGContextStrokePath(ctx);
//    CGContextRestoreGState(ctx);
}

#pragma mark setter/getter
- (void)setData:(id)data
{
    if (data != _data)
    {
        _data = data;
        
        if ([data isKindOfClass:[HYProductListSummary class]])
        {
            HYProductListSummary *product = (HYProductListSummary *)data;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:product.productPicUrl]
                          placeholderImage:nil];
            _titleLab.text = product.productName;
            
            if (product.marketPrice.length > 0)
            {
                NSString *point = [NSString stringWithFormat:@"现金券可抵%ld元", (long)product.points];
                NSString *total = [NSString stringWithFormat:@"￥%@ %@", product.marketPrice, point];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColor:@"d91512" alpha:1] range:NSMakeRange(0, product.marketPrice.length)];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, product.marketPrice.length)];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70/255.0 green:130/255.0 blue:230/255.0 alpha:1.0f] range:NSMakeRange(product.marketPrice.length+1, point.length)];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(product.marketPrice.length+1, point.length)];
                _priceLab.attributedText = attr;
                
            }
        }
    }
}
@end
