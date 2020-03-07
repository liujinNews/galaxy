//
//  MeetingRoomModel.m
//  galaxy
//
//  Created by hfk on 2017/12/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingRoomModel.h"

@implementation MeetingRoomModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getMeetRoomDateWithDict:(NSDictionary *)dic withResult:(NSMutableArray *)array{
    NSArray * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    for (NSDictionary *dict in result) {
        MeetingRoomModel *model=[[MeetingRoomModel alloc]init];
        model.nameCh=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"nameCh"]]]?[NSString stringWithFormat:@"%@",dict[@"nameCh"]]:@"";
        
        model.nameEn=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"nameEn"]]]?[NSString stringWithFormat:@"%@",dict[@"nameEn"]]:@"";
        model.location=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"location"]]]?[NSString stringWithFormat:@"%@",dict[@"location"]]:@"";
        model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"";
        model.capacity=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"capacity"]]]?[NSString stringWithFormat:@"%@",dict[@"capacity"]]:@"";
        model.name=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
        model.equipment=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"equipment"]]]?[NSString stringWithFormat:@"%@",dict[@"equipment"]]:@"";
        model.meetingBookings=[NSMutableArray array];
        if (![dict[@"meetingBookings"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=dict[@"meetingBookings"];
            if (![arr isKindOfClass:[NSNull class]]&&arr.count>0) {
                [MeetingRoomSubModel getMeetRoomDuringWithArray:arr withResult:model.meetingBookings];
            }
        }
        [array addObject:model];
    }
}

@end


@implementation MeetingRoomSubModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getMeetRoomDuringWithArray:(NSMutableArray *)array withResult:(NSMutableArray *)resultarray{
    for (NSDictionary *dict in array) {
        MeetingRoomSubModel *model=[[MeetingRoomSubModel alloc]init];
        model.roomId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"roomId"]]]?[NSString stringWithFormat:@"%@",dict[@"roomId"]]:@"";
        model.taskId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"taskId"]]]?[NSString stringWithFormat:@"%@",dict[@"taskId"]]:@"";
        model.startTimeStr=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"startTimeStr"]]]?[NSString stringWithFormat:@"%@",dict[@"startTimeStr"]]:@"";
        model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"";
        model.endTime=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"endTime"]]]?[NSString stringWithFormat:@"%@",dict[@"endTime"]]:@"";
        model.endTimeStr=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"endTimeStr"]]]?[NSString stringWithFormat:@"%@",dict[@"endTimeStr"]]:@"";
        model.startTime=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"startTime"]]]?[NSString stringWithFormat:@"%@",dict[@"startTime"]]:@"";
        [resultarray addObject:model];
        
    }
}
@end
