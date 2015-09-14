//
//  XunFei.m
//  TRPet
//
//  Created by ljc on 15/7/25.
//  Copyright (c) 2015年 taro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XunFei.h"
#import "IATConfig.h"

#import <iflyMSC/IFlyMSC.h>


@interface XunFei ()<IFlyRecognizerViewDelegate>
@property (copy, nonatomic) XunFeiBlock block;

@end


@implementation XunFei {

    IFlyRecognizerView *_iflyRecognizerView;
    
    BOOL _inited;
    
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


- (id)init {
     if ((self = [super init])) {
         //设置sdk的log等级，log保存在下面设置的工作路径中
         [IFlySetting setLogFile:LVL_ALL];
         
         //打开输出在console的log开关
         [IFlySetting showLogcat:YES];
         
         //设置sdk的工作路径
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
         NSString *cachePath = [paths objectAtIndex:0];
         [IFlySetting setLogFilePath:cachePath];
         

 
     }
    return self;
}


- (void)initAppid:(NSString*)id {
    if(!_inited) {
        //创建语音配置,appid必须要传入，仅执行一次则可
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",id];
        //所有服务启动前，需要确保执行createUtility
        [IFlySpeechUtility createUtility:initString];
        _inited = YES;
    }

}
- (void)initRecognizer:(UIView*)view{
    if (!_inited) {
        NSLog(@"xunfei not config appid");
        return;
    }
    
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:view.center];
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
//        [_iflyRecognizerView setParameter:[IFlySpeechConstant TYPE_LOCAL] forKey:[IFlySpeechConstant ENGINE_TYPE]];
        
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"10000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}

-(void)stop{
    if (_iflyRecognizerView) {
        [_iflyRecognizerView cancel]; //取消识别
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
}

-(void)start:(XunFeiBlock)block{
    _block = block;
    if (_iflyRecognizerView) {
        //设置音频来源为麦克风
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
//        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iflyRecognizerView start];
        
    }
    
}


/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"%s %@",__func__, result);
    if (_block) {
        _block(result, nil);
    }
    
    [self stop];
    _block = nil;
}

/*!
 *  识别结束回调
 *
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error{
    NSLog(@"%s",__func__);
    if (_block) {
        _block(@"", [NSError errorWithDomain:error.errorDesc code:error.errorCode userInfo:nil]);
    }
}


@end