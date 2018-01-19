//
//  SGFFOutputRenderQueue.m
//  SGPlayer
//
//  Created by Single on 2018/1/19.
//  Copyright © 2018年 single. All rights reserved.
//

#import "SGFFOutputRenderQueue.h"

@interface SGFFOutputRenderQueue ()

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) long long duration;
@property (nonatomic, assign) long long size;

@property (nonatomic, strong) NSCondition * condition;
@property (nonatomic, strong) NSMutableArray <id <SGFFOutputRender>> * objects;

@property (nonatomic, assign) BOOL didDestoryed;

@end

@implementation SGFFOutputRenderQueue

- (instancetype)initWithMaxCount:(NSInteger)maxCount
{
    if (self = [super init])
    {
        self.maxCount = maxCount;
        self.objects = [NSMutableArray array];
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)putObjectSync:(id <SGFFOutputRender>)object
{
    if (self.didDestoryed) {
        return;
    }
    [self.condition lock];
    while (self.objects.count >= self.maxCount)
    {
        if (self.didDestoryed)
        {
            [self.condition unlock];
            return;
        }
        [self.condition wait];
    }
    [self putObject:object];
    [self.condition signal];
    [self.condition unlock];
}

- (void)putObjectAsync:(id <SGFFOutputRender>)object
{
    if (self.didDestoryed) {
        return;
    }
    [self.condition lock];
    if (self.objects.count >= self.maxCount)
    {
        [self.condition unlock];
        return;
    }
    [self putObject:object];
    [self.condition signal];
    [self.condition unlock];
}

- (id <SGFFOutputRender>)getObjectSync
{
    [self.condition lock];
    while (self.objects.count <= 0)
    {
        if (self.didDestoryed)
        {
            [self.condition unlock];
            return nil;
        }
        [self.condition wait];
    }
    id <SGFFOutputRender> object = [self getObject];
    [self.condition unlock];
    return object;
}

- (void)putObject:(id <SGFFOutputRender>)object
{
    [self.objects addObject:object];
    self.duration += object.duration;
    self.size += object.size;
}

- (id <SGFFOutputRender>)getObjectAsync
{
    [self.condition lock];
    if (self.objects.count <= 0 || self.didDestoryed)
    {
        return nil;
    }
    id <SGFFOutputRender> object = [self getObject];
    [self.condition unlock];
    return object;
}

- (id <SGFFOutputRender>)getObject
{
    if (!self.objects.firstObject) {
        return nil;
    }
    id <SGFFOutputRender> object = self.objects.firstObject;
    [self.objects removeObjectAtIndex:0];
    self.duration -= object.duration;
    if (self.duration < 0 || self.count <= 0) {
        self.duration = 0;
    }
    self.size -= object.size;
    if (self.size <= 0 || self.count <= 0) {
        self.size = 0;
    }
    return object;
}

- (NSInteger)count
{
    return self.objects.count;
}

- (void)flush
{
    [self.condition lock];
    [self.objects removeAllObjects];
    self.size = 0;
    self.duration = 0;
    [self.condition unlock];
}

- (void)destroy
{
    self.didDestoryed = YES;
    [self flush];
}

@end