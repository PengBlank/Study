//
//  HYMallBrandCellBtn.m
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallBrandCellBtn.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

@interface HYMallBrandCellBtn ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIButton *clickBtn;
@property (strong, nonatomic) UILabel *secTextLabel;
@property (strong, nonatomic) id data;

@end

@implementation HYMallBrandCellBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-20);
        [self addSubview:_clickBtn];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(frame)-20,
                                                               frame.size.width,
                                                               20)];
        [_textLabel setFont:[UIFont systemFontOfSize:17]];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    
    return self;
}

-(void)setData:(HYMallBrandSecModel *)data
{
    _data = data;
    
    [_clickBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if ([_data isKindOfClass:[HYMallBrandSecModel class]])
    {
        HYMallBrandSecModel *model = _data;
        
        if (model.logoPath.length > 0)
        {
            NSURL *url = [NSURL URLWithString:model.logoPath];
            if (url)
            {
                [_clickBtn sd_setBackgroundImageWithURL:url
                                               forState:UIControlStateNormal];
                [_clickBtn sd_setBackgroundImageWithURL:url
                                               forState:UIControlStateSelected];
                _clickBtn.clipsToBounds = YES;
                _clickBtn.backgroundColor = [UIColor whiteColor];
            }
        }
        if (model.brandName.length > 0)
        {
            _textLabel.textColor = [UIColor grayColor];
            _textLabel.font = [UIFont systemFontOfSize:15];
            _textLabel.text = model.brandName;
        }
    }
    else if ([_data isKindOfClass:[HYMallGuessYouLikeModel class]])
    {
        HYMallGuessYouLikeModel *model = _data;
        
        if (model.mainImageBo.imageUrl.length > 0)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.mainImageBo.imageUrl,model.mainImageBo.imageFileType]];
            if (url)
            {
                [_clickBtn sd_setBackgroundImageWithURL:url
                                               forState:UIControlStateNormal
                                       placeholderImage:[UIImage imageNamed:@"logo_loading"]];
                [_clickBtn sd_setBackgroundImageWithURL:url
                                               forState:UIControlStateSelected
                                       placeholderImage:[UIImage imageNamed:@"logo_loading"]];
                _clickBtn.clipsToBounds = YES;
                _clickBtn.backgroundColor = [UIColor whiteColor];
            }
        }
    
        if (model.marketPrice.length > 0)
        {
            _textLabel.text = [NSString stringWithFormat:@"￥%@",model.marketPrice];
            _textLabel.textColor = [UIColor redColor];
        }
        
        if (model.points.length > 0)
        {
            WS(weakSelf);
            self.secTextLabel = [[UILabel alloc]init];
            [self addSubview:self.secTextLabel];
            
            [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).with.offset(0);
                make.left.equalTo(weakSelf).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90), TFScalePoint(90)));
            }];
            
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.clickBtn).with.offset(0);
                make.right.equalTo(weakSelf.clickBtn).with.offset(0);
                make.top.equalTo(weakSelf.clickBtn.mas_bottom).with.offset(0);
                make.height.mas_equalTo(@16);
            }];

            [self.secTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.textLabel).with.offset(0);
                make.right.equalTo(weakSelf.textLabel).with.offset(0);
                make.top.equalTo(weakSelf.textLabel.mas_bottom).with.offset(4);
                make.height.mas_equalTo(@16);
//                make.centerX.equalTo(weakSelf);
            }];
            
            self.secTextLabel.textAlignment = NSTextAlignmentCenter;
            self.secTextLabel.textColor = [UIColor lightGrayColor];
            self.secTextLabel.font = [UIFont systemFontOfSize:12];
            self.secTextLabel.text = [NSString stringWithFormat:@"现金券可抵%@元",model.points];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

@end
