//
//  Header.h
//  TRPet
//
//  Created by ljc on 15/7/25.
//  Copyright (c) 2015年 taro. All rights reserved.
//

#ifndef TRPet_Header_h
#define TRPet_Header_h

#import <UIKit/UIKit.h>
typedef void(^XunFeiBlock)(NSString *result, NSError *error);

@interface XunFei : NSObject

+ (instancetype)sharedInstance;
- (void)initAppid:(NSString*)id;
- (void)initRecognizer:(UIView*)view;

-(void)stop;
-(void)start:(XunFeiBlock)block;
    
    
@end
#endif
