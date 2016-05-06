//
//  HYEarnCashTicketContentView.m
//  Teshehui
//
//  Created by HYZB on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYEarnCashTicketContentView.h"
#import "HYEarnCashTicketButton.h"
#import "HYBusinessTypeDao.h"


@interface HYEarnCashTicketContentView ()

@property (nonatomic, strong) UIScrollView *earnScrollView;
@property (nonatomic, strong) NSArray<HYBusinessType *> *businessTypes;


@end

@implementation HYEarnCashTicketContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    _earnScrollView.frame = CGRectMake(0, 0, self.frame.size.width,
                                       self.frame.size.height);
    
    _head.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    
    CGFloat marginX = TFScalePoint(30);
    CGFloat marginY = TFScalePoint(40);
    CGFloat btnWidth = (self.frame.size.width-4*marginX)/3;
    CGFloat btnHeight = btnWidth + 35;
    
    NSInteger count = self.businessTypes.count;
    if (count > 0)
    {
        NSInteger cols = 3;
        NSInteger rows = (count + 2) / 3;
        NSInteger i = 0;
        
        for (NSInteger row = 0; row<rows; row++)
        {
            for (NSInteger col = 0; col<cols && i<self.businessTypes.count; col++)
            {
                if (i >= count)
                {
                    return;
                }
                
                CGFloat spaceX = (col+1)*marginX + col*btnWidth;
                CGFloat spaceY = (row+1)*marginY + row*btnHeight;
                HYEarnCashTicketButton *btn = [self viewWithTag:100+i];
                btn.frame = CGRectMake(spaceX, spaceY, btnWidth, btnHeight);
                _earnScrollView.contentSize = CGSizeMake(self.frame.size.width,
                                                         CGRectGetMaxY(btn.frame)+40);
                
                HYBusinessType *type = self.businessTypes[i];
                [self updateContentWithType:type button:(HYEarnCashTicketButton *)btn];
                
                i++;
            }
        }
    }
}

- (void)setupUI
{
    UIScrollView *earnScrollView = [[UIScrollView alloc] init];
    earnScrollView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0
                                                      blue:246/255.0 alpha:1.0f];
    _earnScrollView = earnScrollView;
    [self addSubview:earnScrollView];
    
    // 会员升级提示框
    HYEarnTicketHeaderView *head = [[HYEarnTicketHeaderView alloc]
                                    init];
    _head = head;
    [_earnScrollView addSubview:head];
    __weak typeof(self) weakSelf = self;
    head.didClickUpdate = ^
    {
        if ([weakSelf.delegate respondsToSelector:@selector(didSelectUpgrad)])
        {
            [weakSelf.delegate didSelectUpgrad];
        }
    };
    
    // 各种业务按钮
    HYBusinessTypeDao *dao = [[HYBusinessTypeDao alloc] init];
//    self.businessTypes = [dao queryEntitiesWhere:@"isBusinessTypeOpen = 1"];
    self.businessTypes = [dao queryEntities];
    NSInteger count = self.businessTypes.count;
    if (count > 0)
    {
        NSInteger cols = 3;
        NSInteger rows = (count + 2) / 3;
        NSInteger i = 0;
        
        for (NSInteger row = 0; row < rows; row++)
        {
            for (NSInteger col = 0; col < cols; col++)
            {
                if (i >= count)
                {
                    return;
                }
                
                HYEarnCashTicketButton *btn = [[HYEarnCashTicketButton alloc] init];
                btn.tag = 100+i;
                btn.type = self.businessTypes[i];
                [self.earnScrollView addSubview:btn];
                [btn addTarget:self action:@selector(buttonAction:)
              forControlEvents:UIControlEventTouchUpInside];
                
                HYBusinessType *type = self.businessTypes[i];
                
                [self updateContentWithType:type
                                     button:(HYEarnCashTicketButton *)btn];
                i++;
            }
        }
    }
}

/** 更新界面内容 */
- (void)updateContentWithType:(HYBusinessType *)type
                       button:(HYEarnCashTicketButton *)btn
{
    NSDictionary *dict = @{BusinessType_Flight:@"icon_flight_earncashticket",
                           BusinessType_Hotel:@"icon_hotel_earncashticket",
                           BusinessType_MovieTicket:@"icon_movieticket_earncashticket",
                           BusinessType_PhoneCharge:@"icon_phonecharge_earncashticket",
                           BusinessType_Flower:@"icon_flower_earncashticket",
                           BusinessType_MeiQiqi:@"icon_meiweiqiqi_earncashticket",
                           BusinessType_Yangguang:@"icon_baoxian_earncashticket",
                           BusinessType_DidiTaxi:@"icon_taxi_earncashticket",
                           BusinessType_Meituan:@"icon_meituan_earncashticket",
                           BusinessType_TRAIN:@"icon_gaotie_earncashticket",
                           BusinessType_Travel:@"icon_tuniu_earncashticket",
                           BusinessType_Guahao:@"icon_guahao_earncashticket"};
    
    for (NSString *code in dict)
    {
        if ([code isEqualToString:type.businessTypeCode])
        {
            btn.iconImgV.image = [UIImage imageNamed:dict[code]];
            btn.titleLab.text = type.businessTypeName;
        }
    }
}

- (void)buttonAction:(HYEarnCashTicketButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSelectWithEarnType:)])
    {
        [self.delegate didSelectWithEarnType:btn.type];
    }
}

@end
