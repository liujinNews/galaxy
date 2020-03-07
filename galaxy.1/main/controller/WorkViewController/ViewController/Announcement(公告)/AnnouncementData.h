//
//  AnnouncementData.h
//  galaxy
//
//  Created by hfk on 2018/2/11.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementData : NSObject


@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *Subject;
@property(nonatomic,copy)NSString *Body;
@property(nonatomic,copy)NSString *Attachment;
@property(nonatomic,copy)NSString *PublishedDate;
@property(nonatomic,copy)NSString *ReceiverObject;
@property(nonatomic,copy)NSString *Author;
@property(nonatomic,strong)NSMutableArray *NoticeReceiverDtos;
@property(nonatomic,copy)NSString *Status;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AnnouncementData *)model;

@end
