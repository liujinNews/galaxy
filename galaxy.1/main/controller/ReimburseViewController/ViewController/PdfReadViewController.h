//
//  PdfReadViewController.h
//  galaxy
//
//  Created by hfk on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "AddDetailsModel.h"
@interface PdfReadViewController : RootViewController<UIWebViewDelegate,GPClientDelegate>
@property(nonatomic,strong)AddDetailsModel *AddModel;
@property(nonatomic,strong)HasSubmitDetailModel *CheckAddModel;
@property (nonatomic,strong)NSString *PdfUrl;
@end
