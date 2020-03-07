//
//  BackSubmitCommentController.h
//  galaxy
//
//  Created by hfk on 2018/3/26.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface BackSubmitCommentController : VoiceBaseController

@property(nonatomic,strong)FormBaseModel *FormDatas;

//1退回提交  2直送
@property(nonatomic,assign)NSInteger type;

/**
 多余参数
 */
@property(nonatomic,copy)NSString *str_CommonField;


//付款多余参数
@property(nonatomic,assign)BOOL bool_AddPars;
@property(nonatomic,copy)NSString *str_PayAmount;
@property(nonatomic,copy)NSString *str_PayContGridOrder;
@property(nonatomic,copy)NSString *str_PayContractNumber;


@end
