//
//  HYAccountViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseDetailViewController.h"
/**
 *  我的帐户
 */
@interface HYAccountViewController : HYBaseDetailViewController<UITextFieldDelegate>
{
    //View elements
    UILabel *_nameLbl;
    UILabel *_passLbl;
    UILabel *_mailLbl;
    UILabel *_realNameLbl;
    UILabel *_qqLbl;
    
    UITextField *_nameFld;
    UITextField *_passFld;
    UITextField *_mailFld;
    UITextField *_realNameFld;
    UITextField *_qqFld;
    
    UIButton *_submitBtn;
    UIButton *_cancelBtn;
}

@end
