import Foundation

/// This program reads a text file, extracts all words,
/// sorts them alphabetically, and writes them to an output file.
/// Includes random input generation and binary search.
///
/// - Author: Yoma Ozoh
/// - Version: 1.0
/// - Since: 2026-11-13

/// Main function to run the menu, file reading, sorting, and searching.
func main() {
    // Set input file name
    let inputFileName = "input.txt"
    // Set output file name
    let outputFileName = "output.txt"

    // Ask user for choice
    print("Enter your choice (1: existing input.txt) or (2: generate random input.txt): ", terminator: "")

    // Read user input
    guard let choiceStr = readLine() else {
        print("Invalid input. Please enter 1 or 2.")
        return
    }

    // Try converting text input into an integer
    guard let choice = Int(choiceStr) else {
        // Print error if user did not enter a number
        print("Invalid input. Please enter 1 or 2.")
        // Stop program
        return
    }

    // Check if number isn't 1 or 2
    if choice < 1 || choice > 2 {
        print("Invalid choice. Must be 1 or 2.")
        // Stop program
        return
    }

    // Check if user chose option 2
    if choice == 2 {
        // Generate random words into input file
        generateInputFile(fileName: inputFileName)
    }

    // Read and clean words from input file into an array
    let extractedWords = extractWords(fileName: inputFileName)
    // Check if no words were found
    if extractedWords.isEmpty {
        // Print missing file or empty file message
        print("No words found or file missing.")
        // Stop program
        return
    }

    // Sort extracted words from A to Z
    let sortedWords = sortWordsAlphabetically(wordsArray: extractedWords)

    // Save sorted words to output file
    writeWordsToFile(sortedArray: sortedWords, outputFileName: outputFileName)

    // Display sorted words in terminal so user sees what is in the list
    print("Sorted words: ", terminator: "")
    // Loop through sorted array and print each word
    for word in sortedWords {
        // Print current word followed by a space
        print("\(word) ", terminator: "")
    }
    print()

    // Ask user for a word to search
    print("Enter a word to search for in the sorted list: ", terminator: "")
    // Read word and make lowercase
    let target = (readLine() ?? "").lowercased()

    // Check if user didn't input anything
    if target.isEmpty {
        print("Invalid input: no word entered.")
    } else {
        // Search sorted array for target word
        let foundIndex = binarySearchWord(sortedArray: sortedWords, targetWord: target)
        // Check if word was found
        if foundIndex != -1 {
            // Print index where word was found
            print("Word '\(target)' found at index \(foundIndex).")
        } else {
            // Print message if word is not in list
            print("Word '\(target)' was not found.")
        }
    }
}

/// Generates a random input.txt file with sample words.
///
/// - Parameter fileName: The name of the file to create
func generateInputFile(fileName: String) {
    // Array of sample words to pick from
    let wordBank = [
        "zebra", "apple", "mango", "banana", "cherry",
        "grape", "orange", "kiwi", "peach", "lemon"
    ]
    // Set total number of random words to generate
    let wordCount = 8
    // String to build file output
    var outputText = ""

    // Loop 8 times to pick 8 words
    for _ in 0..<wordCount {
        // Pick random index from wordBank
        let randomIndex = Int.random(in: 0..<wordBank.count)
        // Add random word followed by a space
        outputText += wordBank[randomIndex] + " "
    }
    // Add final newline
    outputText += "\n"

    // Try writing string to file
    do {
        try outputText.write(toFile: fileName, atomically: true, encoding: .utf8)
    } catch {
        // Print error if file cannot be created
        print("Error creating \(fileName)")
    }
}

/// Reads a text file and extracts all cleaned words into an array.
///
/// - Parameter fileName: The file to read from
/// - Returns: Array of extracted lowercase words
func extractWords(fileName: String) -> [String] {
    // Create dynamic array to hold extracted words
    var wordList: [String] = []

    // Try opening input file to read
    do {
        // Read full file contents
        let content = try String(contentsOfFile: fileName, encoding: .utf8)
        // Split content by whitespace and newlines
        let rawWords = content.components(separatedBy: .whitespacesAndNewlines)

        // Loop through each raw word
        for rawWord in rawWords {
            // Strip punctuation and convert to lowercase
            let cleanWord = rawWord
                .replacingOccurrences(of: "[^a-zA-Z]", with: "", options: .regularExpression)
                .lowercased()
            // Check if cleaned word still has letters
            if !cleanWord.isEmpty {
                // Add cleaned word to list
                wordList.append(cleanWord)
            }
        }
    } catch {
        // Print error if file is missing
        print("Error: \(fileName) was not found.")
    }

    // Return array of cleaned words
    return wordList
}

/// Sorts an array of strings alphabetically using Bubble Sort.
///
/// - Parameter wordsArray: The unsorted array of words
/// - Returns: Alphabetically sorted array of words
func sortWordsAlphabetically(wordsArray: [String]) -> [String] {
    // Make a mutable copy of the array
    var sorted = wordsArray
    // Get total number of words in array
    let n = sorted.count

    // Only sort if there are at least 2 words
    if n > 1 {
        // Outer loop for each sorting pass
        for i in 0..<(n - 1) {
            // Inner loop to compare adjacent words
            for j in 0..<(n - i - 1) {
                // Check if current word comes after next word
                if sorted[j] > sorted[j + 1] {
                    // Store current word temporarily
                    let temp = sorted[j]
                    // Move next word to current spot
                    sorted[j] = sorted[j + 1]
                    // Place temporary word into next spot
                    sorted[j + 1] = temp
                }
            }
        }
    }
    // Return sorted array
    return sorted
}

/// Searches for a target word in a sorted array using binary search.
///
/// - Parameters:
///   - sortedArray: The alphabetically sorted array
///   - targetWord: The word to search for
/// - Returns: Index of the word if found, or -1 if not found
func binarySearchWord(sortedArray: [String], targetWord: String) -> Int {
    // Set starting search index
    var low = 0
    // Set ending search index
    var high = sortedArray.count - 1

    // Loop while search range is valid
    while low <= high {
        // Find middle index
        let mid = (low + high) / 2
        // Get middle word
        let midWord = sortedArray[mid]

        // Check if middle word matches target
        if targetWord == midWord {
            // Return matching index
            return mid
        } else if targetWord > midWord {
            // Narrow search to right half
            low = mid + 1
        } else {
            // Narrow search to left half
            high = mid - 1
        }
    }
    // Return -1 if word is not found
    return -1
}

/// Writes an array of words to an output text file, one per line.
///
/// - Parameters:
///   - sortedArray: The sorted words to write
///   - outputFileName: The destination file name
func writeWordsToFile(sortedArray: [String], outputFileName: String) {
    // Join all sorted words with newlines
    let outputText = sortedArray.joined(separator: "\n") + "\n"

    // Try opening output file to write
    do {
        // Save text to file
        try outputText.write(toFile: outputFileName, atomically: true, encoding: .utf8)
    } catch {
        // Print error if file cannot be written
        print("Error writing to \(outputFileName)")
    }
}

// Run the main function
main()