//
//  mineModel.h
//  galaxy
//
//  Created by 赵碚 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userData.h"

typedef NS_ENUM(NSInteger, mineCellType) {
    mineCellTypeInfo,
    mineCellTypeDelegateInfo,
    mineCellTypeCompany,
    mineCellTypeCompanyInfo,
    mineCellTypeMessage,
    mineCellTypeShare,
    mineCellTypeSetting,
} ;
@interface mineModel : NSObject
@property(nonatomic, assign)mineCellType type;  //cell类型
@property(nonatomic, strong)UIImage *iconImage; //头像及icon
@property(nonatomic, strong)NSString *title;    //标题
@property(nonatomic, strong)NSNumber *height;   //cell高
@property(nonatomic, strong)userData * perDic;

@property(nonatomic)SEL action;                 //cell触发对象
+ (NSMutableArray *)datasWithUser:(NSString *)quanxian  personDict:(userData *)dic;

@end
