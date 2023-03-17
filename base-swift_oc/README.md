


## SIL 官方文档
(Apple Swift DOC)[https://github.com/apple/swift/tree/main/docs]
(SIL)[https://github.com/apple/swift/blob/main/docs/SIL.rst#reference-counts]

## OC 官方文档
(Objective-C Runtime)[https://developer.apple.com/documentation/objectivec/objective-c_runtime]
(消息转发的案例)[https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html#//apple_ref/doc/uid/TP40008048-CH105-SW11]


### OC 的重要源码定义
1. isa 在 objc-private.h
2. objc_object 在 objc-private.h
3. Class 在 runtime.h
```Objective-C
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
    
    #if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
    #endif

} OBJC2_UNAVAILABLE;
/* Use `Class` instead of `struct objc_class *` */
```
4. autoreleasingpool 的相关操作方法 （objc源码及CoreFundation）
- NSObject.mm 方法 _objc_autoreleasePoolPrint() 打印当前autoreleasingpool的情况
- 

### OC 内存管理原则
1. 自己生成的对象，自己所持有【retain】 （必须）；
2. 非自己生成的对象，自己也能持有（看情况，可以不持有，也可以持有，有一定的约定）；
3. 自己持有的对象，不再需要时要释放（必须）；
4. 非自己持有的对象，无法释放（必须）；

以下约定：
1. new/alloc/copy/mutableCopy 的方法前缀会生成并持有对象；
2. reatin 仅仅持有对象
3. release 仅释放对象
4. dealloc 仅废弃对象


arc关键点解读：
1. autoreleasingpool 中加入对象 会增加引用计数吗？
2. __weak 修饰的变量，会自动注册到 autoReleasePool 中
3. 默认变量修饰符为 __strong 
4. 在 __strong 时，即使非自己生成的对象，也会进行一次持有，但是__weak则不会，而是自动注册到autoreleaspool中
