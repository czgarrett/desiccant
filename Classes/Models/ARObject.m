////
////  ARObject.m
////  ZWorkbench
////
////  Created by Christopher Garrett on 6/1/08.
////  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
////
//
//#import "ARObject.h"
//#import "SQLiteConnectionAdapter.h"
//#import "Zest.h"
//
//@implementation ARObject
//
//@synthesize newRecord, attributes;
//
//#pragma mark Metadata
//
//+ (NSString *)tableName
//{
//	return [NSString stringWithFormat: @"%@s", [[self class] description]];
//}
//
//+ (SQLiteTable *)table
//{
//	return [[[self class] connection] tableNamed: [[self class] tableName]];
//}
//
//+ (NSString *) primaryKeyName {
//   return kPrimaryKeyName;
//}
//
//+ (NSString *) concatenatedColumnNames
//{
//	NSArray *columnNames = [[self table] columnNames];
//	return [columnNames componentsJoinedByString: @", "];   
//}
//
//- (NSString *) createdAtAttributeName
//{
//	return kCreatedAt;
//}
//- (NSString *) updatedAtAttributeName
//{
//	return kUpdatedAt;
//}
//
//- (NSString *)concatenatedColumnNames
//{
//   return [[self class] concatenatedColumnNames];
//}
//
//#pragma mark Database
//
//+ (SQLiteConnectionAdapter *)connection {
//	return [SQLiteConnectionAdapter defaultInstance];
//}
//
//#pragma mark Counters
//
//+ (NSInteger) count
//{
//	NSString *sql = [[NSString alloc] initWithFormat: @"select count(*) from %@", [[self class] tableName]];
//	QueryResult *result = [[ARObject connection] prepareAndExecute: sql];
//   [sql release];
//	NSInteger count = [[result firstRow] integerValueForColumn: @"count(*)"];
//	return count;
//}
//
//+ (NSInteger) countBySQL: (NSString *)sql, ...
//{
//   va_list bindings;
//   va_start(bindings, sql);          // Start scanning for arguments after firstObject.
//   return [self countBySQL: sql variables: bindings];
//}
//
//+ (NSInteger) countBySQL: (NSString *)sql variables: (va_list) bindings
//{
//   SQLitePreparedStatement *statement = [[self connection] preparedStatement: sql];
//   QueryResult *queryResult = [statement executeWithOperation: nil bindingVariables: bindings];
//   return [[queryResult firstRow] integerValueForColumn: @"count(*)"];
//}
//
//+ (NSInteger) countColumn: (NSString *)columnName withFilter: (NSString *) columnFilter {
//	NSString *sql = [NSString stringWithFormat: @"select count(*) from %@ where %@ like ?", [[self class] tableName], columnName];
//   return [self countBySQL: sql, columnFilter];
//}
//
//#pragma mark  Deletion
//
//+ (void)deleteAll
//{
//	NSString *deleteSQL = [NSString stringWithFormat: @"delete from %@", [self tableName]];
//	[[[self connection] preparedStatement: deleteSQL] execute];
//}
//
//+ (void) deleteAllWithCondition: (NSString *)condition, ...
//{
//   NSString *sql = [NSString stringWithFormat: @"delete from %@ where %@", [self tableName], condition];
//   va_list bindings;
//   va_start(bindings, condition);          // Start scanning for arguments after firstObject.
//   SQLitePreparedStatement *statement = [[self connection] preparedStatement: sql];
//   [statement executeWithOperation: nil bindingVariables: bindings];
//}
//
//#pragma mark Finders
//
//+ (NSMutableArray *) findByCondition: (NSString *)condition, ...
//{
//   va_list bindings;
//   va_start(bindings, condition);          // Start scanning for arguments after firstObject.
//   return [self findBySQL: [self sqlForFindByCondition: condition] variables: bindings operation: nil]; 
//}
//
//+ (ARObject *) findFirstByCondition: (NSString *)condition, ... {
//   va_list bindings;
//   va_start(bindings, condition);          // Start scanning for arguments after firstObject.
//   NSArray *result = [self findBySQL: [self sqlForFindByCondition: condition] variables: bindings operation: nil];    
//   if ([result count] > 0) {
//      return (ARObject *) [result objectAtIndex: 0];
//   } else {
//      return nil;
//   }
//}
//
//
//+ (ARObject *)findByPrimaryKey:(NSInteger)key
//{
//   NSString *sql = [NSString stringWithFormat: @"%@ = ?", [self primaryKeyName]];
//   return [[self findByCondition: sql, [NSNumber numberWithInteger:key]] objectAtIndex: 0];
//}
//
//+ (ARObject *) findByAttributeNamed: (NSString *) attributeName value: (NSString *) value {
//   NSString *sql = [NSString stringWithFormat: @"%@ = ?", attributeName];
//   NSArray *results = [self findByCondition: sql, value];
//   unless([results isEmpty]) {
//      return [results objectAtIndex: 0];   
//   } else {
//      return nil;      
//   }
//}
//
//
//+ (NSMutableArray *) findBySQL: (NSString *)sql, ...
//{
//   va_list bindings;
//   va_start(bindings, sql);          // Start scanning for arguments after firstObject.
//   return [self findBySQL: sql variables: bindings operation: nil];
//}
//
//+ (NSMutableArray *) findAll {
//   return [self findBySQL: [NSString stringWithFormat: @"select * from %@", [self tableName]] variables: nil operation: nil];   
//}
//
//+ (NSMutableArray *) findBySQL: (NSString *)sql variables: (va_list) bindings operation: (NSOperation *)operation
//{
//   SQLitePreparedStatement *statement = [[self connection] preparedStatement: sql];
//   QueryResult *queryResult = [statement executeWithOperation: operation bindingVariables: bindings];
//   return [self buildObjectsFromQueryResult: queryResult];
//}
//
//#pragma mark Low Level Operations
//
//+ (NSMutableArray *) usingOperation: (NSOperation *) operation 
//             findByCondition: (NSString *)condition, ... {
//   va_list bindings;
//   va_start(bindings, condition);          // Start scanning for arguments after firstObject.
//   return [self findBySQL: [self sqlForFindByCondition: condition] variables: bindings operation: operation];    
//}
//
//+ (NSString *) sqlForFindByCondition: (NSString *)condition {
//   return [NSString stringWithFormat: @"select %@ from %@ where %@", [self concatenatedColumnNames], [self tableName], condition];
//}
//
//+ (NSMutableArray *)buildObjectsFromQueryResult: (QueryResult *)queryResult
//{
//   NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
//   NSEnumerator *rowEnum = [queryResult rowEnumerator];
//   QueryRow *row;
//   ARObject *newObject;
//   while (row = (QueryRow *)[rowEnum nextObject]) {
//      newObject = [[[self class] alloc] initWithAttributes: [row columnValues] newRecord: NO];
//      [result addObject: newObject];
//      [newObject release];
//   }
//   return result;
//}
//
//
//- (void)bindAttributesToStatement:(SQLitePreparedStatement *)statement
//{
//	NSEnumerator *columnEnum = [[attributes allKeys] objectEnumerator];
//	NSString *columnName;
//	int index = 0;
//	while (columnName = (NSString *)[columnEnum nextObject]) {
//      [statement bindValue: [attributes objectForKey: columnName] toColumn: index];
//		index++;
//	}	
//}
//
//
//#pragma mark Column Finders
//
//+ (NSMutableArray *) usingOperation: (NSOperation *) operation findValuesForColumn: (NSString *)column withCondition: (NSString *)condition, ... {
//   NSString *sql = [NSString stringWithFormat: @"select %@ from %@ where %@", column, [self tableName], condition];
//   va_list bindings;
//   va_start(bindings, condition);          // Start scanning for arguments after condition.
//   SQLitePreparedStatement *statement = [[self connection] preparedStatement: sql];
//   QueryResult *queryResult = [statement executeWithOperation: operation bindingVariables: bindings];
//   return [queryResult valuesForColumn: column];
//   
//}
//
//
//#pragma mark Initialization / Destruction
//
//- (id)init
//{
//	if (self = [super init]) {
//		attributes = [[NSMutableDictionary alloc] init];
//		newRecord = YES;
//      NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//      [dateFormatter1 setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
//      // Dates come from the SOAP service in multiple formats
//      NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//      [dateFormatter2 setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//      dateFormatters = [[NSMutableArray alloc] init];
//      [dateFormatters addObject: dateFormatter1];
//      [dateFormatter1 release];
//      [dateFormatters addObject: dateFormatter2];
//      [dateFormatter2 release];
//	}
//	return self;
//}
//
//- (id)initWithAttributes: (NSDictionary *)newAttributes newRecord: (BOOL)isNewRecord;
//{
//    if ((self = [self init])) {
//       newRecord = isNewRecord;
//       [attributes addEntriesFromDictionary: newAttributes];
//    }
//    return self;
//}
//
//- (void) dealloc
//{
//	[attributes release];
//   [dateFormatters release];
//	[super dealloc];
//}
//
//#pragma mark Object Create / Update / Read / Destroy
//
//- (void)create
//{
//   [self beforeCreate];
//	[self setAttributeNamed: [self createdAtAttributeName] value: [NSNumber numberWithDouble: [NSDate timeIntervalSinceReferenceDate]]];
//	// Build the SQL insertion string
//	NSArray *columnNames = [attributes allKeys];
//	NSEnumerator *columnEnum = [columnNames objectEnumerator];
//	NSMutableString *bindings = [[NSMutableString alloc] init];
//	if ([columnEnum nextObject]) {
//		[bindings appendString: @"?"];
//	}
//	while ([columnEnum nextObject]) {
//		[bindings appendString: @", ?"];			
//	}
//	NSString *columnList = [columnNames componentsJoinedByString: @", "];
//	NSString *creationSQL;
//	creationSQL = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES(%@)", [[self class] tableName], columnList, bindings];
//	[bindings release];
//	
//	// Now bind the column values to the SQL
//	SQLitePreparedStatement *statement = [[self connection] preparedStatement: creationSQL];
//	[self bindAttributesToStatement: statement];
//	[self setAttributeNamed: [[self class] primaryKeyName] value: [statement executeAsInsert]];
//	newRecord = NO;
//   [self afterCreate];
//}
//
//- (void)destroy {
//   [self beforeDestroy];
//   NSString *destroySQL = [NSString stringWithFormat: @"delete from %@ where %@=?", [[self class] tableName], [[self class] primaryKeyName]];
//   // Now bind the column values to the SQL
//   SQLitePreparedStatement *statement = [[self connection] preparedStatement: destroySQL];
//   [statement bindInteger: [self primaryKey] toColumn: 0]; // Bind it to the last param
//   [statement execute];
//   [self afterDestroy];
//}
//
//- (void)clean
//{
//	[attributes removeAllObjects];
//	newRecord = YES;
//}
//
//- (void)save
//{
//	[self setAttributeNamed: [self updatedAtAttributeName] value: [NSNumber numberWithDouble: [NSDate timeIntervalSinceReferenceDate]]];
//	if (newRecord) {
//		[self create];
//	} else {
//      // Build the SQL insertion string
//      NSArray *columnNames = [attributes allKeys];
//      NSMutableString *bindings = [[NSMutableString alloc] init];
//      [bindings appendString: [columnNames componentsJoinedByString: @"=?, "]];
//      [bindings appendString: @"=? "];
//      
//      NSString *updateSQL = [NSString stringWithFormat: @"UPDATE %@ SET %@ where %@=?", [[self class] tableName], bindings, [[self class] primaryKeyName]];
//      [bindings release];
//      
//      // Now bind the column values to the SQL
//      SQLitePreparedStatement *statement = [[self connection] preparedStatement: updateSQL];
//      [self bindAttributesToStatement: statement];
//		[statement bindInteger: [self primaryKey] toColumn: [columnNames count]]; // Bind it to the last param
//      [statement execute];
//   }
//}
//
//
//- (void)refresh
//{
//	if (!newRecord) {
//		SQLitePreparedStatement *statement = [[self connection] preparedStatement: [self findByPrimaryKeyStatement]];
//		[statement bindInteger: [self primaryKey]  toColumn: 0];
//		QueryRow *row = [[statement execute] firstRow];
//		[attributes addEntriesFromDictionary: [row columnValues]];		
//	}
//}
//
//
//#pragma mark Database
//
//- (SQLiteConnectionAdapter *)connection {
//	return [SQLiteConnectionAdapter defaultInstance];
//}
//
//#pragma mark XML
//
//- (NSString *)toXML
//{
//	return nil;
//}
//
//#pragma mark Dates and Times
//
//- (NSTimeInterval)timeIntervalFromString:(NSString *)dateString
//{
//	NSTimeInterval result;
//	if (dateString) {
//      NSEnumerator *dateFormatterEnum = [dateFormatters objectEnumerator];
//      NSDateFormatter *dateFormatter;
//      NSDate *date = nil;
//      while (!date && (dateFormatter = (NSDateFormatter *)[dateFormatterEnum nextObject])) {
//         date =  [dateFormatter dateFromString: dateString];
//      }
//      NSAssert1(date, @"Could not parse date from string: %@", dateString);
//      result = [date timeIntervalSinceReferenceDate];         
//	} else {
//		result =  0.0;
//	}
//	return result;
//}
//
//- (NSString *)textFromDatetimeAttribute:(NSString *)attributeName
//{
//	NSDate *date = [self getDateAttributeNamed: attributeName];
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	[dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//   NSString *result =  [dateFormatter stringFromDate: date];
//	[dateFormatter release];
//	return result;
//}
//
//#pragma mark Attribute Helpers
//
//- (void)setAttributeNamed:(NSString *)attributeName value:(id)value
//{
//   if (value == nil) {
//      [attributes setObject: [NSNull null] forKey: attributeName];
//   } else if ([value isKindOfClass: [NSDate class]]) {
//		NSNumber *floatValue = [NSNumber numberWithFloat: [(NSDate *)value timeIntervalSinceReferenceDate]];
//		[attributes setObject: floatValue forKey: attributeName];
//	} else {
//		[attributes setObject: value forKey: attributeName];		
//	}
//}
//
//- (void)setAttributeNamed:(NSString *)attributeName integerValue: (NSInteger) value {
//   [attributes setObject: [NSNumber numberWithInteger: value] forKey: attributeName];
//}
//
//
//- (id)getAttributeNamed:(NSString *)attributeName 
//{
//	id result = [attributes objectForKey: attributeName];
//   if (result == [NSNull null]) {
//      return nil;
//   } else {
//      return result;
//   }
//}
//
//
//- (NSInteger)primaryKey
//{
//	return [self getIntegerAttributeNamed: [[self class] primaryKeyName]];
//}
//
//- (NSValue *)getValueAttributeNamed:(NSString *)attributeName
//{
//	return (NSValue *)[self getAttributeNamed: attributeName];
//}
//
//- (NSNumber *)getNumberAttributeNamed:(NSString *)attributeName
//{
//	return (NSNumber *)[self getAttributeNamed: attributeName];	
//}
//
//- (NSInteger)getIntegerAttributeNamed:(NSString *)attributeName
//{
//	return (NSInteger)[[self getNumberAttributeNamed: attributeName] integerValue];
//}
//
//- (double)getFloatAttributeNamed:(NSString *)attributeName
//{
//	return [[self getNumberAttributeNamed: attributeName] doubleValue];
//}
//
//- (NSDate *)getDateAttributeNamed:(NSString *)attributeName
//{
//	return [NSDate dateWithTimeIntervalSinceReferenceDate: [self getFloatAttributeNamed: attributeName]];
//}
//
//- (NSString *)findByPrimaryKeyStatement
//{
//	NSString *columnList = [[[[self class] table] columnNames] componentsJoinedByString: @", "];
//	return [NSString stringWithFormat: @"select %@ from %@ where %@ = ?", columnList, [[self class] tableName], [[self class] primaryKeyName]];
//}
//
//- (BOOL)getBooleanAttributeNamed:(NSString *)attributeName
//{
////   return (BOOL) [self getIntegerAttributeNamed: attributeName];
//	return [@"1" isEqualToString:[self getAttributeNamed:attributeName]] || [@"t" isEqualToString:[self getAttributeNamed:attributeName]];
//}
//
//#pragma mark Callbacks
//
//- (void) beforeCreate { }
//- (void) afterCreate { }
//- (void) beforeDestroy { }
//- (void) afterDestroy { }
//
//
//
//@end
