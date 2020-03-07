//
//  ItemRequestDetail.h
//  galaxy
//
//  Created by hfk on 2018/3/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemRequestDetail : NSObject
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *InventoryId;
@property (nonatomic, copy) NSString *Brand;
@property (nonatomic, copy) NSString *Spec;
@property (nonatomic, copy) NSString *Unit;
@property (nonatomic, copy) NSString *Qty;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *UsedPart;
@property (nonatomic, copy) NSString *UsedNode;
@property (nonatomic, copy) NSString *Remark;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(ItemRequestDetail *)model;

@end
