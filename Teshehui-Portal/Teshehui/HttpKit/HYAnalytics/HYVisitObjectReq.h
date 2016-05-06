//
//  HYVisitObjectReq.h
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/*
 *1.2	用户访问行为（VisitObject）
 */

#import "HYAnalyticsBaseReq.h"

@interface HYVisitObjectReq : HYAnalyticsBaseReq

@property (nonatomic, copy) NSString *obj_code;
@property (nonatomic, copy) NSString *obj_type;
@property (nonatomic, copy) NSString *category_code;
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *tsh_price;
@property (nonatomic, copy) NSString *ref_page_id;
@property (nonatomic, copy) NSString *scene_id;
@property (nonatomic, copy) NSString *algorithm_ind;

@end


/*
 1.2.3	调用参数
 参数名称	参数描述	参数参考类型	要求
 xres_uid	Cookie中的XResUID	 String	必选
 user_id	取登录的用户ID	 String	可选
 site_id	站点标识	枚举类型：
 1001  官网
 1002  O2O 	必选
 channel_id	频道标识	枚举类型：
 1001  PC
 
 1002  APP
 
 1003  WAP	必选
 obj_code	对象标识，即用户浏览的商品编码或品类编码或品牌编码或频道页编码；
 obj_type=99，此字段的值为当前URL；
 obj_type=1，此字段的值为字符串APP	String	必选
  
 obj_type	对象类型	枚举类型：
 1.	商城首页
 2.	商品
 3.	分类(三级分类)
 4.	品牌
 5.	频道页
 99. 未分类页面(目前包括：栏位类型是梭哈和URL两种)	必选
 category_code	三级分类编码	 String	obj_type=2，必选
 brand_code	品牌编码	 String	obj_type=2，必选
 tsh_price	售价	 String	可选
 ref_page_id	来源页面唯一标识	String
 （到做点击流系统时再确定）	可选
 scene_id	场景ID	Number
 （这里指推荐场景，做点击流系统时确定）	可选
 algorithm_ind	算法标识	Number
 （推荐算法的标识，做点击流系统时确定）	可选
 device_no	设备识别号	String	可选
 device_type	设备类型	枚举类型：
 1：ios
 2：Android
 9：其他	可选
 app_ver	APP版本号	String	可选
 phone_model	手机型号	String	可选
 os_msg	操作系统	String	可选
 longitude	经度	String	可选
 latitude	纬度	String	可选
 ll_type	坐标类型	枚举类型：
 1：百度  
 2：Google
 3：soso
 4：高德
 9：其他	可选
*/