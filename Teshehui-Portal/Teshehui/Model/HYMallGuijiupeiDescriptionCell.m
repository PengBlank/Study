//
//  HYMallGuijiupeiDescriptionCell.m
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallGuijiupeiDescriptionCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface HYMallGuijiupeiDescriptionCell ()
{
    UILabel *_descriptionLabel;
    UILabel *_descriptionDetailLabel;
}

@end

@implementation HYMallGuijiupeiDescriptionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.frame = CGRectMake(20, 10, 50, 30);
        _descriptionLabel.text = @"描述";
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_descriptionLabel];
        
        _descriptionDetailLabel = [UILabel new];
        _descriptionDetailLabel.font = [UIFont systemFontOfSize:14];
        _descriptionDetailLabel.frame = CGRectMake(20, CGRectGetMaxY(_descriptionLabel.frame), ScreenRect.size.width-40, 75);
        _descriptionDetailLabel.numberOfLines = 0;
        [self.contentView addSubview:_descriptionDetailLabel];
    }
    return self;
}

-(void)setDescriptionData:(HYIndemnityinfo *)descriptionData
{
    _descriptionData = descriptionData;
    
    if (_descriptionData.desc)
    {
        _descriptionDetailLabel.text = _descriptionData.desc;
    }
    
    if (_descriptionData.imgs.count > 0)
    {
        int index = 0;
        for (NSString *url in _descriptionData.imgs)
        {
            UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(20+TFScalePoint(92)*index,
                                                                                   CGRectGetMaxY(_descriptionDetailLabel.frame),
                                                                                   TFScalePoint(72),
                                                                                   TFScalePoint(72))];
            [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:url]
                                           forState:UIControlStateNormal
                                   placeholderImage:[UIImage imageNamed:@"loading"]];
            imageView.tag = [_descriptionData.imgs indexOfObject:url] + 1;
            [imageView addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:imageView];
            index++;
        }
    }
    
}

- (void)imgClick:(UIButton *)btn
{
    if (self.didClickImage) {
        self.didClickImage(btn.tag - 1);
    }
}

@end
