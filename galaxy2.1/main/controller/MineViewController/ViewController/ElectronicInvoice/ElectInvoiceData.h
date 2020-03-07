//
//  ElectInvoiceData.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, electCellType) {
    electCellTypeTitle,
    electCellTypeSelected,
    electCellTypeNoSelected
};
@interface ElectInvoiceData : NSObject
@property(nonatomic, assign)electCellType type;  //cell类型
@property(nonatomic, strong)NSDictionary * quaryDoc; //
@property(nonatomic, strong)NSString *title;    //标题
@property(nonatomic, strong)NSNumber *height;   //cell高
+ (NSMutableArray *)electDocDatasWithUser:(NSDictionary *)quaryDoc;

//list
@property(nonatomic, strong)NSString * fP_DM;
@property(nonatomic, strong)NSString * fP_HM;
@property(nonatomic, strong)NSString * fplx;
@property(nonatomic, strong)NSString * gmF_MC;
@property(nonatomic, strong)NSString * jshj;
@property(nonatomic, strong)NSString * quaryType;
//+ (void)electListDocDatasWithUser:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
