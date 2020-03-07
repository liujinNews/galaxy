//
//  GPClient.h
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define MSDefaultURL @"http://10.1.2.125:8088/"

//服务器编码
#define encodingType CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
//上传文件路径
//#define uploadPath @"api"


@protocol GPClientDelegate

//请求成功
@optional -(void)requestSuccess:(NSDictionary*)responceDic SerialNum:(int)serialNum;

//请求失败
@optional -(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum;

//上传文件成功
@optional -(void)UploadCompeleted:(NSString*)result;

//上传文件失败
@optional -(void)UploadFail:(NSString*)errorString;
@end


@interface GPClient : NSObject
@property(weak,nonatomic) id<GPClientDelegate> delegate;

+(GPClient *)shareGPClient;

//发送请求调用，post方式
//-(void)requestByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;
//发送请求调用，post方式带头
-(void)REquestByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;

//发送请求调用，post不带参数
-(void)RequestByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;


//上传图片请求调用，post方式
-(void)RequestByPostOnImageWithPath:(NSString*)path Parameters:(NSDictionary*)parameters  NSData:(NSData *)image name:(NSString *)imageName type:(NSString *)type Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;

//发送请求调用，get方式
-(void)RequestByGetWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;

//发送请求调用，get方式
-(void)REquestByGetWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;
//发送请求调用，put方式
-(void)requestByPutWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;


-(void)RequestByPostOnImageWithPath:(NSString*)path Parameters:(NSDictionary*)parameters  NSArray:(NSArray *)images name:(NSArray *)imageNames type:(NSString *)type Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;

//上传文件(data)
-(void)uploadFileWithPath:(NSString*)path WithData:(NSData*)data andFileName:(NSString*)name andParameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;


//post方式方式2
-(void)requestTypeTwoByPostWithPath:(NSString*)path Parameters:(id)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;


/**
 *	@brief	判断网络
 *
 *	@return	bool(yes or no)
 */
- (NSString *)networkIsReachable;

//查验微信发票
-(void)REquestWeChatPDFByPostWithPath:(NSString*)path Parameters:(NSDictionary*)parameters Delegate:(id<GPClientDelegate>)delegate SerialNum:(int)serialNum IfUserCache:(BOOL)ifUserCache;

@end
