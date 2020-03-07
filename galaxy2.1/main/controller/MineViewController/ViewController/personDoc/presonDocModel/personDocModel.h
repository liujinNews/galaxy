//
//  personDocModel.h
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, personDocCellType) {
    personDocCellTypeAvater,
    personDocCellTypeName,
    personDocCellTypeDept,
    personDocCellTypeBankCard,
    personDocCellTypePhoneHidden,
    personDocCellTypeLookReportRoot,
    personDocCellTypeSignature
};

@interface personDocModel : NSObject

@property(nonatomic, assign)personDocCellType type;  //cell类型
@property(nonatomic, strong)NSDictionary * perDoc; //头像及icon
@property(nonatomic, strong)NSString *title;    //标题
@property(nonatomic, strong)NSNumber *height;   //cell高
@property(nonatomic)SEL action;                 //cell触发对象
+ (NSMutableArray *)personDocDatasWithUser:(NSDictionary *)perDoc;

@end
