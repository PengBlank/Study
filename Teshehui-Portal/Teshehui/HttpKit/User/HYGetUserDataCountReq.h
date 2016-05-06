//
//  HYGetUserDataCountReq.h
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 *  查询用户统计数据
 */
#import "CQBaseRequest.h"

@interface HYGetUserDataCountReq : CQBaseRequest

@property (nonatomic, strong) NSArray *dataType;

@end

@interface HYGetUserDataCountResp : CQBaseResponse

@property (nonatomic, strong) NSArray *countInfo;

@end

/*
{
    "接口请求说明": [
               "1.请求样例数据只用到部分公传参数，实际接口调用时请传输所有不为空的公传参数\r\n",
               "2.具体请求参数说明中列出了该接口可接收的所有请求字段，接口具体需要传哪些参数根据业务需求来定，可参考请求数据样例中用到的具体请求字段\r\n"
               ],
    "接口响应说明": [
               "1.具体返回字段说明中列出了该接口可返回的所有字段，接口具体返回哪些字段根据业务需求来定，可参考返回数据样例中用到的具体返回字段\r\n"
               ],
    "接口请求参数": {
        "公共请求参数": {
            "version": "接口版本默认1.0.0",
            "clientType": "平台类型PC/WAP/ANDROID/IPHONE/IPAD",
            "clientVersion": "平台版本号如40",
            "timestamp": "请求时间戳，精确到毫秒",
            "signature": "加密字符串，加密字段包括version和clientType和token，加密apiKey=40287ae447680a6b0147680a6b580000",
            "token": "用户登录标识（没有可以不传）",
            "businessType": "业务类型，没有可不传"
        },
        "具体请求参数data": {
            "GetUserDataCountRequestData": {
                "String userId": "用户标识",
                "String[] dataType": "数据类型标识，mallOrderWaitPay(\"11\",\"订单待付款\"),mallOrderWaitDelivery(\"12\",\"订单待发货\"),mallOrderWaitSign(\"13\",\"订单待收货\"),     red(\"20\",\"红包\"),redSend(\"21\",\"红包发送\"),redReceive(\"22\",\"红包接收\")"
            }
        }
    },
    "接口返回字段": {
        "公共字段": {
            "status": "200表示成功，其他表示失败",
            "suggestMsg": "当status不为200时，建议该接口展示的【友好】错误消息",
            "message": "当status不为200时，表示具体错误的消息",
            "code": "当status不为200时有值，表示具体错误的编码",
            "timestamp": "服务端时间戳，精确到毫秒"
        },
        "具体字段data": {
            "GetUserDataCountResponseData": {
                "String dataType": "数据类型标识",
                "String dataCountValue": "数据统计的值"
            }
        }
    },
    "接口请求数据样例": "clientType=ANDROID&data=%7B%22userId%22%3A%2264492%22%2C%22dataType%22%3A%5B%2211%22%2C%2212%22%2C%2213%22%2C%2220%22%5D%7D",
    "接口返回数据样例": {
        "data": [
                 {
                     "dataType": "11",
                     "dataCountValue": "1"
                 },
                 {
                     "dataType": "12",
                     "dataCountValue": "0"
                 },
                 {
                     "dataType": "13",
                     "dataCountValue": "0"
                 }
                 ],
        "status": 200,
        "message": "Success!",
        "timestamp": "1450964093807"
    }
}
*/