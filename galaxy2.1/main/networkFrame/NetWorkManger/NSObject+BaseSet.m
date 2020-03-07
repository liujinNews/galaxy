//
//  NSObject+BaseSet.m
//  galaxy
//
//  Created by hfk on 2018/4/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "NSObject+BaseSet.h"
 
@implementation NSObject (BaseSet)

#pragma mark BaseURL
+ (NSString *)baseURLStr{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *url;
    
//    url=[defaults valueForKey:@"BASEURL"] ?: XBServer;
//    NSLog(@"%@",url);
//#if DEBUG
//    url=XBServer;
//#endif
//    NSLog(@"%@",url);
//    NSString *url = XBServer;
//    NSString *url = XBServer_T155_8082;
//    NSString *url = XBServer_T17_8201;
//    NSString *url = XBServer_T17_8088;
//    NSString *url = XBServer_T234;
//    NSString *url = XBServer_T17_8101;
//    NSString *url = @"http://10.1.2.17:8201/api/";
    NSString *url = XBServer_T17_8401;
//    NSString *url = @"http://xibaoxiao.qicp.vip/api";

    return url;
}
//  文件传输
+(NSString *)fileUrlStr{
//    NSString *url = XBServerFile;
//    NSString *url = XBServer_T155_8082;
//    NSString *url = XBServer_T17_8201;
//    NSString *url = XBServer_T17_8088;
//    NSString *url = XBServer_T234;
//    NSString *url = XBServer_T17_8101;
//    NSString *url = @"http://10.1.2.17:8201/api/";
    NSString *url = XBServer_T17_8401;
//    NSString *url = @"http://xibaoxiao.qicp.vip/api";

    return url;
}

//+ (void)changeBaseURLStrTo:(NSString *)baseURLStr{
//    if (baseURLStr.length <= 0) {
//        baseURLStr = XBServer;
//    }

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:baseURLStr forKey:@"BASEURL"];
//    [defaults synchronize];
//    [AFSessionSingleton changeJsonClient];
//}

+ (NSString *)formH5BaseURLStr{
    
    return XBH5Server;
}
+ (NSString *)helpBaseURLStr{
    return XBHelpServer;
}


@end
