//
//  HYCommentAddOneStepCell.m
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddOneStepCell.h"
#import "UIImageView+WebCache.h"

@interface HYCommentAddOneStepCell ()
{
    BOOL _isReply;
    HYCommentAddOneStepModel *_secondStepInfo;
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_colorAndSizeLabel;
    UILabel *_priceLabel;
    UILabel *_numberLabel;
    UILabel *_totalLabel;
    
    UIButton *_commentBtn;  //去评价按钮
}
@end

@implementation HYCommentAddOneStepCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      //  _isReply = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, TFScalePoint(120), 16)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _colorAndSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, TFScalePoint(110), 16)];
        _colorAndSizeLabel.font = [UIFont systemFontOfSize:12];
        _colorAndSizeLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _colorAndSizeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_colorAndSizeLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, TFScalePoint(130), 16)];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)+10, 60, 120, 16)];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _numberLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_numberLabel];
        
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, TFScalePoint(130), 16)];
        _totalLabel.font = [UIFont systemFontOfSize:12];
        _totalLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _totalLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_totalLabel];
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(ScreenRect.size.width-80, 100, 70, 30);
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_commentBtn setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
        [_commentBtn addTarget:self
                             action:@selector(didSendCommentViewTitle:)
                   forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setBackgroundImage:[[UIImage imageNamed:@"mall_afterSaleType"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentBtn];
        
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:10.];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(84, 10, 230, 34);
}

- (void)didSendCommentViewTitle:(id)sender
{
        if ([self.delegate respondsToSelector:@selector(didSendCommentWithModel:)])
        {
            
            [self.delegate didSendCommentWithModel:_secondStepInfo];
        }
    
}

#pragma mark setter/getter
- (void)setGoodsInfo:(HYCommentAddOneStepModel *)goodsInfo
{
    
    _secondStepInfo = goodsInfo;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.thumbnailPicUrl]];
    _titleLabel.text = goodsInfo.productName;
    _colorAndSizeLabel.text = goodsInfo.specifications;
    _priceLabel.text = [NSString stringWithFormat:@"价格:¥%@+%ld现金券", goodsInfo.price, goodsInfo.points];
    _numberLabel.text = [NSString stringWithFormat:@"数量:%ld", goodsInfo.quantity];
    
    NSInteger price = [goodsInfo.price integerValue]*goodsInfo.quantity;
    NSInteger point = goodsInfo.points * goodsInfo.quantity;
    _totalLabel.text = [NSString stringWithFormat:@"小计:¥%ld+%ld现金券", (long)price, point];
    [self setCommentBtnStates:goodsInfo.isEvaluable];

}

#pragma mark - ----评论按钮显示的状态----
- (void)setCommentBtnStates:(NSInteger)isEvaluable
{
    switch (isEvaluable) {
        case 0:
            [_commentBtn setTitle:@"不可评价" forState:UIControlStateNormal];
            [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_commentBtn setEnabled:NO];
            break;
            
        case 1:
            [_commentBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _isReply = NO;
            [_commentBtn setEnabled:YES];
            break;
            
        case 2:
            [_commentBtn setTitle:@"追加评价" forState:UIControlStateNormal];
            [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _isReply = YES;
            [_commentBtn setEnabled:YES];
            break;
            
        case 3:
            [_commentBtn setTitle:@"已评论" forState:UIControlStateDisabled];
            [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_commentBtn setEnabled:NO];
            break;
    }
    
}

@end
