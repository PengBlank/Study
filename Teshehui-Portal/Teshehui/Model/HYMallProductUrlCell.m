//
//  HYMallProductUrlCell.m
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallProductUrlCell.h"

@interface HYMallProductUrlCell ()
{
    UIButton *_productUrlBtn;
    UILabel *_urlLabel;
}

@end

@implementation HYMallProductUrlCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _productUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _productUrlBtn.frame = CGRectMake(10, 10, 100, 30);
        [_productUrlBtn setTitle:@"商品链接" forState:UIControlStateNormal];
        [_productUrlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _productUrlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _productUrlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_productUrlBtn setImage:[UIImage imageNamed:@"mall_productAsk"] forState:UIControlStateNormal];
        [self.contentView addSubview:_productUrlBtn];
        
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_productUrlBtn.frame), TFScalePoint(300), 25)];
        _urlLabel.font = [UIFont systemFontOfSize:14];
        _urlLabel.textColor = [UIColor blackColor];
        _urlLabel.frame = CGRectMake(10, CGRectGetMaxY(_productUrlBtn.frame), TFScalePoint(300), 25);
        _urlLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _urlLabel.numberOfLines = 0;
        [self.contentView addSubview:_urlLabel];
    }
    return self;
}

-(void)setUrlString:(NSString *)urlString
{
    if (urlString != _urlString)
    {
        _urlString = urlString;
        
        CGSize size = [urlString sizeWithFont:_urlLabel.font
                            constrainedToSize:CGSizeMake(TFScalePoint(300), MAXFLOAT)];
        
        CGRect frame = _urlLabel.frame;
        frame.size.height = size.height+4;
        frame.size.width = size.width+2;
        _urlLabel.frame = frame;
        
        _urlLabel.text = _urlString;
    }
}

@end
