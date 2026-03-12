//
//  TOTPGeneratorImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation
import CommonCrypto

final class TOTPGeneratorImpl: TOTPGenerator {
    
    func generateCode(secret: String, algorithm: TOTPAlgorithm, digits: Int, period: Int) -> String? {
        guard let secretData = base32Decode(secret) else {
            return nil
        }
        
        let timeStep = UInt64(getCurrentTimeStep(period: period))
        
        var counter = timeStep.bigEndian
        let counterData = Data(bytes: &counter, count: MemoryLayout<UInt64>.size)
        
        guard let hmac = calculateHMAC(data: counterData, key: secretData, algorithm: algorithm) else {
            return nil
        }
        
        // Применяем Dynamic Truncation
        let offset = Int(hmac[hmac.count - 1] & 0x0f)  // фактически случайный сдвиг от 0 до 15
        let truncatedHash = hmac.subdata(in: offset..<offset + 4)  // берем 4 бита начиная с offset
        
        var number = truncatedHash.withUnsafeBytes { $0.load(as: UInt32.self) }.bigEndian  // превращаем в 32-битное число
        number &= 0x7fffffff  // убираем знаковый бит
        number = number % UInt32(pow(10, Double(digits)))  // получаем digits-значное как остаток
        
        // Форматируем с ведущими нулями
        return String(format: "%0\(digits)d", number)
    }
    
    func getCurrentTimeStep(period: Int) -> Int {
        let timestamp = Date().timeIntervalSince1970
        return Int(UInt64(timestamp) / UInt64(period))
    }
    
    func getSecondsRemaining(period: Int) -> Int {
        let timestamp = Date().timeIntervalSince1970
        return period - Int(timestamp.truncatingRemainder(dividingBy: Double(period)))
    }
    
    
    private func calculateHMAC(data: Data, key: Data, algorithm: TOTPAlgorithm) -> Data? {
        let algorithmType: CCHmacAlgorithm
        let hashLength: Int
        
        switch algorithm {
        case .sha1:
            algorithmType = CCHmacAlgorithm(kCCHmacAlgSHA1)
            hashLength = Int(CC_SHA1_DIGEST_LENGTH)
        case .sha256:
            algorithmType = CCHmacAlgorithm(kCCHmacAlgSHA256)
            hashLength = Int(CC_SHA256_DIGEST_LENGTH)
        case .sha512:
            algorithmType = CCHmacAlgorithm(kCCHmacAlgSHA512)
            hashLength = Int(CC_SHA512_DIGEST_LENGTH)
        }
        
        
        var hmac = Data(count: hashLength)
        
        // CCHmac это чистейшая си функция, треш)
        hmac.withUnsafeMutableBytes { hmacBytes in
            // в этом скоупе родился указатель hmacBytes.baseAddress = адрес первого байта hmac в памяти
            data.withUnsafeBytes { dataBytes in
                //  в этом скоупе родился указатель dataBytes.baseAddress = адрес первого байта data в памяти
                key.withUnsafeBytes { keyBytes in
                    //  в этом скоупе родился указатель keyBytes.baseAddress = адрес первого байта key в памяти
                    CCHmac(
                        algorithmType,
                        keyBytes.baseAddress,
                        key.count,
                        dataBytes.baseAddress,
                        data.count,
                        hmacBytes.baseAddress
                    )
                }
            }
        }
        
        return hmac
    }
    
    private func base32Decode(_ string: String) -> Data? {
        let cleanString = string.replacingOccurrences(of: " ", with: "").uppercased()
        
        let base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        var bits = ""
        
        // Конвертируем каждый символ в 5-битное представление
        for char in cleanString {
            guard let index = base32Alphabet.firstIndex(of: char) else {
                return nil
            }
            let value = base32Alphabet.distance(from: base32Alphabet.startIndex, to: index)
            bits += String(value, radix: 2).leftPadding(toLength: 5, withPad: "0")
        }
        
        // Конвертируем биты в байты
        var data = Data()
        for i in stride(from: 0, to: bits.count, by: 8) {
            let endIndex = min(i + 8, bits.count)
            let byteString = String(bits[bits.index(bits.startIndex, offsetBy: i)..<bits.index(bits.startIndex, offsetBy: endIndex)])
            
            if byteString.count == 8 {  // иначе вроде как это паддинг в конце строки который при декодинге base32 откидывают
                if let byte = UInt8(byteString, radix: 2) {
                    data.append(byte)
                }
            }
        }
        
        return data
    }
}


// используем при декодировании Base32 так как ему нужно 5-байтное представление ("00001" вместо "1" и тд)
private extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return self
        }
    }
}
