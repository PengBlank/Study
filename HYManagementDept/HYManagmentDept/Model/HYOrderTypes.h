//
//  HYOrderTypes.h
//  HYManagmentDept
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#ifndef HYManagmentDept_HYOrderTypes_h
#define HYManagmentDept_HYOrderTypes_h

typedef enum _OrderType
{
    MallOrder           = 1,
    FlowerOrder         = 2,
    FlightOrder         = 3,
    HotelOrder          = 4,
    OnlineBuyCardOrder  = 5,
    GroupPurchaseOrder  = 6,
    ContinueInsuranceOrder = 8,
    UnkownOrderType     = -1
}OrderType;

typedef enum {
    MallClearing        = 1,
    FlowerClearing      = 2,
    FlightClearing      = 3,
    HotelClearing       = 4,
    OnlineBuyCardClearing  = 6 ,
    GroupPurchaseClearing  = 7 ,
    ContinueInsuranceClearing = 8,
    UnkownClearingType  = -1
}ClearingType;

typedef enum {
    MallOutOrder           = 1,
    FlowerOutOrder         = 4,
    FlightOutOrder         = 2,
    HotelOutOrder          = 3,
    OnlineBuyCardOutOrder  = 6,
    GroupPurchaseOutOrder  = 5,
    ContinueInsuranceOutOrder = 8,
    UnkownOutOrderType     = -1
}OutOrderType;

static NSInteger OrderTypeCount = 7;
static OrderType OrderTypeIndex[] = {MallOrder, FlightOrder, HotelOrder, FlowerOrder, GroupPurchaseOrder, OnlineBuyCardOrder, ContinueInsuranceOrder};

static NSInteger ClearingTypeCount = 7;
static ClearingType ClearingTypeIndex[] = {MallClearing, FlightClearing, HotelClearing, FlowerClearing, GroupPurchaseClearing, OnlineBuyCardClearing, ContinueInsuranceClearing};

static NSInteger OutOrderTypeCount = 5;
static OutOrderType OutOrderTypeIndex[] = {MallOutOrder, FlightOutOrder, HotelOutOrder, FlowerOutOrder, GroupPurchaseOutOrder};

CG_INLINE OrderType orderTypeWithIndex(NSInteger idx)
{
    if (idx >= 0 && idx < OrderTypeCount)
    {
        return OrderTypeIndex[idx];
    }
    return UnkownOrderType;
}

CG_INLINE ClearingType clearingTypeWithIndex(NSInteger idx)
{
    if (idx >= 0 && idx < ClearingTypeCount)
    {
        return ClearingTypeIndex[idx];
    }
    return UnkownClearingType;
}

CG_INLINE OutOrderType outOrderTypeWithIndex(NSInteger idx)
{
    if (idx >= 0 && idx < OutOrderTypeCount)
    {
        return OutOrderTypeIndex[idx];
    }
    return UnkownOutOrderType;
}

#endif
