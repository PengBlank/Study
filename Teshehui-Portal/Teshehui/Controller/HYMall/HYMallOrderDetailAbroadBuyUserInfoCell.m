//
//  HYMallOrderListAbroadBuyUserInfoCell.m
//  Teshehui
//
//  Created by HYZB on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailAbroadBuyUserInfoCell.h"
#import "HYMallChildOrder.h"


@interface HYMallOrderDetailAbroadBuyUserInfoCell ()
{
    UIView *_userInfoV; // 海淘用户身份信息展示
    UILabel *_identificationInfoLab;
    UILabel *_realNameInfoLab;
}

@end

@implementation HYMallOrderDetailAbroadBuyUserInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cellID";
    HYMallOrderDetailAbroadBuyUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[HYMallOrderDetailAbroadBuyUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
};

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *userInfoV = [[UIView alloc]
                             initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 50)];
        userInfoV.hidden = YES;
        _userInfoV = userInfoV;
        [self.contentView addSubview:userInfoV];
        
        CGFloat y = 18;
        UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, y, 18, 18)];
        leftIcon.image = [UIImage imageNamed:@"icon_user_abroadbuy"];
        [_userInfoV addSubview:leftIcon];
        
        UILabel *identificationLab = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 50, 20)];
        identificationLab.text = @"身份证:";
        identificationLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [_userInfoV addSubview:identificationLab];
        
        UILabel *identificationInfoLab = [[UILabel alloc]
                                          initWithFrame:CGRectMake(CGRectGetMaxX(identificationLab.frame)+5, y, 160, 20)];
        _identificationInfoLab = identificationInfoLab;
        identificationInfoLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [_userInfoV addSubview:identificationInfoLab];
        
        UIView *lineV = [[UIView alloc]
                         initWithFrame:CGRectMake(CGRectGetMaxX(_identificationInfoLab.frame), 22, 1, 15)];
        lineV.backgroundColor = [UIColor grayColor];
        [_userInfoV addSubview:lineV];
        
//        UILabel *realNameLab = [[UILabel alloc]
//                                initWithFrame:CGRectMake(CGRectGetMaxX(identificationInfoLab.frame)+10, y, 70, 20)];
//        realNameLab.text = @"真实姓名:";
//        realNameLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
//        [_userInfoV addSubview:realNameLab];
        
        UILabel *realNameInfoLab = [[UILabel alloc]
                                    initWithFrame:CGRectMake(CGRectGetMaxX(lineV.frame)+10, y, 100, 20)];
        _realNameInfoLab = realNameInfoLab;
        realNameInfoLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        [_userInfoV addSubview:realNameInfoLab];
    }
    return self;
}

- (void)setUserInfoWithOrderInfo:(HYMallChildOrder *)orderInfo
{
    if (orderInfo.isSears == 1)
    {
        _userInfoV.hidden = NO;
        NSString *idCard = orderInfo.deliveryAddressPO.idCard;
        _identificationInfoLab.text = [self hidePartIdCard:idCard];
        _realNameInfoLab.text = orderInfo.deliveryAddressPO.realName;
    }
    else
    {
        _userInfoV.hidden = YES;
    }
}

- (NSString *)hidePartIdCard:(NSString *)idCard
{
    
    NSMutableString *str = [idCard mutableCopy];
    NSInteger SecurityLength = idCard.length-10;
    NSMutableString *SecurityStr = [NSMutableString string];
    
    for (NSInteger i = 0; i < SecurityLength; i++)
    {
        [SecurityStr appendString:@"*"];
    }
    
    NSRange range = NSMakeRange(6, SecurityLength);
    [str replaceCharactersInRange:range withString:SecurityStr];
    
    return str;
}

@end
