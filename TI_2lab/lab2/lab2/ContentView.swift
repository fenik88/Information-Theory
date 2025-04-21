//
//  ContentView.swift
//  TI_1lab
//
/*
 Вариант 9.
 Написать программу, которая выполняет шифрование и дешифрование текстового файла любого размера, содержащего текст на заданном языке, используя следующие алгоритмы шифрования:
 - Шифр Плейфейра, текст на английском языке;
 - алгоритм Виженера, прогрессивный ключ, текст на русском языке.
 Для всех алгоритмов ключ задается с клавиатуры пользователем.
 Программа должна игнорировать все символы, не являющиеся буквами заданного алфавита,  и шифровать только текст на заданном языке. Все алгоритмы должны быть реализованы в одной программе. Программа не должна быть написана в консольном режиме. Результат работы программы – зашифрованный/расшифрованный файл/ы.
 
 */
import SwiftUI
import UniformTypeIdentifiers

// 1. Создаем документ для экспорта
struct TextDocument: FileDocument {
    var text: String
    
    static var readableContentTypes: [UTType] { [.plainText] }
    
    init(text: String = "") {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
    }
}

struct ContentView: View {
    // left menu
    @State private var path_to_file:String = ""
    @State private var plaintext:String = ""
    @State private var key:String = ""
    @State private var algos = "Vigenere"
    // rigt menu
    @State private var encrypted:String = ""
    // export file
    @State private var document = TextDocument()
    
    @State private var ShowExporter:Bool = false
    //меню выбора
    @State private var showFilePicker = false
    @State private var fileContent:String = ""
    
    // alert
    @State private var showAlert = false
    @State private var AlertMessage = ""
    @State private var error_warning = ""
    
    
    @State private var start_index_plain:Int = 0
    @State private var start_index_key:Int=0

    // методы шифрования
    let encryption_methods = ["Vigenere", "Playfair"]
    
    
    //добавим проходку по строке и определение есть ли что шифровать
    func check_valid_plf(input:String)->Bool{
        for char in input {
            if ("a"..."z").contains(char) || ("A"..."Z").contains(char) {
                return true
            }
        }
            // что будет в предупреждении
            AlertMessage = "No suitable symbols found in \(input)"
            showAlert = true
        error_warning = "Error"
        return false
    }
    
    //проверка для виженера
    func check_valid_vig(input:String)->Bool{
        for char in input {
            if ("а"..."я").contains(char) || ("А"..."Я").contains(char) {
                return true
            }
            // обработка Ё
            else if (char == "Ё" || char == "ё"){
                return true
            }
        }
            AlertMessage = "No suitable symbols found in \(input)"
            showAlert = true
        error_warning = "Error"
        return false
    }
    
    
    // Диапазоны ASCII кодов для русских букв (верхний и нижний регистр)
    let RUS_UPPER_A: UInt32 = 1040 // 'А'
    let RUS_UPPER_YA: UInt32 = 1071 // 'Я'
    let RUS_LOWER_A: UInt32 = 1072 // 'а'
    let RUS_LOWER_YA: UInt32 = 1103 // 'я'
    let RUS_LETTERS_COUNT:UInt32 = 33
    
    // Проверка, является ли символ русской буквой
    func isRussianLetter(_ char: Character) -> Bool {
        let ascii = char.unicodeScalars.first?.value ?? 0
        print(ascii)
        return (ascii >= RUS_UPPER_A && ascii <= RUS_UPPER_YA) ||
               (ascii >= RUS_LOWER_A && ascii <= RUS_LOWER_YA) ||
                ascii == 1025 || //йо большое
                ascii == 1105 // йо малое
    }
    
    
    // Нормализация символа (приведение к верхнему регистру с учетом 'Ё')
    func normalizeRussianChar(_ char: Character) -> Character {
        let ascii = char.unicodeScalars.first?.value ?? 0
        if ascii >= RUS_LOWER_A && ascii <= RUS_LOWER_YA {
            return Character(UnicodeScalar(ascii - 32)!) // Преобразу в верхний регистр
        }
        else if(ascii == 1105 || ascii == 1025){
            return "Ё"
        }
        return char
    }
    
    func filterText_Rus(text: String) -> String {
        return String(text.filter { isRussianLetter($0) }.map { normalizeRussianChar($0) })
    }
    
    
    // Диапазоны ASCII кодов для английских букв
    let ENG_UPPER_A: UInt32 = 65   // 'A'
    let ENG_UPPER_Z: UInt32 = 90   // 'Z'
    let ENG_LOWER_A: UInt32 = 97   // 'a'
    let ENG_LOWER_Z: UInt32 = 122  // 'z'
    let ENG_LETTERS_COUNT: UInt32 = 26

    // Проверка, является ли символ английской буквой
    func isEnglishLetter(_ char: Character) -> Bool {
        let ascii = char.unicodeScalars.first?.value ?? 0
        return (ascii >= ENG_UPPER_A && ascii <= ENG_UPPER_Z) ||
               (ascii >= ENG_LOWER_A && ascii <= ENG_LOWER_Z)
    }

    // Нормализация английского символа (в верхний регистр)
    func normalizeEnglishChar(_ char: Character) -> Character {
        let ascii = char.unicodeScalars.first?.value ?? 0
        if ascii >= ENG_LOWER_A && ascii <= ENG_LOWER_Z {
            return Character(UnicodeScalar(ascii - 32)!) // Преобразуем в верхний регистр
        }
        return char
    }

    // Фильтрация английского текста
    func filterText_Eng(text: String) -> String {
        return String(text.filter { isEnglishLetter($0) }.map { normalizeEnglishChar($0) })
    }
    
    // передаем наш введенный ключ и длину строки которую будем шифровать
    // нужно пофиксить чтобы передавалась длина уже отфильтрованого plaintext
    // возвращает уже прогрессивный ключ
    
    let russianAlphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
    
    // Функция для получения позиции буквы в алфавите (начиная с 0)
    func positionInAlphabet(_ char: Character, alphabet: String) -> UInt32? {
        guard let index = alphabet.firstIndex(of: char) else {
            return nil
        }
        let position = alphabet.distance(from: alphabet.startIndex, to: index)
        return UInt32(position)
    }
    
    func generateProgressiveKey(key: String, length: Int, alphabet:String) -> String {
        var result = ""
        var shift:UInt32 = 0
       
       // let filteredKey = key.filter { isRussianLetter($0) }.map(normalizeRussianChar) // оставляем в ключе ток подходящие символы
        
        
        // 2. Генерация прогрессивного ключа
        while result.count < length {
            for char in key {
                if result.count >= length { break }
                
  
                guard let pos = positionInAlphabet(char, alphabet: alphabet) else { continue }
              
                // 4. Вычисление нового символа
                let newPos = Int(pos + shift) % alphabet.count
                let newChar = alphabet[alphabet.index(alphabet.startIndex, offsetBy: newPos)]
                result.append(newChar)
              
            
            }
            // 6. Увеличение сдвига
            shift += 1
        }
        
        return result
    }
    
    func encrypt_Vig(input:String, input_key:String) {

        
        if(!(check_valid_vig(input: input) &&
           check_valid_vig(input: input_key))){
            return
        }
        
        // переменная для хранения plaintext только из нужных символов
        let filter_plain = filterText_Rus(text: input)
        
        // отфильтрованный ключ
        let filter_key = filterText_Rus(text: input_key)
        
        // отладочный вывод
        let progressive_key = generateProgressiveKey(key: filter_key, length:filter_plain.count,alphabet: russianAlphabet)
        

        // основной алгоритм
        
        var result = ""
        for (i, char) in filter_plain.enumerated() {
            let key_char = Array(progressive_key)[i]
            
  
            // безопасно извлекаем сразу два значения
            guard let textPos = positionInAlphabet(char, alphabet: russianAlphabet),
                  let keyPos = positionInAlphabet(key_char, alphabet: russianAlphabet) else {
                       continue
                   }
            
            
            // шифруем
            let newPos = Int(textPos + keyPos+1) % russianAlphabet.count
            
            // получаем зашифрованный символ
            let newChar = russianAlphabet[russianAlphabet.index(russianAlphabet.startIndex, offsetBy: newPos)]
            result.append(newChar)
           
        }
        
        encrypted.append(result)
    }
    
    func decrypt_Vig(input:String, input_key:String){
        
        if(!(check_valid_vig(input: input) &&
           check_valid_vig(input: input_key))){
            return
        }
        
        // переменная для хранения plaintext только из нужных символов
        let filter_plain = filterText_Rus(text: input)
        
        // отфильтрованный ключ
        let filter_key = filterText_Rus(text: input_key)
        
        // отладочный вывод
        let progressive_key = generateProgressiveKey(key: filter_key, length:filter_plain.count,alphabet: russianAlphabet)
        
        // основной цикл дешифрования
        var result = ""
        for (i, char) in filter_plain.enumerated() {
            let key_char = Array(progressive_key)[i]
            guard let encryptedPos = positionInAlphabet(char, alphabet: russianAlphabet),
                  let keyPos = positionInAlphabet(key_char, alphabet: russianAlphabet) else {
                        continue
                    }
            var newpos =  (Int(encryptedPos) - Int(keyPos)-1) % russianAlphabet.count
            
            // обработка если ушли в минус
            if newpos<0 {
                newpos += russianAlphabet.count
            }
            let newChar = russianAlphabet[russianAlphabet.index(russianAlphabet.startIndex, offsetBy: newpos)]
                result.append(newChar)
            
        }
        
        
        // результат
        encrypted.append(result)
    }
    
    let EnglishAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" // J объединен с I
    // создаем нашу матрицу 5 на 5 для шифрования
    func create_matrix(key:String)->[[Character]]{
        var usedLetters = Set<Character>()// множество использованных букв
        var keyProcessed = [Character]() // массив куда записываем неповторяющиеся символы ключа
        
        var matrix = [[Character]]() //итоговая матрица для шифрования
        
        
        // заполняем массив неповторяющимися символами ключа
        for char in key{
            
            let norm_char = char == "J" ? "I":char
            if !usedLetters.contains(norm_char){
                
                keyProcessed.append(norm_char)
                usedLetters.insert(norm_char)
            }
            
        }
        // добавляем остальные буквы алфавита кроме j
        for char in EnglishAlphabet{
            if char == "J"{
                continue
            }
            if !usedLetters.contains(char){
                keyProcessed.append(char)
            }
        }
        
        for counter in 0..<5{
            var row = [Character]()
            for j in 0..<5{
                
                row.append(keyProcessed[counter*5+j])
                
            }
            matrix.append(row)
        }
        
       
        return matrix
    }
    // находим координаты в матрице
    func findPosition(_ char: Character, in matrix: [[Character]]) -> (row: Int, col: Int)? {
        if (char == "J"){
            AlertMessage = "A collision may appear"
            showAlert = true
            error_warning = "Warning"
        }
            let norm_char = char == "J" ? "I":char
        
            for i in 0..<5 {
                for j in 0..<5 {
                    if matrix[i][j] == norm_char {
                        return (i, j)
                    }
                }
            }
        
        
        return nil
    }
    
    // создаем биграмму по два символа для дешифровки
    func create_bigram_decrypt(text:String)->String{

        var processed:String = ""
        
        var i = 0
        if (text.count % 2) == 1 {
            print("Нечетное кол-ов символов")
            return processed
        }
            while i<text.count{
                let first_char = text[text.index(text.startIndex,offsetBy:i)] //текущий символ
                
                if i+1>=text.count{ // если следующий символ выходит законец строки следовательно нечетное количество букв
                    processed.append(first_char)
                    processed.append("X")
                    break
                }
                
                let second_char = text[text.index(text.startIndex, offsetBy: i + 1)]
                
                
                    processed.append(first_char)
                    processed.append(second_char)
                    i+=2
                
                
            }
        return processed
    }
    
    // создаем биграмму по два символа для шифровки
    func create_bigram_encrypt(text:String)->String{

        var processed:String = ""
        
        var i = 0
      
            while i<text.count{
                let first_char = text[text.index(text.startIndex,offsetBy:i)] //текущий символ
                
                if i+1>=text.count{ // если следующий символ выходит законец строки следовательно нечетное количество букв
                    processed.append(first_char)
                    processed.append("X")
                    AlertMessage = "A collision may appear"
                    showAlert = true
                    error_warning = "Warning"
                    break
                    
                }
                
                let second_char = text[text.index(text.startIndex, offsetBy: i + 1)]
                
                if first_char == second_char{
                    let separator  = (first_char == "X") ? "Z":"X"//добавляем z если два x подряд для избежания уязвимости
                    
                    
                    
                    processed.append(first_char)
                    processed.append(separator)
                    i+=1
                } else{
                    processed.append(first_char)
                    processed.append(second_char)
                    i+=2
                }
                
            }
        return processed
    }
    
   
    // Шифрование биграммы
     func encrypt_bigram(_ bigram: String, with matrix: [[Character]]) -> String {
         guard bigram.count == 2,
               let firstPos = findPosition(bigram.first!, in: matrix),
               let secondPos = findPosition(bigram.last!, in: matrix) else {
             return bigram
         }
         
         
         
         var encrypted = ""
         
         // 1. Одна строка
         if firstPos.row == secondPos.row {
             let newCol1 = (firstPos.col + 1) % 5
             let newCol2 = (secondPos.col + 1) % 5
             encrypted.append(matrix[firstPos.row][newCol1])
             encrypted.append(matrix[secondPos.row][newCol2])
         }
         // 2. Один столбец
         else if firstPos.col == secondPos.col {
             let newRow1 = (firstPos.row + 1) % 5
             let newRow2 = (secondPos.row + 1) % 5
             encrypted.append(matrix[newRow1][firstPos.col])
             encrypted.append(matrix[newRow2][secondPos.col])
         }
         // 3. Разные строки и столбцы
         else {
             encrypted.append(matrix[firstPos.row][secondPos.col])
             encrypted.append(matrix[secondPos.row][firstPos.col])
         }
         
         return encrypted
     }
    
    
    // Шифрование биграммы
     func decrypt_bigram(_ bigram: String, with matrix: [[Character]]) -> String {
         guard bigram.count == 2,
               let firstPos = findPosition(bigram.first!, in: matrix),
               let secondPos = findPosition(bigram.last!, in: matrix) else {
             return bigram
         }
         
         print(firstPos)
         print(secondPos)
         var decrypted = ""
         
         // 1. Одна строка
         if firstPos.row == secondPos.row {
             let newCol1 = (firstPos.col - 1 + 5) % 5
             let newCol2 = (secondPos.col - 1 + 5) % 5
             decrypted.append(matrix[firstPos.row][newCol1])
             decrypted.append(matrix[secondPos.row][newCol2])
         }
         // 2. Один столбец
         else if firstPos.col == secondPos.col {
             let newRow1 = (firstPos.row - 1 + 5) % 5
             let newRow2 = (secondPos.row - 1 + 5) % 5
             decrypted.append(matrix[newRow1][firstPos.col])
             decrypted.append(matrix[newRow2][secondPos.col])
         }
         // 3. Разные строки и столбцы
         else {
             decrypted.append(matrix[firstPos.row][secondPos.col])
             decrypted.append(matrix[secondPos.row][firstPos.col])
         }
         
         return decrypted
     }
    
    
    func encrypt_Plf(input:String, input_key:String) {
        print("Encrypted with Playfair")
        
        if(!(check_valid_plf(input: input) &&
           check_valid_plf(input: input_key))){
            return
        }
        
        // переменная для хранения plaintext только из нужных символов
        let filter_plain = filterText_Eng(text: input)
        
        // отфильтрованный ключ
        let filter_key = filterText_Eng(text: input_key)
        
        // отладочный вывод
        
        
        //создаем матрицу и разбиваем на биграммы
        let matrix = create_matrix(key: filter_key)
        let prepared_text = create_bigram_encrypt(text: filter_plain)
        
        
        // поочередно обрабатываем каждую биграмму шифруя ее
        
        var result = ""
        for i in stride(from: 0, to: prepared_text.count, by: 2){
            let start = prepared_text.index(prepared_text.startIndex, offsetBy: i)
            
            let end = prepared_text.index(start, offsetBy: 2, limitedBy: prepared_text.endIndex) ?? prepared_text.endIndex
            
            let bigram = String(prepared_text[start..<end])
            result += encrypt_bigram(bigram, with: matrix)
        }
        
    
        // формируем результат
        encrypted.append(result)
    }
    
    func decrypt_Plf(input:String, input_key:String){
        
        
        if(!(check_valid_plf(input: input) &&
           check_valid_plf(input: input_key))){
            return
        }
        
        // переменная для хранения plaintext только из нужных символов
        let filter_plain = filterText_Eng(text: input)
        
        // отфильтрованный ключ
        let filter_key = filterText_Eng(text: input_key)
        
        // отладочный вывод
      
        if filter_plain.count % 2 == 1{
            AlertMessage = "The number of eligible symbols must be even"
            showAlert = true
            error_warning = "Error"
            return
        }
        
        //
        let matrix = create_matrix(key: filter_key)
        let prepared_text = create_bigram_decrypt(text: filter_plain)
        
        var result = ""
        for i in stride(from: 0, to: prepared_text.count, by: 2){
            
            let start = prepared_text.index(prepared_text.startIndex, offsetBy: i)
            
            let end = prepared_text.index(start, offsetBy: 2, limitedBy: prepared_text.endIndex) ?? prepared_text.endIndex
            
            let bigram = String(prepared_text[start..<end])
            result += decrypt_bigram(bigram, with: matrix)
        }
        
        
        var clean_result = ""
        
        // удаляем лишние X
        var i = 0
        while i < result.count {
            let currentChar = result[result.index(result.startIndex, offsetBy: i)]
            
            if i + 1 < result.count {
              
                let nextChar = result[result.index(result.startIndex, offsetBy: i + 1)]
                
                // удаляем добавленные x между повторяющимися символами
                if currentChar == "X" && i > 0 {
                    let prevChar = result[result.index(result.startIndex, offsetBy: i - 1)]
                    if prevChar == nextChar {
                        clean_result.append(nextChar)
                        i += 2 // Пропускаем X
                        continue
                    }
                    // удаляем z между XX
                } else if currentChar == "Z" && i>0{
                    let prevChar = result[result.index(result.startIndex, offsetBy: i - 1)]
                    if prevChar == nextChar && prevChar == "X"{
                        clean_result.append(nextChar)
                        i += 2 // Пропускаем X
                        continue
                    }
                    
                }
            }
            clean_result.append(currentChar)
            i+=1
        }
        
        // результат дешифровки
        encrypted.append(clean_result)
        
        
    }
    
    func encrypt(){
        switch algos{
        case "Vigenere":
            encrypt_Vig(input:plaintext, input_key:key)
        case "Playfair":
            encrypt_Plf(input:plaintext, input_key: key)
        default:
            print("Error, unknown method")
            
        }
    
    }
    
    func decrypt(){
        switch algos{
        case "Vigenere":
            decrypt_Vig(input:plaintext, input_key:key)
        case "Playfair":
            decrypt_Plf(input:plaintext, input_key: key)
        default:
            print("Error, unknown method")
            
        }
    }
    
    
    
    func loadFile(url: URL) {
        // Безопасный доступ к защищённому ресурсу
        guard url.startAccessingSecurityScopedResource() else {
            print("Error accessing file")
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            print("Successfully read file")
            fileContent = try String(contentsOf: url, encoding: .utf8)
            plaintext = fileContent
            path_to_file = url.path()
        } catch {
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
                    .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.plainText], allowsMultipleSelection: false)
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
                
        
                TextField("Enter the key", text:$key )
                    .frame(width:200)
                    .font(.system(size: 15))
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Picker("",selection: $algos ){
                    ForEach(encryption_methods, id: \.self){
                        method in Text(method).tag(method)
                    }
                }
                .frame(width:180)
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
                        decrypt()
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
                    .disabled(true)
                    .padding(.vertical,1)
                    .padding(.horizontal)
            
                    .frame(width:300, height: 100)
                Button("Save to file"){
                    document = TextDocument(text: encrypted)
                    ShowExporter = true
                }
                .padding()
                .fileExporter(
                            isPresented: $ShowExporter,
                            document: document,
                            contentType: .plainText,
                            defaultFilename: "encrypted_text.txt"
                ) { result in
                    switch result {
                    case .success(let url):
                        print("Сохранено в: \(url.path)")
                    case .failure(let error):
                        print("Ошибка: \(error.localizedDescription)")
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
