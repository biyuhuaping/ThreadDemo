//
//  ZBCFThread.m
//  NestScrollView
//
//  Created by ZB on 2023/1/17.
//

#import "ZBCFThread.h"

@interface ZBThread : NSThread
@end

@implementation ZBThread
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end



@interface ZBCFThread ()

@property (nonatomic, strong) ZBThread *thread;

@end

@implementation ZBCFThread

- (instancetype)init{
    self = [super init];
    if (self) {
        self.thread = [[ZBThread alloc]initWithBlock:^{
            NSLog(@"---- 线程begin ----");
            
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            // 销毁source
            CFRelease(source);
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            NSLog(@"---- 线程end ----");
        }];
        [self.thread start];
    }
    return self;
}

- (void)executeTask:(void(^)(void))task{
    if (!self.thread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)__executeTask:(void(^)(void))task{
    task();
}

- (void)stop{
    if (!self.thread) return;
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)__stop{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [self stop];
}

@end
