//
//  WxPayManager.m
//  WxPayTest
//
//  Created by 互联易付ljl on 2017/11/15.
//  Copyright © 2017年 palm. All rights reserved.
//

#import "WxPayManager.h"
#import "WXApi.h"

@interface WxPayManager()<WXApiDelegate>

@end

@implementation WxPayManager

+ (instancetype)shareWxPayManager {
    static dispatch_once_t onceToken;
    static WxPayManager *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[WxPayManager alloc] init];
    });
    return _instance;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)wxAppPayWithParam:(NSDictionary *)params result:(void (^)(PayErrorCode, NSString *))result {
    //解析结果
//    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    _payResult = result;
    
    NSString *appid = params[@"appid"];
    NSString *partnerid = params[@"partnerid"];
    NSString *prepayid = params[@"prepayid"];
    NSString *package = params[@"package"];
    NSString *noncestr = params[@"noncestr"];
    NSString *timestamp = params[@"timestamp"];
    NSString *sign = params[@"sign"];
    
//    if(error != nil) {
//        _payResult(WXERROR_PAYPARAM, @"支付参数解析错误");
//        return ;
//    }

    if ((appid.length == 0) || (appid == nil)) {
        if (_payResult) {
            _payResult(WXERROR_PAYNOAPPID, @"appid为空");
        }
    }
    
    [WXApi registerApp:appid];
    
    if(![WXApi isWXAppInstalled]) {
        if (_payResult) {
            _payResult(WXERROR_PAYNOTINSTALL, @"未安装微信");
        }
        return ;
    }
    
    //发起微信支付
    PayReq* req   = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.prepayId  = prepayid;
    req.nonceStr  = noncestr;
    req.timeStamp = timestamp.intValue;
    req.package   = package;
    req.sign      = sign;
    [WXApi sendReq:req];
}

#pragma mark - 微信回调

- (void)onResp:(BaseResp *)resp{
    NSLog(@"onResp");
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        
        switch (response.errCode) {
            case WXSuccess:
                if (_payResult) {
                    _payResult(WXSUCCESS_PAY, @"支付成功");
                }
                break;
                
            case WXErrCodeUserCancel:   //用户点击取消并返回
                if (_payResult) {
                    _payResult(WXCANCEL_PAY, @"用户点击取消支付");
                }
                break;
                
            default:        //剩余都是支付失败
                if (_payResult) {
                    _payResult(WXERROR_PAY, @"支付失败");
                }
                break;
        }
    }

}

@end
