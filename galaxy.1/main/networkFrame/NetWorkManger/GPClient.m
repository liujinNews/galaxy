//
//  GPClient.m
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "GPClient.h"
#import "AFURLRequestSerialization.h"
//缓存空间
#define Capacity 1*1024*1024

@interface GPClient()
@end

@implementation GPClient


+(GPClient*)shareGPClient{
    static GPClient* _sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GPClient alloc]init];
    });
    return _sharedClient;
}

-(void)RequestByPostOnImageWithPath:(NSString*)path Parameters:(NSDictionary*)parameters  NSArray:(NSArray *)images name:(NSArray *)imageNames type:(NSString *)type Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareFileManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        userData * datas = [userData shareUserData];
        if (datas.SystemType==1) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemToken] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemUserId] forHTTPHeaderField:@"uid"];
        }else{
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.token] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.userId] forHTTPHeaderField:@"uid"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]]
                             forHTTPHeaderField:@"cid"];
   
        }
        [manager.requestSerializer setValue: [NSString getDeviceName] forHTTPHeaderField:@"dname"];
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
        
        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSInteger cnt=0;
            for (NSData *image in images) {
                [formData appendPartWithFileData:image name:datas.userId fileName:imageNames[cnt] mimeType:type];
                cnt++;
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
        
    }
    else{
        return;
    }
}


-(void)REquestByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
        userData * datas = [userData shareUserData];
        if (datas.SystemType==1) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemToken] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemUserId] forHTTPHeaderField:@"uid"];
        }else{
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.token] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.userId] forHTTPHeaderField:@"uid"];
            NSLog(@"cid--------%@",[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]]);
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]] forHTTPHeaderField:@"cid"];
        }
        [manager.requestSerializer setValue:[NSString getDeviceName] forHTTPHeaderField:@"dname"];
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 18000.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.不使用缓存
    else{
        return;
    }
    
}

-(void)RequestByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.不使用缓存
    else{
        return;
    }
}

//上传图片请求调用，post方式
-(void)RequestByPostOnImageWithPath:(NSString*)path Parameters:(NSDictionary*)parameters  NSData:(NSData *)image name:(NSString *)imageName type:(NSString *)type Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache
{
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareFileManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        userData * datas = [userData shareUserData];
        if (datas.SystemType==1) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemToken] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemUserId] forHTTPHeaderField:@"uid"];
        }else{
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.token] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.userId] forHTTPHeaderField:@"uid"];
            NSLog(@"cid--------%@",[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]]);
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]] forHTTPHeaderField:@"cid"];
        }
        [manager.requestSerializer setValue:[NSString getDeviceName] forHTTPHeaderField:@"dname"];
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
       [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:image name:datas.userId fileName:imageName mimeType:type];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
        
    }
    else{
        return;
    }
}

//调用：get方式提交
-(void)RequestByGetWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
        userData * datas = [userData shareUserData];
        if (datas.SystemType==1) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemToken] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemUserId] forHTTPHeaderField:@"uid"];
        }else{
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.token] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.userId] forHTTPHeaderField:@"uid"];
            NSLog(@"cid--------%@",[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]]);
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]] forHTTPHeaderField:@"cid"];

        }
        [manager.requestSerializer setValue:[NSString getDeviceName] forHTTPHeaderField:@"dname"];
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.不使用缓存
    else{
        return;
    }
}
//调用：get方式提交
-(void)REquestByGetWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
      
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
//        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
//        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
//        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
//        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        
        [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.不使用缓存
    else{
        return;
    }
    
}

//调用：put方式提交
-(void)requestByPutWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
        
    }
    //2.不使用缓存
    else{
        return;
    }
    
}





//上传文件(data)
-(void)uploadFileWithPath:(NSString*)path WithData:(NSData*)data andFileName:(NSString*)fileName andParameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer.stringEncoding = encodingType;
    
    
    [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //解析出文件名
    NSString* name = [fileName stringByDeletingPathExtension];
    
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"multipart/form-data"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //判断数据是否符合预期，给出提示
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"401"]) {
                [ApplicationDelegate AppTokenInvalid];
                return;
            }
            [delegate requestSuccess:responseObject SerialNum:serialNum];
            [self showSystemErrorWithResult:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error && [error isKindOfClass:[NSError class]]){
            NSError *Error = (NSError *)error;
            NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
            [delegate requestFail:err serialNum:serialNum];
        }else{
            [delegate requestFail:[error localizedDescription] serialNum:serialNum];
        }
    }];
}

-(void)requestTypeTwoByPostWithPath:(NSString*)path Parameters:(id)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.使用缓存
    else{
        return;
    }


}
- (NSString *)networkIsReachable
{
    NSString * str;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            str  = @"no";
            break;
        case ReachableViaWiFi:
            str = @"wifi";
            break;
        case ReachableViaWWAN:
            str = @"wan";
            break;
    }
    return str;
}

-(void)showSystemErrorWithResult:(NSDictionary *)result{
    
    NSString * success = [NSString stringWithFormat:@"%@",[result objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        if ([result[@"error"] isKindOfClass:[NSDictionary class]]) {
            if ([NSString isEqualToNull:result[@"error"][@"message"]]) {
                
                [[GPAlertView sharedAlertView]showAlertText:[[AppDelegate appDelegate]topViewController] WithText:[NSString stringWithFormat:@"%@",result[@"error"][@"message"]] duration:1.0];
            }
        }
    }
}
//查验微信发票
-(void)REquestWeChatPDFByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache{
    
    //1.不使用缓存
    if (!ifUserCache) {
        AFHTTPSessionManager *manager=[AFSessionSingleton shareFileManager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.responseSerializer.stringEncoding = encodingType;
        userData * datas = [userData shareUserData];
        if (datas.SystemType==1) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemToken] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.SystemUserId] forHTTPHeaderField:@"uid"];
        }else{
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.token] forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",datas.userId] forHTTPHeaderField:@"uid"];
            NSLog(@"cid--------%@",[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]]);
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[datas.multCompanyId integerValue]] forHTTPHeaderField:@"cid"];
        }
        [manager.requestSerializer setValue:[NSString getDeviceName] forHTTPHeaderField:@"dname"];
        [manager.requestSerializer setValue:@"jsoiajfa" forHTTPHeaderField:@"device"];
        [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"source"];
        [manager.requestSerializer setValue:XIBAOVERSION forHTTPHeaderField:@"Version"];
        [manager.requestSerializer setValue:[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" forHTTPHeaderField:@"lang"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 18000.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //判断数据是否符合预期，给出提示
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *code=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"401"]) {
                    [ApplicationDelegate AppTokenInvalid];
                    return;
                }
                [delegate requestSuccess:responseObject SerialNum:serialNum];
                [self showSystemErrorWithResult:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error && [error isKindOfClass:[NSError class]]){
                NSError *Error = (NSError *)error;
                NSString *err = [NSString stringWithFormat:@"%@",[Error.userInfo objectForKey:@"NSLocalizedDescription"]];
                [delegate requestFail:err serialNum:serialNum];
            }else{
                [delegate requestFail:[error localizedDescription] serialNum:serialNum];
            }
        }];
    }
    //2.不使用缓存
    else{
        return;
    }
    
}






@end
