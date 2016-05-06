//
//  HYPassengerListCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPassengerListCell.h"
#import "NSString+Common.h"

@interface HYPassengerListCell ()
{
    UIImageView *_checkImageView;
    UILabel *_cardIDLab;
    UILabel *_phoneNumberLab;
    UILabel *_cardTitle;
    NSInteger _length;
    NSInteger _location;
}
@end

@implementation HYPassengerListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _showCheckBox = YES;
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 18, 18)];
        _checkImageView.image = [UIImage imageNamed:@"checkbox_unselected"];
        [self.contentView addSubview:_checkImageView];
        

//        _eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _eidtBtn.frame = CGRectMake(ScreenRect.size.width-80, 0, 80, 44);
//        [_eidtBtn setImage:[UIImage imageNamed:@"icon_dest_review"]
//                  forState:UIControlStateNormal];
//        [_eidtBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//        [self.contentView addSubview:_eidtBtn];

        _cardTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 60, 20)];
        _cardTitle.font = [UIFont systemFontOfSize:14];
        _cardTitle.textColor = [UIColor grayColor];
//        _cardTitle.backgroundColor = [UIColor orangeColor];
        [self addSubview:_cardTitle];
        
        _cardIDLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, 160, 20)];
        _cardIDLab.font = [UIFont systemFontOfSize:14];
//        _cardIDLab.backgroundColor = [UIColor redColor];
        _cardIDLab.textColor = [UIColor grayColor];
        [self addSubview:_cardIDLab];
        
        _phoneNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, TFScalePoint(250), 20)];
        _phoneNumberLab.font = [UIFont systemFontOfSize:14];
        _phoneNumberLab.textColor = [UIColor grayColor];
//        _phoneNumberLab.backgroundColor = [UIColor blueColor];
        [self addSubview:_phoneNumberLab];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat org_x = _showCheckBox ? 34: 16;
    self.textLabel.frame = CGRectMake(org_x, 10, 200, 18);
}

#pragma mark setter/getter
- (void)setPassenger:(HYPassengers *)passenger
{
    if (passenger != _passenger)
    {
        _passenger = passenger;
    }
    
    _cardTitle.text = passenger.cardName;
//    _cardTitle.backgroundColor = [UIColor redColor];
    CGSize size  = [passenger.cardName sizeWithFont:[UIFont systemFontOfSize:14]];
    _cardTitle.frame = CGRectMake(15, 30, size.width, 20);
    
    self.textLabel.text = passenger.name;
    self.textLabel.textColor = [UIColor grayColor];
  //  self.detailTextLabel.text = passenger.cardID;
    
    _cardIDLab.text = [NSString turnToSecurityNum:passenger.cardID];

//    CGSize idSize  = [passenger.cardID sizeWithFont:[UIFont systemFontOfSize:14]];
//    _cardIDLab.frame = CGRectMake(CGRectGetMaxX(_cardTitle.frame) + 25, 30, idSize.width, 20);
    _cardIDLab.frame = CGRectMake(140, 30, 150, 20);
    if (passenger.phone)
    {
        
        _phoneNumberLab.text = [NSString stringWithFormat:@"手机号码                  %@", passenger.phone];
    }
    else
    {    
        _phoneNumberLab.text = @"";
    }
    
    [self setIsCheck:passenger.isSelected];
}

- (void)setIsCheck:(BOOL)isCheck
{
    if (isCheck != _isCheck)
    {
        _isCheck = isCheck;
        NSString *imageName = isCheck ? @"checkbox_selected" : @"checkbox_unselected";
        _checkImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setShowCheckBox:(BOOL)showCheckBox
{
    if (showCheckBox != _showCheckBox)
    {
        _showCheckBox = showCheckBox;
        [_checkImageView setHidden:!showCheckBox];
    }
}

@end
