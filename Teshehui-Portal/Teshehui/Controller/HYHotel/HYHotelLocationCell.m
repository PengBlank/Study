//
//  HYHotelLocationCellV2.m
//  Teshehui
//
//  Created by RayXiang on 14-8-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelLocationCell.h"
#import "UIView+GetImage.h"
#import "UIView+Style.h"
#import "Masonry.h"
#import "HYImageButton.h"


@implementation HYHotelLocationCell
{
    UIView *_cityView;
    UIButton *_locationBtn;
    UIView *_line;
    UILabel *_cityLab;
    UIImageView *searchImg;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _cityView = [[UIView alloc] initWithFrame:CGRectZero];
        _cityView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_cityView];
//        __weak typeof(self) b_self = self;
        [_cityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 70));
        }];
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cityLabel.textColor = [UIColor grayColor];
        cityLabel.text = @"深圳";
//        cityLabel.numberOfLines = 2;
        [_cityView addSubview:cityLabel];
        self.locationLab = cityLabel;
        UIImageView *searchicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i_search"]];
        searchicon.contentMode = UIViewContentModeCenter;
        [_cityView addSubview:searchicon];
        [searchicon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_cityView.mas_right).offset(-3);
            make.centerY.equalTo(_cityView.mas_centerY);
        }];
        [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-searchicon.image.size.width-3);
            make.bottom.mas_equalTo(0);
        }];
        
        //line
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithWhite:.83 alpha:1];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(1);
            make.left.equalTo(_cityView.mas_right);
        }];
        
        //button aroundMall_address
        HYImageButton *locateBtn = [[HYImageButton alloc] initWithFrame:CGRectZero];
        [locateBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        locateBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [locateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [locateBtn setImage:[UIImage imageNamed:@"icon_locate2"]
                   forState:UIControlStateNormal];
        [locateBtn addTarget:self
                      action:@selector(locateBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        locateBtn.type = ImageButtonTypeVerticle;
        [self.contentView addSubview:locateBtn];
        [locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(_cityView.mas_right);
            make.right.mas_equalTo(0);
        }];
        
        
//        self.textLabel.numberOfLines = 2;
//        self.textLabel.textColor = [UIColor blackColor];
//        CGFloat h = 44;
//        
//        UIView *myLocationView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-90-15, (h-33)/2, 90, 33)];
//        myLocationView.backgroundColor = [UIColor whiteColor];
//        [myLocationView addCorner:3.0];
//        [myLocationView addBorder:1.0 borderColor:[UIColor colorWithWhite:.8 alpha:1]];
//        myLocationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        //[self.contentView addSubview:myLocationView];
//        /*
//        UIImage *border = [UIImage imageNamed:@"frame_border.png"];
//        border = [border stretchableImageWithLeftCapWidth:1.25 topCapHeight:1.25];
//        UIImageView *borderV = [[UIImageView alloc] initWithImage:border];
//        borderV.frame = myLocationView.bounds;
//        [myLocationView addSubview:borderV];*/
//        
//        UIImage *con = [UIImage imageNamed:@"home_name_icon.png"];
//        UIImageView *conV = [[UIImageView alloc] initWithImage:con];
//        CGFloat y = CGRectGetHeight(myLocationView.frame)/2 - 15 / 2;
//        conV.frame = CGRectMake(5, y, 15, 15);
//        [myLocationView addSubview:conV];
//        
//        //我的位置按钮标题
//        NSString *str = @"我的位置";
//        UIFont *font = [UIFont systemFontOfSize:13.0];
//        CGSize size = [str sizeWithFont:font];
//        y = (CGRectGetHeight(myLocationView.frame)-size.height) / 2;
//        CGFloat x = CGRectGetMaxX(conV.frame) + 5;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, size.width, size.height)];
//        label.text = str;
//        label.font = font;
//        [myLocationView addSubview:label];
//        
//        UIImage *myLocImage = [myLocationView getImage];
//        UIButton *myLocBtn = [[UIButton alloc] initWithFrame:myLocationView.frame];
//        [myLocBtn setBackgroundImage:myLocImage forState:UIControlStateNormal];
//        [myLocBtn addTarget:self
//                     action:@selector(locateBtnAction:)
//           forControlEvents:UIControlEventTouchUpInside];
//        myLocBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [self.contentView addSubview:myLocBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.iconView.frame = CGRectMake(20, (self.frame.size.height-21)/2, 21, 21);
//    self.textLabel.frame = CGRectMake(48, 0, CGRectGetWidth(self.frame)-48-105, CGRectGetHeight(self.frame));
}

- (void)cityBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(hotelLocationCellDidClickCityBtn)]) {
        [self.delegate hotelLocationCellDidClickCityBtn];
    }
}

- (void)locateBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(hotelLocationCellDidClickLocateBtn)]) {
        [self.delegate hotelLocationCellDidClickLocateBtn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
