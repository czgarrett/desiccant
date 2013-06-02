////
////  SQLitePreparedStatement.m
////  ZWorkbench
////
////  Created by Christopher Garrett on 6/1/08.
////  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
////
//
//#import "SQLitePreparedStatement.h"
//
//
//@implementation SQLitePreparedStatement
//
//
//- (id)initWithConnection:(sqlite3 *)myConnection sql:(NSString *)mySql
//{
//	sql = mySql;
//	[sql retain];
//	connection = myConnection;
//	if (sqlite3_prepare_v2(connection, (const char *)[sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
//       NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(connection));
//   }
//   return self;
//}
//
//- (void) dealloc
//{
//	[sql release];
//	if (statement) sqlite3_finalize(statement);
//	[super dealloc];
//}
//
//- (QueryResult *)execute
//{  
//   return [self executeWithOperation: nil];
//}
//
//- (QueryResult *)executeWithOperation:(NSOperation *)operation
//{
//   return [[[QueryResult alloc] initWithStatement: statement operation: operation] autorelease];         
//}
//
//
//- (NSNumber *)executeAsInsert
//{
//	[self execute];
//	return [NSNumber numberWithLongLong: sqlite3_last_insert_rowid(connection)];
//}
//
//- (void) bindVariables: (va_list) bindings {
//   NSObject *binding;
//   NSInteger bindingCount = [self bindingCount];
//   for (int column=0; column < bindingCount; column++) {
//      binding = va_arg(bindings, NSObject *);
//      [self bindValue: binding toColumn: column];
//   }
//   va_end(bindings);      
//}
//
//- (QueryResult *)executeWithOperation:(NSOperation *)operation bindingVariables: (va_list)bindings
//{
//   [self bindVariables: bindings];
//   return [self executeWithOperation:operation];
//}
//
//- (NSInteger) bindingCount
//{
//   return [[sql componentsSeparatedByString: @"?"] count] - 1;   
//}
//
//
//- (void)bindTextValue: (NSString *)text toColumn: (NSInteger)column
//{
//	// Increment the column by 1 because sqlite uses 1-based indexing
//   sqlite3_bind_text(statement, column + 1, [text UTF8String], -1, SQLITE_TRANSIENT);	
//}
//
//- (void)bindInteger: (NSInteger)value toColumn: (NSInteger)column
//{
//	[self bindIntegerValue: [NSNumber numberWithInteger: value] toColumn: column];
//}
//
//- (void)bindIntegerValue: (NSNumber *)value toColumn: (NSInteger)column
//{
//	// Increment the column by 1 because sqlite uses 1-based indexing
//	sqlite3_bind_int(statement, column + 1, [value intValue]);
//}
//- (void)bindFloatValue: (NSNumber *)value toColumn: (NSInteger)column
//{
//	// Increment the column by 1 because sqlite uses 1-based indexing
//	sqlite3_bind_double(statement, column + 1, [value doubleValue]);
//}
//
//- (void)bindFloat: (double)value toColumn: (NSInteger)column {
//	// Increment the column by 1 because sqlite uses 1-based indexing
//	sqlite3_bind_double(statement, column + 1, value);   
//}
//
//- (void)bindValue: (NSObject *)value toColumn: (NSInteger)column{
//   if ([value isKindOfClass: [NSNumber class]]) {
//      // SQLite will automatically convert it to the appropriate number (i.e. int, etc)
//      [self bindFloatValue: (NSNumber *)value toColumn: column];			
//   } else if ([value isKindOfClass: [NSString class]]){
//      [self bindTextValue: (NSString *)value toColumn: column];			
//   } else if ([value isKindOfClass: [NSDate class]]) {
//      [self bindFloat: [(NSDate *)value timeIntervalSinceReferenceDate] toColumn: column];			      
//   } else if ([value isKindOfClass: [NSNull class]]) {
//      sqlite3_bind_null(statement, column + 1);
//   } else {
//      NSAssert1(NO, @"Value not supported: %@", value);
//   }   
//}
//
//
//@end
