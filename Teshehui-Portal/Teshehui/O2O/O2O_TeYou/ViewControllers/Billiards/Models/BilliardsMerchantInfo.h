//
//  BilliardsMerchantInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BilliardsMerchantInfo : NSObject

@property (nonatomic,strong) NSString *Number;
@property (nonatomic,strong) NSString *MerchantsName;
@property (nonatomic,strong) NSString *Address;
@property (nonatomic,strong) NSString *Phone;
@property (nonatomic,strong) NSString *MerNumber;
@property (nonatomic,strong) NSString *MerLogo;

@property (nonatomic,assign) NSInteger First_Area_Id;
@property (nonatomic,assign) NSInteger Second_Area_Id;
@property (nonatomic,assign) NSInteger Third_Area_Id;
@property (nonatomic,assign) NSInteger Fourth_Area_Id;
@property (nonatomic,strong) NSString *Gid;


//@property (nonatomic,strong) NSString *ModifiedBy;
//@property (nonatomic,strong) NSString *ModifiedOn;
//@property (nonatomic,strong) NSString *CreatedBy;
//@property (nonatomic,strong) NSString *CreatedOn;
//@property (nonatomic,assign) NSInteger IsDel;



@end
