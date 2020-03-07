//
//  FormRelatedView.h
//  galaxy
//
//  Created by hfk on 2018/11/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitPersonalModel.h"
#import "FormBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormRelatedView : UIView
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
@property(nonatomic,strong)UITextField *txf_Client;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;

@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableDictionary *requireDict;
@property(nonatomic,strong)NSMutableArray *unShowArray;
@property(nonatomic,strong)VoiceBaseController *baseController;
@property(nonatomic,strong)FormBaseModel *baseModel;

//申请人返回数据
@property (nonatomic, copy) void(^FormRelatedViewBackBlock)(id backObj);


/**
 填写页面

 @param dateArray 表单显示数据
 @param requireDict 必填项字典
 @param unShowArray 不显示数组
 @param baseModel 表单数据
 */
-(void)initFormRelatedViewWithDate:(NSMutableArray *)dateArray WithRequireDict:(NSMutableDictionary *)requireDict WithUnShowArray:(NSMutableArray *)unShowArray WithBaseModel:(FormBaseModel *)baseModel Withcontroller:(VoiceBaseController *)baseController;


/**
 查看页面申请人信息视图
 
 @param dateArray 表单显示数据
 @param baseModel 表单数据
 
 */
-(void)initOnlyApproveFormRelatedViewWithDate:(NSMutableArray *)dateArray WithBaseModel:(FormBaseModel *)baseModel;

/**
 查看审批页面视图
 
 @param dateArray 表单显示数据
 @param baseModel 数据Model
 */
-(void)initApproveFormRelatedViewWithDate:(NSMutableArray *)dateArray WithBaseModel:(FormBaseModel *)baseModel;

@end

NS_ASSUME_NONNULL_END
