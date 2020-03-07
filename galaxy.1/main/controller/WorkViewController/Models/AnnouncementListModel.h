//
//  AnnouncementListModel.h
//  galaxy
//
//  Created by hfk on 2018/2/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementListModel : NSObject

@property(nonatomic,copy)NSString *attachment;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *authorId;
@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *isSticky;
@property(nonatomic,copy)NSString *noticeReceiverDtos;
@property(nonatomic,copy)NSString *publishedDate;
@property(nonatomic,copy)NSString *receiverObject;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *supportCount;
@property(nonatomic,copy)NSString *visitCount;
@property(nonatomic,copy)NSString *visitPplCount;
@property(nonatomic,copy)NSString *support;

@end
