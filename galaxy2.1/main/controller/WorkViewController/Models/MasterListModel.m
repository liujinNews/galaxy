//
//  MasterListModel.m
//  galaxy
//
//  Created by hfk on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MasterListModel.h"

@implementation MasterListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getMasterListByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        MasterListModel *model=[[MasterListModel alloc]init];
        model.Id =dict[@"id"];
        model.name=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
        model.no=dict[@"no"];
        [array addObject:model];
    }

}
@end
