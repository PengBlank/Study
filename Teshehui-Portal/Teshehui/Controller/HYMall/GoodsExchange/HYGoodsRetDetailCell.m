//
//  HYGoodsRetDetailCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetDetailCell.h"

@implementation HYGoodsRetDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isGray = NO;
        self.selectable = NO;
        self.nessary = NO;
        
        CGFloat x = CGRectGetMinX(self.nessaryImage.frame);
        CGFloat y = CGRectGetMaxY(self.grayView.frame) - 5;
        CGFloat w = CGRectGetWidth(self.frame) - 2*x;
        CGFloat h = 50;
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        detailLab.numberOfLines = 0;
        detailLab.backgroundColor = [UIColor clearColor];
        detailLab.textColor = [UIColor grayColor];
        detailLab.font = [UIFont systemFontOfSize:14.0];
        //detailLab.text = @"广东省深圳市福田区车公庙泰然六路52号雪松大厦b座\n刘静 123*******";
        [self.contentView addSubview:detailLab];
        self.detailLab = detailLab;
    }
    return self;
}

- (void)setDetailContent:(NSString *)detailContent
{
    if (_detailContent != detailContent)
    {
        _detailContent = detailContent;
        CGFloat w = CGRectGetWidth(_detailLab.frame);
        CGSize size = [detailContent sizeWithFont:_detailLab.font constrainedToSize:CGSizeMake(w, 1000)];
        CGRect frame = _detailLab.frame;
        frame.size.height = size.height;
        _detailLab.frame = frame;
        _detailLab.text = detailContent;
        
        frame = self.bounds;
        frame.size.height = CGRectGetMaxY(_detailLab.frame) + 5;
        self.bounds = frame;
    }
}

+ (CGFloat)heightForDetailContent:(NSString *)content
{
    CGFloat w = 290;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(w, 50)];
    if (size.height > 0) {
        return size.height + 32;
    } else {
        return 42;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
