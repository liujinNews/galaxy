//
//  quaryResultData.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, quaryCellType) {
    quaryCellTypeTitle,
    quaryCellTypeContent,
    quaryCellTypeResult
};
@interface quaryResultData : NSObject
@property(nonatomic, assign)quaryCellType type;  //cell类型
@property(nonatomic, strong)NSDictionary * quaryDoc; //
@property(nonatomic, strong)NSString *title;    //标题
@property(nonatomic, strong)NSNumber *height;   //cell高
+ (NSMutableArray *)quaryDocDatasWithUser:(NSDictionary *)quaryDoc;

@end
