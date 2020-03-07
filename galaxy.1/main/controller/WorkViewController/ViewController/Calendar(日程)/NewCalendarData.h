//
//  NewCalendarData.h
//  galaxy
//
//  Created by hfk on 2018/1/16.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCalendarData : NSObject

@property(nonatomic,copy)NSString *Subject;
@property(nonatomic,copy)NSString *Address;
@property(nonatomic,copy)NSString *StartTime;
@property(nonatomic,copy)NSString *EndTime;
@property(nonatomic,copy)NSString *NotifyUserId;
@property(nonatomic,copy)NSString *NotifyUserName;
@property(nonatomic,copy)NSString *IsPrivate;
@property(nonatomic,copy)NSString *ProjId;
@property(nonatomic,copy)NSString *ProjName;
@property(nonatomic,copy)NSString *ProjMgrUserId;
@property(nonatomic,copy)NSString *ProjMgr;
@property(nonatomic,copy)NSString *ClientId;
@property(nonatomic,copy)NSString *ClientName;
@property(nonatomic,copy)NSString *SupplierId;
@property(nonatomic,copy)NSString *SupplierName;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *Attachments;
@property(nonatomic,copy)NSString *Id;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(NewCalendarData *)model;

@end
