//
//  HYFlightPassengerCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightPassengerCell.h"
#import "HYFlightWarningView.h"

@interface HYFlightPassengerCell ()
{
    UILabel *_nameLab;
    UILabel *_cardNOLab;
    UILabel *_cardNameLab;
    UILabel *_descLab;
    UILabel *_childPriceLab;
    UIButton *_buyChildrenBtn;
}

@property (nonatomic, strong) UIImageView *childrenView;
@property (nonatomic, strong) UIButton *infoBtn;

@end

@implementation HYFlightPassengerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _supportChild = NO;
        UIImage *arrIcon = [UIImage imageNamed:@"icon_arrow"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(300), 20, 10, 10)];
        arrView1.image = arrIcon;
        [self.contentView addSubview:arrView1];
        
//        UIImage *selectBg = [[UIImage imageNamed:@"btn_flightnavigation_pressed"] stretchableImageWithLeftCapWidth:20
//                                                                                                      topCapHeight:0];
//        
//        UIButton *startDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        startDateBtn.frame = TFRectMakeFixWidth(16, 3, 268, 44);
//        [startDateBtn setBackgroundImage:selectBg
//                                forState:UIControlStateHighlighted];
//        [startDateBtn addTarget:self
//                         action:@selector(startDateEvent:)
//               forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:startDateBtn];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = TFRectMake(20, 15, 15, 15);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"flight_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deletePassenger:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 200, 18)];
        _nameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_nameLab setFont:[UIFont systemFontOfSize:15]];
        _nameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLab];
        
        _cardNameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 28, 80, 18)];
        _cardNameLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_cardNameLab setFont:[UIFont systemFontOfSize:13]];
        _cardNameLab.backgroundColor = [UIColor clearColor];
//        _cardNameLab.text = @"身份证";
        _cardNameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cardNameLab];
        
        _cardNOLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 28, 160, 18)];
        _cardNOLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_cardNOLab setFont:[UIFont systemFontOfSize:13]];
        _cardNOLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cardNOLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark private methods
- (void)deletePassenger:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(deletePassengerCellForIndexPath:)])
    {
        [self.delegate deletePassengerCellForIndexPath:_indexPath];
    }
}


- (void)setchildrenEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.passenger.buyChildren = btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(childUpdateBuyTicketType:)])
    {
        [self.delegate childUpdateBuyTicketType:self.passenger];
    }
}

//简写了该部分
- (void)checkFlightBoardWarning
{
    HYFlightWarningView *view = [[HYFlightWarningView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self.passenger.type == Baby)
    {
        view.msg = @"该舱位不支持婴儿票";
    }
    else
    {
        view.msg = @"该舱位不支持儿童票";
    }
    
    [view show];
}

- (void)updateWithPassenger:(HYPassengers *)passenger
                      price:(NSString *)price
                    support:(BOOL)support;
{
    self.passenger = passenger;
    _supportChild = support;
    _nameLab.text = passenger.name;
    _cardNOLab.text = passenger.cardID;
    _cardNameLab.text = passenger.cardName;
    
    if (_supportChild && [passenger isChildren])
    {
        [self.childrenView setHidden:NO];
        switch (passenger.type)
        {
            case Children:
                _descLab.text = @"购买儿童票：";
                break;
            case Baby:
                _descLab.text = @"购买婴儿票：";
                break;
            default:
                break;
        }
        _childPriceLab.text = price;
        [_buyChildrenBtn setSelected:self.passenger.buyChildren];
    }
    else
    {
        [self.childrenView removeFromSuperview];
        self.childrenView = nil;
    }
    
    if (!_supportChild && [self.passenger isChildren])
    {
        [self.infoBtn setHidden:NO];
    }
    else
    {
        [_infoBtn setHidden:YES];
    }
}
#pragma mark setter/getter
- (UIButton *)infoBtn
{
    if (!_infoBtn)
    {
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize size = [self.passenger.name sizeWithFont:[UIFont systemFontOfSize:15]
                                      constrainedToSize:CGSizeMake(200, 20)];
        _infoBtn.frame = CGRectMake(size.width+64, 0, 30, 30);
        [_infoBtn setImage:[UIImage imageNamed:@"icon_flight_board_warning"]
                  forState:UIControlStateNormal];
        [_infoBtn setImage:[UIImage imageNamed:@"icon_flight_board_warning_pressed"]
                  forState:UIControlStateHighlighted];
        [_infoBtn addTarget:self
                     action:@selector(checkFlightBoardWarning)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_infoBtn];
    }
    
    return _infoBtn;
}

- (UIImageView *)childrenView
{
    if (!_childrenView && self.supportChild)
    {
        _childrenView = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(14, 50, 268, 40)];
        _childrenView.userInteractionEnabled = YES;
        _childrenView.image = [[UIImage imageNamed:@"children_bg"] stretchableImageWithLeftCapWidth:10
                                                                                       topCapHeight:0];
        
        _buyChildrenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyChildrenBtn.frame = CGRectMake(40, 11, 18, 18);
        [_buyChildrenBtn setImage:[UIImage imageNamed:@"checkbox_unselected"]
                         forState:UIControlStateNormal];
        [_buyChildrenBtn setImage:[UIImage imageNamed:@"checkbox_selected"]
                         forState:UIControlStateSelected];
        [_buyChildrenBtn setSelected:self.passenger.buyChildren];
        
        //儿童必须购买儿童票，修改版本为1.3.0
        [_buyChildrenBtn setUserInteractionEnabled:NO];
        
        [_buyChildrenBtn addTarget:self
                            action:@selector(setchildrenEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_childrenView addSubview:_buyChildrenBtn];
        
        _descLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(70, 11, 80, 18)];
        _descLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_descLab setFont:[UIFont boldSystemFontOfSize:12]];
        _descLab.backgroundColor = [UIColor clearColor];
        [_childrenView addSubview:_descLab];
        
        _childPriceLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(150, 11, 100, 18)];
        _childPriceLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                                   green:154.0f/255.0f
                                                    blue:19.0f/255.0f
                                                   alpha:1.0];
        [_childPriceLab setFont:[UIFont boldSystemFontOfSize:12]];
        _childPriceLab.backgroundColor = [UIColor clearColor];
        [_childrenView addSubview:_childPriceLab];
        
        [self.contentView addSubview:_childrenView];
    }
    
    return _childrenView;
}

@end
