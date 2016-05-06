//
//  HYAfterSaleAddressCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleAddressCell.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"

@implementation HYAfterSaleAddressCell
{
    UILabel *_name;
    UILabel *_phone;
    UILabel *_address;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        UIImage *bg = [UIImage imageNamed:@"mallOrder_address"];
        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(12, 0, 12, 0) resizingMode:UIImageResizingModeStretch];
        UIImageView *bgv = [[UIImageView alloc] initWithImage:bg];
        [self.contentView addSubview:bgv];
        [bgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mallOrder_addressIcon"]];
        [self.contentView addSubview:icon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"收货信息";
        [self.contentView addSubview:title];
        
        UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        personLabel.font = [UIFont systemFontOfSize:14.0];
        personLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        personLabel.backgroundColor = [UIColor clearColor];
        personLabel.text = @"联系人:";
        [self.contentView addSubview:personLabel];
        UILabel *person = [[UILabel alloc] initWithFrame:CGRectZero];
        person.font = [UIFont systemFontOfSize:14.0];
        person.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        person.backgroundColor = [UIColor clearColor];
        person.text = @"联系人:";
        [self.contentView addSubview:person];
        _name = person;
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        phoneLabel.font = [UIFont systemFontOfSize:14.0];
        phoneLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.text = @"手机号码:";
        [self.contentView addSubview:phoneLabel];
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectZero];
        phone.font = [UIFont systemFontOfSize:14.0];
        phone.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        phone.backgroundColor = [UIColor clearColor];
        phone.text = @"联系人:";
        [self.contentView addSubview:phone];
        _phone = phone;
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        addressLabel.font = [UIFont systemFontOfSize:14.0];
        addressLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = @"收货地址:";
        [self.contentView addSubview:addressLabel];
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectZero];
        address.font = [UIFont systemFontOfSize:14.0];
        address.textColor = [UIColor colorWithHexColor:@"494949" alpha:1];
        address.backgroundColor = [UIColor clearColor];
        address.numberOfLines = 0;
        address.text = @"深圳市福田区车公庙雪松大厦B座";
        [self.contentView addSubview:address];
        _address = address;
        
        //Layout!
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(icon.mas_centerY);
            make.left.equalTo(icon.mas_right).offset(8);
        }];
        CGFloat lineSpace = 10;
        CGFloat vspace = 8;
        [personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_left);
            make.top.equalTo(title.mas_bottom).offset(lineSpace);
        }];
        [person mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(personLabel.mas_right).offset(vspace);
            make.top.equalTo(personLabel.mas_top);
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_left);
            make.top.equalTo(personLabel.mas_bottom).offset(lineSpace);
        }];
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(personLabel.mas_right).offset(vspace);
            make.top.equalTo(phoneLabel.mas_top);
        }];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_left);
            make.top.equalTo(phoneLabel.mas_bottom).offset(lineSpace);
        }];
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressLabel.mas_right).offset(vspace);
            make.top.equalTo(addressLabel.mas_top);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(personLabel.mas_width);
            make.width.equalTo(addressLabel.mas_width);
        }];
        
        
//        //equal!
//        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(person.mas_left);
//        }];
//        [address mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(phone.mas_left);
//        }];
    }
    return self;
}

/*
 UILabel *_name;
 UILabel *_phone;
 UILabel *_address;
 */
- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        _name.text = saleInfo.contactName;
        _phone.text = saleInfo.contactMobile;
        NSMutableString *address = [NSMutableString string];
        if (saleInfo.contactProvinceName) {
            [address appendString:saleInfo.contactProvinceName];
        }
        if (saleInfo.contactCityName) {
            [address appendString:saleInfo.contactCityName];
        }
        if (saleInfo.contactRegionName) {
            [address appendString:saleInfo.contactRegionName];
        }
        if (saleInfo.contactAddress) {
            [address appendString:saleInfo.contactAddress];
        }
        _address.text = address;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY(_address.frame) + 10;
        self.frame = frame;
    }
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//    CGRect frame = self.frame;
//    frame.size.height = CGRectGetMaxY(_address.frame) + 10;
//    self.frame = frame;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
