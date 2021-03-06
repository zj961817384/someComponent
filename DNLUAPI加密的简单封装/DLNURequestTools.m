//
//  DLNURequestTools.m
//  
//
//  Created by zzzzz on 2017/4/26.
//
//

#import "DLNURequestTools.h"
#import <CommonCrypto/CommonCrypto.h>

static DLNURequestTools *shareTools;

@implementation DLNURequestTools

+ (DLNURequestTools *)shareDLNURequestTools {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (shareTools == nil) {
			shareTools = [[DLNURequestTools alloc] init];
			if (nil == shareTools.apiKey || [@"" isEqualToString:shareTools.apiKey]) {
				shareTools.apiKey = @"AAAxxx";
			}
			if (nil == shareTools.secretKey || [@"" isEqualToString:shareTools.secretKey]) {
				shareTools.secretKey = @"JSZqvCElb16pqZc1l4tmdOrOiK27ppH6tO1oABhpWxbJoIH4PDMRKXjc8Omwea5UtQo";
			}
			if (nil == shareTools.nonce || [@"" isEqualToString:shareTools.nonce]) {
				shareTools.nonce = @"YOvmnLpUw1p3faRoQUg0qW689";
			}
		}
	});
	return shareTools;
}

- (NSString *)encryptMsg:(NSDictionary *)dic {
	NSString *key = [self getKey];
	NSString *iv = [self getIv:dic];
	NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	NSString *res = [self AES128Encrypt:str key:[key lowercaseString] iv:[iv lowercaseString]];
	return res;
}


/**
 构造args_sign

 @param dic 要传输的数据的字典
 @return 构造出来的字符串
 */
- (NSString *)createArgsSign:(NSDictionary *)dic {
	NSArray<NSString *> *keys = [dic allKeys];
	keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2 options:NSLiteralSearch];
	}];
	NSString *stringA = @"";
	for (NSString *key in keys) {
		NSString *value = [dic objectForKey:key];
		if (nil == value || [@"" isEqualToString:value]) {
			continue;
		}
		stringA = [stringA stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, value]];
	}
	NSString *stringSignTemp = @"";
	if ([@"" isEqualToString:stringA]) {
		stringSignTemp = @"&";
	}
	stringSignTemp = [NSString stringWithFormat:@"%@string=%@", stringA, self.nonce];
	stringSignTemp = [self md5HexDigest:stringSignTemp];//MD5加密
	
	return stringSignTemp;
}

/**
 获取当前时间时间戳

 @return 当前时间戳字符串
 */
- (NSString *)getTimeInterval {
	return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

/**
 md5加密

 @param orignString 要加密的字符串
 @return 加密之后的字符串
 */
- (NSString *)md5HexDigest:(NSString *)orignString {
	const char *original_str = [orignString UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(original_str, strlen(original_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash uppercaseString];
}


/**
 AES/CBC/NoPadding 加密

 @param plainText 要加密的字符串
 @param gKey key
 @param gIv iv
 @return 加密之后的字符串
 */
- (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)gKey iv:(NSString *)gIv {
	char keyPtr[kCCKeySizeAES128+1];
	memset(keyPtr, 0, sizeof(keyPtr));
	[gKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	char ivPtr[kCCBlockSizeAES128+1];
	memset(ivPtr, 0, sizeof(ivPtr));
	[gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
	
	NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	NSUInteger dataLength = [data length];
	
	int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
	int newSize = 0;
	
	if(diff > 0)
	{
		newSize = dataLength + diff;
	}
	
	char dataPtr[newSize];
	memcpy(dataPtr, [data bytes], [data length]);
	for(int i = 0; i < diff; i++)
	{
		dataPtr[i + dataLength] = 0x00;
	}
	
	size_t bufferSize = newSize + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	memset(buffer, 0, bufferSize);
	
	size_t numBytesCrypted = 0;
	
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
										  kCCAlgorithmAES128,
										  0x0000,//No padding
										  keyPtr,
										  kCCKeySizeAES128,
										  ivPtr,
										  dataPtr,
										  sizeof(dataPtr),
										  buffer,
										  bufferSize,
										  &numBytesCrypted);
	
	if (cryptStatus == kCCSuccess) {
		NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
		return [self createStringFromData:resultData];
	}
	free(buffer);
	return nil;
}

/**
 AES/CBC/NoPadding 解密

 @param encryptText 要解密的字符串
 @param gKey key
 @param gIv iv
 @return 解密之后的字符串
 */
- (NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)gKey iv:(NSString *)gIv {
	char keyPtr[kCCKeySizeAES128 + 1];
	memset(keyPtr, 0, sizeof(keyPtr));
	[gKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	char ivPtr[kCCBlockSizeAES128 + 1];
	memset(ivPtr, 0, sizeof(ivPtr));
	[gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
	
	NSData *data = [self createDataFromString:encryptText];
	NSUInteger dataLength = [data length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesCrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
										  kCCAlgorithmAES128,
										  0x0000,
										  keyPtr,
										  kCCBlockSizeAES128,
										  ivPtr,
										  [data bytes],
										  dataLength,
										  buffer,
										  bufferSize,
										  &numBytesCrypted);
	if (cryptStatus == kCCSuccess) {
		NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
		return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	}
	free(buffer);
	return nil;
}

/**
 将string按位转化成data (必须是满足16整数倍)

 @param str 要转换的字符串
 @return 转化出来的data
 */
- (NSData *)createDataFromString:(NSString *)str {
	NSMutableData *data = [NSMutableData data];
	const char *pStr = [str UTF8String];
	int c = 0;
	for (int i = 0; pStr[i] != '\0'; i++) {
		int n = 0;
		if (pStr[i] <= '9' && pStr[i] >= '0') {
			n = (int)(pStr[i] - '0');
		} else if (pStr[i] <= 'z' && pStr[i] >= 'a') {
			n = (int)(pStr[i] - 'a' + 10);
		} else if ('A' <= pStr[i] && pStr[i] <= 'F') {
			n = (int)(pStr[i] - 'A' + 10);
		}
		if (i % 2 == 0) {
			c = 16 * n;
		} else {
			c += n;
			[data appendBytes:&c length:1];
		}
	}
	return data;
}

/**
 将data按位转化成string

 @param data 要转化的data
 @return 转化出来的string
 */
- (NSString *)createStringFromData:(NSData *)data {
	NSMutableString *str = [NSMutableString string];
	char *p = malloc(sizeof(char));
	for (int i = 0; i < data.length; i++) {
		[data getBytes:p range:NSMakeRange(i, 1)];
		int n = (int)p[0] & 0x00ff;
		NSString *step = [NSString stringWithFormat:@"%x", n];
		if (step.length == 1) {
			step = [@"0" stringByAppendingString:step];
		}
		[str appendString:step];
	}
	free(p);
	return str;
}

/**
 获取AES/CBC/NoPadding的key

 @return 获取到的key
 */
- (NSString *)getKey {
	NSString *md5Secret = [self md5HexDigest:_secretKey];
	NSString *key = @"";
	for (int i = 31; i >= 0; i -= 2) {
		key = [key stringByAppendingString:[md5Secret substringWithRange:NSMakeRange(i, 1)]];
	}
	return key;
}

/**
 获取AES/CBC/NoPadding的iv

 @return 获取到的iv
 */
- (NSString *)getIv:(NSDictionary *)dic {
	NSString *iv = @"";
	NSString *argsSign = [self createArgsSign:dic];
	argsSign = [self md5HexDigest:argsSign];
	for (int i = 31; i >= 0; i -= 2) {
		iv = [iv stringByAppendingString:[argsSign substringWithRange:NSMakeRange(i, 1)]];
	}
	return iv;
}

/**
 哈希校验生成字符串

 @param input 要校验的字符串
 @return 生成的字符串
 */
- (NSString *)sha1:(NSString *)input {
	
	NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (unsigned int)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return [output uppercaseString];
}

/**
 生成msg_signature

 @param parameters 请求的参数
 @param timeInterval 时间戳
 @return 生成的msg_signature
 */
- (NSString *)createMsgSignature:(NSDictionary *)parameters timeInterval:(NSString *)timeInterval {
	NSArray *arr = @[_nonce, timeInterval, [self encryptMsg:parameters], [self createArgsSign:parameters], _apiKey];
//	NSArray *arr = @[_nonce, @"1491395776", @"50d0de4d0bdf1b396f517019051c53000c5907697bafe09a448e0b46d02771106390adc8348059828422a03939836c28", @"343118F1906F923C878B14460F42CBDB", _apiKey];
	arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2 options:NSLiteralSearch];
	}];
	NSString *str = @"";
	for (NSString *s in arr) {
		str = [str stringByAppendingString:s];
	}
	return [self sha1:str];
}




@end
