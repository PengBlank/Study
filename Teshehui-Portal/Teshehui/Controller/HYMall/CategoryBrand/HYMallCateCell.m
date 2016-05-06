//
//  HYMallCateCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallCateCell.h"
#import "UIImageView+WebCache.h"

@interface HYMallCateCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *contentImg;

@end

@implementation HYMallCateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *content = [[UIImageView alloc] initWithFrame:self.bounds];
        content.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        content.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:content];
        self.contentImg = content;
        
        /*
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40,
                                                                   CGRectGetMidY(self.contentView.frame)-TFScalePoint(30)/2, TFScalePoint(54),
                                                                   TFScalePoint(30))];
        title.text = @"标题";
        title.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        title.layer.cornerRadius = 3.0;
        title.textAlignment = NSTextAlignmentCenter;
        title.clipsToBounds = YES;
        title.font = [UIFont systemFontOfSize:15.0];
        title.textColor = [UIColor whiteColor];
        [self.contentView addSubview:title];
        title.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.titleLab = title;
         */
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setCateInfo:(HYMallCategoryInfo *)cateInfo
{
    if (_cateInfo != cateInfo)
    {
        _cateInfo = cateInfo;
        [self.contentImg sd_setImageWithURL:[NSURL URLWithString:cateInfo.thumbnail_tetragonal]
                           placeholderImage:nil];
        
//        [self.titleLab setText:cateInfo.cate_name];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
