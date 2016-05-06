//
//  HYMallHomeFashionView.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeFashionView.h"
#import "UIImageView+WebCache.h"

@interface HYMallHomeFashionView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *cateLab;

@end

@implementation HYMallHomeFashionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        self.imgView = imgView;
        
        CGFloat height = frame.size.height * 0.23;
        UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-height, frame.size.width, height)];
        mask.backgroundColor = [UIColor whiteColor];
        mask.alpha = .5;
        [self addSubview:mask];
        
        UILabel *label = [[UILabel alloc] initWithFrame:mask.frame];
        label.font = [UIFont systemFontOfSize:14.0];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.cateLab = label;
    }
    return self;
}

- (void)setImgName:(NSString *)imgName
{
    if (_imgName != imgName)
    {
        _imgName = imgName;
        if (imgName.length > 0)
        {
            NSURL *url = [NSURL URLWithString:imgName];
            [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        }
    }
}

- (void)setCategory:(NSString *)category
{
    if (_category != category)
    {
        _category = category;
        self.cateLab.text = category;
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
