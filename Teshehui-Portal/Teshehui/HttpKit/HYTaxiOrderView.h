//
//  HYTaxiOrderView.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiOrderFee : JSONModel

@property (nonatomic, copy) NSString *feeName;
@property (nonatomic, copy) NSString *feeType;
@property (nonatomic, copy) NSString *fee;

@end

@protocol HYTaxiOrderFee

@end

/**
 *  滴滴打车, 实时刷单所获取的订单数据
 */
@interface HYTaxiOrderView : JSONModel

@property (nonatomic, copy) NSString *didiOrderExtraInfo;
@property (nonatomic, copy) NSString *didiOrderTotalAmount;
@property (nonatomic, copy) NSString *endLatitude;
@property (nonatomic, copy) NSString *passengerPhone;
@property (nonatomic, copy) NSString *startAddressDetail;
@property (nonatomic, copy) NSString *driverHeadPicUrl;
@property (nonatomic, copy) NSString *startChargeTime;
@property (nonatomic, copy) NSString *driverLevel;
@property (nonatomic, copy) NSString *endChargeTime;
@property (nonatomic, copy) NSString *normalDistance;
@property (nonatomic, strong) NSArray<HYTaxiOrderFee> *orderFee;
@property (nonatomic, copy) NSString *currentLongitude;
@property (nonatomic, copy) NSString *startLongitude;
@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *startLatitude;
@property (nonatomic, copy) NSString *endAddressName;
@property (nonatomic, copy) NSString *currentLatitude;
@property (nonatomic, copy) NSString *driverCarType;
@property (nonatomic, copy) NSString *endAddressDetail;
@property (nonatomic, copy) NSString *didiOrderStatus;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *didiOrderType;
@property (nonatomic, copy) NSString *driverPhone;
@property (nonatomic, copy) NSString *driverLicence;
@property (nonatomic, copy) NSString *didiOrderId;
@property (nonatomic, copy) NSString *driverOrderCount;
@property (nonatomic, copy) NSString *startAddressName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endLongitude;
@property (nonatomic, copy) NSString *driverCount;

@end


///** 滴滴订单标识 */
//private String didiOrderId;
///** 滴滴订单状态:300等待应答,311 订单超时，400 等待接驾，410 司机已到达，500 行程中，600 行程结束，610 行程异常结束，700 已支付 */
//private String didiOrderStatus;
///** 城市编码 */
//private String cityCode;
///** 城市车型编码 */
//private String carTypeCode;
///** 滴滴订单类型 */
//private String didiOrderType;
////    private String mobilephone;
///** 叫车人手机号 */
//private String passengerPhone;
//
///** 司机名称 */
//private String driverName;
///** 司机电话 */
//private String driverPhone;
///** 司机标识 */
//private String driverId;
///** 司机车型 */
//private String driverCarType;
///** 司机车牌 */
//private String driverLicence;
///** 司机头像 */
//private String driverHeadPicUrl;
///** 司机接单数 */
//private String driverOrderCount;
///** 司机评分星级等级 */
//private String driverLevel;
//
///** 出发地纬度 */
//private String startLatitude;
///** 出发地经度 */
//private String startLongitude;
///** 出发地地址名称 */
//private String startAddressName;
///** 出发地详细地址 */
//private String startAddressDetail;
///** 出发时间,预约叫车时用到 */
//private String startTime;
///** 目的地纬度 */
//private String endLatitude;
///** 目的地经度 */
//private String endLongitude;
///** 目的地名称 */
//private String endAddressName;
///** 目的地详细地址 */
//private String endAddressDetail;
///** 当前位置纬度 */
//private String currentLatitude;
///** 当前位置经度 */
//private String currentLongitude;
//
///** 滴滴订单扩展数据 */
//private String didiOrderExtraInfo;
//
///** 套餐时长 */
//private String comboTime;
///** 套餐距离 */
//private String comboDistance;
///** 套餐费用 */
//private String comboFee;
//
///** 预估订单总费用 */
//private String didiOrderTotalAmount;
//
///** 订单创建时间 */
//private String createdTime;
//
///** 订单开始计费时间 */
//private String startChargeTime;
///** 订单结束计费时间 */
//private String endChargeTime;
///** 订单实际行程距离 */
//private String normalDistance;
//
///** 具体费用名称 */
//private String feeName;
///** 具体费用类型 */
//private String feeType;
///** 具体费用金额 */
//private String fee;
//}


/*
{
    "data":{
        "didiOrderId":"6109235733427932688",
        "didiOrderStatus":"700",
        "cityCode":"2",
        "carTypeCode":"600",
        "didiOrderType":"0",
        "passengerPhone":"18576773015",
        "driverName":"郑师傅",
        "driverPhone":"15302670571",
        "driverCarType":"奥迪A6（进口）",
        "driverLicence":"奥迪A6（进口）",
        "driverHeadPicUrl":"http://static.xiaojukeji.com/gulfstream/upload/20140704/140444390135938.jpg",
        "driverOrderCount":"17",
        "driverLevel":"5.0",
        "startLatitude":"22.531159",
        "startLongitude":"114.021877",
        "startAddressName":"福田区泰然六路52号",
        "startAddressDetail":"雪松大厦B座",
        "startTime":"2015-11-20 15:25:07",
        "endLatitude":"22.500420",
        "endLongitude":"113.924043",
        "endAddressName":"南山公安分局",
        "endAddressDetail":"南山公安分局",
        "currentLatitude":"22.531159",
        "currentLongitude":"114.021877",
        "didiOrderExtraInfo":"",
        "didiOrderTotalAmount":"13.00",
        "startChargeTime":"2015-11-20 15:55:59",
        "endChargeTime":"2015-11-20 15:56:04",
        "normalDistance":"0.00",
        "orderFee":[
                    {
                        "feeName":"快车最低消费补足",
                        "feeType":"limit_pay",
                        "fee":"13.00"
                    }
                    ]
    },
    "status":200,
    "message":"Success!",
    "code":null,
    "suggestMsg":null,
    "timestamp":"1448271319441"
}
 */
