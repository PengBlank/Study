//
//  HYMallCartTableHeader.m
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartTableHeader.h"
#import "HYMallGoodsInfo.h"

@interface HYMallCartTableHeader ()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, weak) UIButton *editBtn;

@end

@implementation HYMallCartTableHeader

- (id)initWithFrame:(CGRect)frame
{
    //default size.
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:240/255.0
                                               green:239/255.0
                                                blue:245/255.0
                                               alpha:1];
        
        // Initialization code
        CGFloat x = 5;
        CGFloat h = 35;
        CGFloat y = CGRectGetMidY(frame) - h/2;
        CGFloat w = 54;
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, w, h)];
        [checkBtn setImage:[UIImage imageNamed:@"check_no"]
                  forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateSelected];
        [checkBtn addTarget:self
                     action:@selector(checkBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkBtn];
        self.checkBtn = checkBtn;
        
        x = CGRectGetMaxX(checkBtn.frame) + 3;
        y = 0;
        w = CGRectGetWidth(frame) - x - 54;
        h = CGRectGetHeight(frame);
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        nameLab.font = [UIFont systemFontOfSize:14.0];
        nameLab.backgroundColor = [UIColor clearColor];
        //nameLab.text = @"润媛世界(1)";
        [self addSubview:nameLab];
        self.nameLab = nameLab;
        
        UIButton *editBtn =[[UIButton alloc] initWithFrame:
                            CGRectMake(frame.size.width-54, 0, 44, frame.size.height)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [editBtn addTarget:self
                    action:@selector(editAction:)
          forControlEvents:UIControlEventTouchUpInside];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:editBtn];
        self.editBtn = editBtn;
        
        //顶部横线
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, h-1, frame.size.width, 1)];
        line.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:line];
    }
    return self;
}

- (void)checkBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    //向控制器发回消息
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cartHeaderDidClickCheckButton:)])
    {
        [self.delegate cartHeaderDidClickCheckButton:self];
    }
}

- (void)editAction:(UIButton *)btn
{
    self.edit = !_edit;
    if ([self.delegate respondsToSelector:@selector(cartHeaderDidClickEditButton:)])
    {
        [self.delegate cartHeaderDidClickEditButton:self];
    }
}

#pragma mark setter and getter
- (void)setEditBtnHidden:(NSNumber *)status
{
    _editBtn.selected = NO;
    _editBtn.hidden = [status boolValue];
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    self.editBtn.selected = edit;
}

- (void)setShopInfo:(HYMallCartShopInfo *)shopInfo
{
    self.checkBtn.selected = shopInfo.isSelect;
    
    if (_shopInfo != shopInfo)
    {
        _shopInfo = shopInfo;
        NSString *display = [NSString stringWithFormat:@"%@(%@)", shopInfo.store_name, shopInfo.quantity];
        self.nameLab.text = display;
    }
    self.edit = shopInfo.isEdit;
}

@end
