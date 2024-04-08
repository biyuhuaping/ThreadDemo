//
//  ZBPermenantThread.h
//  NestScrollView
//
//  Created by ZB on 2023/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBPermenantThread : NSObject


/// 开启一个子线程，并在子线程执行一个任务
/// @param block block
- (void)executeTask:(void(^)(void))block;

/// 结束线程（不调用也会自动结束线程）
- (void)stop;

@end

NS_ASSUME_NONNULL_END
