//
//  WxPayManager.h
//  WxPayTest
//
//  Created by 互联易付ljl on 2017/11/15.
//  Copyright © 2017年 palm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PayErrorCode) {
    WXSUCCESS_PAY             = 1000,  //支付成功
    WXERROR_PAYPARAM          = 1001,  //支付参数解析错误
    WXERROR_PAYNOAPPID        = 1002,  //未注册appid
    WXERROR_PAYNOTINSTALL     = 1003,  //未安装微信
    WXERROR_PAY               = 1004,  //支付失败
    WXCANCEL_PAY              = 1005,  //支付取消
};

typedef void (^WxAppPayResult) (PayErrorCode code, NSString *errorDesc);

@interface WxPayManager : NSObject

@property (nonatomic, copy) WxAppPayResult payResult;

+ (instancetype)shareWxPayManager;

- (void)wxAppPayWithParam:(NSDictionary *)params result:(void(^)(PayErrorCode code, NSString *errorDesc))result;

- (BOOL)handleOpenURL:(NSURL *)url;

@end
