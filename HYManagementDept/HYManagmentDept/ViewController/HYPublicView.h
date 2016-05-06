//
//  HYPublicView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-28.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSpaceTextField.h"

@protocol HYPublicViewDelegate <NSObject>

- (void)didGetNumber:(NSString *)number endNumber:(NSString *)endNumber;
- (void)didGetSigleNumber:(NSString *)number;

@end

@interface HYPublicView : UIView
<
UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    
    //自动补全
    UITableView *_autoCompleteTable;
    UIView *_autoCompleteWrapper;
    NSArray *_searchNumbers;
    
    __weak UITextField *_activeField;
    
    IBOutlet UILabel *_agencyLbl;
    IBOutlet UILabel *_agency2Label;
}

@property (nonatomic, weak) IBOutlet HYSpaceTextField *fromField;
@property (nonatomic, strong) IBOutlet HYSpaceTextField *toField;
@property (nonatomic, strong) IBOutlet HYSpaceTextField *numberField;
@property (nonatomic, strong) IBOutlet UIButton *allSubmitBtn;
@property (nonatomic, strong) IBOutlet UIButton *singleSubmitBtn;
@property (nonatomic, strong) IBOutlet UIButton *allSelectBtn;
@property (nonatomic, strong) IBOutlet UIButton *singleSelectBtn;

@property (nonatomic, strong) UITableView *autoCompleteTable;
@property (nonatomic, strong) UIView *autoCompleteWrapper;
@property (nonatomic, strong) NSArray *searchNumbers;

@property (nonatomic, weak) UITextField *activeField;

@property (nonatomic, weak) id <HYPublicViewDelegate> delegate;

@property (nonatomic, strong ) NSString *agencyName;

@property (nonatomic, strong) NSString *titleName1; //批量指定操作员
@property (nonatomic, strong) NSString *titleName2; //单张指定操作员
@property (nonatomic, strong) IBOutlet UILabel *titleLab1;
@property (nonatomic, strong) IBOutlet UILabel *titleLab2;

- (void)resetSelectBtn;

- (void)layoutTextField:(BOOL)move;
- (void)keyboardHide;

- (void)setNumberSearchResult:(NSArray *)numbers;

- (void)getNumber:(NSString **)number endNumber:(NSString **)endNumber;
- (void)getNumber:(NSString **)number;
- (void)resetNumber;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

//create with xib.
+ (instancetype)instanceView;

@end
