//
//  ContentView.swift
//  TI_2lab
//
/*
 Вариант 10
 Реализовать систему потокового шифрования и дешифрования для файла с любым содержимым с помощью генератора ключевой последовательности на основе линейного сдвигового регистра с обратной связью LFSR1 (размерность регистра приведена в таблице №1). Начальное состояние регистра ввести с клавиатуры. Поле для ввода состояния регистра должно игнорировать любые символы кроме 0 и 1. Вывести на экран сгенерированный ключ (последовательность из 0 и 1), исходный файл и зашифрованный файл в двоичном виде. Программа не должна быть написана в консольном режиме. Результат работы программы – зашифрованный/расшифрованный файл
 */
import SwiftUI
import UniformTypeIdentifiers

struct BinaryDocument: FileDocument {
    static var readableContentTypes: [UTType] { // какие типы файлов можно открывать
        [
            // Общие типы
            .data,
            .item,
            .content,
            .archive,
            
            // Изображения
            .image,
            .jpeg,
            .png,
            .tiff,
            .gif,
            .bmp,
            .ico,
            .icns,
            .rawImage,
            .svg,
            .heic,
            .heif,
            .webP,
            
            // Видео
            .movie,
            .video,
            .mpeg,
            .mpeg2Video,
            .mpeg4Movie,
            .appleProtectedMPEG4Video,
            .avi,
            .quickTimeMovie,
            .mp3,
            .wav,
            .aiff,
            .midi,

            
            // Аудио
            .audio,
            .mp3,
            .mpeg4Audio,
            .appleProtectedMPEG4Audio,
            .wav,
            .aiff,
            .midi,
            
            // Документы
            .text,
            .plainText,
            .rtf,
            .pdf,
            .presentation,
            .spreadsheet,
            .database,
            .json,
            .xml,
            .sourceCode,
            .assemblyLanguageSource,
            .cSource,
            .objectiveCSource,
            .swiftSource,
            .cPlusPlusSource,
            .objectiveCPlusPlusSource,
            .cHeader,
            .cPlusPlusHeader,
            .script,
            .shellScript,
            .pythonScript,
            .rubyScript,
            .perlScript,
            .phpScript,
            .javaScript,
            .html,
            .css,
            
            // Архивы
            .zip,
            .gzip,
            .bz2,
            
            // Исполняемые файлы
            .executable,
            .systemPreferencesPane,
            .application,
            .bundle
        ]
    }

    static var writableContentTypes: [UTType] { // какие типы файлов можно сохранять
        [
            // Основные типы для записи
            .data,
            .item,
            .content,
            
            // Изображения (записываемые форматы)
            .image,
            .jpeg,
            .png,
            .tiff,
            .gif,
            .bmp,
            .heic,
            .heif,
            .webP,
            
            // Видео/аудио (записываемые форматы)
            .movie,
            .video,
            .mpeg4Movie,
            .quickTimeMovie,
            .audio,
            .mp3,
            .mpeg4Audio,
            .wav,
            
            // Документы
            .text,
            .plainText,
            .rtf,
            .pdf,
            
            // Архивы
            .zip,
            .gzip
        ]
    }
    
    var data: Data
    var fileType: UTType
    // корректируй тип файла
    init(data: Data = Data(), fileType: UTType = .data) {
        self.data = data
        self.fileType = fileType
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
        self.fileType = configuration.contentType
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
}


struct ContentView: View {
    // left menu
    @State private var path_to_file:String = ""
    @State private var plaintext:String = ""
    @State private var key:String = ""
    // Состояния для UI
       @State private var binaryKeyStream: String = ""
       @State private var originalBinary: String = ""
       @State private var encryptedBinary: String = ""
       @State private var fileData: Data?
       @State private var doc = BinaryDocument()
    // расширение из файла
    @State private var FileExtensionDefault:UTType = .data
    
    @State private var showExporter = false
    
    // rigt menu
    @State private var encrypted:String = ""
    // export file
    @State private var ShowExporter:Bool = false
    //меню выбора
    @State private var showFilePicker = false
    @State private var fileContent:String = ""
    
    // alert
    @State private var showAlert = false
    @State private var AlertMessage = ""
    @State private var error_warning = ""
    

        private let taps = [31, 6, 4, 2, 1, 0] // Отводы
        private let keyLength = 32
    
    // класс для более грамотной работы
    private class LFSR{
        private var state:UInt32
        private let taps:[Int]
        private let length: Int = 32
        
        init?(seed: UInt32, taps: [Int]) {
            guard seed != 0 else { return nil }
            self.state = seed
            self.taps = taps
        }
        
        // рассчитываем след бит
        func next_bit()->UInt32{
            guard state != 0 else { return 0 }
            var feedback: UInt32 = 0
            for tap in taps{
                feedback ^= (state >> tap) & 1 //xorим младший бит с отводами
            }
            state  = (state>>1) //сдвигаем на одну
            | (feedback<<(length-1)) // объединяем с фидбеком в старшей позиции
            return state & 1 // достаем только младший бит
        }
        
        // рассчитываем сразу байт ибо регистр 32 битный
        func next_byte() -> UInt8 {
                var byte: UInt8 = 0
                for i in 0..<8 {
                    byte |= UInt8(next_bit()) << i // устанавливаю бит в соответствующую позицию
                }
                return byte
            }
        
        func generateKeyStream(length: Int) -> [UInt8] {
            return (0..<length).map { _ in next_byte() }
            }
        
        func generateBinaryKeyStream(length: Int) -> String {
                return (0..<length).map { _ in String(next_bit()) }.joined()
            }
            
    }
    
    // оставляем ток 0 и 1
    
    func filter_input(input:String)->String{
        let filtered = input.filter{$0 == "0" || $0 == "1"}
        return filtered
    }
    
    // здесь проверяем сид на правильность
    
    func check_seed(input:String)->Bool{
        let filtered = filter_input(input:input)
        if filtered.count == 32 && input != String(repeating:"0", count:32){
            return true
        } else {
            showAlert = true
            error_warning = "Error"
            AlertMessage = "Seed must be 32-bit binary number (without leading zeros)"
            return false
            
        }
        
    }
    
    // выбор файла
    private func handleFileSelection(_ result: Result<[URL], Error>) {
        do {
            let urls = try result.get()
            guard let url = urls.first else { return }
            
            guard url.startAccessingSecurityScopedResource() else {
                throw NSError(domain: "File access denied", code: 0)
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            let data = try Data(contentsOf: url)
            fileData = data
            originalBinary = data.map { String(format: "%08b", $0) }.joined()
            encryptedBinary = ""
            binaryKeyStream = ""
        } catch {
            showAlert = true
        }
    }
    
    // сохранение файла
      private func saveEncryptedFile() {
          guard let data = fileData else { return }
          doc = BinaryDocument(data: data)
          showExporter = true
      }
      // экспорт
      private func handleExportResult(_ result: Result<URL, Error>) {
          switch result {
          case .success(let url):
              print("File saved to: \(url.path)")
          case .failure(let error):
              showAlert = true
          }
      }
    
    // сохранение бинарных данных
    func saveBinaryData(_ data: Data) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.data]
        if panel.runModal() == .OK, let url = panel.url {
            do {
                try data.write(to: url)
            } catch {
                AlertMessage = "Save failed: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
  

    

    private func dataFromHexString(_ hex: String) -> Data? {
        var data = Data()
        var hexString = hex
        
        // Удаляем все не-hex символы
        let hexChars = Set("0123456789ABCDEFabcdef")
        hexString = hexString.filter { hexChars.contains($0) }
        
        // Если длина нечетная, добавляем ведущий ноль
        if hexString.count % 2 != 0 {
            hexString = "0" + hexString
        }
        
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            let byteString = hexString[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            }
            index = nextIndex
        }
        
        return data
    }
    
    
   // шифруем
    func encrypt(){
        guard check_seed(input: key) else { return }
        
        let seed = UInt32(key, radix: 2) ?? 0
        
        guard let lfsr = LFSR(seed: seed, taps: taps) else {
            AlertMessage = "Invalid seed - cannot be all zeros"
            showAlert = true
            return
        }
        
        // Используем fileData если есть, иначе plaintext
        let dataToEncrypt: Data
        if let fileData = fileData {
            dataToEncrypt = fileData
        
        } else {
            AlertMessage = "No data to encrypt"
            showAlert = true
            return
        }
        
        // Шифруем XOR с ключевым потоком
        var encryptedData = Data()
        let keyStream = lfsr.generateKeyStream(length: dataToEncrypt.count)
        for (byte, keyByte) in zip(dataToEncrypt, keyStream) {
            encryptedData.append(byte ^ keyByte)
        }
        
        // Обновляем интерфейс
        fileData = encryptedData
        encryptedBinary = encryptedData.map { String(format: "%08b", $0) }.joined()
        binaryKeyStream = keyStream.prefix(20).map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
        
        // Для отображения в текстовом поле (первые 100 байт)
        encrypted = "Encrypted data (\(encryptedData.count) bytes)\n" +
        encryptedData.prefix(20).map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
    }
    
    func encryptFile() {
        guard check_seed(input: key) else { return }
        
        let seed = UInt32(key, radix: 2) ?? 0
        let taps = [31, 21, 1, 0] // Для 32-битного LFSR
        
        guard let lfsr = LFSR(seed: seed, taps: taps) else {
            AlertMessage = "Invalid seed (cannot be all zeros)"
            showAlert = true
            return
        }
        
        // Чтение файла как бинарных данных
        guard let fileData = plaintext.data(using: .utf8) else {
            AlertMessage = "Failed to read file data"
            showAlert = true
            return
        }
        
        // Генерация ключа
        let keyStream = lfsr.generateKeyStream(length: fileData.count)
        
        // Шифрование XOR
        var encryptedData = Data()
        for (byte, keyByte) in zip(fileData, keyStream) {
            encryptedData.append(byte ^ keyByte)
        }
        
        // Обновление интерфейса
        encrypted = encryptedData.map { String(format: "%08b", $0) }.joined()
        binaryKeyStream = keyStream.prefix(20).map{ String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
    }

  // дешифруем
    func decrypt() {
        guard check_seed(input: key) else { return }
        
        let seed = UInt32(key, radix: 2) ?? 0
        guard let lfsr = LFSR(seed: seed, taps: taps) else {
            AlertMessage = "Invalid seed - cannot be all zeros"
            showAlert = true
            return
        }
        
        // Используем fileData (зашифрованные данные) для дешифрования
        guard let encryptedData = fileData else {
            AlertMessage = "No encrypted data to decrypt"
            showAlert = true
            return
        }
        
        // Дешифруем XOR с тем же ключевым потоком
        var decryptedData = Data()
        let keyStream = lfsr.generateKeyStream(length: encryptedData.count)
        for (byte, keyByte) in zip(encryptedData, keyStream) {
            decryptedData.append(byte ^ keyByte)
        }
        
        // Обновляем интерфейс
        fileData = decryptedData
        
        // Пытаемся отобразить как текст, если это возможно
      
        plaintext = "Binary data (hex): " + decryptedData.prefix(20).map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
        
        
        // Обновляем бинарное представление
        originalBinary = decryptedData.map { String(format: "%08b", $0) }.joined()
        binaryKeyStream = keyStream.prefix(20).map{ String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
        
        // Для отображения в текстовом поле (первые 100 байт)
        encrypted = "Decrypted data (\(decryptedData.count) bytes)\n" +
        decryptedData.prefix(20).map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
    }
    
    
    // загружаем файл для де/-шифрования
    func loadFile(url: URL) {
        // Безопасный доступ к защищённому ресурсу
        guard url.startAccessingSecurityScopedResource() else {
            AlertMessage = "File access denied"
            showAlert = true
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            print("Successfully read file")
            let data = try Data(contentsOf: url)
            
            fileData = data
            path_to_file = url.path()
            // Определяем тип файла
            if let type = UTType(filenameExtension: url.pathExtension) {
                        FileExtensionDefault = type
            } else {
            // Если не удалось определить, используем общий тип
            FileExtensionDefault = .data
            }
            originalBinary = data.map { String(format: "%08b", $0) }.joined()

            
            
            plaintext = "Binary data (hex): " + data.prefix(20).map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }.joined()
            
           
       
        } catch {
            AlertMessage = "Error reading file: \(error.localizedDescription)"
            showAlert = true
            print("Error reading file: \(error)")
        }
    }
    
    
    
    var body: some View {
        HStack{
            VStack{
                Spacer()
                
                HStack{
                    TextField("Path to the file", text:$path_to_file)
                        .frame(width:120, height:1)
                        .font(.system(size: 12))
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    
                    Button("File"){
                        showFilePicker = true
                    }
                    .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.data], /*поменял plaintext */ allowsMultipleSelection: false)
                    {
                        result in
                        switch result {
                        case .success(let urls):
                            if let url = urls.first{
                                loadFile(url: url)
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        
                        }
                    }
                }
                
                TextField("Enter 32-bit binary seed", text:$key )
                    .frame(width:200)
                    .font(.system(size: 15))
                    .padding(.horizontal)
                    .padding(.vertical, 1)
                    .textFieldStyle(.roundedBorder)
                    .frame(width:180)
                
                // Key stream
                    Text("Generated Key Stream (binary):")
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                        .font(.system(size: 15))
                    
                    TextEditor(text: $binaryKeyStream)
                        .padding(.vertical, 1)
                        .padding(.horizontal)
                        .frame(width: 240, height: 100)
                
                      Rectangle() // Невидимый разделитель
                     .fill(Color.clear)
                     .frame(height: 10) // Точная высота разделителя
                
                HStack(spacing:12){
                    Button(action:{
                        print("Encrypting...")
                        encrypted = "\n"
                        encrypt()
                        
                    })
                    {
                        Text("Encrypt")
                            .fontWeight(.medium)
                    }
                    .alert(error_warning, isPresented:$showAlert){
                        Button("Got it", role: .cancel){
                            //действие при нажатии
                        }
                    } message: {
                        Text(AlertMessage)
                    }
                    
                    Button(action:{
                        print("Decrypting...")
                        encrypted = "\n"
                        encrypt()
                    }){
                        Text("Decrypt")
                            .fontWeight(.medium)

                    }.alert(error_warning, isPresented:$showAlert){
                        Button("Got it", role: .cancel){
                            //действие при нажатии
                        }
                    } message: {
                        Text(AlertMessage)
                    }
                }
                Spacer()

            }
            .frame(width:250)
            .background(Color.gray.opacity(0.1))
            
            VStack(){
                Text("Enter the plain text here:")
                           .foregroundColor(.gray)
                           .padding(.vertical, 5)
                           .font(.system(size: 15))
          
                    
                TextEditor(text:$plaintext)
                    .padding(.vertical,1)
                    .padding(.horizontal)
                    .frame(width:300, height: 100)
                
                Text("The result is here:")
                           .foregroundColor(.gray)
                           .padding(.vertical, 5)
                           .font(.system(size: 15))
           
                    
                TextEditor(text:$encrypted)
                    .padding(.vertical,1)
                    .padding(.horizontal)
            
                    .frame(width:300, height: 100)
                
                Button("Save to file") {
                    if let data = fileData {
                        doc = BinaryDocument(data: data, fileType: FileExtensionDefault)
                        ShowExporter = true
                    } else {
                        AlertMessage = "No data to save"
                        showAlert = true
                    }
                }
                .fileExporter(
                    isPresented: $ShowExporter,
                    document: doc,
                    contentType: FileExtensionDefault,
                    defaultFilename: "encrypted.\(FileExtensionDefault.preferredFilenameExtension ?? "bin")"
                ) { result in
                    switch result {
                    case .success(let url):
                        print("Saved to: \(url.path)")
                    case .failure(let error):
                        AlertMessage = "Save failed: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 400, idealWidth: 800, maxWidth: 1920, minHeight: 400, idealHeight: 800, maxHeight: 1080)
        
    }
    
}

#Preview {
    ContentView()
}
// В самом низу твоего ViewController или другого файла
extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let paddingCount = toLength - self.count
        guard paddingCount > 0 else { return self }
        return String(repeating: character, count: paddingCount) + self
    }
}
