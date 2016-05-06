//
//  HYMallProductListTableViewHeaderView.m
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallProductListTableViewHeaderView.h"
#import "Masonry.h"
#import "HYScreenTransformHeader.h"
#import "UIImageView+WebCache.h"

@interface HYMallProductListTableViewHeaderView ()
<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *mainIntroLabel;
//you cannot use weak,because the gesture on it may be release
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandCountry;

@property (nonatomic, assign) CGFloat contentHeight;


@end

@implementation HYMallProductListTableViewHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _mainImage.frame = TFRectMake(0, 0, 320, 162);
    _brandImage.frame = CGRectMake(10,
                                   CGRectGetMaxY(_mainImage.frame)-TFScalePoint(38)/2,
                                   TFScalePoint(52),
                                   TFScalePoint(38));
    _brandImage.layer.borderColor = [[UIColor colorWithWhite:0.8
                                                       alpha:1.0] CGColor];
    _brandImage.layer.borderWidth = 1.0f;
    
    _brandLabel.frame = CGRectMake(CGRectGetMaxX(_brandImage.frame)+10,
                                   CGRectGetMaxY(_mainImage.frame)+4,
                                   TFScalePoint(320)-CGRectGetMaxX(_brandImage.frame)+10,
                                   20);
    _brandCountry.frame = CGRectMake(10,
                                     CGRectGetMaxY(_brandImage.frame)+10,
                                     TFScalePoint(200),
                                     20);
    
    _mainIntroLabel.numberOfLines = 200;
    _mainIntroLabel.lineBreakMode = NSLineBreakByClipping;
    _mainIntroLabel.textColor = [UIColor grayColor];
    _mainIntroLabel.frame = CGRectMake(10,
                                       CGRectGetMaxY(_brandCountry.frame)+5,
                                       TFScalePoint(300),
                                       50);
    
    _mainImage.clipsToBounds = YES;
    _brandImage.clipsToBounds = YES;
    
    [_arrowBtn setHidden:YES];
    
    _contentHeight = TFScalePoint(192);
}

- (IBAction)arrowBtnClick:(id)sender
{
    _arrowBtn.selected = !_arrowBtn.isSelected;
    
    if (_arrowBtn.isSelected)
    {
        NSDictionary *attribute = @{NSFontAttributeName: _mainIntroLabel.font};
        CGRect rect1 = [self.data.brandStory boundingRectWithSize:CGSizeMake(CGRectGetWidth(_mainIntroLabel.frame), CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:attribute
                                                     context:nil];
        CGSize size = rect1.size;
        
        size.height += 10;

        CGRect rect = _mainIntroLabel.frame;
        rect.size = size;
        _mainIntroLabel.frame = rect;
        _mainIntroLabel.text = _data.brandStory;
        
        _contentHeight = CGRectGetMaxY(rect)+20;
        _arrowBtn.frame = CGRectMake(CGRectGetMidX(self.frame)-60,
                                     CGRectGetMaxY(_mainIntroLabel.frame),
                                     120, 20);
        [_arrowBtn setImage:[UIImage imageNamed:@"brand_arrowUp"]
                   forState:UIControlStateNormal];
    }
    else
    {
        CGRect rect = _mainIntroLabel.frame;
        rect.size.height = 50;
        _mainIntroLabel.frame = rect;
        _mainIntroLabel.text = _data.brandStory;

        _contentHeight = CGRectGetMaxY(rect)+20;
        
        _arrowBtn.frame = CGRectMake(CGRectGetMidX(self.frame)-60,
                                     CGRectGetMaxY(_mainIntroLabel.frame),
                                     120, 20);
        [_arrowBtn setImage:[UIImage imageNamed:@"brand_arrowDown"]
                   forState:UIControlStateNormal];

    }
    
    if ([self.delegate respondsToSelector:@selector(contentHeightHasChange)])
    {
        [self.delegate contentHeightHasChange];
    }
}

#pragma mark getter & setter
-(void)setData:(HYMallBrandStory *)data
{
    if (data != _data)
    {
        _data = data;
        
        if (data.brandName.length > 0)
        {
            _brandLabel.text = data.brandName;
        }
        
        if (data.brandCountry.length > 0)
        {
            _brandCountry.text = [NSString stringWithFormat:@"品牌国家：%@",_data.brandCountry];
        }
        
        if (data.brandStory.length > 0)
        {
            NSDictionary *attribute = @{NSFontAttributeName: _mainIntroLabel.font};
            
            CGRect rect1 = [data.brandStory boundingRectWithSize:CGSizeMake(CGRectGetWidth(_mainIntroLabel.frame), CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:attribute
                                                         context:nil];
            
            CGSize size = rect1.size;
            size.height += 10;
            
            CGRect rect = _mainIntroLabel.frame;
            rect.size = size;
            
            //超过50高度，缩起
            if (rect.size.height > 50)
            {
                rect.size.height = 50;
                
                _mainIntroLabel.frame = rect;
                _mainIntroLabel.text = _data.brandStory;
                
                _arrowBtn.hidden = NO;
                _arrowBtn.frame = CGRectMake(CGRectGetMidX(_mainImage.frame)-60,
                                             CGRectGetMaxY(_mainIntroLabel.frame),
                                             120, 20);
                
                _contentHeight = CGRectGetMaxY(rect)+20;
            }
            else
            {
                _mainIntroLabel.frame = rect;
                _mainIntroLabel.text = _data.brandStory;
                
                _contentHeight = CGRectGetMaxY(rect);
            }
        }
        
        if (data.bannerImage.length > 0)
        {
            [_mainImage sd_setImageWithURL:[NSURL URLWithString:data.bannerImage]];
        }
        
        if (data.logoUrl.length > 0)
        {
            [_brandImage sd_setImageWithURL:[NSURL URLWithString:data.logoUrl]];
        }
    }
}

@end
