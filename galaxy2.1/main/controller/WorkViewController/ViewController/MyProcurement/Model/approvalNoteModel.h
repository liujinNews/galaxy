//
//  approvalNoteModel.h
//  galaxy
//
//  Created by hfk on 15/10/30.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface approvalNoteModel : NSObject
@property (copy, nonatomic) NSString * actionLinkName;
@property (copy, nonatomic) NSString * comment;
@property (copy, nonatomic) NSString * finishDate;
@property (copy, nonatomic) NSString * handlerUserId;
@property (copy, nonatomic) NSString * handlerUserName;
@property (copy, nonatomic) NSString * nodeName;
@property (copy, nonatomic) NSString * procId;
@end
