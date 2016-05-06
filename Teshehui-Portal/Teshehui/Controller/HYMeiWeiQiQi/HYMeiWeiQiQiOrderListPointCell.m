//
//  HYMeiWeiQiQiOrderListPointCell.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListPointCell.h"

@interface HYMeiWeiQiQiOrderListPointCell ()
{
    UILabel *_pointTitleLab;
    UILabel *_pointNumberLab;
}

@end

@implementation HYMeiWeiQiQiOrderListPointCell

+ (HYMeiWeiQiQiOrderListPointCell *)setCellWithTableView:(UITableView *)tableView
{
    static NSString *pointCellId = @"pointCellId";
    HYMeiWeiQiQiOrderListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:pointCellId];
    if (!cell)
    {
        cell = [[HYMeiWeiQiQiOrderListPointCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:pointCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _pointNumberLab = [[UILabel alloc] init];
        _pointNumberLab.font = [UIFont systemFontOfSize:14];
//        _pointNumberLab.backgroundColor = [UIColor redColor];
        _pointTitleLab = [[UILabel alloc] init];
        _pointTitleLab.font = [UIFont systemFontOfSize:14];
//        _pointTitleLab.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_pointNumberLab];
        [self.contentView addSubview:_pointTitleLab];
    }
    return self;
}

- (void)setPointNumber:(NSString *)str
{
    _pointNumberLab.text = str;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]];
    _pointNumberLab.frame = CGRectMake(TFScalePoint(300) - size.width, 10, size.width, 20);
    CGFloat x = CGRectGetMinX(_pointNumberLab.frame) - 80;
    _pointTitleLab.frame = CGRectMake(x, 10, 80, 20);
    _pointTitleLab.text = @"赠现金券数:";
}

@end
