//
//  HYMineInfoHeadCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMineInfoHeadCell.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"
#import "HYImageButton.h"

@interface HYMineInfoHeadCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UIImageView *photoV;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, weak) IBOutlet UIImageView *photoBgV;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, weak) IBOutlet UIImageView *levelIcon;
@property (weak, nonatomic) IBOutlet UIImageView *card;


@end

@implementation HYMineInfoHeadCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.frame = CGRectMake(0, 0, ScreenRect.size.width, self.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoAction:)];
    self.photoV.userInteractionEnabled = YES;
    [self.photoV addGestureRecognizer:tap];
    
    UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameAction:)];
//    self.nameLab.userInteractionEnabled = YES;
//    [self.nameLab addGestureRecognizer:nametap];
    [self.contentView addGestureRecognizer:nametap];
    
    self.photoV.layer.cornerRadius = self.photoV.frame.size.width/2;
    self.photoV.layer.masksToBounds = YES;
    [self setIsLogin:YES];
    
    /// 新版登录按钮
    self.loginBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLogin:(BOOL)isLogin
{
    if (_isLogin != isLogin)
    {
        _isLogin = isLogin;
        if (isLogin)
        {
            self.loginBtn.hidden = YES;
            
            self.nameLab.hidden = NO;
            self.menuView.hidden = NO;
            self.levelIcon.hidden = NO;
            self.card.hidden = NO;
            
            self.photoBgV.center = CGPointMake(55, 50);
            self.photoV.center = CGPointMake(55, 50);
        }
        else
        {
            self.loginBtn.hidden = NO;
            self.nameLab.hidden = YES;
            self.menuView.hidden = YES;
            self.levelIcon.hidden = YES;
            self.card.hidden = YES;
            
            self.photoBgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-10);
            self.photoV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-10);
            self.photoV.image = [UIImage imageNamed:@"mine_default"];
        }
    }
}

- (void)setUserinfo:(HYUserInfo *)userinfo
{
    if (_userinfo != userinfo)
    {
        _userinfo = userinfo;
        if (!_isLogin) {
            return;
        }
        NSString *display = userinfo.nickName.length > 0 ? userinfo.nickName : userinfo.realName;
        if (display.length == 0)
        {
            display = userinfo.mobilePhone;
        }
        self.nameLab.text = [NSString stringWithFormat:@"您好，%@", display];
        
        /// 实名认证标志
        //  布局：y轴由xib确定，x根据用户名子计算得出
        [self.nameLab sizeToFit];
        CGSize cardSize = CGSizeMake(14, 10);
        if (CGRectGetMaxX(_nameLab.frame) + cardSize.width > self.frame.size.width)
        {
            _nameLab.frame = CGRectMake(_nameLab.frame.origin.x, _nameLab.frame.origin.y, _nameLab.frame.size.width-cardSize.width, _nameLab.frame.size.height);
        }
        _card.frame = CGRectMake(CGRectGetMaxX(_nameLab.frame) + 5, _card.frame.origin.y, cardSize.width, cardSize.height);
        if ([userinfo.idAuthentication isEqualToString:@"1"])
        {
            _card.image = [UIImage imageNamed:@"mine_cardConfirm"];
        }else
        {
            _card.image = [UIImage imageNamed:@"mine_cardUnConfirm"];
        }
        
        /// 头像
        if (userinfo.userLogo)
        {
            NSURL *URL = [NSURL URLWithString:userinfo.userLogo.defaultURL];
            [self.photoV sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"mine_default"] options:SDWebImageRefreshCached];
        }
        
        /// 菜单项
        if (userinfo)
        {
            self.menuView.hidden = NO;
            for (UIView *view in self.menuView.subviews)
            {
                if (view.tag > 0)
                {
                    [view removeFromSuperview];
                }
            }
            BOOL reviewd = [[NSUserDefaults standardUserDefaults] boolForKey:kIsReviewed];
            NSIndexPath *types = nil;
            if (_userinfo.userLevel == 0)
            {
                NSUInteger index[] = {MyCard, Fuli, Upgrade};
                types = [NSIndexPath indexPathWithIndexes:index length:3];
            }
            else if (_userinfo.userType==Normal_User || _userinfo.userType==Enterprise_Member)
            {
                if (reviewd)
                {
                    NSUInteger index[] = {MyCard, Xubao};
                    types = [NSIndexPath indexPathWithIndexes:index length:2];
                }
                else
                {
                    NSUInteger index[] = {MyCard};
                    types = [NSIndexPath indexPathWithIndexes:index length:1];
                }
            }
            else if (_userinfo.userType == Enterprise_User)
            {
                if (reviewd)
                {
                    NSUInteger index[] = {MyCard, Xubao};
                    types = [NSIndexPath indexPathWithIndexes:index length:2];
                }
                else
                {
                    
                }
            }
            
            NSDictionary *titleMap = @{@(MyCard): @"我的名片",
                                       @(Xubao): @"会员续费",
                                       @(Fuli): @"会员权益",
                                       @(Upgrade): @"升级会员",
                                       @(Member): @"我的员工"};
            NSDictionary *iconMap = @{@(MyCard): @"mine_icon_mingpian",
                                      @(Xubao): @"mine_icon_xufei",
                                      @(Fuli): @"mine_icon_fuli",
                                      @(Upgrade): @"mine_icon_shengji",
                                      @(Member): @"mine_icon_mingpian"};
            if (types != nil && types.length > 0)
            {
                CGFloat width = (CGRectGetWidth(ScreenRect)-(types.length-1)) / (CGFloat)types.length;
                CGFloat x = 0;
                for (int i = 0; i < types.length; i++)
                {
                    NSUInteger type = [types indexAtPosition:i];
                    HYImageButton *btn = [[HYImageButton alloc] initWithFrame:CGRectMake(x, 0, width, self.menuView.frame.size.height)];
                    btn.type = ImageButtonTypeTitleFirst;
                    btn.spaceInTestAndImage = 5;
                    [btn setTitle:titleMap[@(type)] forState:UIControlStateNormal];
                    UIImage *image = [UIImage imageNamed:iconMap[@(type)]];
                    [btn setImage:image forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                    btn.tag = type;
                    [btn addTarget:self
                            action:@selector(btnAction:)
                  forControlEvents:UIControlEventTouchUpInside];
                    [self.menuView addSubview:btn];
                    
                    x += width + 1;
                }
            }
        }
        else
        {
            self.menuView.hidden = YES;
        }
        
        //判断钻石和认证用户
        if (userinfo)
        {
            if (userinfo.userLevel > 0)
            {
                _levelIcon.image = [UIImage imageNamed:@"mine_icon_fufei"];
            }
            else if (userinfo.userLevel < 0)
            {
                _levelIcon.image = [UIImage imageNamed:@"mine_icon_tiyan"];
            }
            else
            {
                _levelIcon.image = [UIImage imageNamed:@"mine_icon_tiyan"];
            }
            [_levelIcon sizeToFit];
        }
        else
        {
            _levelIcon.hidden = YES;
            _card.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //layout the level icon!
//    CGSize tsize = [self.nameLab.text sizeWithFont:_nameLab.font constrainedToSize:_nameLab.frame.size];
//    CGRect frame = _levelIcon.frame;
//    frame.origin.x = CGRectGetMinX(_nameLab.frame) + tsize.width;
//    _levelIcon.frame = frame;
}

- (IBAction)btnAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(headCellDidClickWithMenuType:)])
    {
        [self.delegate headCellDidClickWithMenuType:(HYMineInfoMenuType)[sender tag]];
    }
}

- (IBAction)loginAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(headCellDidClickLogin)])
    {
        [self.delegate headCellDidClickLogin];
    }
}

- (void)photoAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(headCellDidClickPhoto)])
    {
        [self.delegate headCellDidClickPhoto];
    }
}

- (void)nameAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(headCellDidClickUserName)])
    {
        [self.delegate headCellDidClickUserName];
    }
}

@end
