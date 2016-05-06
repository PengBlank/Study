//
//  HYMallOrderAdressListCell.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderAdressListCell.h"
#import "HYAddressEditViewController.h"

@interface HYMallOrderAdressListCell ()
{
    UIButton *_defaultBtn;
}


@end

@implementation HYMallOrderAdressListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
      
//        CGRect bounds = [UIScreen mainScreen].bounds;
        
        UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editbtn = editbtn;
        editbtn.hidden = YES;
        // 245 60 35
        editbtn.backgroundColor = [UIColor colorWithRed:245/255.0f green:60/255.0f blue:35/255.0f alpha:1.0f];
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
        editbtn.frame = TFRectMake(264, 0, 60, 80);
        [editbtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editbtn];
        
        _nameLab = [[UILabel alloc]initWithFrame:TFRectMake(16,0,80,30)];
        _nameLab.textColor = [UIColor darkTextColor];
        _nameLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_nameLab];
        
        _numLab = [[UILabel alloc]initWithFrame:TFRectMake(140,0,140,30)];
        _numLab.textAlignment = NSTextAlignmentRight;
        _numLab.textColor = [UIColor darkTextColor];
        _numLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_numLab];
        
//        _adressDefaultLab = [[UILabel alloc] initWithFrame:TFRectMake(17, 30, 40, 30)];
//        _adressDefaultLab.text = @"[默认]";
//        _adressDefaultLab.backgroundColor = [UIColor redColor];
//        _adressDefaultLab.textColor = [UIColor grayColor];
//        _adressDefaultLab.font = [UIFont systemFontOfSize:14.0f];
//        [self.contentView addSubview:_adressDefaultLab];
//        _adressDefaultLab.hidden = YES;
        
        _adressLab = [[UILabel alloc]initWithFrame:TFRectMake(17, 15, 240, 60)];
        _adressLab.textColor = [UIColor grayColor];
        _adressLab.numberOfLines = 2;
        _adressLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_adressLab];
        
        UIButton *editIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        editIcon.frame = TFRectMake(280, 35, 25, 25);
        _editIcon = editIcon;
        editIcon.hidden = YES;
        [self.contentView addSubview:editIcon];
        [_editIcon addTarget:self action:@selector(editIconClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton* setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        setDefaultBtn.frame = TFRectMake(260, 10, 60, 60);
//        [setDefaultBtn setImage:[UIImage imageNamed:@"manageAddress_normal"] forState:UIControlStateNormal];
//        [setDefaultBtn setImage:[UIImage imageNamed:@"manageAddress_select"] forState:UIControlStateSelected];
//        setDefaultBtn.backgroundColor = [UIColor redColor];
//        [setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"setAddress_radio"] forState:UIControlStateNormal];
//        [setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"setAddress_radio_on"] forState:UIControlStateSelected];
//        [setDefaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [setDefaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
//        setDefaultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [setDefaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [setDefaultBtn addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:setDefaultBtn];
//        _defaultBtn = setDefaultBtn;

//        UIView *lineView = [[UIView alloc] initWithFrame:TFRectMake(0, 75, bounds.size.width, 1)];
//        lineView.backgroundColor = [UIColor colorWithWhite:.93 alpha:1.0];
//        [self.contentView addSubview:lineView];
//        
//        UIButton* setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        setDefaultBtn.frame = CGRectMake(10,CGRectGetMaxY(lineView.frame),80, 45);
//        [setDefaultBtn setImage:[UIImage imageNamed:@"setAddress_radio"] forState:UIControlStateNormal];
//        [setDefaultBtn setImage:[UIImage imageNamed:@"setAddress_radio_on"] forState:UIControlStateSelected];
//        [setDefaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [setDefaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
//        setDefaultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [setDefaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [setDefaultBtn addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:setDefaultBtn];
//        _defaultBtn = setDefaultBtn;
//        
//        UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        deleteBtn.frame = CGRectMake(bounds.size.width - 120,CGRectGetMaxY(lineView.frame),60, 45);
//        [deleteBtn setImage:[UIImage imageNamed:@"setAddress_delete"] forState:UIControlStateNormal];
//        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
//        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:deleteBtn];
//        
//        UIButton* editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        editBtn.frame = CGRectMake(bounds.size.width - 60,CGRectGetMaxY(lineView.frame),60, 45);
//        [editBtn setImage:[UIImage imageNamed:@"setAddress_edit"] forState:UIControlStateNormal];
//        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//        editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
//        [editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:editBtn];
        
    }
    return self;
}

- (void)setAddressInfo:(HYAddressInfo *)addressInfo
{
    if (_addressInfo != addressInfo)
    {
        _addressInfo = addressInfo;
        _nameLab.text = addressInfo.consignee;
        _numLab.text = addressInfo.phoneMobile;
        
      //  _adressLab.text = [addressInfo fullAddress];
        
    }
    
    if (addressInfo.isDefault)
    {
        _defaultBtn.selected = YES;
        self.adressDefaultLab.hidden = NO;
        _adressLab.frame = TFRectMake(17, 15, 260, 60);
        self.contentView.backgroundColor = [UIColor colorWithRed:60/255.0f green:80/255.0f blue:115/255.0f alpha:1.0f];
        
        _nameLab.textColor = [UIColor whiteColor];
        _numLab.textColor = [UIColor whiteColor];
     //   _adressDefaultLab.textColor = [UIColor whiteColor];
        _adressLab.textColor = [UIColor whiteColor];
        _adressLab.text = [NSString stringWithFormat:@"[默认]  %@", [addressInfo fullAddress]];
    }
    else
    {
        _defaultBtn.selected = NO;
        self.adressDefaultLab.hidden = YES;
        _adressLab.frame = TFRectMake(17, 15, 260, 60);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _nameLab.textColor = [UIColor blackColor];
        _numLab.textColor = [UIColor blackColor];
   //     _adressDefaultLab.textColor = [UIColor blackColor];
        _adressLab.textColor = [UIColor blackColor];
        _adressLab.text = [addressInfo fullAddress];
    }
}

- (void)editBtnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(editBtnAction:)])
    {
        [self.delegate editBtnAction:self];
    }
}

- (void)editIconClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(editIconAction:)])
    {
        [self.delegate editIconAction:self];
    }
}

//- (void)edit:(UIButton *)sender
//{
//    if ([self.delegate respondsToSelector:@selector(addressCellDidClickEdit:)])
//    {
//        [self.delegate addressCellDidClickEdit:self];
//    }
//}

//- (void)delete:(UIButton *)sender
//{
//    if ([self.delegate respondsToSelector:@selector(addressCellDidClickEdit:)])
//    {
//        [self.delegate addressCellDidClickDelete:self];
//    }
//}

//- (void)defaultAction:(UIButton *)btn
//{
//    if ([self.delegate respondsToSelector:@selector(addressCellDidClickDefaultBtn:)])
//    {
//        [self.delegate addressCellDidClickDefaultBtn:self];
//    }
//}

@end
