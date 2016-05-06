//
//  HYMyDesireDetailHeaderView.m
//  Teshehui
//
//  Created by Kris on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "HYZoomImage.h"
#import "HYUserInfo.h"
#import "HYImageInfo.h"

@interface HYMyDesireDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *descLab;


@end

@implementation HYMyDesireDetailHeaderView

- (instancetype)initMyNib
{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"HYMyDesireDetailHeaderView" owner:nil options:nil];
    
    return views.count > 0 ? views[0]:nil;
}

- (void)awakeFromNib
{
    
    self.topLineView.frame = CGRectMake(10, 56, [[UIScreen mainScreen] bounds].size.width - 20, 1);
    self.bottomLineView.frame = CGRectMake(10, 115, [[UIScreen mainScreen] bounds].size.width - 20, 1);
}

- (void)setHeaderViewWithModel:(HYMyDesireDetailModel *)model
{
    // 用户头像
    HYImageInfo *logoImage = [HYUserInfo getUserInfo].userLogo;
    NSURL *URL = [NSURL URLWithString:logoImage.defaultURL];
    [self.userHeaderImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"mine_default"] options:SDWebImageRefreshCached];
    
    if (model.contactName) {
        
        self.userNameLab.text = [NSString stringWithFormat:@"%@ (%@)", model.contactName, model.contactMobile];
    } else {
        
        self.userNameLab.text = [NSString stringWithFormat:@"%@", model.contactMobile];
    }
    
    NSArray *strArr = [model.wishTime componentsSeparatedByString:@" "];
    self.dateLab.text = strArr[0];
    
    self.titleLab.text = model.wishTitle;
    
    CGFloat wishContentWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat wishContentHeight = [model.wishContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(wishContentWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    self.descLab.frame = CGRectMake(14, 136, wishContentWidth, wishContentHeight);
    self.descLab.text = model.wishContent;
    
    for (NSInteger i = 0; i < model.wishPicList.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * TFScalePoint(100) + (i * TFScalePoint(5)) + TFScalePoint(5), CGRectGetMaxY(self.descLab.frame) + 16, TFScalePoint(100), TFScalePoint(100))];
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        [imgView addGestureRecognizer:tap];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.wishPicList[i]]];
    }
    
}

- (void)zoomImage:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    [HYZoomImage showImage:imgView];
}

@end
