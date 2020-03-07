//
//  WareHouseEntryDetail.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WareHouseEntryDetail : NSObject

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Brand;
@property (nonatomic, copy) NSString *Spec;
@property (nonatomic, copy) NSString *Unit;
@property (nonatomic, copy) NSString *Qty;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *ItemId;
@property (nonatomic, copy) NSString *ItemCatId;
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *ItemCatName;




+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(WareHouseEntryDetail *)model;


@end

NS_ASSUME_NONNULL_END
