/*!
 @header SGDatabaseManager.h
 
 @abstract 数据库类管理
 
 @author Created by 吴周鑫 on 16/4/27.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

#if __has_include(<FMDB/FMDB.h>)
#import <fmdb/FMDB.h>
#else
#import "FMDB.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @brief 键值存储单元
 */
@interface SGSKeyValueItem : NSObject

/*!
 *  @brief 键，存储单元唯一标识
 */
@property (nullable, nonatomic, copy) NSString *itemId;

/*!
 *  @brief 创建时间
 */
@property (nullable, nonatomic, strong) id itemObject;

/*!
 *  @brief 创建时间
 */
@property (nullable, nonatomic, strong) NSDate *createdTime;

@end


/*!
 *  @brief 数据库管理者
 */
@interface SGSDatabaseManager : NSObject

/*!
 *  @brief FMDB 线程安全队列
 */
@property (nonatomic, strong, readonly) FMDatabaseQueue * dbQueue;

/*!
 *  @brief 校验表名是否合法
 *  
 *  @discussion 合法的表名长度不能为0，并且不能包含有空格
 *
 *  @param tableName 表名
 *
 *  @return 合法的表名返回'YES'，非法的表名返回'NO'
 */
+ (BOOL)checkTableName:(NSString *)tableName;

/*!
 *  @brief 根据数据库名实例化数据库管理者
 *
 *  @discussion 数据库的路径为：~/Documents/数据库名
 *
 *  数据库存在直接连接，如果不存在则创建并连接
 *
 *  @param dbName 数据库名
 *
 *  @return 数据库管理者
 */
- (instancetype)initDBWithName:(NSString *)dbName;

/*!
 *  @brief 根据指定的数据库路径实例化数据库管理者
 *
 *  @discussion 数据库存在直接连接，如果不存在则创建并连接
 *
 *  @param dbPath 数据库路径
 *
 *  @return 数据库管理者
 */
- (instancetype)initWithDBWithPath:(NSString *)dbPath;

/*!
 *  @brief 关闭数据库
 */
- (void)close;


#pragma mark - 表操作
///-----------------------------------------------------------------------------
/// @name 表操作
///-----------------------------------------------------------------------------

/*!
 *  @brief 根据表名创建数据库表
 *
 *  @param tableName 数据库表名
 */
- (void)createTableWithName:(NSString *)tableName;

/*!
 *  @brief 判断数据库表是否存在
 *
 *  @param tableName 数据库表名
 *
 *  @return 存在返回'YES'，不存在返回'NO'
 */
- (BOOL)isTableExists:(NSString *)tableName;

/*!
 *  @brief 清空数据库表
 *
 *  @param tableName 数据库表名
 */
- (void)clearTable:(NSString *)tableName;

/*!
 *  @brief 删除数据库表
 *
 *  @param tableName 数据库表名
 */
- (void)dropTable:(NSString *)tableName;


#pragma mark - 数据操作
///-----------------------------------------------------------------------------
/// @name 数据操作
///-----------------------------------------------------------------------------

/*!
 *  @brief 将JSON对象插入指定表中
 *
 *  @param object    JSON对象
 *  @param objectId  Id
 *  @param tableName 表名
 */
- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

/*!
 *  @brief 根据id从指定表中获取数据
 *
 *  @param objectId  Id
 *  @param tableName 表名
 *
 *  @return JSON对象 or nil
 */
- (nullable id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

/*!
 *  @brief 根据id从指定表中获取存储单元
 *
 *  @param objectId  Id
 *  @param tableName 表名
 *
 *  @return 存储单元 or nil
 */
- (nullable SGSKeyValueItem *)getKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

/*!
 *  @brief 将字符串插入指定表中
 *
 *  @param string    字符串
 *  @param stringId  Id
 *  @param tableName 表名
 */
- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

/*!
 *  @brief 根据id从指定表中获取字符串
 *
 *  @param stringId  Id
 *  @param tableName 表名
 *
 *  @return 字符串 or nil
 */
- (nullable NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

/*!
 *  @brief 将数字插入指定表中
 *
 *  @param number    数字
 *  @param numberId  Id
 *  @param tableName 表名
 */
- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;

/*!
 *  @brief 根据id从指定表中获取数字
 *
 *  @param numberId  Id
 *  @param tableName 表名
 *
 *  @return 数字 or nil
 */
- (nullable NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

/*!
 *  @brief 从指定表中获取所有记录
 *
 *  @param tableName 表名
 *
 *  @return 数据记录 or nil
 */
- (nullable NSArray *)getAllItemsFromTable:(NSString *)tableName;

/*!
 *  @brief 获取指定表中的记录数
 *
 *  @param tableName 表名
 *
 *  @return 记录数目
 */
- (NSUInteger)getCountFromTable:(NSString *)tableName;

/*!
 *  @brief 从指定表中删除匹配id的记录
 *
 *  @param objectId  Id
 *  @param tableName 表名
 */
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

/*!
 *  @brief 从指定表中批量删除所有匹配数组中id的记录
 *
 *  @param objectIdArray Id数组
 *  @param tableName     表名
 */
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

/*!
 *  @brief 从指定表中批量删除匹配指定前缀id的记录
 *
 *  @param objectIdPrefix 模糊匹配的id
 *  @param tableName      表名
 */
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

@end


NS_ASSUME_NONNULL_END
