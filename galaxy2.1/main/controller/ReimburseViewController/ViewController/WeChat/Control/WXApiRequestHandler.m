//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@implementation WXApiRequestHandler

#pragma mark - Public Methods


+ (BOOL)chooseInvoice:(NSString *)appid
             cardSign:(NSString *)cardSign
             nonceStr:(NSString *)nonceStr
             signType:(NSString *)signType
            timestamp:(UInt32)timestamp
{
    WXChooseInvoiceReq *chooseInvoiceReq = [[WXChooseInvoiceReq alloc] init];
    chooseInvoiceReq.appID = appid;
    chooseInvoiceReq.cardSign = cardSign;
    chooseInvoiceReq.nonceStr = nonceStr;
    chooseInvoiceReq.signType = signType;
    //    chooseCardReq.cardType = @"INVOICE";
    chooseInvoiceReq.timeStamp = timestamp;
    //    chooseCardReq.canMultiSelect = 1;
    return [WXApi sendReq:chooseInvoiceReq];
}



@end
