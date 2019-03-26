# Southgis iOS(OC) 移动支撑平台组件 - 数据持久化存储组件

[![CI Status](http://img.shields.io/travis/Lee/SGSDatabase.svg?style=flat)](https://travis-ci.org/Lee/SGSDatabase)
[![Version](https://img.shields.io/cocoapods/v/SGSDatabase.svg?style=flat)](http://cocoapods.org/pods/SGSDatabase)
[![License](https://img.shields.io/cocoapods/l/SGSDatabase.svg?style=flat)](http://cocoapods.org/pods/SGSDatabase)
[![Platform](https://img.shields.io/cocoapods/p/SGSDatabase.svg?style=flat)](http://cocoapods.org/pods/SGSDatabase)

------

**SGSDatabase**（OC版本）是移动支撑平台 iOS Objective-C 组件之一，该组件是基于 [FMDB](https://github.com/ccgus/fmdb) 封装的键值对数据存储工具

## 安装
------
**SGSDatabase** 可以通过 **Cocoapods** 进行安装，可以复制下面的文字到 Podfile 中：

```ruby
target '项目名称' do
pod 'SGSDatabase', '~> 0.1.0'
end
```

如果自行导入需要在工程的 `General` 板块的 `Linked Frameworks and Libraries` 选项中添加 `libsqlite3.tbd` 

## 使用说明
------
通过 **SGSDatabaseManager** 实例来进行数据库操作

### 连接数据库

在实例化 **SGSDatabaseManager** 时，会自动连接指定目录下的数据库，如果数据库不存在，则会创建一个新的数据库

```
// 打开~/Documents/目录下默认的的database.sqlite数据库，如果不存在则创建同名的数据库
SGSDatabaseManager *dbManager = [[SGSDatabaseManager alloc] init];

// 打开~/Documents/目录下的MyDatabase1.sqlite数据库，如果不存在则创建同名的数据库
SGSDatabaseManager *dbManager1 = [[SGSDatabaseManager alloc] initDBWithName:@"MyDatabase1.sqlite"];

// 打开Home目录下的MyDatabase2.sqlite数据库，如果不存在则创建同名的数据库
NSString *path = @"~/MyDatabase2.sqlite".stringByExpandingTildeInPath;
SGSDatabaseManager *dbManager2 = [[SGSDatabaseManager alloc] initWithDBWithPath:path];

// 关闭数据库
[dbManager close];
```

### 数据库表操作

通过 `-createTableWithName:` 方法可以创建一张只有id（Key）、json（Value）、createdTime（记录的插入或更新时间）字段结构的数据库表
通过 `-isTableExists:` 方法判断数据库表是否存在
通过 `-clearTable:` 方法清空表内的记录
通过 `-dropTable:` 方法删除数据库表

```
// 创建表
[dbManager createTableWithName:tableName];

// 判断表是否存在
BOOL isTableExists = [dbManager isTableExists:tableName];

// 清空表记录
[dbManager clearTable:tableName];

// 删除表
[dbManager dropTable:tableName];
```

### 数据增删改查

**SGSDatabaseManager** 以键值对的形式存储数据，存入的数据需要提供Key以及对应的Value，如果使用同一个Key重复存储多次，将会替换原来的Value

可存储的数值类型包括： **JSON** ( **NSDictionary** 和 **NSArray** ) 、 **NSString** 、 **NSNumber** ，存储的接口如下：

```
// 存储字典或数组对象
- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

// 存储字符串
- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

// 存储数字
- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;


// 例子
Person *p = [[Person alloc] initWithIdNum:@"1001" name:@"张三" age:@(20)];
id json = p.toJSON;
[dbManager putObject:json withId:@"1001" intoTable:@"PersonTable"];

// 如果需要更新记录，可以使用同一个Key重新存储即可
// 更新张三的数据
p.age = @(22);
json = p.toJSON;
[dbManager putObject:json withId:@"1001" intoTable:@"PersonTable"];
```

获取数据的接口如下：

```
// 获取字典或数组对象
- (nullable id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

// 获取字符串
- (nullable NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

// 获取数值
- (nullable NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

// 获取所有记录
- (nullable NSArray *)getAllItemsFromTable:(NSString *)tableName;
```

删除数据的接口如下：

```
// 清空数据库表的所有记录
- (void)clearTable:(NSString *)tableName;

// 从指定表中，删除匹配Key的记录
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

// 从指定表中，批量删除匹配一组Key的记录
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

// 从指定表中，批量删除匹配指定前缀的记录
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;
```

### FMDB

**SGSDatabaseManager** 对外暴露了 `FMDatabaseQueue` 类型的属性 `dbQueue`
```
@property (nonatomic, strong, readonly) FMDatabaseQueue * dbQueue;
```

因此可以通过该属性继续使用FMDB的功能

例如希望继续以关系型数据表的形式存储数据而不是Key-Value的形式存储，可以使用FMDB的功能来完成

```
// 创建关系型数据库表
[dbManager.dbQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PersonTable (id TEXT NOT NULL, name TEXT, age INTEGER, PRIMARY KEY(id))"];
}];

// 插入数据
__block BOOL success;
[_dbManager.dbQueue inDatabase:^(FMDatabase *db) {
    success = [db executeUpdate:@"INSERT INTO PersonTable (id, name, age) values (?, ?, ?)", p.idNum, p.name, p.age];
}];
if (success) {
    NSLog(@"保存成功");
} else {
    NSLog(@"保存失败");
}

// 获取数据
__block NSString *idNum = nil;
__block NSString *name  = nil;
__block int age         = 0;

[_dbManager.dbQueue inDatabase:^(FMDatabase *db) {
    FMResultSet * rs = [db executeQuery:@"SELECT * from PersonTable where id = ? Limit 1", @"1001"];
    if ([rs next]) {
        idNum = [rs stringForColumn:@"id"];
        name = [rs stringForColumn:@"name"];
        age = [rs intForColumn:@"age"];
    }
    [rs close];
}];

if (idNum) {
    Person *p = [[Person alloc] initWithIdNum:idNum name:name age:@(age)];
    NSLog(@"获取数据成功: %@", p.description);
} else {
    NSLog(@"获取数据失败");
}
```

## 结尾
------
**移动支撑平台** 是研发中心移动团队打造的一套移动端开发便捷技术框架。这套框架立旨于满足公司各部门不同的移动业务研发需求，实现App快速定制的研发目标，降低研发成本，缩短开发周期，达到代码的易扩展、易维护、可复用的目的，从而让开发人员更专注于产品或项目的优化与功能扩展

整体框架采用组件化方式封装，以面向服务的架构形式供开发人员使用。同时兼容 Android 和 iOS 两大移动平台，涵盖 **网络通信**, **数据持久化存储**, **数据安全**, **移动ArcGIS** 等功能模块（近期推出混合开发组件，只需采用前端的开发模式即可同时在 Android 和 iOS 两个平台运行），各模块间相互独立，开发人员可根据项目需求使用相应的组件模块

更多组件请参考：
> * [HTTP 请求模块组件](http://112.94.224.243:8081/kun.li/sgshttpmodule/tree/master)
> * [数据安全组件](http://112.94.224.243:8081/kun.li/sgscrypto/tree/master)
> * [ArcGIS绘图组件](https://github.com/crash-wu/SGSketchLayer-OC)
> * [常用类别组件](http://112.94.224.243:8081/kun.li/sgscategories/tree/master)
> * [常用工具组件](http://112.94.224.243:8081/kun.li/sgsutilities/tree/master)
> * [集合页面视图](http://112.94.224.243:8081/kun.li/sgscollectionpageview/tree/master)
> * [二维码扫描与生成](http://112.94.224.243:8081/kun.li/sgsscanner/tree/master)

如果您对移动支撑平台有更多的意见和建议，欢迎联系我们！

研发中心移动团队

2016 年 08月 30日   

## Author
------
Lee, kun.li@southgis.com

## License
------
SGSDatabase is available under the MIT license. See the LICENSE file for more info.
