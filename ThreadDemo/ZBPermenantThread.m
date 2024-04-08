//
//  ZBPermenantThread.m
//  NestScrollView
//
//  Created by ZB on 2023/1/17.
//

#import "ZBPermenantThread.h"

//@interface ZBThread : NSThread
//@end
//
//@implementation ZBThread
//- (void)dealloc{
//    NSLog(@"%s",__func__);
//}
//@end



@interface ZBPermenantThread ()

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;

@end

@implementation ZBPermenantThread

- (instancetype)init{
    self = [super init];
    if (self) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        
        self.thread = [[NSThread alloc]initWithBlock:^{
            NSLog(@"---- 线程begin ----");
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"---- 线程end ----");
        }];
        [self.thread start];
    }
    return self;
}

- (void)executeTask:(void(^)(void))block{
    if (!self.thread || !block) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:block waitUntilDone:NO];
}

- (void)__executeTask:(void(^)(void))block{
    block();
}

- (void)stop{
    if (!self.thread) return;
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)__stop{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [self stop];
}

@end
